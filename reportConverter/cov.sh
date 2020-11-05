[[ -n "$DEBUG" ]] && set -x
IFS=$'\n'

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
cd $1

if [ $(find ./raw -name \*.coverage | wc -l) = 0 ]; then
    echo "No coverage files were found under raw.";
    exit 0;
fi

report_assemblyfilters="-unittests.*;$(cat ./raw/.ReportGeneratorFilter 2>/dev/null)"

set -e

mkdir -p cov
for i in $(find ./raw/ -name \*.coverage); do
    "$SCRIPTPATH/cov/CodeCoverage/CodeCoverage.exe" "$i"
    cp "$i.xml" "./cov/$(basename "$i").xml"
done

echo "report_assemblyfilters: $report_assemblyfilters"

"$SCRIPTPATH/cov/ReportGenerator/ReportGenerator.exe" -reports:'./cov/*.xml' "-assemblyfilters:$report_assemblyfilters" -reporttypes:"HtmlInline;Badges" -targetdir:./cov/

mv cov/index.htm cov/index.html

COV_BADGE_FILE="./cov/badge_linecoverage.svg"
if [ ! -f "$COV_BADGE_FILE" ]; then
    echo "cov.sh - Coverage is empty, skip badge"
    exit 0;
fi

coverage=$(sed -rn 's/.*>([0-9]{1,3}(\.[0-9]+)?)%<\/text>.*/\1/p' "$COV_BADGE_FILE")
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

"$SCRIPTPATH/../badgen.sh" "coverage" "$coverage %" "" "$color" > "cov/badge.svg"