"Automatic formating of paragraphs whenever text is inserted set
"formatoptions+=a
"let b:noStripWhitespace=1
setlocal textwidth=71
set spell

if getline(1) =~ "JAW Weekly Report"
	%s/%dty%/\=strftime("%Y%m%d")/ge
	%s/%dts%/\=strftime("%d\/%m\/%Y")/ge
endif
