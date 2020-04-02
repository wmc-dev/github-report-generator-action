IFS=$'\n'

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
SOURCE_DIRECTORY="$2"
cd $1

if [ $(find ./raw -name \*.coverage | wc -l) = 0 ]; then
    exit 1;
fi

report_assemblyfilters="-unittests.*;$(cat ./raw/.ReportGeneratorFilter 2>/dev/null)"
echo "cov report_assemblyfilters: $report_assemblyfilters"

set -e

mkdir -p cov
for i in $(find ./raw/ -name \*.coverage); do
    $SCRIPTPATH/cov/CodeCoverage/CodeCoverage.exe "$i"
    cp "$i.xml" "./cov/$(basename "$i").xml"
done


#replace source file drive d,e,... with drive c
find ./cov -name '*.coverage.xml' -exec sed -i -e 's/<SourceFileName>[a-zA-Z]:\\/<SourceFileName>C:\\/g' {} \;

#read source filepath
reportId=""
for n in $(find ./cov -name *.coverage.xml)
do
    tmpSourceCsPath=$(awk '/SourceFileName>/{print $NF}' "$n" | head -1)
    tmpSourceCsPath=${tmpSourceCsPath#*>} # example C:\builds\CzUiisLs\0\wmc\Zuken.Math\source\UnitTests.Zuken.Math\UnitTest1.cs</SourceFileName>
    tmpSourcePath=${tmpSourceCsPath%%\\0\\*}'\0\' #example C:\builds\CzUiisLs\0\
    reportId=$(echo ${tmpSourceCsPath:${#tmpSourcePath} } | cut -d\\ -f1,2) # example wmc\Zuken.Math
    if [ ! -z "$reportId" -a "$reportId" != " " ]; then
        break;
    fi
done

echo "cov - ReportId: $reportId"
if [ -z "$reportId" -o "$reportId" == " " ]; then
    echo "Error ReportId not found";
    exit 1;
fi

sourceCodeDirectory=$tmpSourcePath$reportId

cp -R "$SOURCE_DIRECTORY" "$sourceCodeDirectory"
ls -la "$sourceCodeDirectory"

$SCRIPTPATH/cov/ReportGenerator/ReportGenerator.exe -reports:'./cov/*.xml' "-assemblyfilters:$report_assemblyfilters" -reporttypes:"HtmlInline;Badges" -targetdir:./cov/

rm -rf $(dirname "$tmpSourcePath")
cutTempDirFromLink=$(echo $tmpSourcePath | sed 's/\\/\\\\/g')
find ./cov/ -name '*.*' -exec sed -i -e "s/$cutTempDirFromLink//g" {} \;

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

"$SCRIPTPATH/../helper/badgen.sh" "coverage" "$coverage %" "$color" > "cov/badge.svg"

mv cov/index.htm cov/index.html