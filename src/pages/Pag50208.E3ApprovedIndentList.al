page 50208 "E3 Approved Indent List"
{
    PageType = List;
    SourceTable = "E3 Purchase Indent Header";
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'System Approved Indent List';
    CardPageId = "E3 Purchase Indent Card";
    SourceTableView = sorting("Document No.") order(descending) WHERE(Status = FILTER(Approved), "Source Type" = filter(D365));

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
                field("Indent No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique indent number.';
                }
                field("Indenter Name"; Rec."Indenter Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the indentor.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on which the indent was requested.';
                }
                field("To Department"; Rec."To Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department for which the indent is created.';
                }
                field("To Department Name"; Rec."To Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department for which the indent is created.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the indent.';
                }
                field("shortcut dimension 2 code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shortcut dimension 2 code associated with the indent.';
                }
                field("department name"; Rec."Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name associated with the indent.';
                }
                field("to department code";
                Rec."To Department Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department code associated with the indent.';
                }
                field("todepartment name";
                Rec."To Department Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name associated with the indent.';
                }

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who approved the indent.';
                }
                field("Approved Date"; Rec."Approval Date Time") // Replace with your exact Approval Date field name on header table
                {
                    ApplicationArea = All;
                    Caption = 'Approved Date';
                    ToolTip = 'Specifies the date on which the indent was approved.';
                }

                // New Fields for PO Details
                field("PO Status"; POStatus)
                {
                    ApplicationArea = All;
                    Caption = 'PO Status';
                    ToolTip = 'Specifies whether PO creation is Completed, Partially Created, or Not Created.';
                }
                field("PO No."; PONumbers)
                {
                    ApplicationArea = All;
                    Caption = 'PO No.';
                    ToolTip = 'Specifies all PO numbers created against this document.';
                }
                field("PO Date"; PODates)
                {
                    ApplicationArea = All;
                    Caption = 'PO Date';
                    ToolTip = 'Specifies all PO dates corresponding to the created POs.';
                }
                field(approver; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who approved the indent.';
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

    trigger OnAfterGetRecord()
    begin
        CalculatePOInformation();
    end;

    var
        POStatus: Text[30];
        PONumbers: Text[250];
        PODates: Text[250];

    local procedure CalculatePOInformation()
    var
        IndentLine: Record "E3 Purchase Indent Line"; // Replace with your actual Indent Line table name
        PurchHeader: Record "Purchase Header";
        TotalLines: Integer;
        POLinesCount: Integer;
    begin
        // Reset global display variables
        POStatus := 'Not Created';
        PONumbers := '';
        PODates := '';
        TotalLines := 0;
        POLinesCount := 0;

        IndentLine.SetRange("Document No.", Rec."Document No.");
        if IndentLine.FindSet() then begin
            TotalLines := IndentLine.Count();
            repeat
                // Check if PO is linked on line level
                if IndentLine."Purchase Order No." <> '' then begin
                    POLinesCount += 1;

                    // Build comma-separated PO Numbers (avoiding duplicates)
                    if not PONumbers.Contains(IndentLine."Purchase Order No.") then begin
                        if PONumbers <> '' then begin
                            PONumbers += ', ';
                            PODates += ', ';
                        end;
                        PONumbers += IndentLine."Purchase Order No.";

                        // Fetch Order Date from Purchase Header
                        if PurchHeader.Get(PurchHeader."Document Type"::Order, IndentLine."Purchase Order No.") then
                            PODates += Format(PurchHeader."Order Date", 0, '<Day,2>/<Month,2>/<Year4>')
                        else
                            PODates += 'N/A';
                    end;
                end;
            until IndentLine.Next() = 0;
        end;

        // Determine Status based on line counts
        if (TotalLines > 0) and (POLinesCount = TotalLines) then
            POStatus := 'Completed'
        else if POLinesCount > 0 then
            POStatus := 'Partially Created'
        else
            POStatus := 'Not Created';
    end;
}