codeunit 50027 "E3 HIS Indent Integration"
{
    Permissions = tabledata "Purch. Inv. Header" = rm,
    tabledata "Purch. Inv. Line" = rm,
    tabledata "Purch. Cr. Memo Hdr." = rm,
    tabledata "Purch. Cr. Memo Line" = rm;

    trigger OnRun()
    begin

    end;

    procedure OrderValidation(RecordType: option; DocumentType: Option; DocumentNo: Code[20])
    var
        txtPurchaseAccount: Text[100];
        HISItemMapping: Record "E3 HIS Item Mapping";
        RecItem: Record Item;
        RecVendor: Record Vendor;
        GSTGroupCode: Code[20];
        txtHSNCode: Text[100];
        HSNSAC: Record "HSN/SAC";
        GSTGroup: Record "GST Group";
        LineCount: Integer;

    begin
        txtPurchaseAccount := '';
        HISPurchaseSaleLine.RESET;
        HISPurchaseSaleLine.SetRange("Record Type", RecordType);
        HISPurchaseSaleLine.SetRange("Document Type", DocumentType);
        HISPurchaseSaleLine.SETRANGE("Document No.", DocumentNo);
        IF HISPurchaseSaleLine.FINDFIRST THEN BEGIN
            REPEAT
                //LineCount += 1;
                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then begin
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::Purchase) AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::Invoice) THEN BEGIN
                            HISItemMapping.RESET();
                            HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Purchase");
                            HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                            IF HISItemMapping.FINDFIRST() THEN begin
                                HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                HISPurchaseSaleLine.MODIFY();
                            end;
                        end else
                            IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::"Purchase Return") AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::"Credit Memo") THEN begin
                                HISItemMapping.RESET();
                                HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Purchase Return");
                                HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                                IF HISItemMapping.FINDFIRST() THEN begin
                                    HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                    HISPurchaseSaleLine.MODIFY();
                                end;
                            end;
                end else begin
                    IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then begin
                        if HISPurchaseSaleLine."Item No." <> '' then begin
                            if not RecItem.get(HISPurchaseSaleLine."Item No.") then
                                txtPurchaseAccount := 'Item does not exists';
                        end;
                    end;
                end;

                IF HISPurchaseSaleLine."Service Code" <> '' THEN begin
                    if HISPurchaseSaleLine."GST Per" = '' then
                        GSTGroupCode := 'Must have a value';

                    HSNSAC.RESET();
                    HSNSAC.SetRange("GST Group Code", HISPurchaseSaleLine."GST Per");
                    HSNSAC.SETRANGE(Code, HISPurchaseSaleLine."Service Code");
                    IF NOT HSNSAC.FINDFIRST() THEN
                        txtHSNCode := 'Create New HSN Code'
                END;

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then
                    if HISPurchaseSaleLine."Item No." = '' then
                        txtPurchaseAccount := 'Item No. is Missing';

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        txtPurchaseAccount := 'Purchase Account is Missing';

                //IF (HISPurchaseSaleLine."Item Id" = HISPurchaseSaleLine."Purchase Account") or (HISPurchaseSaleLine."Purchase Account" = '') THEN
                //txtPurchaseAccount := 'Purchase Account Missing';

                IF HISPurchaseSaleLine."GST Per" <> '' THEN BEGIN
                    if HISPurchaseSaleLine."Service Code" = '' then
                        txtHSNCode := 'HSN Code must not be blank.';

                    GSTGroup.RESET();
                    GSTGroup.SETRANGE(GSTGroup.Code, HISPurchaseSaleLine."GST Per");
                    IF NOT GSTGroup.FINDFIRST() THEN
                        GSTGroupCode := 'Create New GST Group';
                END;
            UNTIL HISPurchaseSaleLine.NEXT() = 0;

            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", HISPurchaseSaleLine."Record Type");
            HISPurchaseSaleHeader.SetRange("Document Type", HISPurchaseSaleLine."Document Type");
            HISPurchaseSaleHeader.SETRANGE("Document No.", HISPurchaseSaleLine."Document No.");
            IF HISPurchaseSaleHeader.FINDFIRST() THEN begin
                if HISPurchaseSaleHeader."No. of Lines" <> LineCount then
                    HISPurchaseSaleHeader."Error Description" := 'Line Count Mismatch';
                IF (HISPurchaseSaleHeader."Vendor/Customer Name" = '') OR (txtHSNCode <> '') OR (txtPurchaseAccount <> '') OR (GSTGroupCode <> '') THEN
                    HISPurchaseSaleHeader."Error Description" := 'Kindly Check Vendor,HSN Code,GST Group Code'
                ELSE
                    HISPurchaseSaleHeader."Error Description" := '';
                HISPurchaseSaleHeader.MODIFY();
            end;
        END ELSE BEGIN
            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
            HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
            HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
            IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
                HISPurchaseSaleLine.RESET();
                HISPurchaseSaleLine.SetRange("Record Type", HISPurchaseSaleHeader."Record Type");
                HISPurchaseSaleLine.SetRange("Document Type", HISPurchaseSaleHeader."Document Type");
                HISPurchaseSaleLine.SETRANGE("Document No.", HISPurchaseSaleHeader."Document No.");
                IF NOT HISPurchaseSaleLine.FINDFIRST() THEN
                    HISPurchaseSaleHeader."Error Description" := 'Integration Line is Empty';
                HISPurchaseSaleHeader.MODIFY();
            END;
        END;

        HISPurchaseSaleHeader.RESET();
        HISPurchaseSaleHeader.SetRange("Record Type", HISPurchaseSaleLine."Record Type");
        HISPurchaseSaleHeader.SetRange("Document Type", HISPurchaseSaleLine."Document Type");
        HISPurchaseSaleHeader.SETRANGE("Document No.", HISPurchaseSaleLine."Document No.");
        IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
            if not RecVendor.get(HISPurchaseSaleHeader."Vendor/Customer No.") then
                HISPurchaseSaleHeader."Error 1" := true;
            IF (HISPurchaseSaleHeader."Vendor/Customer Name" = '') THEN
                HISPurchaseSaleHeader."Error 1" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 1" := FALSE;
            IF (txtPurchaseAccount <> '') THEN
                HISPurchaseSaleHeader."Error 2" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 2" := FALSE;
            IF (txtHSNCode <> '') THEN
                HISPurchaseSaleHeader."Error 3" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 3" := FALSE;
            IF (GSTGroupCode <> '') THEN
                HISPurchaseSaleHeader."Error 4" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 4" := FALSE;


            HISPurchaseSaleHeader.MODIFY();
        END;

    end;

    procedure OrderReValidation(RecordType: option; DocumentType: Option; DocumentNo: Code[20])
    var
        HSNSAC: Record "HSN/SAC";
        GSTGroup: Record "GST Group";
        HISItemMapping: Record "E3 HIS Item Mapping";
        txtHSNCode: Text[100];
        txtPurchaseAccount: Text[100];
        txtHSNCodeNew: Text[100];
        GSTGroupCode: Text[100];
        LineCount: Integer;
        RecItem: Record Item;
        Vendor: Record Vendor;
    BEGIN
        LineCount := 0;
        txtHSNCode := '';
        txtPurchaseAccount := '';
        txtHSNCodeNew := '';
        GSTGroupCode := '';
        IntegrationSetup.get();

        HISPurchaseSaleHeader.RESET();
        HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
        HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
        HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
        IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
            HISPurchaseSaleHeader."Error 1" := FALSE;
            HISPurchaseSaleHeader."Error 2" := FALSE;
            HISPurchaseSaleHeader."Error 3" := FALSE;
            HISPurchaseSaleHeader."Error 4" := FALSE;
            HISPurchaseSaleHeader."Error Description" := '';
            HISPurchaseSaleHeader.MODIFY();
        END;

        HISPurchaseSaleLine.RESET();
        HISPurchaseSaleLine.SetRange("Record Type", RecordType);
        HISPurchaseSaleLine.SetRange("Document Type", DocumentType);
        HISPurchaseSaleLine.SETRANGE("Document No.", DocumentNo);
        IF HISPurchaseSaleLine.FINDFIRST() THEN BEGIN
            REPEAT
                LineCount += 1;
                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then begin
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::Purchase) AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::Invoice) THEN BEGIN
                            HISItemMapping.RESET();
                            HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Purchase");
                            HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                            IF HISItemMapping.FINDFIRST() THEN begin
                                HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                HISPurchaseSaleLine.MODIFY();
                            end;
                        end else
                            IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::"Purchase Return") AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::"Credit Memo") THEN begin
                                HISItemMapping.RESET();
                                HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Purchase Return");
                                HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                                IF HISItemMapping.FINDFIRST() THEN begin
                                    HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                    HISPurchaseSaleLine.MODIFY();
                                end;
                            end;
                end else begin
                    IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then begin
                        if HISPurchaseSaleLine."Item No." <> '' then begin
                            if not RecItem.get(HISPurchaseSaleLine."Item No.") then
                                txtPurchaseAccount := 'Item does not exists';
                        end;
                    end;
                end;
                // IF HISPurchaseSaleLine."HSN Code" = '' THEN BEGIN
                //     txtHSNCode := 'HSN Code';
                // END;

                if HISPurchaseSaleLine."Service Code" <> '' THEN BEGIN
                    if HISPurchaseSaleLine."GST Per" = '' then
                        GSTGroupCode := 'GST Group';

                    HSNSAC.RESET();
                    HSNSAC.SetRange("GST Group Code", HISPurchaseSaleLine."GST Per");
                    HSNSAC.SETRANGE(Code, HISPurchaseSaleLine."Service Code");
                    IF NOT HSNSAC.FINDFIRST() THEN
                        txtHSNCodeNew := 'HSN Code New';
                End;

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then
                    if HISPurchaseSaleLine."Item No." = '' then
                        txtPurchaseAccount := 'Item No. is Missing';

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        txtPurchaseAccount := 'Purchase Account is Missing';

                // IF HISPurchaseSaleLine."Purchase Account" = '' THEN
                //     txtPurchaseAccount := 'Purchase Account';

                IF HISPurchaseSaleLine."GST Per" <> '' THEN BEGIN
                    if HISPurchaseSaleLine."Service Code" = '' then
                        txtHSNCodeNew := 'Must not be Blank';

                    GSTGroup.Reset();
                    GSTGroup.SetRange(Code, HISPurchaseSaleLine."GST Per");
                    IF NOT GSTGroup.FINDFIRST() THEN
                        GSTGroupCode := 'GST Group';
                END;
            UNTIL HISPurchaseSaleLine.NEXT() = 0;

            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
            HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
            HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
            IF HISPurchaseSaleHeader.FINDFIRST() THEN begin
                if HISPurchaseSaleHeader."No. of Lines" <> LineCount then
                    HISPurchaseSaleHeader."Error Description" := 'Line Count Mismatch';

                IF HISPurchaseSaleHeader."Vendor/Customer Name" <> '' THEN
                    HISPurchaseSaleHeader."Error 1" := FALSE;

                IF HISPurchaseSaleHeader.Type = HISPurchaseSaleHeader.Type::Vendor then begin
                    Vendor.Reset();
                    Vendor.SetRange("No.", HISPurchaseSaleHeader."Vendor/Customer No.");
                    if Vendor.FindFirst() then begin
                        HISPurchaseSaleHeader."Vendor/Customer Name" := Vendor.Name;
                        HISPurchaseSaleHeader.Modify();
                    end else begin
                        HISPurchaseSaleHeader."Error 1" := true;
                        HISPurchaseSaleHeader.Modify();
                    end;
                end;

                IF (HISPurchaseSaleHeader."Vendor/Customer Name" = '') OR (txtHSNCodeNew <> '') OR (txtPurchaseAccount <> '') OR (GSTGroupCode <> '') THEN
                    HISPurchaseSaleHeader."Error Description" := 'Revalidation Error found'
                ELSE
                    HISPurchaseSaleHeader."Error Description" := '';

                IF txtPurchaseAccount = '' THEN
                    HISPurchaseSaleHeader."Error 2" := FALSE;

                IF txtHSNCodeNew = '' THEN
                    HISPurchaseSaleHeader."Error 3" := FALSE;
                IF GSTGroupCode = '' THEN
                    HISPurchaseSaleHeader."Error 4" := FALSE;
                HISPurchaseSaleHeader.MODIFY();
            end;
        END ELSE BEGIN
            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
            HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
            HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
            IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
                HISPurchaseSaleLine.RESET();
                HISPurchaseSaleLine.SetRange("Record Type", HISPurchaseSaleLine."Record Type");
                HISPurchaseSaleLine.SetRange("Document Type", HISPurchaseSaleLine."Document Type");
                HISPurchaseSaleLine.SETRANGE("Document No.", HISPurchaseSaleHeader."Document No.");
                IF NOT HISPurchaseSaleLine.FINDFIRST() THEN
                    HISPurchaseSaleHeader."Error Description" := 'Integration Line is Empty';
                HISPurchaseSaleHeader.MODIFY();
            END;
        END;

    END;


    procedure InitPurchaseOrder(RecordType: Option; DocumentType: Option; DocumentNo: CODE[20])
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        LineNo: Integer;
    begin
        IntegrationSetup.GET;
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("GRN Item Wise/ Account Wise");
        IntegrationSetup.TESTFIELD("GRN Creation Enabled", TRUE);


        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."GRN Creation Enabled") THEN
            EXIT;
        OrderValidation(RecordType, documentType, DocumentNo);


        HISPurchaseSaleHeader.RESET;
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Document No.", DocumentNo);
        HISPurchaseSaleHeader.SETRANGE("rECORD tYPE", HISPurchaseSaleHeader."rECORD tYPE");
        HISPurchaseSaleHeader.SETRANGE("Document Type", HISPurchaseSaleHeader."Document Type");
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Create PO", FALSE);
        HISPurchaseSaleHeader.SETFILTER(HISPurchaseSaleHeader."Vendor/Customer No.", '<>%1', '');
        HISPurchaseSaleHeader.SETFILTER(HISPurchaseSaleHeader."Error Description", '%1', '');
        HISPurchaseSaleHeader.SETFILTER(HISPurchaseSaleHeader."No. of Lines", '<>%1', 0);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 1", FALSE);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 2", FALSE);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 3", FALSE);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 4", FALSE);
        IF HISPurchaseSaleHeader.FINDFIRST THEN BEGIN
            PurchHeader.INIT;
            IF (HISPurchaseSaleHeader."Record Type" = HISPurchaseSaleHeader."Record Type"::Purchase) AND (HISPurchaseSaleHeader."Document Type" = HISPurchaseSaleHeader."Document Type"::Invoice) THEN BEGIN
                PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice
            END ELSE
                IF (HISPurchaseSaleHeader."Record Type" = HISPurchaseSaleHeader."Record Type"::"Purchase Return") AND (HISPurchaseSaleHeader."Document Type" = HISPurchaseSaleHeader."Document Type"::"Credit Memo") THEN
                    PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";

            PurchHeader."No." := HISPurchaseSaleHeader."Document No.";
            PurchHeader.INSERT(TRUE);
            PurchHeader.VALIDATE("Buy-from Vendor No.", HISPurchaseSaleHeader."Vendor/Customer No.");
            PurchHeader.VALIDATE("Order Date", HISPurchaseSaleHeader."Document Date");
            PurchHeader.VALIDATE("Posting Date", HISPurchaseSaleHeader."Posting Date");
            PurchHeader.VALIDATE("Vendor Invoice No.", HISPurchaseSaleHeader."Invoice No." + '-P');
            PurchHeader.VALIDATE("Location Code", HISPurchaseSaleHeader."Shortcut Dimension 1 Code");
            PurchHeader.VALIDATE(PurchHeader."Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Shortcut Dimension 1 Code");
            PurchHeader.VALIDATE(PurchHeader."Shortcut Dimension 2 Code", HISPurchaseSaleHeader."Shortcut Dimension 2 Code");
            PurchHeader.VALIDATE(PurchHeader."Vendor Order No.", HISPurchaseSaleHeader."Indent Order No.");
            PurchHeader.VALIDATE(PurchHeader."Order Amount", HISPurchaseSaleHeader.Amount);
            PurchHeader.VALIDATE(PurchHeader."Vendor Cr. Memo No.", HISPurchaseSaleHeader."Document No.");
            PurchHeader.VALIDATE("Posting No. Series", '');
            PurchHeader.VALIDATE("Posting No.", HISPurchaseSaleHeader."Document No.");
            //PurchHeader.Validate("Reference No.", HISPurchaseSaleHeader."Reference No.");
            PurchHeader."Indent Amount" := HISPurchaseSaleHeader.Amount;
            PurchHeader."Order Amount" := HISPurchaseSaleHeader.Amount;
            //PurchHeader."Integration PO Created" := HISPurchaseSaleHeader."Integration PO Created";
            PurchHeader."Integration PO Created" := TRUE;
            PurchHeader.MODIFY;
            LineNo := 0;

            HISPurchaseSaleLine.RESET;
            HISPurchaseSaleLine.SetRange("Record Type", HISPurchaseSaleHeader."Record Type");
            HISPurchaseSaleLine.SetRange("document Type", HISPurchaseSaleHeader."document Type");
            HISPurchaseSaleLine.SETRANGE(HISPurchaseSaleLine."Document No.", PurchHeader."No.");
            IF HISPurchaseSaleLine.FINDFIRST THEN
                REPEAT
                    LineNo += 10000;
                    PurchLine.INIT;
                    PurchLine.VALIDATE("Document Type", PurchHeader."Document Type");
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine.VALIDATE("Line No.", LineNo);
                    PurchLine.VALIDATE(Type, HISPurchaseSaleLine."Item Type");
                    IntegrationSetup.Get();
                    IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then begin
                        PurchLine.VALIDATE("No.", HISPurchaseSaleLine."Purchase Account")
                    end else begin
                        IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then
                            PurchLine.VALIDATE("No.", HISPurchaseSaleLine."Item No.")
                    end;

                    IF HISPurchaseSaleLine."Received QTY" <> 0 THEN
                        PurchLine.VALIDATE(Quantity, HISPurchaseSaleLine."Received QTY")
                    ELSE
                        PurchLine.VALIDATE(Quantity, HISPurchaseSaleLine."Free QTY");
                    PurchLine.VALIDATE("Location Code", HISPurchaseSaleLine."Location Code");
                    PurchLine.VALIDATE("Direct Unit Cost", HISPurchaseSaleLine."Unit Cost");
                    PurchLine.VALIDATE(PurchLine."Shortcut Dimension 1 Code", HISPurchaseSaleLine."Shortcut Dimension 1 Code");
                    PurchLine.VALIDATE(PurchLine."Shortcut Dimension 2 Code", HISPurchaseSaleLine."Shortcut Dimension 2 Code");
                    PurchLine.Description := COPYSTR(HISPurchaseSaleLine."Item Name", 1, 100);
                    PurchLine.VALIDATE("Line Discount Amount", HISPurchaseSaleLine.Discount);
                    PurchLine."Vendor Item No." := HISPurchaseSaleLine."Item No.";
                    PurchLine.Validate("GST Group Code", HISPurchaseSaleLine."GST Per");
                    PurchLine.Validate("HSN/SAC Code", HISPurchaseSaleLine."Service Code");

                    PurchLine.INSERT(TRUE);
                UNTIL HISPurchaseSaleLine.NEXT = 0;
            HISPurchaseSaleHeader."Create PO" := TRUE;
            HISPurchaseSaleHeader.MODIFY;

        END;


    end;

    procedure SalesOrderValidation(RecordType: option; DocumentType: Option; DocumentNo: Code[20])
    var
        txtPurchaseAccount: Text[100];
        HISItemMapping: Record "E3 HIS Item Mapping";
        RecItem: Record Item;
        RecCustomer: Record Customer;
        GSTGroupCode: Code[20];
        txtHSNCode: Text[100];
        HSNSAC: Record "HSN/SAC";
        GSTGroup: Record "GST Group";
        LineCount: Integer;

    begin
        txtPurchaseAccount := '';
        HISPurchaseSaleLine.RESET;
        HISPurchaseSaleLine.SetRange("Record Type", RecordType);
        HISPurchaseSaleLine.SetRange("Document Type", DocumentType);
        HISPurchaseSaleLine.SETRANGE("Document No.", DocumentNo);
        IF HISPurchaseSaleLine.FINDFIRST THEN BEGIN
            REPEAT
                //LineCount += 1;
                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then begin
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::Sales) AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::Invoice) THEN BEGIN
                            HISItemMapping.RESET();
                            HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Sales");
                            HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                            IF HISItemMapping.FINDFIRST() THEN begin
                                HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                HISPurchaseSaleLine.MODIFY();
                            end;
                        end else
                            IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::"Sales Return") AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::"Credit Memo") THEN begin
                                HISItemMapping.RESET();
                                HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Sales Return");
                                HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                                IF HISItemMapping.FINDFIRST() THEN begin
                                    HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                    HISPurchaseSaleLine.MODIFY();
                                end;
                            end;
                end else begin
                    IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then begin
                        if HISPurchaseSaleLine."Item No." <> '' then begin
                            if not RecItem.get(HISPurchaseSaleLine."Item No.") then
                                txtPurchaseAccount := 'Item does not exists';
                        end;
                    end;
                end;

                IF HISPurchaseSaleLine."Service Code" <> '' THEN begin
                    if HISPurchaseSaleLine."GST Per" = '' then
                        GSTGroupCode := 'Must have a value';

                    HSNSAC.RESET();
                    HSNSAC.SetRange("GST Group Code", HISPurchaseSaleLine."GST Per");
                    HSNSAC.SETRANGE(Code, HISPurchaseSaleLine."Service Code");
                    IF NOT HSNSAC.FINDFIRST() THEN
                        txtHSNCode := 'Create New HSN Code'
                END;

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then
                    if HISPurchaseSaleLine."Item No." = '' then
                        txtPurchaseAccount := 'Item No. is Missing';

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        txtPurchaseAccount := 'Purchase Account is Missing';

                //IF (HISPurchaseSaleLine."Item Id" = HISPurchaseSaleLine."Purchase Account") or (HISPurchaseSaleLine."Purchase Account" = '') THEN
                //txtPurchaseAccount := 'Purchase Account Missing';

                IF HISPurchaseSaleLine."GST Per" <> '' THEN BEGIN
                    if HISPurchaseSaleLine."Service Code" = '' then
                        txtHSNCode := 'HSN Code must not be blank.';

                    GSTGroup.RESET();
                    GSTGroup.SETRANGE(GSTGroup.Code, HISPurchaseSaleLine."GST Per");
                    IF NOT GSTGroup.FINDFIRST() THEN
                        GSTGroupCode := 'Create New GST Group';
                END;
            UNTIL HISPurchaseSaleLine.NEXT() = 0;

            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", HISPurchaseSaleLine."Record Type");
            HISPurchaseSaleHeader.SetRange("Document Type", HISPurchaseSaleLine."Document Type");
            HISPurchaseSaleHeader.SETRANGE("Document No.", HISPurchaseSaleLine."Document No.");
            IF HISPurchaseSaleHeader.FINDFIRST() THEN begin
                if HISPurchaseSaleHeader."No. of Lines" <> LineCount then
                    HISPurchaseSaleHeader."Error Description" := 'Line Count Mismatch';
                IF (HISPurchaseSaleHeader."Vendor/Customer Name" = '') OR (txtHSNCode <> '') OR (txtPurchaseAccount <> '') OR (GSTGroupCode <> '') THEN
                    HISPurchaseSaleHeader."Error Description" := 'Kindly Check Vendor,HSN Code,GST Group Code'
                ELSE
                    HISPurchaseSaleHeader."Error Description" := '';
                HISPurchaseSaleHeader.MODIFY();
            end;
        END ELSE BEGIN
            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
            HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
            HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
            IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
                HISPurchaseSaleLine.RESET();
                HISPurchaseSaleLine.SetRange("Record Type", HISPurchaseSaleHeader."Record Type");
                HISPurchaseSaleLine.SetRange("Document Type", HISPurchaseSaleHeader."Document Type");
                HISPurchaseSaleLine.SETRANGE("Document No.", HISPurchaseSaleHeader."Document No.");
                IF NOT HISPurchaseSaleLine.FINDFIRST() THEN
                    HISPurchaseSaleHeader."Error Description" := 'Integration Line is Empty';
                HISPurchaseSaleHeader.MODIFY();
            END;
        END;

        HISPurchaseSaleHeader.RESET();
        HISPurchaseSaleHeader.SetRange("Record Type", HISPurchaseSaleLine."Record Type");
        HISPurchaseSaleHeader.SetRange("Document Type", HISPurchaseSaleLine."Document Type");
        HISPurchaseSaleHeader.SETRANGE("Document No.", HISPurchaseSaleLine."Document No.");
        IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
            if not RecCustomer.get(HISPurchaseSaleHeader."Vendor/Customer No.") then
                HISPurchaseSaleHeader."Error 1" := true;
            IF (HISPurchaseSaleHeader."Vendor/Customer Name" = '') THEN
                HISPurchaseSaleHeader."Error 1" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 1" := FALSE;
            IF (txtPurchaseAccount <> '') THEN
                HISPurchaseSaleHeader."Error 2" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 2" := FALSE;
            IF (txtHSNCode <> '') THEN
                HISPurchaseSaleHeader."Error 3" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 3" := FALSE;
            IF (GSTGroupCode <> '') THEN
                HISPurchaseSaleHeader."Error 4" := TRUE
            ELSE
                HISPurchaseSaleHeader."Error 4" := FALSE;


            HISPurchaseSaleHeader.MODIFY();
        END;

    end;

    procedure SalesOrderReValidation(RecordType: option; DocumentType: Option; DocumentNo: Code[20])
    var
        HSNSAC: Record "HSN/SAC";
        GSTGroup: Record "GST Group";
        HISItemMapping: Record "E3 HIS Item Mapping";
        txtHSNCode: Text[100];
        txtPurchaseAccount: Text[100];
        txtHSNCodeNew: Text[100];
        GSTGroupCode: Text[100];
        LineCount: Integer;
        RecItem: Record Item;
        Customer: Record Customer;
    BEGIN
        LineCount := 0;
        txtHSNCode := '';
        txtPurchaseAccount := '';
        txtHSNCodeNew := '';
        GSTGroupCode := '';
        IntegrationSetup.get();

        HISPurchaseSaleHeader.RESET();
        HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
        HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
        HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
        IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
            HISPurchaseSaleHeader."Error 1" := FALSE;
            HISPurchaseSaleHeader."Error 2" := FALSE;
            HISPurchaseSaleHeader."Error 3" := FALSE;
            HISPurchaseSaleHeader."Error 4" := FALSE;
            HISPurchaseSaleHeader."Error Description" := '';
            HISPurchaseSaleHeader.MODIFY();
        END;

        HISPurchaseSaleLine.RESET();
        HISPurchaseSaleLine.SetRange("Record Type", RecordType);
        HISPurchaseSaleLine.SetRange("Document Type", DocumentType);
        HISPurchaseSaleLine.SETRANGE("Document No.", DocumentNo);
        IF HISPurchaseSaleLine.FINDFIRST() THEN BEGIN
            REPEAT
                LineCount += 1;
                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then begin
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::Sales) AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::Invoice) THEN BEGIN
                            HISItemMapping.RESET();
                            HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Sales");
                            HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                            IF HISItemMapping.FINDFIRST() THEN begin
                                HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                HISPurchaseSaleLine.MODIFY();
                            end;
                        end else
                            IF (HISPurchaseSaleLine."Record Type" = HISPurchaseSaleLine."Record Type"::"Sales Return") AND (HISPurchaseSaleLine."Document Type" = HISPurchaseSaleLine."Document Type"::"Credit Memo") THEN begin
                                HISItemMapping.RESET();
                                HISItemMapping.SETRANGE("eNTRY tYPE", HISItemMapping."Entry Type"::"Indent Sales Return");
                                HISItemMapping.SETRANGE(HISItemMapping."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                                IF HISItemMapping.FINDFIRST() THEN begin
                                    HISPurchaseSaleLine."Purchase Account" := HISItemMapping."G/L Account No.";
                                    HISPurchaseSaleLine.MODIFY();
                                end;
                            end;
                end else begin
                    IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then begin
                        if HISPurchaseSaleLine."Item No." <> '' then begin
                            if not RecItem.get(HISPurchaseSaleLine."Item No.") then
                                txtPurchaseAccount := 'Item does not exists';
                        end;
                    end;
                end;
                // IF HISPurchaseSaleLine."HSN Code" = '' THEN BEGIN
                //     txtHSNCode := 'HSN Code';
                // END;

                if HISPurchaseSaleLine."Service Code" <> '' THEN BEGIN
                    if HISPurchaseSaleLine."GST Per" = '' then
                        GSTGroupCode := 'GST Group';

                    HSNSAC.RESET();
                    HSNSAC.SetRange("GST Group Code", HISPurchaseSaleLine."GST Per");
                    HSNSAC.SETRANGE(Code, HISPurchaseSaleLine."Service Code");
                    IF NOT HSNSAC.FINDFIRST() THEN
                        txtHSNCodeNew := 'HSN Code New';
                End;

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then
                    if HISPurchaseSaleLine."Item No." = '' then
                        txtPurchaseAccount := 'Item No. is Missing';

                IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then
                    if HISPurchaseSaleLine."Purchase Account" = '' then
                        txtPurchaseAccount := 'Purchase Account is Missing';

                // IF HISPurchaseSaleLine."Purchase Account" = '' THEN
                //     txtPurchaseAccount := 'Purchase Account';

                IF HISPurchaseSaleLine."GST Per" <> '' THEN BEGIN
                    if HISPurchaseSaleLine."Service Code" = '' then
                        txtHSNCodeNew := 'Must not be Blank';

                    GSTGroup.Reset();
                    GSTGroup.SetRange(Code, HISPurchaseSaleLine."GST Per");
                    IF NOT GSTGroup.FINDFIRST() THEN
                        GSTGroupCode := 'GST Group';
                END;
            UNTIL HISPurchaseSaleLine.NEXT() = 0;

            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
            HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
            HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
            IF HISPurchaseSaleHeader.FINDFIRST() THEN begin
                if HISPurchaseSaleHeader."No. of Lines" <> LineCount then
                    HISPurchaseSaleHeader."Error Description" := 'Line Count Mismatch';

                IF HISPurchaseSaleHeader."Vendor/Customer Name" <> '' THEN
                    HISPurchaseSaleHeader."Error 1" := FALSE;

                IF HISPurchaseSaleHeader.Type = HISPurchaseSaleHeader.Type::Vendor then begin
                    Customer.Reset();
                    Customer.SetRange("No.", HISPurchaseSaleHeader."Vendor/Customer No.");
                    if Customer.FindFirst() then begin
                        HISPurchaseSaleHeader."Vendor/Customer Name" := Customer.Name;
                        HISPurchaseSaleHeader.Modify();
                    end else begin
                        HISPurchaseSaleHeader."Error 1" := true;
                        HISPurchaseSaleHeader.Modify();
                    end;
                end;

                IF (HISPurchaseSaleHeader."Vendor/Customer Name" = '') OR (txtHSNCodeNew <> '') OR (txtPurchaseAccount <> '') OR (GSTGroupCode <> '') THEN
                    HISPurchaseSaleHeader."Error Description" := 'Revalidation Error found'
                ELSE
                    HISPurchaseSaleHeader."Error Description" := '';

                IF txtPurchaseAccount = '' THEN
                    HISPurchaseSaleHeader."Error 2" := FALSE;

                IF txtHSNCodeNew = '' THEN
                    HISPurchaseSaleHeader."Error 3" := FALSE;
                IF GSTGroupCode = '' THEN
                    HISPurchaseSaleHeader."Error 4" := FALSE;
                HISPurchaseSaleHeader.MODIFY();
            end;
        END ELSE BEGIN
            HISPurchaseSaleHeader.RESET();
            HISPurchaseSaleHeader.SetRange("Record Type", RecordType);
            HISPurchaseSaleHeader.SetRange("Document Type", DocumentType);
            HISPurchaseSaleHeader.SETRANGE("Document No.", DocumentNo);
            IF HISPurchaseSaleHeader.FINDFIRST() THEN BEGIN
                HISPurchaseSaleLine.RESET();
                HISPurchaseSaleLine.SetRange("Record Type", HISPurchaseSaleLine."Record Type");
                HISPurchaseSaleLine.SetRange("Document Type", HISPurchaseSaleLine."Document Type");
                HISPurchaseSaleLine.SETRANGE("Document No.", HISPurchaseSaleHeader."Document No.");
                IF NOT HISPurchaseSaleLine.FINDFIRST() THEN
                    HISPurchaseSaleHeader."Error Description" := 'Integration Line is Empty';
                HISPurchaseSaleHeader.MODIFY();
            END;
        END;

    END;


    procedure InitSalesOrder(RecordType: Option; DocumentType: Option; DocumentNo: CODE[20])
    var
        PurchHeader: Record "Sales Header";
        PurchLine: Record "Sales Line";
        LineNo: Integer;
    begin
        IntegrationSetup.GET;
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("GRN Item Wise/ Account Wise");
        IntegrationSetup.TESTFIELD("GRN Creation Enabled", TRUE);


        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."GRN Creation Enabled") THEN
            EXIT;
        SalesOrderValidation(RecordType, documentType, DocumentNo);


        HISPurchaseSaleHeader.RESET;
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Document No.", DocumentNo);
        HISPurchaseSaleHeader.SETRANGE("rECORD tYPE", HISPurchaseSaleHeader."rECORD tYPE");
        HISPurchaseSaleHeader.SETRANGE("Document Type", HISPurchaseSaleHeader."Document Type");
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Create PO", FALSE);
        HISPurchaseSaleHeader.SETFILTER(HISPurchaseSaleHeader."Vendor/Customer No.", '<>%1', '');
        HISPurchaseSaleHeader.SETFILTER(HISPurchaseSaleHeader."Error Description", '%1', '');
        HISPurchaseSaleHeader.SETFILTER(HISPurchaseSaleHeader."No. of Lines", '<>%1', 0);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 1", FALSE);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 2", FALSE);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 3", FALSE);
        HISPurchaseSaleHeader.SETRANGE(HISPurchaseSaleHeader."Error 4", FALSE);
        IF HISPurchaseSaleHeader.FINDFIRST THEN BEGIN
            PurchHeader.INIT;
            IF (HISPurchaseSaleHeader."Record Type" = HISPurchaseSaleHeader."Record Type"::Sales) AND (HISPurchaseSaleHeader."Document Type" = HISPurchaseSaleHeader."Document Type"::Invoice) THEN BEGIN
                PurchHeader."Document Type" := PurchHeader."Document Type"::Invoice
            END ELSE
                IF (HISPurchaseSaleHeader."Record Type" = HISPurchaseSaleHeader."Record Type"::"Sales Return") AND (HISPurchaseSaleHeader."Document Type" = HISPurchaseSaleHeader."Document Type"::"Credit Memo") THEN
                    PurchHeader."Document Type" := PurchHeader."Document Type"::"Credit Memo";

            PurchHeader."No." := HISPurchaseSaleHeader."Document No.";
            PurchHeader.INSERT(TRUE);
            PurchHeader.VALIDATE("Sell-to Customer No.", HISPurchaseSaleHeader."Vendor/Customer No.");
            PurchHeader.VALIDATE("Order Date", HISPurchaseSaleHeader."Document Date");
            PurchHeader.VALIDATE("Posting Date", HISPurchaseSaleHeader."Posting Date");
            PurchHeader.VALIDATE("External Document No.", HISPurchaseSaleHeader."Document No.");
            PurchHeader.VALIDATE("Location Code", HISPurchaseSaleHeader."Shortcut Dimension 1 Code");
            PurchHeader.VALIDATE(PurchHeader."Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Shortcut Dimension 1 Code");
            PurchHeader.VALIDATE(PurchHeader."Shortcut Dimension 2 Code", HISPurchaseSaleHeader."Shortcut Dimension 2 Code");
            PurchHeader.VALIDATE(PurchHeader."Your Reference", HISPurchaseSaleHeader."Indent Order No.");
            PurchHeader.VALIDATE("Posting No. Series", '');
            PurchHeader.VALIDATE("Posting No.", HISPurchaseSaleHeader."Document No.");
            PurchHeader.Validate("Station Name", HISPurchaseSaleHeader."Station Name");
            PurchHeader."Indent Amount" := HISPurchaseSaleHeader.Amount;
            PurchHeader."Order Amount" := HISPurchaseSaleHeader.Amount;
            PurchHeader."Integration PO Created" := TRUE;
            PurchHeader.MODIFY;
            LineNo := 0;
            HISPurchaseSaleLine.RESET;
            HISPurchaseSaleLine.SetRange("Record Type", HISPurchaseSaleHeader."Record Type");
            HISPurchaseSaleLine.SetRange("document Type", HISPurchaseSaleHeader."document Type");
            HISPurchaseSaleLine.SETRANGE(HISPurchaseSaleLine."Document No.", PurchHeader."No.");
            IF HISPurchaseSaleLine.FINDFIRST THEN
                REPEAT
                    LineNo += 10000;
                    PurchLine.INIT;
                    PurchLine.VALIDATE("Document Type", PurchHeader."Document Type");
                    PurchLine."Document No." := PurchHeader."No.";
                    PurchLine.VALIDATE("Line No.", LineNo);
                    PurchLine.VALIDATE(Type, HISPurchaseSaleLine."Item Type");
                    IntegrationSetup.Get();
                    IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::"G/L Account" then begin
                        PurchLine.VALIDATE("No.", HISPurchaseSaleLine."Purchase Account")
                    end else begin
                        IF IntegrationSetup."GRN Item Wise/ Account Wise" = IntegrationSetup."GRN Item Wise/ Account Wise"::Item then
                            PurchLine.VALIDATE("No.", HISPurchaseSaleLine."Item No.")
                    end;

                    IF HISPurchaseSaleLine."Received QTY" <> 0 THEN
                        PurchLine.VALIDATE(Quantity, HISPurchaseSaleLine."Received QTY")
                    //PurchLine.VALIDATE(Quantity, 1)
                    ELSE
                        PurchLine.VALIDATE(Quantity, HISPurchaseSaleLine."Free QTY");
                    PurchLine.VALIDATE("Location Code", HISPurchaseSaleHeader."Shortcut Dimension 1 Code");
                    PurchLine.VALIDATE(PurchLine."Unit Price", HISPurchaseSaleLine."Unit Cost");
                    //PurchLine.VALIDATE(PurchLine."Unit Price", HISPurchaseSaleLine.Amount);
                    PurchLine.VALIDATE(PurchLine."Shortcut Dimension 1 Code", HISPurchaseSaleHeader."Shortcut Dimension 1 Code");
                    PurchLine.VALIDATE(PurchLine."Shortcut Dimension 2 Code", HISPurchaseSaleLine."Shortcut Dimension 2 Code");
                    PurchLine.Description := COPYSTR(HISPurchaseSaleLine."Item Name", 1, 100);
                    PurchLine.VALIDATE("Line Discount Amount", HISPurchaseSaleLine.Discount);
                    PurchLine.VALIDATE("GST Group Code", HISPurchaseSaleLine."GST Per");
                    PurchLine.VALIDATE("HSN/SAC Code", HISPurchaseSaleLine."Service Code");
                    PurchLine.VALIDATE(PurchLine."BatchNo", HISPurchaseSaleLine."BatchNo");
                    PurchLine.VALIDATE(PurchLine."ExpiryDate", HISPurchaseSaleLine."ExpiryDate");
                    PurchLine.VALIDATE(PurchLine."Item Category Code", HISPurchaseSaleLine."Item Category Code");
                    //PurchLine.VALIDATE(PurchLine."Product Group Code", HISPurchaseSaleLine."Product Group Code");
                    PurchLine.VALIDATE(PurchLine."Indent No", HISPurchaseSaleLine."Indent No");
                    PurchLine.VALIDATE(PurchLine."Station SI No", HISPurchaseSaleLine."Station SI No");

                    //PurchLine."Customer Item No." := HISPurchaseSaleLine."Item No.";

                    PurchLine.INSERT(TRUE);
                UNTIL HISPurchaseSaleLine.NEXT = 0;
            HISPurchaseSaleHeader."Create PO" := TRUE;
            HISPurchaseSaleHeader.MODIFY;

        END;


    end;

    procedure PostGenJnlLineEntries()
    var
        GenJnlLine: Record "Gen. Journal Line";
        HISIntegrationSetupLine: Record "E3 HIS Integration Setup Line";
        GenJournalLine1: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        IntegrationSetup.GET;
        IntegrationSetup.TESTFIELD("Integration Enabled", TRUE);
        IntegrationSetup.TESTFIELD("Revenue Creation Enabled", TRUE);


        IF NOT (IntegrationSetup."Integration Enabled") AND (IntegrationSetup."Revenue Creation Enabled") THEN
            EXIT;

        GenJnlLine.RESET;
        GenJnlLine.SETFILTER(GenJnlLine."Account No.", '%1', '');
        GenJnlLine.SETFILTER(GenJnlLine.Amount, '%1', 0);
        IF GenJnlLine.FINDFIRST THEN BEGIN
            GenJnlLine.DELETEALL;
        END;
        HISIntegrationSetupLine.Reset();
        IF HISIntegrationSetupLine.FindFirst() then begin
            repeat
                GenJnlLine.RESET;
                GenJnlLine.SETRANGE("Journal Template Name", HISIntegrationSetupLine."General Journal Template Code");
                GenJnlLine.SETRANGE("Journal Batch Name", HISIntegrationSetupLine."General Journal Batch Code");
                IF GenJnlLine.FINDFIRST THEN BEGIN
                    REPEAT
                        GenJournalLine1.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJournalLine1.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJournalLine1.SETRANGE("Document No.", GenJnlLine."Document No.");
                        GenJournalLine1.SETRANGE("Posting Date", GenJnlLine."Posting Date");
                        IF GenJournalLine1.FINDFIRST THEN
                            REPEAT
                                GenJnlPostBatch.RUN(GenJournalLine1);
                            UNTIL GenJournalLine1.NEXT = 0;
                    UNTIL GenJnlLine.NEXT = 0;
                END else
                    Message('There is no HIS Entries Pending for the Posting');
            until HISIntegrationSetupLine.Next() = 0;
        end;
    end;

    var
        myInt: Integer;
        IntegrationSetup: Record "E3 HIS Integartion Setup";
        GSTState: Code[2];
        HISPurchaseSaleHeader: Record "E3 HIS Indent Header";
        HISPurchaseSaleLine: Record "E3 HIS Indent Line";
        GeneralLedgerSetup: Record "General Ledger Setup";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        PurchaseCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";
        DimensionSetEntry: Record "Dimension Set Entry";
}