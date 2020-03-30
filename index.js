const core = require("@actions/core");
const { execSync } = require("child_process");
const path = require('path');
const fs = require('fs');

const main = async () => {
    const inputFolder = core.getInput("input-folder");
    const outputFolder = core.getInput("output-folder");
    const debug = core.getInput("DEBUG");
    const absoluteOutputFolder = path.join(process.cwd(), outputFolder);
    const outputRawFolder = path.join(outputFolder, "raw");

    if (!fs.existsSync(outputRawFolder)) {
        fs.mkdirSync(outputRawFolder, { recursive: true });
    }

    if (debug) {
        console.log("ls:")
        const lsOutput = execSync(`ls`, {
            maxBuffer: 1024 * 1024 * 5
        }).toString();
        console.log(lsOutput);
    }

    const copyOutput = execSync(`cp -r "${inputFolder}/*" "${outputRawFolder}"`, {
        maxBuffer: 1024 * 1024 * 5
    }).toString();
    console.log(copyOutput);

    const runOutput = execSync(`sh ./auto.sh ${absoluteOutputFolder}`, {
        maxBuffer: 1024 * 1024 * 5,
        cwd: `${__dirname}/reportConverter`
    }).toString();
    console.log(runOutput);

};

main().catch(err => core.setFailed(err.message));