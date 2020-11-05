
[[ -n "$DEBUG" ]] && set -x
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

cd $1

if [ ! -d "./raw/gocov" ]; then
 echo "Directory ./raw/gocov not found";
 exit 0;
fi

cp -r ./raw/gocov ./gocov/

coverage=$(cat ./gocov/*.gotestlog | grep -o -P '(?<=coverage: )[0-9]*(\.[0-9]*)?(?=%)')
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

"$SCRIPTPATH/../badgen.sh" "coverage" "$coverage %" "" "$color" > "gocov/badge.svg"