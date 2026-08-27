report 50049 "E3 Pro Forma Sales Invoice"
{
    Caption = 'Pro Forma Sales Invoice';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;

    DefaultLayout = RDLC;
    RDLCLayout = './src/Reports/Rpt50049.ProFormaSalesInvoice.rdl';

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Invoice));
            RequestFilterFields = "No.";

            column(DocumentNo; "No.") { }
            column(DocumentDate; "Document Date") { }
            column(PostingDate; "Posting Date") { }
            column(ExternalDocumentNo; "External Document No.") { }

            column(SellToCustomerNo; "Sell-to Customer No.") { }
            column(SellToCustomerName; "Sell-to Customer Name") { }
            column(SellToCustomerName2; "Sell-to Customer Name 2") { }
            column(SellToAddress; "Sell-to Address") { }
            column(SellToAddress2; "Sell-to Address 2") { }
            column(SellToCity; "Sell-to City") { }
            column(SellToPostCode; "Sell-to Post Code") { }
            column(SellToState; "Sell-to County") { }
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            column(Sell_to_Phone_No_; "Sell-to Phone No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(SellCustomer_GST_Reg__No_; "Customer GST Reg. No.") { }

            column(BillToName; "Bill-to Name") { }
            column(BillToAddress; "Bill-to Address") { }
            column(BillToAddress2; "Bill-to Address 2") { }
            column(BillToCity; "Bill-to City") { }

            column(LocationCode; "Location Code") { }
            column(PaymentTermsCode; "Payment Terms Code") { }
            column(ShipmentMethodCode; "Shipment Method Code") { }

            column(CurrencyCode; "Currency Code") { }

            column(CompanyName; CompanyInfo.Name) { }
            column(CompPicture; CompanyInfo.Picture) { }
            column(CompanyAddress; CompanyInfo.Address) { }
            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }
            column(CompanyPhone; CompanyInfo."Phone No.") { }
            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyGST; CompanyInfo."GST Registration No.") { }
            column(CGSTAmount; CGST_Amt)
            {
            }

            column(SGSTAmount; SGST_Amt)
            {
            }

            column(IGSTAmount; IGST_Amt)
            {
            }

            column(CGSTRsAmount; CGSTRsAmount_Var)
            {
            }

            column(SGSTRsAmount; SGSTRsAmount_Var)
            {
            }

            column(IGSTRsAmount; IGSTRsAmount_Var)
            {
            }

            column(PrintCGSTSGST; PrintCGSTSGST)
            {
            }

            column(PrintIGST; PrintIGST)
            {
            }
            column(TotalAmttoCustomer; TotalAmttoCustomer) { }

            dataitem(SalesLine; "Sales Line")
            {
                DataItemLink =
                    "Document Type" = field("Document Type"),
                    "Document No." = field("No.");

                DataItemTableView = sorting("Document Type", "Document No.", "Line No.")
                                    where(Type = filter(<> " "));

                column(LineNo; "Line No.") { }
                column(Type; Type) { }
                column(No; "No.") { }
                column(Description; Description) { }
                column(Description2; "Description 2") { }
                column(UnitofMeasure; "Unit of Measure") { }
                column(Quantity; Quantity) { }
                column(UnitPrice; "Unit Price") { }
                column(LineDiscount; "Line Discount %") { }
                column(LineAmount; "Line Amount") { }
                column(Amount; Amount) { }
                column(AmountIncludingVAT; "Amount Including VAT") { }
                column(VATPercent; "VAT %") { }

                trigger OnAfterGetRecord()
                begin
                    CalStatitics.GetSalesStatisticsAmount(SalesHeader, TotalAmttoCustomer);

                    CalStatitics.OnGetSalesHeaderGSTAmount(SalesHeader, TotalGSTAmt);

                    Clear(CGST_Amt);
                    Clear(SGST_Amt);
                    Clear(IGST_Amt);

                    Clear(CGSTRsAmount_Var);
                    Clear(SGSTRsAmount_Var);
                    Clear(IGSTRsAmount_Var);

                    Clear(PrintCGSTSGST);
                    Clear(PrintIGST);

                    GetGSTAmounts(SalesHeader);
                    if IGST_Amt <> 0 then begin

                        IGSTRsAmount_Var := IGST_Amt;

                        CGSTRsAmount_Var := 0;
                        SGSTRsAmount_Var := 0;

                        PrintIGST := true;
                        PrintCGSTSGST := false;
                    end
                    else begin

                        CGSTRsAmount_Var := CGST_Amt;
                        SGSTRsAmount_Var := SGST_Amt;

                        IGSTRsAmount_Var := 0;

                        PrintCGSTSGST := true;
                        PrintIGST := false;
                    end;
                end;

            }

            trigger OnAfterGetRecord()
            begin
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    local procedure GetGSTAmounts(SalesHeader: Record "Sales Header")
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        SalesLine: Record "Sales Line";
        GSTSetup: Record "GST Setup";
        ComponentName: Code[30];
    begin
        Clear(CGST_Amt);
        Clear(SGST_Amt);
        Clear(IGST_Amt);

        if not GSTSetup.Get() then
            exit;

        SalesLine.Reset();
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");

        if SalesLine.FindSet() then
            repeat
                if SalesLine.Type <> SalesLine.Type::" " then begin

                    ComponentName := GetComponentName(SalesLine, GSTSetup);
                    TaxTransactionValue.Reset();
                    TaxTransactionValue.SetRange("Tax Record ID", SalesLine.RecordId);
                    TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
                    TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
                    TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
                    if TaxTransactionValue.FindSet() then
                        repeat
                            case TaxTransactionValue."Value ID" of

                                2:
                                    CGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                6:
                                    SGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));
                                3:
                                    IGST_Amt += Round(TaxTransactionValue.Amount, GetGSTRoundingPrecision(ComponentName));

                            end;
                        until TaxTransactionValue.Next() = 0;
                end;

            until SalesLine.Next() = 0;
    end;

    local procedure GetComponentName(SalesLine: Record "Sales Line"; GSTSetup: Record "GST Setup"): Code[30]
    var
        ComponentName: Code[30];
    begin
        ComponentName := '';

        if GSTSetup."GST Tax Type" = GSTLbl then begin

            if SalesLine."GST Jurisdiction Type" =
                SalesLine."GST Jurisdiction Type"::Interstate then
                ComponentName := IGSTLbl
            else
                ComponentName := CGSTLbl;

        end else
            if GSTSetup."Cess Tax Type" = GSTCESSLbl then
                ComponentName := CESSLbl;

        exit(ComponentName);
    end;

    local procedure GetGSTRoundingPrecision(ComponentName: Code[30]): Decimal
    var
        TaxComponent: Record "Tax Component";
        GSTSetup: Record "GST Setup";
        GSTRoundingPrecision: Decimal;
    begin
        GSTRoundingPrecision := 1;

        if not GSTSetup.Get() then
            exit(GSTRoundingPrecision);

        GSTSetup.TestField("GST Tax Type");

        TaxComponent.Reset();
        TaxComponent.SetRange("Tax Type", GSTSetup."GST Tax Type");

        TaxComponent.SetRange(Name, ComponentName);

        if TaxComponent.FindFirst() then
            if TaxComponent."Rounding Precision" <> 0 then
                GSTRoundingPrecision :=
                    TaxComponent."Rounding Precision";

        exit(GSTRoundingPrecision);
    end;

    var
        CompanyInfo: Record "Company Information";
        CalStatitics: Codeunit "Calculate Statistics";
        SalesHdr: Record "Sales Header";
        TotalAmttoCustomer: Decimal;
        TotalGSTAmt: Decimal;
        Customer: Record Customer;
        CGST_Amt: Decimal;
        SGST_Amt: Decimal;
        IGST_Amt: Decimal;

        CGSTRsAmount_Var: Decimal;
        SGSTRsAmount_Var: Decimal;
        IGSTRsAmount_Var: Decimal;

        PrintCGSTSGST: Boolean;
        PrintIGST: Boolean;
        GSTLbl: Label 'GST';
        CGSTLbl: Label 'CGST';
        SGSTLbl: Label 'SGST';
        IGSTLbl: Label 'IGST';
        CESSLbl: Label 'CESS';
        GSTCESSLbl: Label 'GST CESS';

}