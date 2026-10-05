page 50216 "E3 Salary Data Batch API"
{
    APIGroup = 'salary';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'SalaryDataBatchAPI';
    DelayedInsert = true;
    EntityName = 'salaryDataBatch';
    EntitySetName = 'salaryDataBatchs';
    SourceTable = "E3 Salary Data";
    SourceTableTemporary = true;
    PageType = API;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(batchNo; BatchNo)
                {
                    Caption = 'Batch No.';

                    trigger OnValidate()
                    begin
                        Rec.Init();
                        Rec.Insert();
                    end;
                }
            }
            part(SalaryDataLine; "E3 Salary Data")
            {
                Caption = 'SalaryData';
                EntityName = 'salaryData';
                EntitySetName = 'salaryDatas';
            }
        }
    }

    var
        BatchNo: Text[100];
}
