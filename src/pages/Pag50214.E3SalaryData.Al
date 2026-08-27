page 50214 "E3 Salary Data List"
{
    PageType = List;
    SourceTable = "E3 Salary Data";
    Permissions = tabledata "E3 Salary Data" = RIMD;
    Caption = 'Salary Data';
    ApplicationArea = All;
    UsageCategory = Lists;


    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(group)
            {
                field(glCode; Rec.GlCode)
                {
                    ApplicationArea = All;
                }
                field(debit; Rec.Debit)
                {
                    ApplicationArea = All;
                }
                field(credit; Rec.Credit)
                {
                    ApplicationArea = All;
                }
                field(companyName; Rec.CompanyName)
                {
                    ApplicationArea = All;
                }
                field(departmentName; Rec.DepartmentName)
                {
                    ApplicationArea = All;
                }
                field(branch; Rec.Branch)
                {
                    ApplicationArea = All;
                }
                field(branchName; Rec.BranchName)
                {
                    ApplicationArea = All;
                }
                field(employeeCode; Rec.EmployeeCode)
                {
                    ApplicationArea = All;
                }
            }

        }
    }
}

