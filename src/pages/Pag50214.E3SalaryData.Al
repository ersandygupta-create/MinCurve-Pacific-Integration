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
                field("Department Code"; Rec."Department Code")
                {
                    ApplicationArea = All;
                    Caption = 'Department Code';
                    ToolTip = 'Specifies the department code.';
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
                field("Employee Name"; Rec."Employee Name")
                {
                    ApplicationArea = All;
                    Caption = 'Employee Name';
                    ToolTip = 'Specifies the employee name.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = all;
                    ToolTip = 'Posting Date';
                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                    ToolTip = 'Month';
                }
                field(Created; Rec.Created)
                {
                    ApplicationArea = all;
                    ToolTip = 'JV Created';
                }
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Post Salary")
            {
                Caption = 'Post Salary';
                ToolTip = 'Post Salary';
                Image = Post;
                trigger OnAction()
                var
                    IntegrationManagment: Codeunit "E3 HIS Integration Mgmt.";
                begin
                    IntegrationManagment.CreateGenJnlLinesFromSalaryData(rec);
                end;
            }
        }
    }
}

