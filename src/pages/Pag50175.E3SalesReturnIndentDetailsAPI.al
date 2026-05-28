page 50175 "E3 Sales Return Indent API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'indentSalesReturnlAPI';
    DelayedInsert = true;
    EntityName = 'indentSaleRetDetail';
    EntitySetName = 'indentSalesRetDetails';
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
                field(indentOrderNo; Rec."Indent Order No.")
                {
                    Caption = 'Indent Order No.';
                }
                field(indentOrderDate; Rec."Indent Order Date")
                {
                    Caption = 'Purchase Order Date';
                }
                field(noofLines; Rec."No. of Lines")
                {
                    Caption = 'No. of Lines';
                }
                field(gstAmount; Rec."GST Amount")
                {
                    Caption = 'GST Amount';
                }
                field(fromLocationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(fromLocationName; Rec."Station Name")
                {
                    Caption = 'Station Name';
                }
                field(shortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    Caption = 'Shortcut Dimension 1 Code';
                }
                field(shortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    Caption = 'Shortcut Dimension 2 Code';
                }
                field(shortcutDimension3Code; Rec."Shortcut Dimension 3 Code")
                {
                    Caption = 'Shortcut Dimension 3 Code';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
            }
            part(IndentLine; "E3 Sales Ret Indent Line API")
            {
                Caption = 'Lines';
                EntityName = 'indentSalesRetline';
                EntitySetName = 'indentSalesRetlines';
                SubPageLink = "Record Type" = field("Record Type"), "Document Type" = field("Document Type"), "Document No." = field("Document No.");
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec.Validate("Record Type", Rec."Record Type"::"Sales Return");
        Rec."Document Type" := Rec."Document Type"::"Credit Memo";
        rec.Type := rec.Type::Customer;
        //DuplicateCheck();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Validate("Record Type", Rec."Record Type"::"Sales Return");
        Rec."Document Type" := Rec."Document Type"::"Credit Memo";
        Rec.Type := Rec.Type::Customer;
        //DuplicateCheck();
    end;

    local procedure DuplicateCheck()
    var
        IndentHeader: Record "E3 HIS Indent Header";
    begin
        IndentHeader.Setrange("Record Type", Rec."Record Type"::"Sales Return");
        IndentHeader.Setrange("Document Type", Rec."Document Type"::"Credit Memo");
        IndentHeader.SetRange("Document No.", Rec."Document No.");
        if IndentHeader.Count >= 1 then
            error('Duplicate Entry');
    end;
}
