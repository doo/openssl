SETLOCAL EnableDelayedExpansion EnableExtensions

SET PATH="%~dp0strawberry_perl\perl\bin";"%~dp0nasm-2.11rc1";%PATH%
IF NOT EXIST strawberry_perl\perl\bin\perl.exe call download_strawberry_perl.bat
IF NOT EXIST nasm-* call download_nasm.bat

IF EXIST ms\ntdll.mak (
	nmake -f ms\ntdll.mak vclean
) 

perl Configure VC-WIN64A
call ms\do_win64a
nmake -f ms\ntdll.mak

mkdir x64
copy out32dll\libeay32.* x64\
copy out32dll\ssleay32.* x64\

ENDLOCAL

EXIT /B 0
