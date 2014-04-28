SETLOCAL EnableDelayedExpansion EnableExtensions

if %1 == VC-WIN32        SET OUTDIR=x86
if %1 == debug-VC-WIN32  SET OUTDIR=x86.dbg
if %1 == VC-WIN64A       SET OUTDIR=x64
if %1 == debug-VC-WIN64A SET OUTDIR=x64.dbg

if not defined OUTDIR (
	echo Invalid platform. Supported are: debug-VC-WIN64A VC-WIN64A debug-VC-WIN32 VC-WIN32
	exit /b 1
)

SET PATH="%~dp0strawberry_perl\perl\bin";"%~dp0nasm-2.11rc1";%PATH%
IF NOT EXIST strawberry_perl\perl\bin\perl.exe call download_strawberry_perl.bat
IF NOT EXIST nasm-* call download_nasm.bat

IF EXIST ms\ntdll.mak (
	nmake -f ms\ntdll.mak vclean
) 

perl Configure %1
set X64="VC-WIN64A debug-VC-WIN64A"
set substituted=!X64:%1=!
if not %substituted% == %X64% (
	call ms\do_win64a
) else (
	call ms\do_nasm
)

nmake -f ms\ntdll.mak
mkdir %OUTDIR%
copy out32dll\libeay32.* %OUTDIR%\
copy out32dll\ssleay32.* %OUTDIR%\

ENDLOCAL

EXIT /B 0
