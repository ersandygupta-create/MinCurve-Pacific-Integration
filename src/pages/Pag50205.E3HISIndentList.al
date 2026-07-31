page 50205 "E3 HIS Indent List"
{
    PageType = List;
    SourceTable = "E3 Purchase Indent Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'HIS Indent List';
    CardPageId = "E3 Purchase Indent Card";
    SourceTableView = WHERE(Status = FILTER(Open | "Pending Approval"), "Source Type" = filter(HIS));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; Rec."Requested To")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                }

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}