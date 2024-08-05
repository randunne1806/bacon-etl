SELECT
    [INVOICE/PACKING SLIP #] as "Invoice Num",
    [Invoice Date] as "Invoice Date",
    [Job Nbr] as "Eng Part Num",
    [PURCHASE ORDER NBR] as "PO Num",
    [Part #] as "Part Num",
    Rev as Revision,
    [Ship Via] as "Ship Via",
    IIF(
        Terms IS NULL,
        'NET30',
        IIF(
            Terms = 'NET 30',
            'NET30',
            IIF(
                Terms = 'NET 45',
                'NET45',
                IIF(
                    Terms = 'NET 60',
                    'NET60',
                    IIF(
                        Terms = 'NET 70',
                        'NET70',
                        IIF(
                            Terms = 'NET 90',
                            'NET90',
                            IIF(
                                Terms = 'CRED CARD',
                                'NET0',
                                IIF(
                                    Terms = 'COD',
                                    'NET0',
                                    IIF(
                                        Terms = 'Credit Card',
                                        'NET0',
                                        IIF(
                                            Terms = '30',
                                            'NET30',
                                            IIF(
                                                Terms = '1%10/NET 30',
                                                'NET60',
                                                IIF(Terms = '1%15/NET 30', 'NET60', Terms)
                                            )
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    ) as "Terms",
    [Total Amount] as "Total",
    Freight,
    [Tooling $] as "Tooling",
    [Total Qty] as "Quantity",
    [Customer-NBR] as "Customer",
    [SLS REP 2] as "Sales Rep 2",
    [H-SLMN#] as "Sales Rep 1",
    [Customer-Name] as "Customer Name",
    [Balance] as "Balance Due",
    Discount as "Discount Taken",
    ROUND([Total Amount] - [Balance] - [Discount], 2) as "Paid Amount",
    [PACKING_SLIP_NBR] as "Packing Slip",
    'Open' as "Status",
    true as "Is Bacon"
FROM
    IHEADER
WHERE
    [Invoice Date] >= '01/01/2022'