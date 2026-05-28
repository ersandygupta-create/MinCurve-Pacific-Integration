pageextension 50000 "E3 HIS Vendor Card" extends "Vendor Card"
{
    layout
    {
        addlast(General)
        {
            field("E3 HIS Code"; Rec."E3 HIS Code")
            {
                ApplicationArea = All;
                Editable = false;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("E3 MSME Type"; Rec."E3 MSME Type")
            {
                ApplicationArea = All;
                Editable = true;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("MSME No."; Rec."E3 MSME No.")
            {
                ApplicationArea = All;
                Editable = true;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the value of the MSME No. field';
            }
            field("Type Of MSME"; Rec."Type Of MSME")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Type Of MSME field';
            }
            field("Classification of MSME"; Rec."Classification of MSME")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Classification of MSME field';
            }
            field("E3 Auto E-Mail"; Rec."E3 Auto E-Mail")
            {
                ApplicationArea = All;
                Style = StrongAccent;
                StyleExpr = true;
            }
            field("DL No."; Rec."DL No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("Name2"; Rec."Name 2")
            {
                ApplicationArea = All;
                Caption = 'Name 2';
                ToolTip = 'Specifies the value of the Name 2 field';
            }
        }
    }

    actions
    {
        addafter(PayVendor)
        {
            action("Vendor Ledger Report")
            {
                ApplicationArea = All;
                Caption = 'Vendor Ledger Report';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Report;
                trigger OnAction()
                begin
                    recVendor.Reset();
                    recVendor.SetRange("No.", Rec."No.");
                    REPORT.RUNMODAL(Report::"Vendor Ledger Report", TRUE, TRUE, recVendor);

                end;
            }
            action("Vendor NotePad Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor Payment Report_N';
                Image = xmlport;
                RunObject = xmlport "Vendor Payment Report_N";
                RunPageMode = Edit;
            }
            action("Vendor Excel Report")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Vendor Payment Report_Excel';
                Image = Report;
                RunObject = report "Vendor Payment Report";
                RunPageMode = Edit;

            }
            action("TDS Register")
            {
                ApplicationArea = All;
                Caption = 'TDS Register';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Report;
                trigger OnAction()
                begin
                    recTDSEntry.Reset();
                    recTDSEntry.SetRange(recTDSEntry."Vendor No.", Rec."No.");
                    REPORT.RUNMODAL(Report::"TDS Register Report", TRUE, TRUE, recTDSEntry);

                end;
            }
            action(CreateOrderAddress)
            {
                ApplicationArea = All;
                Caption = 'Generate Order Address';
                ToolTip = 'Generate Order Address';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Create;
                trigger OnAction()
                var
                    myInt: Integer;
                begin
                    GenerateOrderAddress(Rec);
                end;

            }

        }

        addafter("Ven&dor")
        {
            group(AkhilIntegration)
            {
                Caption = 'HIS Integration';

                action(SyncLog)
                {
                    Caption = 'HIS Sync Logs';
                    ToolTip = 'HIS System Sync Logs.';
                    Image = Log;
                    ApplicationArea = all;
                    RunObject = page "E3 API Supplier Update Logs";
                    RunPageLink = "No." = field("No.");
                    RunPageMode = View;
                }

                // action(ReSync)
                // {
                //     Caption = 'Re-Sync';
                //     ToolTip = 'Re-sync all data to Akhil Systems.';
                //     Image = LinkAccount;
                //     ApplicationArea = all;

                //     trigger OnAction()
                //     var
                //         EDCAkhilMgmt: Codeunit "E3 Akhil Integration Mgmt.";
                //     begin
                //         Clear(EDCAkhilMgmt);
                //         EDCAkhilMgmt.SupplierSyncAll(Rec);
                //     end;
                // }
            }
        }
    }
    procedure GenerateOrderAddress(var VendorRec: Record Vendor)
    begin
        PurchPayable.Get();
        if (PurchPayable."E3 Order Address Number" <> '') then begin
            OrderAddress.Reset();
            OrderAddress.SetRange("Vendor No.", VendorRec."No.");
            if OrderAddress.Find('-') then begin
                if Confirm('Do you want to create a new Order Address for Vendor %1?', false, VendorRec."No.") then begin
                    OrderAddress.Code := NoSeqMgmt.GetNextNo(PurchPayable."E3 Order Address Number");
                    OrderAddress."Vendor No." := VendorRec."No.";
                    OrderAddress.Address := '';
                    OrderAddress."Address 2" := '';
                    OrderAddress."ARN No." := '';
                    OrderAddress.City := '';
                    OrderAddress.State := '';
                    OrderAddress."GST Registration No." := '';
                    OrderAddress."Country/Region Code" := '';
                    State.Get(VendorRec."State Code");
                    OrderAddress.Name := VendorRec.Name + '-' + State."State Code (GST Reg. No.)";
                    OrderAddress."Name 2" := VendorRec."Name 2";
                    OrderAddress."Post Code" := '';
                    OrderAddress."Phone No." := '';
                    OrderAddress."E-Mail" := '';
                    OrderAddress.Insert();
                    CurrPage.Update();
                    Message('Order Address generated for Vendor %1.', VendorRec."No.");
                end;

            end
            else begin
                OrderAddress.Code := NoSeqMgmt.GetNextNo(PurchPayable."E3 Order Address Number");
                OrderAddress."Vendor No." := VendorRec."No.";
                OrderAddress.Address := VendorRec.Address;
                OrderAddress."Address 2" := VendorRec."Address 2";
                OrderAddress."ARN No." := VendorRec."ARN No.";
                OrderAddress.City := VendorRec.City;
                OrderAddress.State := VendorRec."State Code";
                OrderAddress."GST Registration No." := VendorRec."GST Registration No.";
                OrderAddress."Country/Region Code" := VendorRec."Country/Region Code";
                State.Get(VendorRec."State Code");
                OrderAddress.Name := VendorRec.Name + '-' + State."State Code (GST Reg. No.)";
                OrderAddress."Name 2" := VendorRec."Name 2";
                OrderAddress."Post Code" := VendorRec."Post Code";
                OrderAddress."Phone No." := VendorRec."Phone No.";
                OrderAddress."E-Mail" := VendorRec."E-Mail";
                OrderAddress.Insert();
                CurrPage.Update();
                Message('Order Address generate for Vendor %1.', VendorRec."No.");
            end;
        end else
            Error('Order Address Number sequence is not found in Purchase & Payble Setup.');

    end;

    var
        OrderAddress: Record "Order Address";
        PurchPayable: Record "Purchases & Payables Setup";
        NoSeqMgmt: Codeunit "No. Series";
        recVendor: Record Vendor;
        recTDSEntry: Record "TDS Entry";
        State: Record State;

}
