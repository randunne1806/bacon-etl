SELECT
    true as "Is Bacon",
    IIF(
        [R-STOCK-LOC] <> '',
        'STOCK',
        CASE
            [R-RELEASE-STATUS]
            WHEN 'I' THEN 'Invoiced'
            WHEN 'S' THEN 'Shipped'
            WHEN 'Y' THEN 'Released'
            WHEN 'M' THEN 'MRB'
            WHEN 'X' THEN 'Canceled'
            ELSE 'Not Released'
        END
    ) as "Status",
    [H-CUST-NBR] as "Customer",
    TRIM([R-JOB#]) + TRIM([R-RELEASE-NBR]) as "Release Num",
    [H-CUST-NBR] + ':' + TRIM(ISNULL([R-PO-NBR], '-')) + ':' + TRIM([R-JOB#]) + ':' + TRIM([R-TRACKING-NBR]) + '' as "Item Id",
    [H-CUST-NBR] + ':' + TRIM(ISNULL([R-PO-NBR], '-')) + ':' + TRIM([R-JOB#]) + ':' + TRIM([R-RELEASE-NBR]) as "Order Item",
    [H-CUST-NBR] + ':' + TRIM(ISNULL([R-PO-NBR], '-')) as "Order",
    ISNULL([R-DUE-QTY], 0) as "Quantity",
    [R-JOB#] as "Item",
    [R-JOB#] as "Eng Part",
    [R-SHIP-VIA] as "Ship Via",
    [R-SHIP-ID] as "Ship Address Index",
    [R-REMARKS2] as "Release Notes",
    [RecordCreateDateTime] as "Created At",
    IIF(
        [R-Plant-Id] = '1',
        'Amitron',
        IIF(
            [R-Plant-Id] = '2',
            'India',
            IIF([R-Plant-Id] = '3', 'China', '')
        )
    ) as "Manf Location",
    [R-RELEASE-DATE] as "Release Date",
    [R-STATUS] as "Bacon - Status",
    [R-RELEASE-STATUS] as "Bacon - Release Status",
    TRIM([R-JOB#]) + ':' + TRIM(ISNULL([R-PROC-SEQ], [H-PROC-SEQ])) + '' as "BOM",
    [R-RELEASED-BY] as "Released By",
    'Manufacture' as "Release Type",
    [R-DUE-DATE] as "Ship Date",
    [MLZCY] as "Bacon - Sales Priority",
    [R-Priority] as "Bacon - Production Priority",
    [R-STOCK-LOC] as "Bacon - Stock Location"
FROM
    RELEASE
    LEFT JOIN HEADER ON [R-JOB#] = [H-JOB#]
WHERE
    [R-DUE-DATE] >= '2022-01-01'