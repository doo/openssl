SET PATH="%~dp0ActivePerl-5.18.1.1800-MSWin32-x86-64int-297570\perl\bin";"%~dp0nasm-2.11rc1";%PATH%
IF NOT EXIST ActivePerl-* call download_ActivePerl.bat
IF NOT EXIST nasm-* call download_nasm.bat

IF EXIST ms\ntdll.mak (
	nmake -f ms\ntdll.mak clean
) 

perl Configure VC-WIN32
call ms\do_nasm
nmake -f ms\ntdll.mak

mkdir x86
copy out32dll\libeay32.* x86\
copy out32dll\ssleay32.* x86\
