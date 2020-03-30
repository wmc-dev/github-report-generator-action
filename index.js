const core = require("@actions/core");
const { execSync } = require("child_process");
const path = require('path');
const fs = require('fs');

const main = async () => {
    const inputFolder = core.getInput("input-folder");
    const outputFolder = core.getInput("output-folder");
    const absoluteOutputFolder = path.join(process.cwd(), outputFolder);
    const absoluteOutputRawFolder = path.join(absoluteOutputFolder, "raw");

    if (!fs.existsSync(absoluteOutputRawFolder)) {
        fs.mkdirSync(absoluteOutputRawFolder, { recursive: true });
    }

    const copyOutput = execSync(`cp -r "${path.join(process.cwd(), inputFolder)}/*" "${absoluteOutputRawFolder}"`, {
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