page 50178 "E3 Purch Ret Indent Line API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'E3IndentPurchRetLineAPI';
    DelayedInsert = true;
    AutoSplitKey = true;
    EntityName = 'indentPurchRetline';
    EntitySetName = 'indentPurchRetlines';
    PageType = API;
    SourceTable = "E3 HIS Indent Line";
    ODataKeyFields = "Entry No.";
    Extensible = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Documment No.';
                }
                field(itemID; Rec."Item ID")
                {
                    Caption = 'Item ID';
                }
                field(itemName; Rec."Item Name")
                {
                    Caption = 'Item Name';
                }
                field(unitCost; Rec."Unit Cost")
                {
                    Caption = 'Unit Cost';
                }

                field(quantity; Rec."Received Qty")
                {
                    Caption = 'Quantity';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(grossAmount; Rec."Gross Amount")
                {
                    Caption = 'Gross Amount';
                }
                field(itemCategoryCode; Rec."Item Category Code")
                {
                    Caption = 'Item Category Code';
                }
                field(itemCategoryName; Rec."Item Category Name")
                {
                    Caption = 'Item Category Name';
                }
                field(itemSubcategoryId; Rec."Item Sub category Id")
                {
                    Caption = 'Item Sub category Id';
                }
                field(gstPer; Rec."GST Per")
                {
                    Caption = 'GST Per';
                }
                field(serviceCode; Rec."Service Code")
                {
                    Caption = 'Service Code';
                }
                field(batchNo; Rec.BatchNo)
                {
                    Caption = 'BatchNo';
                }
                field(expiryDate; Rec.ExpiryDate)
                {
                    Caption = 'ExpiryDate';
                }
                field(indentNo; Rec."Indent No")
                {
                    Caption = 'Indent No';
                }
                field(stationSINo; Rec."Station SI No")
                {
                    Caption = 'Station SI No';
                }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.HasFilter() then begin
            Rec.Validate("Record Type", Rec."Record Type"::"Purchase Return");
            Rec."Document Type" := Rec."Document Type"::"Credit Memo";
            Rec."Document No." := Rec.GetFilter("Document No.");
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if Rec.HasFilter() then begin
            Rec.Validate("Record Type", Rec."Record Type"::"Purchase Return");
            Rec."Document Type" := Rec."Document Type"::"Credit Memo";
            Rec."Document No." := Rec.GetFilter("Document No.");
        end;
    end;
}
