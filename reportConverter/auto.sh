# $1 absolute commitDir
# $2 uniqueId

for f in $(find . -maxdepth 1 -type f -name "*.sh"); do
    if [ $(basename $0) = $(basename $f) ]; then
        continue;
    fi
    echo `date "+%Y-%m-%d %H:%M:%S"` "RUN -> " $f $1 $2
    bash $f $1 $2
    echo `date "+%Y-%m-%d %H:%M:%S"` "FINISHED -> " $f $1 $2
done