import { writeFile } from 'fs'

import { baconOutputPath } from '../util'

export function writeCsv(rowsCsv: any, scriptName: any) {
    const resultsPath = baconOutputPath() + scriptName + '_'
        + new Date(Date.now()).toISOString().replace(/:/g, '_') + '.csv'
    try {
        writeFile(
            resultsPath,
            rowsCsv,
            (err) => {
                if (err) throw err;
                console.log('writing ' + resultsPath)
            })
    } catch (err) {
        console.log(err)
    }
}