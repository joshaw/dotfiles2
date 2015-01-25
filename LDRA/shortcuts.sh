#!/bin/bash
set +e

source $(dirname $BASH_SOURCE)/settings.sh

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
rm -r "$STARTMENU/Programs/$GENFOLDER"* 2> /dev/null || true
find "$DESKTOPPUB" -maxdepth 1 -name "LDRA*" -delete -or -name "TB*" -delete

for VERSION in $VERSIONS; do

	echo $VERSION

	for LANGUAGE in $LANGUAGES; do

		echo $LANGUAGE

		SPECFOLDER="$GENFOLDER $LANGUAGE v$VERSION"
		WORKINGDIR="$WORKAREA_DIR/$LANGUAGE/$VERSION/"
		rm -r "$DESKTOP/$SPECFOLDER"
		mkdir -p "$DESKTOP/$SPECFOLDER"

		# LDRA Toolsuite Programs
		for TBPROG in $PROGRAMS; do
			echo -e "\t$TBPROG"
			LINKFILE="$DESKTOP/$SPECFOLDER/$TBPROG - $LANGUAGE"
			TBFILE="$TOOLSUITE_DIR/$LANGUAGE/$VERSION/$TBPROG.exe"

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

			LINKFILE="$DESKTOP/$SPECFOLDER/Configure/${VERSION}_${LANGUAGE}_$OPTNAME"
			OPTFILE="$TOOLSUITE_DIR/$LANGUAGE/$VERSION/Compconfig/setup.exe"

			mkshortcut -n "$LINKFILE" -w "$WORKINGDIR" "$OPTIONSDASH" "$OPTFILE"
		done

		# Licensing
		LINKDIR="$DESKTOP/$SPECFOLDER/Licensing/"
		mkdir -p "$LINKDIR"

		LINKFILE="$LINKDIR/${VERSION}_${LANGUAGE}_LicenseManager"
		LICENSE="$TOOLSUITE_DIR/$LANGUAGE/$VERSION/Liccfgdlg.exe"
		OPTION="/use_lang=$LANGUAGE"
		mkshortcut -n "$LINKFILE" -a "$OPTION" "$LICENSE"

		cp -r "$DESKTOP/$SPECFOLDER" "$STARTMENU/Programs/"

	done
done

rm "$STARTMENU/LDRA"* 2> /dev/null || true
rm "$STARTMENU/TB"* 2> /dev/null || true
