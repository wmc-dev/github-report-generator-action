const core = require("@actions/core");
const { execSync, spawnSync } = require("child_process");
const path = require('path');
const fs = require('fs');

const main = async () => {
    const inputFolder = core.getInput("input-folder");
    const outputFolder = core.getInput("output-folder");
    const debug = core.getInput("DEBUG");
    const absoluteOutputFolder = path.join(process.cwd(), outputFolder);
    const absoluteOutputRawFolder = path.join(absoluteOutputFolder, "raw");

    if (!fs.existsSync(absoluteOutputRawFolder)) {
        fs.mkdirSync(absoluteOutputRawFolder, { recursive: true });
    }

    if (debug) {
        console.log("ls:")
        const lsOutput = execSync(`ls`, {
            maxBuffer: 1024 * 1024 * 5
        }).toString();
        console.log(lsOutput);
    }

    const copyOutput = execSync(`cp -r "${path.join(process.cwd(), inputFolder)}"/* "${absoluteOutputRawFolder}"`, {
        maxBuffer: 1024 * 1024 * 5
    }).toString();
    console.log(copyOutput);

    out = spawnSync('sh', [`auto.sh '${absoluteOutputFolder}'`,], {
        maxBuffer: 1024 * 1024 * 5,
        cwd: `${__dirname}/reportConverter`
    });
    console.log('status: ' + out.status);
    console.log('stdout: ' + out.stdout.toString('utf8'));
    console.log('stderr: ' + out.stderr.toString('utf8'));
    console.log();
    if(out.status !== 0)
        throw new Error(out.stderr.toString('utf8'))
};

main().catch(err => core.setFailed(err.message));