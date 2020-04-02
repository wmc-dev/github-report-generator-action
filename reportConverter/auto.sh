# $1 absolute output directory
SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

set -e
echo "Files in report raw directory"
ls "$1"

for f in $(find "$SCRIPTPATH" -maxdepth 1 -type f -name "cov.sh"); do #"*.sh"
    if [ $(basename $0) = $(basename $f) ]; then
        continue;
    fi
    echo `date "+%Y-%m-%d %H:%M:%S"` "RUN -> $f $1"
    bash `$f` `$1`
    echo `date "+%Y-%m-%d %H:%M:%S"` "FINISHED -> $f $1"
done

echo "Files in report output directory"
ls "$1"