page 50076 "E3 Indent Role Center"
{
    PageType = RoleCenter;
    Caption = 'Indent Module';
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(RoleCenter)
        {
            part(IndentCue; "E3 Indent Cue Card")
            {
                ApplicationArea = All;
            }
            part(PurchaseActivity; "E3 Indent Purch. Cue Card")
            {
                ApplicationArea = All;
            }
            part(EmailActivities; "Email Activities")
            {
                ApplicationArea = All;
            }
            part(ApprovalsActivities; "Approvals Activities")
            {
                ApplicationArea = Suite;
            }
        }
    }

    actions
    {
        area(Embedding)
        {
            group("Indent Module")
            {
                Caption = 'Indent Module';
                group("Create Indent")
                {
                    Caption = 'Create Indent';
                    action("System Indent")
                    {
                        ApplicationArea = All;
                        Caption = 'System Indent';
                        Image = NewDocument;
                        RunObject = Page "E3 Purchase Indent List";
                        RunPageMode = Create;
                    }

                }
                group("Approved Indent")
                {
                    Caption = 'Approved Indent';

                    action("System Approved Indent")
                    {
                        ApplicationArea = All;
                        Caption = 'System Approved Indent';
                        Image = Approvals;
                        RunObject = Page "E3 Approved Indent List";
                    }

                }


            }
        }
        // area(Creation)
        // {

        // }
        area(Processing)
        {
            action(Vendor)
            {
                Caption = 'Vendor';
                Image = Vendor;
                visible = false;
                RunObject = Page "Vendor List";
            }
            action(SyatemIndent)
            {
                Caption = 'System Indent';
                Image = View;
                RunObject = Page "E3 Purchase Indent List";
            }

            action(ApprovedIndentList)
            {
                Caption = 'Approved Indents';
                Image = Approvals;
                RunObject = Page "E3 Approved Indent List";
            }

        }

        // area(Reporting)
        // {
        //     group("Indent Reports")
        //     {
        //         Caption = 'Indent Reports';

        //         action("Indent Report")
        //         {
        //             ApplicationArea = All;
        //             Caption = 'Indent Report';
        //             Image = Report;
        //             RunObject = Report "E3 Indent Slip";
        //         }
        //         action("Indent Slip")
        //         {
        //             ApplicationArea = All;
        //             Caption = 'Indent Slip';
        //             Image = Report;
        //             RunObject = Report "E3 Indent Slip";
        //         }
        // }
        //}
    }
}