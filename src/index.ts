import { writeFile } from 'fs'

import * as extract from './extract'
import * as loadLocalfs from './load/localfs'
import { createConnectionPool, getConnection } from './db'
import { schedule, mainTask } from './tasks'
import { splitRowsAndMeta, removeNullsAndTrim, jsonArrayToCsv } from './transform'
import { testingBaconOutputPath } from './util'

let cmd: string

if (process.argv.length > 2) {
    cmd = process.argv[2]
}

(async () => {

    const pool = await createConnectionPool()

    if (cmd == "mainTask") {
        console.log("Invoices, Order Releases, and Main queries are scheduled to execute at 19:00 every 24 hours.")
        schedule(mainTask, 19, 24, pool)

    } else if (cmd == "debug" && process.argv.length > 3) {
        const scriptName = process.argv[3]
        const c1 = await getConnection(pool)
        const rowsAndMeta = await extract.getRowsAndMeta(c1, { queryFile: scriptName })
        let divided = splitRowsAndMeta(rowsAndMeta)
        console.log('meta: ' +
            JSON.stringify(divided.meta, null, " "))
        console.log('rows: ' +
            JSON.stringify(
                removeNullsAndTrim(
                    divided.rows), null, " "))

    } else if (cmd == "1q" && process.argv.length > 3) {
        const scriptName = process.argv[3]
        const c1 = await getConnection(pool)
        const rowsAndMeta = await extract.getRowsAndMeta(c1, { queryFile: scriptName })
        let rowsCsv = jsonArrayToCsv(
            splitRowsAndMeta(rowsAndMeta).rows)
        const queryNameCsv = testingBaconOutputPath('special') + scriptName + '.csv'
        try {
            writeFile(
                queryNameCsv,
                rowsCsv,
                (err) => {
                    if (err) throw err;
                    console.log('writing ' + queryNameCsv)
                })
        } catch (err) {
            console.log(err)
        }

    } else if (cmd == "updateAnicerTableView" && process.argv.length > 3) {
        const tableName = process.argv[3]
        const c1 = await pool.connect()
        const rowsAndMeta = await extract.getRowsAndMeta(
            c1,
            { query: await extract.niceTableViewQuery(c1, tableName) }
        )
        const tableNameCsv = testingBaconOutputPath('raw-tables') + tableName + '.csv'
        loadLocalfs.updateAnicerTableView(rowsAndMeta, tableNameCsv)

    } else if (cmd == "updateNonEmptyTableNames") {
        const c1 = await pool.connect()
        const rowsAndMeta = await extract.getRowsAndMeta(c1, { queryFile: 'table-names.sql' })
        loadLocalfs.updateNonEmptyTableNamesFile(c1, rowsAndMeta)

    }

    await pool.close()

})()