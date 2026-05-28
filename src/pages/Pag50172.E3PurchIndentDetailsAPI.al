page 50172 "E3 Purchase Indent Details API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'indentPurchaseDetailAPI';
    DelayedInsert = true;
    EntityName = 'indentPurchsaseDetail';
    EntitySetName = 'indentPurchaseDetails';
    PageType = API;
    SourceTable = "E3 HIS Indent Header";
    ODataKeyFields = "Entry No.";
    Extensible = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(entryNo; Rec."Entry No.")
                {
                    Caption = 'Entry No.';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';

                    trigger OnValidate()
                    begin
                        DuplicateCheck();
                    end;
                }
                field(documentDate; Rec."Document Date")
                {
                    Caption = 'Document Date';
                }
                field(vendorCustomerNo; Rec."Vendor/Customer No.")
                {
                    Caption = 'Vendor/Customer No.';
                }
                field(vendorCustomerName; Rec."Vendor/Customer Name")
                {
                    Caption = 'Vendor/Customer Name';
                }
                field(invoiceNo; Rec."Invoice No.")
                {
                    Caption = 'Invoice No.';
                }
                field(invoiceDate; Rec."Invoice Date")
                {
                    Caption = 'Invoice Date';
                }
                field(indentOrderNo; Rec."Indent Order No.")
                {
                    Caption = 'Indent Order No.';
                }
                field(indentOrderDate; Rec."Indent Order Date")
                {
                    Caption = 'Indent Order Date';
                }
                field(noofLines; Rec."No. of Lines")
                {
                    Caption = 'No. of Lines';
                }
                field(gstAmount; Rec."GST Amount")
                {
                    Caption = 'GST Amount';
                }
                field(toLocationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(toLocationName; Rec."Station Name")
                {
                    Caption = 'Station Name';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }

                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }

            }
            part(IndentLine; "E3 Purchase Indent Line API")
            {
                Caption = 'Lines';
                EntityName = 'indentPurchaseline';
                EntitySetName = 'indentPurchaselines';
                SubPageLink = "Record Type" = field("Record Type"), "Document Type" = field("Document Type"), "Document No." = field("Document No.");
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec.Validate("Record Type", Rec."Record Type"::Purchase);
        Rec."Document Type" := Rec."Document Type"::Invoice;
        Rec.Type := Rec.Type::Vendor;
        //DuplicateCheck();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate("Record Type", Rec."Record Type"::Purchase);
        Rec."Document Type" := Rec."Document Type"::Invoice;
        Rec.Type := Rec.Type::Vendor;
        //DuplicateCheck();
    end;

    local procedure DuplicateCheck()
    var
        IndentHeader: Record "E3 HIS Indent Header";
    begin
        IndentHeader.Setrange("Record Type", Rec."Record Type"::Purchase);
        IndentHeader.Setrange("Document Type", Rec."Document Type"::Invoice);
        IndentHeader.SetRange("Document No.", Rec."Document No.");
        if IndentHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}
