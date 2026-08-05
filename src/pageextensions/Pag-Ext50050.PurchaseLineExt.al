pageextension 50050 "E3 HIS Purch. Order Subform" extends "Purchase Order Subform"
{
    layout
    {
        addafter("Qty. Assigned")
        {
            field("Service Start Date"; Rec."Service Start Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the service start date.';
            }

            field("Service End Date"; Rec."Service End Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the service end date.';
            }
            field("Indent No."; Rec."Indent No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Indent No.';
            }
            field("Indent Line No."; Rec."Indent Line No.")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Indent Line No.';
            }
        }
    }
}
