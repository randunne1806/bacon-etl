import { queryToString } from './db'
import { splitRowsAndMeta } from './transform'

const fetchData = async (connection: any, sql: any, params = []) => {
    let result = null
    try {
        result = await connection.query(sql, params)
    } catch (err) {
        console.log(err)
    }
    return result
}

interface PostQueryOptions {
    connection: any
    queryFile?: any
    query?: string
    params?: any
}

export async function postQuery({
    connection,
    queryFile,
    query,
    params
}: PostQueryOptions) {
    let result = null
    try {
        const sql = queryFile ? queryToString(queryFile) : query
        result = await fetchData(connection, sql, params)
    } catch (err) {
        console.log(err)
    }
    return result
}

export async function niceTableViewQuery(connection: any, tableName: any) {
    let query = ""
    try {
        const columnData = await fetchData(connection,
            `EXECUTE PROCEDURE sp_GetColumns(NULL, NULL, '${tableName}', NULL)`)
        const columnNames = columnData.map(row => '[' + row.COLUMN_NAME.trim() + ']')
        const scoreCalculation = columnNames.map(
            col => `CASE WHEN ${col} IS NOT NULL THEN 1 ELSE 0 END`).join(" + ")
        const orderByColumns = columnNames.join(", ")
        query = `
            SELECT *
            FROM ${tableName}
            ORDER BY
                (${scoreCalculation}) DESC,
                ${orderByColumns};
            `
    } catch (err) {
        console.log(err)
    }
    return query
}

export async function getRowsAndMeta(connection: any, queryOption: any) {
    let rowsAndMeta = {}
    try {
        rowsAndMeta = await postQuery({
            connection: connection,
            ...queryOption,
        })
    } catch (err) {
        console.log(err)
    }
    return rowsAndMeta
}

export async function execScriptAndNotify(connection: any, scriptName: any) {
    console.log("Making query from: " + scriptName)
    return splitRowsAndMeta(
        await getRowsAndMeta(
            connection, { queryFile: scriptName })).rows
}