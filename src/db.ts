import { pool } from 'odbc'
import { readFileSync } from 'fs'

const QUERIES_PATH_BASE = 'queries'

export function queryPath(fileName: any) {
    return QUERIES_PATH_BASE + '/' + fileName
}

export function queryToString(queryFile: any) {
    let contentString = ""
    try {
        contentString = readFileSync(queryPath(queryFile)).toString()
    } catch (err) {
        console.log(err)
    }
    return contentString
}

export async function createConnectionPool() {
    let p = null
    try {
        p = await pool({
            connectionString: 'DSN=BaconSoftware',
            initialSize: 10
        })
    } catch (err) {
        console.log(err)
        process.exit(0)
    }
    return p
}

export async function getConnection(pool: any) {
    let connection = null
    try {
        connection = await pool.connect()
    } catch (err) {
        console.log(err)
    }
    return connection
}