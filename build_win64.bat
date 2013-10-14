SET PATH="%~dp0ActivePerl-5.18.1.1800-MSWin32-x86-64int-297570\perl\bin";"%~dp0nasm-2.11rc1";%PATH%
IF NOT EXIST ActivePerl-* call download_ActivePerl.bat
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

EXIT /B 0
