page 50078 "E3 Indent Purch. Cue Card"
{
    PageType = CardPart;
    SourceTable = "E3 Indent Cue";
    Caption = 'Purchase Activities';

    layout
    {
        area(Content)
        {
            cuegroup(Activities)
            {
                field("Purchase Orders"; Rec."Purchase Orders")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the total number of purchase orders.';
                }
                field("Pending Purchase Orders"; Rec."Pending Purchase Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the total number of purchase orders that are pending approval.';
                }
                field("Approved Purchase Orders"; Rec."Approved Purchase Orders")
                {
                    ApplicationArea = All;
                    DrillDownPageId = "Purchase Order List";
                    ToolTip = 'Specifies the total number of approved (released) purchase orders.';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get('1') then begin
            Rec.Init();
            Rec."Primary Key" := '1';
            Rec.Insert();
        end;
    end;
}
