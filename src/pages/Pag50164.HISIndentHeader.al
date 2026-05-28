page 50164 "E3 HIS Purchase Indent Header"
{

    Caption = 'HIS Purchase Indent Header';
    PageType = Document;
    Editable = true;
    // InsertAllowed = false;
    // DeleteAllowed = false;
    // DelayedInsert = false;
    SourceTable = "E3 HIS Indent Header";
    SourceTableView = sorting("Entry No.") where("Record Type" = Filter(Purchase | "Purchase Return"), "Document Type" = filter(Invoice | "Credit Memo"));

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Record Type"; Rec."Record Type")
                {
                    ToolTip = 'Specifies the value of the Record Type field';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ToolTip = 'Specifies the value of the Document Type field';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Vendor No."; Rec."Vendor/Customer No.")
                {
                    ToolTip = 'Specifies the value of the Vendor No. field';
                    ApplicationArea = All;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Editable = false;
                    Caption = 'Vendor No.';
                }
                field("Vendor Name"; Rec."Vendor/Customer Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field';
                    ApplicationArea = All;
                    Style = StrongAccent;
                    StyleExpr = false;
                    Editable = false;
                    Caption = 'Vendor Name';
                }
                // field("Invoice No."; Rec."Invoice No.")
                // {
                //     ToolTip = 'Specifies the value of the Invoice No. field';
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                // field("Invoice Date"; Rec."Invoice Date")
                // {
                //     ToolTip = 'Specifies the value of the Invoice Date field';
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Indent Order No."; Rec."Indent Order No.")
                {
                    ToolTip = 'Specifies the value of the Indent Order No. field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Indent Order Date"; Rec."Indent Order Date")
                {
                    ToolTip = 'Specifies the value of the Indent Order Date field';
                    ApplicationArea = All;
                    Editable = false;
                }
                // field("Posting Date"; Rec."Posting Date")
                // {
                //     ToolTip = 'Specifies the value of the Posting Date field';
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                // field("Location Code"; Rec."Location Code")
                // {
                //     ToolTip = 'Specifies the value of the Location Code field';
                //     ApplicationArea = All;
                //     Editable = false;
                // }
                field("No. of Lines"; Rec."No. of Lines")
                {
                    ToolTip = 'Specifies the value of the No. of Lines field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Station Name"; Rec."Station Name")
                {
                    ToolTip = 'Specifies the value of the Station Name field';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Create Document"; Rec."Create PO")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                    Caption = 'Create Document';
                }
                field("Error Description"; Rec."Error Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Customer/Vendor No."; Rec."Error 1")
                {
                    Caption = 'Vendor No';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pruchase Account"; Rec."Error 2")
                {
                    Caption = 'Account No.';
                    ApplicationArea = All;
                    Editable = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("HSN Code"; Rec."Error 3")
                {
                    Caption = 'HSN/SAC Code';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("GST Group Code"; Rec."Error 4")
                {
                    Caption = 'GST Group Code';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            part(HISPurchaseSubform; "E3 HIS Purchase Indent Subform")
            {
                ApplicationArea = Basic, Suite;
                UpdatePropagation = Both;
                SubPageLink = "Document No." = FIELD("Document No."), "Record Type" = field("Record Type"),
                "document Type" = field("Document Type");
                Editable = blnPageEditable;
            }
            group("Log Details")
            {
                field(SystemCreatedBy; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = all;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = ALL;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action("Indent Order Validate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Indent Order Validate';
                Image = Create;
                Visible = blnPageEditable;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    HISIntegration: Codeunit "E3 HIS Indent Integration";
                begin
                    IF NOT REC."Create PO" then begin
                        if (Rec."Record Type" = Rec."Record Type"::Purchase) OR (Rec."Record Type" = Rec."Record Type"::"Purchase Return") and (Rec."Document Type" = Rec."Document Type"::Invoice) then begin
                            HISIntegration.OrderValidation(Rec."Record Type", Rec."Document Type", Rec."Document No.");
                        end;
                    END ELSE
                        Error('Purchase Order is already Created.No need to Validate Purchase Order');
                end;
            }
            action("Indent Order ReValidate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Indent Order ReValidate';
                Visible = blnPageEditable;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    HISIntegration: Codeunit "E3 HIS Indent Integration";
                begin
                    IF NOT REC."Create PO" then begin
                        if (Rec."Record Type" = Rec."Record Type"::Purchase) or (Rec."Record Type" = Rec."Record Type"::"Purchase Return") and (Rec."Document Type" = Rec."Document Type"::Invoice) OR (Rec."Document Type" = Rec."Document Type"::"Credit Memo") then begin
                            HISIntegration.OrderREValidation(Rec."Record Type", Rec."Document Type", Rec."Document No.");
                        end;
                    END ELSE
                        Error('Purchase Order is already Created.No need to ReValidate Purchase Order');
                end;
            }
            action("Create Pruchase Invoice")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Create Pruchase Invoice';
                Image = Create;
                Visible = blnPageEditable;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    HISIntegration: Codeunit "E3 HIS Indent Integration";
                begin
                    IF NOT REC."Create PO" then begin
                        if (Rec."Record Type" = Rec."Record Type"::Purchase) or (Rec."Record Type" = Rec."Record Type"::"Purchase Return") and (Rec."Document Type" = Rec."Document Type"::Invoice) OR (Rec."Document Type" = Rec."Document Type"::"Credit Memo") then begin
                            HISIntegration.InitPurchaseOrder(Rec."Record Type", Rec."Document Type", Rec."Document No.");
                        end;
                    END ELSE
                        Error('Purchase Order is already Created.No need to Create Purchase Order %1', Rec."Document No.");


                end;
            }
            action("Created Pruchase Invoice/Credit Memo")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Created Pruchase Invoice/Credit Memo';
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    HISIntegration: Codeunit "E3 HIS Indent Integration";
                    PurchHeader: Record "Purchase Header";
                begin
                    IF (Rec."Create PO") THEN begin
                        PurchHeader.Reset;
                        PurchHeader.SetRange("Document Type", PurchHeader."Document Type"::Order, PurchHeader."Document Type"::"Return Order");
                        PurchHeader.SetRange("No.", Rec."Document No.");
                        if PurchHeader.FindFirst() then begin
                            if Rec."Record Type" = Rec."Record Type"::Purchase then
                                Page.RunModal(Page::"Purchase Invoice", PurchHeader);
                            if Rec."Record Type" = Rec."Record Type"::"Purchase Return" then
                                Page.RunModal(Page::"Purchase Credit Memo", PurchHeader);

                        end;
                    end;
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        if Rec."Create PO" then
            blnPageEditable := false
        ELSE
            blnPageEditable := true;
    end;

    trigger OnAfterGetRecord()
    begin
        if Rec."Create PO" then
            blnPageEditable := false
        ELSE
            blnPageEditable := true;
    end;


    var
        blnPageEditable: Boolean;
        PurchHeader: Record "Purchase Header";
        FileManagement: Codeunit "File Management";
        Text0001: TextConst ENU = 'Select Directory', ENN = 'Select Directory';
}
