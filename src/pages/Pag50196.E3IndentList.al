page 50196 "E3 Purchase Indent List"
{
    PageType = List;
    SourceTable = "E3 Purchase Indent Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'System Indent List';
    CardPageId = "E3 Purchase Indent Card";
    SourceTableView = WHERE(Status = FILTER(Open | "Pending Approval" | "Cancelled"), "Source Type" = filter(D365));

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Source Type"; Rec."Source Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source type of the indent.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Indent No.';
                    ToolTip = 'Specifies the unique document number of the indent.';
                }
                field("Indentor Name"; Rec."Indenter Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the indentor.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the indent request was created.';
                }
                field("Requested To"; Rec."Requested To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the person or department to whom the indent is requested.';
                }
                field(requestedto; Rec.RequestedTo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the person or department to whom the indent is requested.';
                }
                field("Expected Receive Date"; Rec."Expected Receive Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected receipt date for the indent items.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'BU';
                    ToolTip = 'Specifies the Business Unit code.';
                }
                field("Business Unit Name"; Rec."Business Unit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Business Unit Name';
                    ToolTip = 'Specifies the Business Unit name.';
                }
                field("To Department Code"; Rec."To Department Code")
                {
                    ApplicationArea = All;
                    Caption = 'Department Code';
                    ToolTip = 'Specifies the department code.';
                }
                field("To Department Name"; Rec."To Department Name")
                {
                    ApplicationArea = All;
                    Caption = 'Department Name';
                    ToolTip = 'Specifies the department name.';
                }
                field("Total Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the total calculated amount for the indent.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the indent.';
                }
                field("approval date time"; Rec."Approval Date Time")
                {
                    ApplicationArea = All;
                    Caption = 'Approved Date';
                    ToolTip = 'Specifies the date and time when the indent was approved.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies any remarks or additional comments.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(2);                  // Switch to FilterGroup 2 (Locked/Page Filters)
        Rec.SetFilter(Indenter, '%1', UserId); // Apply the locked filter
        Rec.FilterGroup(0);
    end;

}