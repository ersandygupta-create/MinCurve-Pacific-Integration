page 50201 "E3 Quotation List"
{
    CardPageID = "E3 Quotation Card";
    Editable = false;
    PageType = List;
    SourceTableView = sorting("Document No.") WHERE(Status = FILTER(Approved), "Release Indent" = FILTER(false));
    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Quotation Lists';
    SourceTable = "E3 Purchase Indent Header";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Document No."; Rec."Document No.")
                {
                    Caption = 'Indent No.';
                    ToolTip = 'Specifies the indent number of the Indent No.';
                }
                field("Requested By"; Rec."Requested To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the requested by of the Requested By.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the request date of the Request Date.';
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

                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the Status.';
                }

                field("Expected Receive Date"; Rec."Expected Receive Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the expected receive date of the Expected Receive Date.';
                }

                field("Approved By"; Rec."Approved By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approved by of the Approved By.';
                }
                field("Approval date time"; Rec."Approval Date Time")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval date time of the Approval Date Time.';
                }

                // New Fields
                field("PO Status"; POStatus)
                {
                    ApplicationArea = All;
                    Caption = 'PO Status';
                    ToolTip = 'Specifies whether PO creation is Completed or Partially Created.';
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
            }
        }
    }

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
                // Check if PO is linked on line level (e.g., "PO No." or "Purchase Order No.")
                if IndentLine."Purchase Order No." <> '' then begin
                    POLinesCount += 1;

                    // Build comma-separated PO Numbers (avoiding duplicates)
                    if not PONumbers.Contains(IndentLine."Purchase Order No.") then begin
                        if PONumbers <> '' then begin
                            PONumbers += ', ';
                            PODates += ', ';
                        end;
                        PONumbers += IndentLine."Purchase Order No.";

                        // Get Order Date from Purchase Header
                        if PurchHeader.Get(PurchHeader."Document Type"::Order, IndentLine."Purchase Order No.") then
                            PODates += Format(PurchHeader."Order Date", 0, '<Day,2>/<Month,2>/<Year4>')
                        else
                            PODates += 'N/A';
                    end;
                end;
            until IndentLine.Next() = 0;
        end;

        // Determine Status
        if (TotalLines > 0) and (POLinesCount = TotalLines) then
            POStatus := 'Completed'
        else if POLinesCount > 0 then
            POStatus := 'Partially Created'
        else
            POStatus := 'Not Created';
    end;
}