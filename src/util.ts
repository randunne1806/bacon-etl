import { mkdir } from 'fs'
import { platform as _platform, homedir } from 'os'
import { join } from 'path'

const BACON_OUTPUT_DIR = 'bacon-tables'
const BACON_REPORTS_DIR = 'bacon-reports'
const MS_DELIM = '\\'
const UNIX_DELIM = '/'

const createDir = async (dirPath: any) => {
    mkdir(dirPath, { recursive: true }, (err) => {
        if (err) {
            console.error('Error creating directory:', err)
        }
    })
}

export function downloadsPath() {
    const platform = _platform()
    switch (platform) {
        case 'win32':
            return join(homedir(), 'Downloads')
        case 'darwin':
            return join(homedir(), 'Downloads')
        case 'linux':
            return join(homedir(), 'Downloads')
        default:
            throw new Error('Unsupported platform: ' + platform)
    }
}

export function baconOutputPath() {
    const platform = _platform()
    const path = (delim: any) => {
        return downloadsPath() + delim + BACON_REPORTS_DIR + delim
    }
    switch (platform) {
        case 'win32': {
            const p = path(MS_DELIM)
            createDir(p)
            return p
        } case 'darwin':
        case 'linux':
            const p = path(UNIX_DELIM)
            createDir(p)
            return p
        default:
            throw new Error('Unsupported platform: ' + platform)
    }
}

export function testingBaconOutputPath(outputType: any) {
    const platform = _platform()
    const path = (delim: any) => {
        return downloadsPath() + delim + BACON_OUTPUT_DIR + delim
            + outputType + delim
    }
    switch (platform) {
        case 'win32': {
            const p = path(MS_DELIM)
            createDir(p)
            return p
        } case 'darwin':
        case 'linux':
            const p = path(UNIX_DELIM)
            createDir(p)
            return p
        default:
            throw new Error('Unsupported platform: ' + platform)
    }
}