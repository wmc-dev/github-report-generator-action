IFS=$'\n'

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
cd $1

if [ $(find ./raw -name \*.coverage | wc -l) = 0 ]; then
    echo "No coverage files were found under raw.";
    exit 1;
fi

report_assemblyfilters="-unittests.*;$(cat ./raw/.ReportGeneratorFilter 2>/dev/null)"
echo "cov report_assemblyfilters: $report_assemblyfilters"

set -e

mkdir -p cov
for i in $(find ./raw/ -name \*.coverage); do
    "$SCRIPTPATH/cov/CodeCoverage/CodeCoverage.exe" "$i"
    cp "$i.xml" "./cov/$(basename "$i").xml"
done

echo "files in cov: "
echo ls "$PWD/cov"
echo "current path: $PWD"

"$SCRIPTPATH/cov/ReportGenerator/ReportGenerator.exe" -reports:'./cov/*.xml' "-assemblyfilters:$report_assemblyfilters" -reporttypes:"HtmlInline;Badges" -targetdir:./cov/

coverage=$(sed -rn 's/.*>([0-9]{1,3}(\.[0-9]+)?)%<\/text>.*/\1/p' "./cov/badge_linecoverage.svg")
decimalCoverage=`echo "$coverage" | sed -rn 's/([0-9]+)[\.[0-9]*]?/\1/p'`

if [ "$coverage" = "ERROR" ] || [ $decimalCoverage -lt 75 ]
then
    color='#e05d44'
elif [ $decimalCoverage -lt 90 ]
then
    color='#dfb317'
else
    color='#4c1'
fi

"$SCRIPTPATH/../badgen.sh" "coverage" "$coverage %" "$color" > "cov/badge.svg"

mv cov/index.htm cov/index.html