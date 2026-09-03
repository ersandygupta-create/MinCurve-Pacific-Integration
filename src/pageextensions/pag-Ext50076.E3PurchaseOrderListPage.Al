pageextension 50076 E3PurchaseOrderListPage extends 9307
{
    layout
    {
        addafter("Posting Date")
        {
            field("Order Date"; rec."Order Date")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Date field';
            }
        }
    }

}