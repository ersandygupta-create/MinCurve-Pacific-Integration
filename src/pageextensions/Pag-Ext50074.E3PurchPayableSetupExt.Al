pageextension 50075 "E3 Purch Payble Extension" extends 460
{
    layout
    {
        addafter("Posted Delivery Challan Nos.")
        {
            field("E3 Order Address Number"; Rec."E3 Order Address Number")
            {
                ApplicationArea = all;
                ToolTip = 'No. seried for Order Address';
                Caption = 'Order Address No. Series';
            }
            field("HIS GRN Amount Validation"; Rec."HIS GRN Amount Validation")
            {
                Caption = 'HIS GRN Amount Validation';
                ApplicationArea = All;
                ToolTip = 'Specify a HIS GRN Amount Validation field.';
            }
            field("GRN Vendor Code Check"; Rec."GRN Vendor Code Check")
            {
                Caption = 'GRN Vendor Code Check';
                ApplicationArea = All;
                ToolTip = 'Specify a GRN Vendor Code Check field.';
            }

        }
    }


}