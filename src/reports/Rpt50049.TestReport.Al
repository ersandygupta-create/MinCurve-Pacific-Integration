report 50049 TestReport
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    Caption = 'Test Report';
    DefaultLayout = RDLC;
    RDLCLayout = './src/reports/Rpt50049.TestReport.rdl';

    dataset
    {
        dataitem(Vendor; Vendor)
        {
            column(Name; Name)
            {

            }
            column(No_; "No.")
            { }
            column(Address; Address)
            {

            }
        }
    }

    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(VendNo; VendNo)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Vendor No.';
                        Caption = 'Vendor No.';
                        TableRelation = Vendor."No.";
                    }
                }
            }
        }
    }
    var
        VendNo: Text;
}