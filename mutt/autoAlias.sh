#!/bin/sh

#MESSAGE=$(cat | par -qefigd)
MESSAGE=$(cat)

NEWALIAS=$(echo "${MESSAGE}" | grep ^"From: " | sed s/[\,\"\']//g | awk '{$1=""; if (NF == 3) {print "alias" $0;} else if (NF == 2) {print "alias" $0 $0;} else if (NF > 3) {print "alias", tolower($(NF-1))"-"tolower($2) $0;}}')


if [[ "$NEWALIAS" != *facebook* ]]; then
	if grep -Fxq "$NEWALIAS" $HOME/.mutt/aliases_auto; then
    	:
	else
    	echo "$NEWALIAS" >> $HOME/.mutt/aliases_auto
	fi
fi

echo "${MESSAGE}"
