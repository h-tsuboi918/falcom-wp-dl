#!/bin/bash

## Get Script Dir
SCRIPT_DIR=$(cd $(dirname $0); pwd)

## source env file
. $SCRIPT_DIR/dir_param.env
. $SCRIPT_DIR/url_param.env

## Move to DL Dir
cd $DL_DIR

## make curl url
YEAR_SHORT=$(( YEAR % 100 ))
MONTH_SHORT=$(( ( MONTH + 1 ) % 12 ))
if [ $MONTH_SHORT -eq 0 ]; then
    MONTH_SHORT=12
elif [ $MONTH_SHORT -eq 1 ]; then
    YEAR_SHORT=$(( YEAR_SHORT + 1 ))
fi
MONTH_PRINT=$(printf "%02d" "${MONTH}")
MONTH_SHORT_PRINT=$(printf "%02d" "${MONTH_SHORT}")
URL="https://www.falcom.co.jp/page/wp-content/uploads/${YEAR}/${MONTH_PRINT}/cal-h${YEAR_SHORT}${MONTH_SHORT_PRINT}-m.jpg"

echo $URL

curl -O -b 'f_opt_in=1' $URL

FILE_TYPE=`file "$DL_DIR/cal-h${YEAR_SHORT}${MONTH_SHORT_PRINT}-m.jpg" | awk '{print $2}'`

if [ $FILE_TYPE == "JPEG" ]; then
  if [ $MONTH_SHORT -eq 1 ]; then
      NEXT_YEAR=$(( YEAR + 1 ))
  else
      NEXT_YEAR=$YEAR
  fi
  echo "YEAR=${NEXT_YEAR}" > $SCRIPT_DIR/url_param.env
  echo "MONTH=$MONTH_SHORT" >> $SCRIPT_DIR/url_param.env
else
  rm "$DL_DIR/cal-h${YEAR_SHORT}${MONTH_SHORT_PRINT}-m.jpg"
  echo "${YEAR_SHORT}/${MONTH_SHORT_PRINT} wp is not exist"
fi
