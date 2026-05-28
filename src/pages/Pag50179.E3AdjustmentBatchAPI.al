page 50179 "E3 Adjustment Batch API"
{
    APIGroup = 'apiHIS';
    APIPublisher = 'mindcurve';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'e3AdjustmentBatchAPI';
    DelayedInsert = true;
    EntityName = 'e3AdjustmentBatch';
    EntitySetName = 'e3AdjustmentBatch';
    SourceTable = "E3 HIS Consumption Entries";
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
            part(RevenueLine; "E3 Adjustment API")
            {
                Caption = 'Adjustments';
                EntityName = 'adjustment';
                EntitySetName = 'adjustments';
            }
        }
    }

    var
        BatchNo: Text[100];
}
