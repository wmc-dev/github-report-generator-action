const core = require("@actions/core");
const { execSync } = require("child_process");
const { GitHub, context } = require("@actions/github");

const main = async () => {
    const githubToken = core.getInput("github-token");
    const inputFolder = core.getInput("input-folder");
    const outputFolder = core.getInput("output-folder");

    console.log("__dirname: " + __dirname)
    console.log("process.cwd(): " + process.cwd())

    const runOutput = execSync(`cd ./reportConverter && sh ./auto.sh`, { maxBuffer: 1024 * 1024 * 5 }).toString();
    console.log(runOutput);

};

main().catch(err => core.setFailed(err.message));