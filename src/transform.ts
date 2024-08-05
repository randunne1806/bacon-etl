import { unparse } from 'papaparse'

export function jsonArrayToCsv(data: any[]) {
    return unparse(data)
}

export function splitRowsAndMeta(data: any) {
    let rows = []
    let meta = {}
    for (const x in data) {
        const i = Number(x)
        if (!Number.isNaN(i) && typeof data[i] === 'object') {
            rows.push(data[i])
        } else {
            meta[x] = data[x]
        }
    }
    return { meta: meta, rows: rows }
}

export function removeNullsAndTrim(data: any[]) {
    data.forEach(row => {
        for (let column in row) {
            const value = row[column]
            if (typeof value === 'string') {
                row[column] = value.trim()
            }
            if (value == null || value == undefined) {
                delete row[column]
            }
        }
    })
    return data
}