pageextension 50016 "E3 Order Address Card" extends "Order Address"
{
    layout
    {
        addlast(General)
        {
            field("E3 NPU"; Rec."E3 NPU")
            {
                ToolTip = 'Specifies the value of the NPU field.';
                ApplicationArea = All;
            }
        }
        addlast(Communication)
        {
            field(HIS; Rec.HIS)
            {
                ToolTip = 'Specifies the value of the HIS Check box field.';
                ApplicationArea = All;
            }
            field("HIS Response"; Rec."HIS Response")
            {
                ToolTip = 'Specifies the value of the HIS Response field.';
                ApplicationArea = All;
            }
            field("IT Dose"; Rec."IT Dose")
            {
                ToolTip = 'Specifies the value of the HIS Check box field.';
                ApplicationArea = All;
            }
            field("IT Response"; Rec."IT Response")
            {
                Caption = 'IT Dose Response';
                ToolTip = 'Specifies the value of the IT Dose Response field.';
                ApplicationArea = All;

            }

        }
    }
    actions
    {
        addlast(Processing)
        {
            group("HIS Integration")
            {
                Caption = 'Integration';
                Image = SendTo;

                action(SendToHIS)
                {
                    ApplicationArea = all;
                    Caption = 'Send to HIS';
                    ToolTip = 'Send to HIS';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Image = SendTo;
                    trigger OnAction()
                    var
                        E3IntegrationMgmt: Codeunit "E3 Akhil Integration Mgmt.";
                        VendRec: Record Vendor;
                    begin
                        // Get the vendor record for this address
                        if VendRec.Get(Rec."Vendor No.") then
                            E3IntegrationMgmt.ManualSendToHIS(Rec);
                    end;
                }
                action(SyncLog)
                {
                    Caption = 'HIS Sync Logs';
                    ToolTip = 'HIS System Sync Logs.';
                    Image = Log;
                    ApplicationArea = all;
                    RunObject = page "E3 API Supplier Update Logs";
                    RunPageLink = "No." = field("Vendor No.");
                    RunPageMode = View;
                }
                action(SendToITDose)
                {
                    ApplicationArea = all;
                    ToolTip = 'Send to HIS';
                    Caption = 'Send to IT Dose';
                    Image = SendTo;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        E3IntegrationMgmt: Codeunit "E3 ITDose Integration Mgmt.";
                        VendRec: Record Vendor;
                    begin
                        if VendRec.Get(Rec."Vendor No.") then
                            E3IntegrationMgmt.ManualSendToHIS(Rec);
                    end;
                }
                action(SyncLogITDose)
                {
                    Caption = 'ITDose Sync Logs';
                    ToolTip = 'HIS System Sync Logs.';
                    Image = Log;
                    ApplicationArea = all;
                    RunObject = page "E3 API Suppl Update Log ITDose";
                    RunPageLink = "No." = field("Vendor No.");
                    RunPageMode = View;
                }
            }
        }
    }
}
