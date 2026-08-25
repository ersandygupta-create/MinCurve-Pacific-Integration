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
        field(5; DepartmentName; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Department Name';
        }
        field(6; Branch; Text[60])
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
    }

    keys
    {
        key(Key1; EntryNo)
        {
            Clustered = true;
        }
    }

}