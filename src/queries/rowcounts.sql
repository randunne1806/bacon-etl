CREATE TABLE #RowCounts(NumberOfRows BIGINT,TableName VARCHAR(128))

EXEC sp_MSForEachTable 'INSERT INTO #RowCounts
                        SELECT COUNT_BIG(*) AS NumberOfRows,
                        ''?'' as TableName FROM ?'

SELECT   TableName,NumberOfRows
FROM     #RowCounts
ORDER BY NumberOfRows DESC,TableName

DROP TABLE #RowCounts