# $1 absolute commitDir

echo "Extract zip"
sourcePath=`cygpath -u "$1"/raw`

if [ "$1" = "" ] || [ ! -d $1 ] || [ ! -d $sourcePath ]; then
    (>&2 echo "invalid parameter")
    exit 1;
fi

targetPath=`cygpath -u "$1/zip"`

sourceFile=$(find "$sourcePath" -type f -name zip.zip | awk '{ print length, $0 }' | sort -n | cut -d" " -f2- | head -n 1)

if [ "$sourceFile" = "" ]; then
    (>&2 echo "zip.zip not file found")
    exit 1;
fi

mkdir -p $targetPath
sourceFile=`realpath "$sourceFile"`


echo "SourceFile: $sourceFile"
echo "TargetPath: $targetPath"

echo "Extract:"
unzip "$sourceFile" -d "$targetPath"
echo "Extract end"
echo "End extract zip"