const core = require("@actions/core");
const { execSync } = require("child_process");
const path = require('path');
const fs = require('fs');

const main = async () => {
    const inputFolder = core.getInput("input-folder");
    const outputFolder = core.getInput("output-folder");
    const debug = core.getInput("DEBUG");
    const sourceDirectory = process.cwd();
    const absoluteOutputFolder = path.join(sourceDirectory, outputFolder);
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

    const runOutput = execSync(`sh ./auto.sh '${absoluteOutputFolder}' '${sourceDirectory}'`, {
        maxBuffer: 1024 * 1024 * 5,
        cwd: `${__dirname}/reportConverter`
    }).toString();
    console.log(runOutput);

};

main().catch(err => core.setFailed(err.message));