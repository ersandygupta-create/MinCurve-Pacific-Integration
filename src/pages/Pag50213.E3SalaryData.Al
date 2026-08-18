page 50213 "E3 Salary Data"
{
    PageType = API;
    SourceTable = "E3 Salary Data";
    Permissions = tabledata "E3 Salary Data" = RIMD;
    APIPublisher = 'mindcurve';
    APIGroup = 'salary';
    APIVersion = 'v2.0';
    Caption = 'Salary Data API';

    EntityName = 'salaryData';
    EntitySetName = 'salaryDatas';

    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(group)
            {

            }
            field(glCode; Rec.GlCode)
            {

            }
            field(debit; Rec.Debit)
            {

            }
            field(credit; Rec.Credit)
            {

            }
            field(companyName; Rec.CompanyName)
            { }
            field(departmentName; Rec.DepartmentName)
            { }
            field(branch; Rec.Branch)
            { }
            field(branchName; Rec.BranchName)
            { }
            field(employeeCode; Rec.EmployeeCode)
            { }
        }
    }
}

