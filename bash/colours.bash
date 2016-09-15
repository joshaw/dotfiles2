# Created:  Fri 19 Jun 2015
# Modified: Thu 15 Sep 2016
# Author:   Josh Wainwright
# Filename: colours.bash

LS_COLORS="no=90:fi=0:di=32:ln=35:so=34:pi=34:ex=33:bd=34:cd=34:su=34:sg=34:tw=1;32:ow=1;32"
export LS_COLORS

if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0272822" #black
    echo -en "\e]P875715e" #darkgrey
    echo -en "\e]P1f92672" #darkred
    echo -en "\e]P9cc064e" #red
    echo -en "\e]P2a6e22e" #darkgreen
    echo -en "\e]PA7aac18" #green
    echo -en "\e]P3f4bf75" #brown
    echo -en "\e]PBf0a945" #yellow
    echo -en "\e]P466d9ef" #darkblue
    echo -en "\e]PC33c7e9" #blue
    echo -en "\e]P5ae81ff" #darkmagenta
    echo -en "\e]PD7e33ff" #magenta
    echo -en "\e]P6a1efe4" #darkcyan
    echo -en "\e]PE5fe3d2" #cyan
    echo -en "\e]P7f8f8f2" #lightgrey
    echo -en "\e]PFf9f8f5" #white
    clear #for background artifacting
fi
