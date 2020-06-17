#!/bin/sh

if [ -z "$2" ]; then
    echo "Usage: $0 <strings_xml> <output_path> <enum_file>"
    exit -1
fi

INPUT_XML=$1
OUTPUT_PATH=$2
ENUM_FILE=$3
ITEMS=0

if ! xmllint $INPUT_XML > /dev/null; then
    echo "Invalid $INPUT_XML XML format"
    exit -1
fi

for LANG in $(xsltproc list.xslt $INPUT_XML)
do
    mkdir -p $OUTPUT_PATH/$LANG.lproj
    xsltproc --stringparam lang $LANG strings.xslt $INPUT_XML > $OUTPUT_PATH/$LANG.lproj/Localizable.strings
    echo "Processed $LANG into $OUTPUT_PATH/$LANG/Localizable.strings"
    ((ITEMS += 1))
done

echo "Total $ITEMS trasnlations generated"

if [ -z "$3" ]; then
    echo "Skipping enum file generation..."
    exit 0
fi

xsltproc enum.xslt $INPUT_XML > $ENUM_FILE
echo "Created enum at $ENUM_FILE"
