import * as extract from './extract'
import * as msnetwork from './load/msnetwork'
import { getConnection } from './db'
import { jsonArrayToCsv } from './transform'

export async function schedule(task: any, hour: any, hourInterval: any, arg = undefined) {
    const now = new Date()
    let nextRun = new Date(now)
    nextRun.setHours(hour, 0, 0, 0)
    if (now >= nextRun) {
        nextRun.setDate(now.getDate() + 1)
    }
    const delay = nextRun.getTime() - now.getTime()
    setTimeout(async () => {
        if (arg === undefined) {
            await task()
        } else {
            await task(arg)
        }
        setInterval(task, hourInterval * 60 * 60 * 1000)
    }, delay)
}

export async function mainTask(pool: any) {
    const c1 = await getConnection(pool)
    const invoicesScriptName = 'invoices-q1-2022.sql'
    const mainScriptName = 'main-q1-2022.sql'
    const orderReleasesScriptName = 'order-releases-q1-2022.sql'
    const invoicesRows = await extract.execScriptAndNotify(c1, invoicesScriptName)
    const mainRows = await extract.execScriptAndNotify(c1, mainScriptName)
    const orderReleasesRows = await extract.execScriptAndNotify(c1, orderReleasesScriptName)
    const invoicesRowsCsv = jsonArrayToCsv(invoicesRows)
    const mainRowsCsv = jsonArrayToCsv(mainRows)
    const orderReleasesRowsCsv = jsonArrayToCsv(orderReleasesRows)
    msnetwork.writeCsv(invoicesRowsCsv, invoicesScriptName)
    msnetwork.writeCsv(mainRowsCsv, mainScriptName)
    msnetwork.writeCsv(orderReleasesRowsCsv, orderReleasesScriptName)
}