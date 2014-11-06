VERSION="946"
GENFOLDER="LDRA Tool Suite"
DESKTOP="/cygdrive/c/Users/JoshWainwright/Desktop"

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

# Remove any old Start Menu Entries
STARTMENU="/cygdrive/c/ProgramData/Microsoft/Windows/Start Menu"
rm -r "$STARTMENU/Programs/$GENFOLDER"*

for LANG in "C_C++" "Ada"; do

	SPECFOLDER="$GENFOLDER $LANG v$VERSION"
	WORKINGDIR="/cygdrive/c/LDRA_Workarea/$LANG/$VERSION/"
	rm -r "$DESKTOP/$SPECFOLDER"
	mkdir -p "$DESKTOP/$SPECFOLDER"

	# LDRA Toolsuite Programs
	for TBPROG in $PROGRAMS; do
		LINKFILE="$DESKTOP/$SPECFOLDER/$TBPROG - $LANG"
		TBFILE="/cygdrive/c/LDRA_Toolsuite/$LANG/$VERSION/$TBPROG.exe"

		mkshortcut -n "$LINKFILE" -w "$WORKINGDIR" "$TBFILE"

	done

	# Configuration Options
	mkdir -p "$DESKTOP/$SPECFOLDER/Configure"
	for OPT in $CONFIGURES; do
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

rm "$STARTMENU/LDRA"*
rm "$STARTMENU/TB"*
