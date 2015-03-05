#!/bin/bash
set +e

source $(dirname $BASH_SOURCE)/settings.sh

GENFOLDER="LDRA Tool Suite"
DESKTOP="/cygdrive/c/Users/JoshWainwright/Desktop"
DOCUMENTS="/cygdrive/c/Users/JoshWainwright/Documents/LDRA"
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
mv "$STARTMENU/Programs/*Assembler*" /tmp

rm -r "$STARTMENU/Programs/LDRA"* 2> /dev/null || true
find "$DESKTOPPUB" -maxdepth 1 -name "LDRA*" -delete -or -name "TB*" -delete

mv "/tmp/*Assembler*" "$STARTMENU/Programs/"

for LANG in lang_c lang_a lang_j; do

	LANGUAGE=${langs[$LANG]}
	echo $LANGUAGE

	for VERSION in $(eval echo "\${$LANG[@]}"); do

		printf "\t%s\n" "$VERSION"

		SPECFOLDER="$GENFOLDER $LANGUAGE v$VERSION"
		WORKINGDIR="$WORKAREA_DIR/$LANGUAGE/$VERSION/"
		rm -r "$DESKTOP/$SPECFOLDER"
		mkdir -p "$DESKTOP/$SPECFOLDER"

		# LDRA Toolsuite Programs
		for TBPROG in $PROGRAMS; do
			printf "\t\t%s\n" "$TBPROG"
			LINKFILE="$DESKTOP/$SPECFOLDER/$TBPROG - $LANGUAGE"
			TBFILE="$TOOLSUITE_DIR/$LANGUAGE/$VERSION/$TBPROG.exe"

			mkshortcut -n "$LINKFILE" -w "$WORKINGDIR" "$TBFILE"

		done

		# Configuration Options
		mkdir -p "$DESKTOP/$SPECFOLDER/Configure"
		for OPT in $CONFIGURES; do
			printf "\t\t%s\n" "$OPT"
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

sapath="/cygdrive/c/Program Files (x86)/LDRA/"

find "$sapath" -mindepth 1 -maxdepth 1 -print0 | while read -d $'\0' folder
do
	! [[ "$folder" =~ LDRA[cru] ]] && continue
	satype=$(basename "$folder")
	tmp=${satype#LDRA}
	VARIENT=${tmp%%_*}
	tmp=${tmp#*_}
	LANGUAGE=${tmp%_*}
	VERSION=${tmp##*_}

	printf "\n%s\n" "$satype"

	SPECFOLDER="LDRA${VARIENT} ${LANGUAGE} ${VERSION}"
	WORKINGDIR="$DOCUMENTS/$satype"
	LINKFILE="$DESKTOP/$SPECFOLDER/$LANGUAGE $VARIENT $VERSION"
	TBFILE="${sapath}${satype}/LDRA${VARIENT}.exe"

	rm -r "$DESKTOP/$SPECFOLDER"
	mkdir -p "$DESKTOP/$SPECFOLDER"

	mkshortcut -n "$LINKFILE" -w "$WORKINGDIR" "$TBFILE"

	# Configuration Options
	mkdir -p "$DESKTOP/$SPECFOLDER/Configure"
	for OPT in $CONFIGURES; do
		printf "\t\t%s\n" "$OPT"
		OPTNAME=${OPT%:*}
		OPTSET=${OPT#*:}

		if [ "$OPTSET" == "X" ]; then
			OPTIONSDASH="-a -NOINI"
		else
			OPTIONSDASH="-a -$OPTSET -NOINI"
		fi

		LINKFILE="$DESKTOP/$SPECFOLDER/Configure/${VERSION}_${LANGUAGE}_$OPTNAME"
		OPTFILE="${sapath}${satype}/Compconfig/setup.exe"

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

# Remove lone files in start menu
rm "$STARTMENU/LDRA"* 2> /dev/null || true
rm "$STARTMENU/TB"* 2> /dev/null || true
