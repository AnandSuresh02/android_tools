#!/bin/bash

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Copyright (C) 2019 Shivam Kumar Jha <jha.shivam3@gmail.com>
#
# Helper functions

# Store project path
PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null && pwd )"

# Common stuff
source $PROJECT_DIR/tools/common_script.sh

# Exit if invalid arguements
if [ ! -d "$1" ] || [ ! -d "$2" ]; then
	echo -e "${bold}${red}Supply source & target ROM path's as arguements!${nocol}"
	exit
fi

# Create temp dir's
mkdir -p $TMPDIR/dt_common/common $TMPDIR/dt_common/source $TMPDIR/dt_common/target

# Find common & device-specific blob's
echo -e "${bold}${cyan}Comparing source and target ROM's. Wait ...!${nocol}"
. $PROJECT_DIR/tools/rom_compare.sh "$1" "$2" > /dev/null 2>&1
cat $PROJECT_DIR/working/Common.txt > $TMPDIR/dt_common/common/blobs_list.txt
cat $PROJECT_DIR/working/Added.txt > $TMPDIR/dt_common/target/blobs_list.txt
cat $PROJECT_DIR/working/Missing.txt > $TMPDIR/dt_common/source/blobs_list.txt
cat $PROJECT_DIR/working/Modified.txt >> $TMPDIR/dt_common/source/blobs_list.txt
cat $PROJECT_DIR/working/Modified.txt >> $TMPDIR/dt_common/target/blobs_list.txt

# Prepare proprietary-files.txt
. $PROJECT_DIR/tools/proprietary-files.sh $TMPDIR/dt_common/common/blobs_list.txt > /dev/null 2>&1
cat $PROJECT_DIR/working/proprietary-files.txt > $TMPDIR/dt_common/common-proprietary-files.txt
. $PROJECT_DIR/tools/proprietary-files.sh $TMPDIR/dt_common/source/blobs_list.txt > /dev/null 2>&1
cat $PROJECT_DIR/working/proprietary-files.txt > $TMPDIR/dt_common/source-proprietary-files.txt
. $PROJECT_DIR/tools/proprietary-files.sh $TMPDIR/dt_common/target/blobs_list.txt > /dev/null 2>&1
cat $PROJECT_DIR/working/proprietary-files.txt > $TMPDIR/dt_common/target-proprietary-files.txt

# Final results
rm -rf $PROJECT_DIR/working/*
cp -a $TMPDIR/dt_common/*-proprietary-files.txt $PROJECT_DIR/working/
rm -rf $TMPDIR/dt_common/
echo -e "${bold}${cyan}Files prepared. Check $PROJECT_DIR/working/${nocol}"