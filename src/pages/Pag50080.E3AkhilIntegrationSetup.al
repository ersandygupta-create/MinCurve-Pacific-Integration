page 50080 "E3 Akhil Integration Setup"
{
    ApplicationArea = All;
    Caption = 'HIS Integration Setup';
    PageType = Card;
    SourceTable = "E3 Akhil Integration Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Integration Enabled"; Rec."Integration Enabled")
                {
                    ToolTip = 'Specifies the value of the Integration Enabled field.';
                }
                field(Username; Rec.Username)
                {
                    ToolTip = 'Specifies the value of the Username field.';
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                }
                field(Host; Rec.Host)
                {
                    ToolTip = 'Specifies the value of the Host field.';
                }
            }
            group(API)
            {
                Caption = 'API';

                field("Vendor Master API"; Rec."Vendor Master API")
                {
                    ToolTip = 'Specifies the value of the Vendor Master API field.';
                }
                field("Vendor Master API Enabled"; Rec."Vendor Master API Enabled")
                {
                    ToolTip = 'Specifies the value of the Vendor Master API Enabled field.';
                }
                // field("Settlement API"; Rec."Settlement API")
                // {
                //     ToolTip = 'Specifies the value of the Settlement API field.';
                // }
                // field("Settlement API Enabled"; Rec."Settlement API Enabled")
                // {
                //     ToolTip = 'Specifies the value of the Settlement API Enabled field.';
                // }

                // field("TDS API"; Rec."TDS API")
                // {
                //     ToolTip = 'Specifies the value of the TDS API field.';
                // }
                // field("TDS API Enabled"; Rec."TDS API Enabled")
                // {
                //     ToolTip = 'Specifies the value of the TDS API Enabled field.';
                // }
                // field("Write-off API"; Rec."Write-off API")
                // {
                //     ToolTip = 'Specifies the value of the Write-off API field.';
                // }
                // field("Write-off API Enabled"; Rec."Write-off API Enabled")
                // {
                //     ToolTip = 'Specifies the value of the Write-off API Enabled field.';
                // }
            }
            group("LIS API")
            {
                Caption = 'LIS API';
                field("LIS Username"; Rec."LIS Username")
                {
                    ToolTip = 'Specifies the value of the LIS Username field.';
                }
                field("LIS Password"; Rec."LIS Password")
                {
                    ToolTip = 'Specifies the value of the LIS Password field.';
                }
                field("LIS Host"; Rec."LIS Host")
                {
                    ToolTip = 'Specifies the value of the LIS Host field.';
                }

                field("LIS Vendor Master API"; Rec."LIS Vendor Master API")
                {
                    ToolTip = 'Specifies the value of the Vendor Master API field.';
                }
                field("LIS Vendor Master API Enabled"; Rec."LIS Vendor Master API Enabled")
                {
                    ToolTip = 'Specifies the value of the LIS Vendor Master API field.';
                }
            }
        }
    }
}