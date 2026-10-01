table 50042 "E3 Salary Data"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; GlCode; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'GL Account';
        }
        field(2; Debit; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Debit Amount';
        }
        field(3; Credit; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Credit Amount';
        }
        field(4; CompanyName; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Company Name';
        }
        field(5; DepartmentName; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Department Name';
        }
        field(6; Branch; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Branch';
        }
        field(7; BranchName; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Branch Name';
        }
        field(8; EmployeeCode; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Employee Code';
        }
        field(9; EntryNo; Integer)
        {
            AutoIncrement = true;
        }
        field(10; "Posting Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Posting Date';
        }
        field(11; "Month"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Month';
        }
        field(12; Created; Boolean)
        {
            Editable = false;
            DataClassification = CustomerContent;
            Caption = 'JV Created';
        }
        field(13; "Employee Name"; Text[100])
        {
            Caption = 'Employee Name';
            DataClassification = CustomerContent;
        }
        field(14; "Department Code"; Code[20])
        {
            Caption = 'Department Code';
            DataClassification = CustomerContent;
        }
    }


    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }
    // trigger OnInsert()
    // begin
    //     "Posting Date" := Today();
    //     Month := Format(Today(), 0, '<Month Text>-<Year4>');
    // end;

}