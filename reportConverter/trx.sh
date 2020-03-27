SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`
# $2 commit id
cd $1

if [ $(find ./raw -name \*.trx | wc -l) = 0 ]; then
	exit 1;
fi

mkdir -p trx
for i in $(find ./raw/ -name \*.trx); do
    cp $i ./trx/$(basename "$i")
done

if [ $(find ./trx -name \*.trx | wc -l) == "1" ]; then 
	cp $(find ./trx -name \*.trx) ./index.trx
else
	$SCRIPTPATH/trx/TrxMerger/TRX_Merger.exe //trx:trx //output:index.trx
fi

#//curl https://github.com/NivNavick/trxer/releases/download/v1.0.0.2/TrxerConsole.exe -o $SCRIPTPATH/trx/TrxerConsole.exe
$SCRIPTPATH/trx/TrxerConsole.exe index.trx

mv index.trx.html ./trx/index.html

ok=$(xmllint --xpath '//*[local-name()="Counters"]/@executed' ./index.trx)
failed=$(xmllint --xpath '//*[local-name()="Counters"]/@failed' ./index.trx | tr -dc '0-9')
if [ "$failed" -gt "0" ]; then colour="#E31"; else colour="#3C1"; fi

"$SCRIPTPATH/../badgen.sh" "tests ${2::8}" "$ok, $failed" "" "$colour" > ./trx/badge.svg