tableextension 50067 "E3 Purchase Payable Setup Ext" extends "Purchases & Payables Setup"
{
    fields
    {
        field(50000; "E3 Order Address Number"; code[10])
        {
            Caption = 'Order Address No Series';
            TableRelation = "No. Series".Code;
        }
        field(50001; "HIS GRN Amount Validation"; Boolean)
        {
            Caption = 'HIS GRN AMount Validation';
            DataClassification = CustomerContent;
        }
        field(50002; "GRN Vendor Code Check"; Boolean)
        {
            Caption = 'GRN Vendor Code Check';
            DataClassification = CustomerContent;
        }

    }

}