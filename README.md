# github-report-generator-action
## How to use
````
- name: Generate reports
        uses: wmc-dev/github-report-generator-action@latest
        with:
          input-folder: reports
          output-folder: reportsOutput
````

## Update latest tag
git push --delete origin latest && git tag --delete latest && git tag -a -m "update" latest && git push origin --tags