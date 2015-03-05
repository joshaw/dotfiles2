#!/bin/bash
# Created:  Mon 02 Feb 2015
# Modified: Thu 05 Mar 2015
# Author:   Josh Wainwright
# Filename: settings.sh

# Languages
lang_c=(946)
lang_a=(946 947)
lang_j=(946)

declare -A langs=(["lang_c"]="C_C++" ["lang_a"]="Ada" ["lang_j"]="Java")

standalone=("unit" "cover" "rules")

WORKAREA_DIR=/cygdrive/c/LDRA_Workarea
TOOLSUITE_DIR=/cygdrive/c/LDRA_Toolsuite
