tableextension 50018 "E3 HIS Purch. Inv. Line" extends "Purch. Inv. Line"
{
    fields
    {

        field(50000; "E3 HIS Item Type"; Enum "E3 HIS Item Type")
        {
            Caption = 'Item Type';
            DataClassification = CustomerContent;
        }
        field(50002; "E3 HIS Type"; Enum "E3 HIS Type")
        {
            Caption = 'HIS Type';
            DataClassification = CustomerContent;
        }
        field(50003; "BatchNo"; Code[20])
        {
            Caption = 'BatchNo';
            DataClassification = ToBeClassified;
        }
        field(50004; "ExpiryDate"; Date)
        {
            Caption = 'ExpiryDate';
            DataClassification = ToBeClassified;
        }
        field(50005; "Indent No"; Integer)
        {
            Caption = 'Indent No';
            DataClassification = ToBeClassified;
        }
        field(50006; "Station SI No"; Integer)
        {
            Caption = 'Station SI No';
            DataClassification = ToBeClassified;
        }
        field(50008; "Service Start Date"; Date)
        {
            Caption = 'Service Start Date';
            DataClassification = CustomerContent;
        }
        field(50009; "Service End Date"; Date)
        {
            Caption = 'Service End Date';
            DataClassification = CustomerContent;
        }
        field(50010; "Indent No."; Code[20])
        {
            Caption = 'Indent No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Indent Line No."; Integer)
        {
            Caption = 'Indent Line No.';
            DataClassification = CustomerContent;
        }

    }
}
