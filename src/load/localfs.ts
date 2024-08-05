import { writeFileSync, writeFile } from 'fs'

import { jsonArrayToCsv, removeNullsAndTrim, splitRowsAndMeta } from '../transform'
import { postQuery } from '../extract'
import { testingBaconOutputPath } from '../util'

export function updateAnicerTableView(rowsAndMeta: any, tableNameCsv: any) {
    try {
        writeFile(
            tableNameCsv,
            jsonArrayToCsv(
                removeNullsAndTrim(
                    splitRowsAndMeta(rowsAndMeta).rows)),
            (err) => {
                if (err) throw err;
                console.log('writing ' + tableNameCsv)
            })
    } catch (err) {
        console.log(err)
    }
}

export async function updateNonEmptyTableNamesFile(connection: any, rowsAndMeta: any) {
    const nonEmptyTableNamesFileName = testingBaconOutputPath('raw-tables') + 'non-empty-tables.txt'
    const rows = splitRowsAndMeta(rowsAndMeta).rows
    const tableNames = removeNullsAndTrim(rows).map(x => x.TABLE_NAME)
    const nonEmptyTables = []
    for (const tableName of tableNames) {
        const rows = splitRowsAndMeta(await postQuery({
            connection: connection,
            query: `select top 1 * from [${tableName}]`
        })).rows
        if (rows.length !== 0) {
            nonEmptyTables.push(tableName)
        }
    }
    const nonEmptyTablesStr = nonEmptyTables.join(' ')
    try {
        writeFileSync(nonEmptyTableNamesFileName, nonEmptyTablesStr)
        console.log('writing ' + nonEmptyTableNamesFileName)
    } catch (err) {
        console.error(err)
    }
}