tableextension 50023 "E3 HIS Sales Header" extends "Sales Header"
{
    fields
    {
        field(50000; "E3 RCM"; Boolean)
        {
            Caption = 'RCM';
            DataClassification = CustomerContent;
        }
        field(50001; "E3 HIS Module"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'HIS Module';
        }
        field(50002; "E3 HIS Document Type"; Text[60])
        {
            DataClassification = CustomerContent;
            Caption = 'HIS Document Type';
        }
        field(50003; "E3 Receipt No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Receipt No.';
        }
        field(50004; "E3 UHID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'UHID';
        }
        field(50005; "E3 Patient Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Patient Name';
        }
        field(50100; "E3 Encounter No."; Code[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Encounter No.';
        }
        field(50102; "E3 Doctor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Doctor Name';
        }
        field(50103; "E3 Speciality"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Speciality';
        }
        field(50104; "E3 Sponsor Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Sponsor Code';
        }
        field(50105; "E3 Sponsor Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Sponsor Name';
        }
        field(50106; "E3 Payer Code"; Code[16])
        {
            DataClassification = CustomerContent;
            Caption = 'Payer Code';
        }
        field(50107; "E3 Payer Name"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Payer Name';
        }
        field(50008; "Indent Amount"; Decimal)
        {
            Caption = 'Indent Amount';
            DataClassification = ToBeClassified;
        }
        field(50009; "Station Name"; Text[60])
        {
            Caption = 'Station Name';
            DataClassification = ToBeClassified;
        }
        field(50010; "Order Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50011; "Integration PO Created"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50012; "Indent Order"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50013; "Amount to Customer"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Sales Line"."Line Amount" WHERE("Document Type" = FIELD("Document Type"),
                                                                                 "Document No." = FIELD("No.")));
            Caption = 'Amount to Customer';
            Editable = false;
            FieldClass = FlowField;
        }
    }
}
