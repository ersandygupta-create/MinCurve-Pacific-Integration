tableextension 50033 HISInvoicePostingBuffer extends "Invoice Posting Buffer"
{
    fields
    {
        field(50001; "Shortcut Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Shortcut Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
            ValidateTableRelation = false;
            DataClassification = ToBeClassified;
        }
    }

}