SELECT
    [R-PLN-QTY-BDS] as "Planned Qty",
    [R-DUE-QTY] as "Due Qty",
    [R-PLN-QTY-PNLS] as "Planned Panel Qty",
    [R-INVOICE-NBR] as "Invoice Num",
    [R-Turn-Time] as "Lead Time",
    [R-QUOTE-NBR] as "Quote Num",
    [R-ROUTING-LINEAL-INCHES] as "Routing Linear Inches",
    [R-PACKING-SLIP-NBR] as "Packing Slip Num",
    [R-Yield-Qty] as "Yield Qty",
    [R-SLDR-MSK-COLOR] as "Mask Color",
    [TR].[Inner Layer Num],
    [Shipped],
    [TT2].OPERID as "Work Operator",
    ROUND([TT2].DURATION, 2) as "Work Duration",
    [TT1].[Start] as "Start Time",
    [TT1].[OperId] as "Start Operator",
    [R-PO-NBR] as "PO Number",
    [R-PO-Date] as "PO Date",
    [R-COST] as "Unit Price",
    [R-LOT-PRICE] as "Lot Price",
    [TT].[Customer Id] as "Customer",
    TRIM([D-JOB#]) + CAST([D-DATE] as SQL_CHAR) + CAST([D-TIME] as SQL_CHAR) as "Item Id",
    TRIM([D-JOB#]) as "Release Num",
    [D-DATE] as "Date In",
    [D-TIME] as "Time In",
    [D-DEST] as "To Gate",
    [D-OPR] as "Moved By Operator",
    [D-FROM] as "Gate From",
    [D-DATE-OUT] as "Date Out",
    [D-TIME-OUT] as "Time Out",
    [R-BOARDS-PER-PNL] as "Boards Per Panel",
    [R-DUE-DATE] as "Due Date",
    [R-PRIORITY] as "Priority",
    [R-SHIP-VIA] as "Ship Via",
    [D-QTY-MOVED] as "Quantity Moved",
    [R-NBR-LAYERS] as "Layers",
    [R-STATUS] as "Release Status",
    [R-PLANT-ID] as "Plant Id",
    [R-PERCENT-OVER] as "Percent Over",
    RecordCreateDateTime as "Created At",
    [R-PARENT-CHILD-FLAG] as "Is Child",
    [R-Planner-ID] as "Planner",
    [R-PO-LINE-NBR] as "PO Line",
    [TR].[R-JOB#] as "Job Num",
    [R-DATE-CODE] as "Date Code",
    [IPCClass] as "IPC Class",
    [R-REV-NBR] as "Part Revision",
    [H-Part#] as "Part Num",
    [Matl-Lot-No] as "Material",
    [Lam-thickness] as "Surface Finish",
    TRIM(ISNULL([R-PROC-SEQ], [H-PROC-SEQ])) as "Process Sequence",
    [ITAR] as "ITAR",
    [H-MISC1] as "Outer Limits",
    [MLZCY] as "Sales Priority",
    [IDryFilmSide3] as "Complexity",
    [DryFilmSide4] as "Tech Team"
FROM
    (
        SELECT
            [D-JOB#],
            [D-DATE],
            [D-TIME],
            [D-DEST],
            [D-OPR],
            [D-FROM],
            [D-DATE-OUT],
            [D-TIME-OUT],
            [D-QTY-MOVED],
            'N' as "Shipped"
        FROM
            DETAIL
        UNION
        SELECT
            [D-JOB#],
            [D-DATE],
            [D-TIME],
            [D-DEST],
            [D-OPR],
            [D-FROM],
            [D-DATE-OUT],
            [D-TIME-OUT],
            [D-QTY-MOVED],
            'Y' as "Shipped"
        FROM
            ARCSHIP
        WHERE
            [D-DATE] >= CAST(TIMESTAMPADD(SQL_TSI_DAY, -4, NOW()) as SQL_DATE)
    ) as [TD]
    INNER JOIN (
        SELECT
            [RELEASE].*,
            [P-TRACKING-NBR] as "R-TRACKING-NBR1",
            [P-PNL-REL-NBR] as "Inner Layer Num"
        FROM
            [PNLREL]
            INNER JOIN [RELEASE] ON [PNLREL].[P-JOB-NBR] = [RELEASE].[R-JOB#]
            AND [PNLREL].[P-REL-NBR] = [RELEASE].[R-RELEASE-NBR]
        WHERE
            [P-RELEASE-DATE] >= '1/1/2022'
        UNION
        SELECT
            [RELEASE].*,
            [R-TRACKING-NBR] as "R-TRACKING-NBR1",
            '' as "Inner Layer Num"
        FROM
            [RELEASE]
        WHERE
            [R-DUE-DATE] >= '1/1/2022'
    ) AS [TR] ON [TR].[R-TRACKING-NBR1] = [TD].[D-JOB#]
    LEFT JOIN (
        SELECT
            DISTINCT [Customer Id],
            [JOB NBR]
        FROM
            [TRAVHEAD]
    ) as [TT] ON [TT].[JOB NBR] = [TR].[R-JOB#]
    AND [Customer Id] <> ''
    LEFT JOIN (
        SELECT
            MIN([Start]) as "Start",
            MAX(OperId) as "OPERID",
            GATEID,
            JOBNBR
        FROM
            JOBTIME
        WHERE
            Status = 'START'
        GROUP BY
            JOBNBR,
            GATEID
    ) as [TT1] ON [TT1].[JobNbr] = [D-JOB#]
    AND [TT1].GateId = TD.[D-DEST]
    LEFT JOIN (
        SELECT
            SUM(DURATION) as DURATION,
            JOBNBR,
            GATEID,
            MAX(OPERID) as OPERID
        FROM
            JOBTIME
        WHERE
            Status = 'DONE'
        GROUP BY
            JOBNBR,
            GATEID
    ) as [TT2] ON [TT2].[JobNbr] = [D-JOB#]
    AND [TT2].GateId = TD.[D-DEST]
    LEFT JOIN HEADER ON [TR].[R-JOB#] = [H-JOB#]
    LEFT JOIN TRAVHEAD ON TRAVHEAD.[JOB NBR] = [H-JOB#]
    AND TRAVHEAD.[Process-Sequence] = ISNULL([R-PROC-SEQ], [H-PROC-SEQ])
    LEFT JOIN TRAVASM ON TRAVHEAD.[JOB NBR] = TRAVASM.[JOBNBR]
    AND TRAVHEAD.[Process-Sequence] = TRAVASM.[ProcessSequence]
WHERE
    [D-DEST] <> 'SK'
    AND [R-PO-Date] >= '1/1/2022'