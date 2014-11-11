#!/bin/bash
set +e

VERSION="946"
GENFOLDER="LDRA Tool Suite"
DESKTOP="/cygdrive/c/Users/JoshWainwright/Desktop"
DESKTOPPUB="/cygdrive/c/Users/Public/Desktop"
STARTMENU="/cygdrive/c/ProgramData/Microsoft/Windows/Start Menu"

PROGRAMS=("
TBvision
TBmanager
TBrun
LDRAlauncher
Testbed
")

CONFIGURES=("
LDRAWorkarea:WORKAREA
OperationModeSettings:TWEAK
AdditionalTools:TOOLS
CompilerOptions:X
InstrumentationStrategy:INSTR
")

# Remove any old Start Menu and Desktop Entries
rm -r "$STARTMENU/Programs/$GENFOLDER"*
find "$DESKTOPPUB" -maxdepth 1 -name "LDRA*" -delete -or -name "TB*" -delete

for LANG in "C_C++" "Ada"; do

	echo $LANG
	SPECFOLDER="$GENFOLDER $LANG v$VERSION"
	WORKINGDIR="/cygdrive/c/LDRA_Workarea/$LANG/$VERSION/"
	rm -r "$DESKTOP/$SPECFOLDER"
	mkdir -p "$DESKTOP/$SPECFOLDER"

	# LDRA Toolsuite Programs
	for TBPROG in $PROGRAMS; do
		echo -e "\t$TBPROG"
		LINKFILE="$DESKTOP/$SPECFOLDER/$TBPROG - $LANG"
		TBFILE="/cygdrive/c/LDRA_Toolsuite/$LANG/$VERSION/$TBPROG.exe"

		mkshortcut -n "$LINKFILE" -w "$WORKINGDIR" "$TBFILE"

	done

	# Configuration Options
	mkdir -p "$DESKTOP/$SPECFOLDER/Configure"
	for OPT in $CONFIGURES; do
		echo -e "\t$OPT"
		OPTNAME=${OPT%:*}
		OPTSET=${OPT#*:}

		if [ "$OPTSET" == "X" ]; then
			OPTIONSDASH="-a -NOINI"
		else 
			OPTIONSDASH="-a -$OPTSET -NOINI"
		fi

		LINKFILE="$DESKTOP/$SPECFOLDER/Configure/$OPTNAME"
		OPTFILE="/cygdrive/c/LDRA_Toolsuite/$LANG/$VERSION/Compconfig/setup.exe"

		mkshortcut -n "$LINKFILE" -w "$WORKINGDIR" "$OPTIONSDASH" "$OPTFILE"
	done

	# Licensing
	LINKDIR="$DESKTOP/$SPECFOLDER/Licensing/"
	mkdir -p "$LINKDIR"

	LINKFILE="$LINKDIR/LicenseManager"
	LICENSE="/cygdrive/c/LDRA_Toolsuite/$LANG/$VERSION/Liccfgdlg.exe"
	OPTION="/use_lang=$LANG"
	mkshortcut -n "$LINKFILE" -a "$OPTION" "$LICENSE"

	cp -r "$DESKTOP/$SPECFOLDER" "$STARTMENU/Programs/"

done

rm "$STARTMENU/LDRA"* 2> /dev/null || true
rm "$STARTMENU/TB"* 2> /dev/null || true
