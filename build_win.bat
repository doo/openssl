@echo off
SETLOCAL EnableDelayedExpansion EnableExtensions

if %1 == VC-WIN32        SET OUTDIR=x86
if %1 == debug-VC-WIN32  SET OUTDIR=x86.dbg
if %1 == VC-WIN64A       SET OUTDIR=x64
if %1 == debug-VC-WIN64A SET OUTDIR=x64.dbg

if not defined OUTDIR (
	echo Invalid platform. Supported are: debug-VC-WIN64A VC-WIN64A debug-VC-WIN32 VC-WIN32
	exit /b 1
)

SET MSVC=12
if "%2" == "11" set MSVC=%2

SET PATH="%~dp0strawberry_perl\perl\bin";"%~dp0nasm-2.11rc1";%PATH%
IF NOT EXIST strawberry_perl\perl\bin\perl.exe call download_strawberry_perl.bat
IF NOT EXIST nasm-* call download_nasm.bat

set X64="VC-WIN64A debug-VC-WIN64A"
set substituted=!X64:%1=!
if not %substituted% == %X64% (
	SET IS_X64=true
) else (
	SET IS_X64=false
)
set config=%1
set substituted=!config:debug=!
if not %substituted% == %1 (
	SET IS_DEBUG=true
) ELSE (
	SET IS_DEBUG=false
)
set config=
set X64=
set substituted=

if %IS_X64% == true (
	call "C:\Program Files (x86)\Microsoft Visual Studio %MSVC%.0\VC\vcvarsall.bat" x64
) else (
	call "C:\Program Files (x86)\Microsoft Visual Studio %MSVC%.0\VC\vcvarsall.bat" x86
)

perl Configure %1
IF EXIST ms\ntdll.mak (
	nmake -f ms\ntdll.mak clean
)

if %IS_X64% == true (
	call ms\do_win64a
) else (
	call ms\do_nasm
)

nmake -f ms\ntdll.mak
mkdir %OUTDIR%\include
del /Q %OUTDIR%\include\openssl\*.*
mkdir %OUTDIR%\bin
del /Q %OUTDIR%\bin\*.*

if %IS_DEBUG% == true (
	xcopy /Y out32dll.dbg\libeay32.* %OUTDIR%\bin\
	xcopy /Y out32dll.dbg\ssleay32.* %OUTDIR%\bin\
) else (
	xcopy /Y out32dll\libeay32.* %OUTDIR%\bin\
	xcopy /Y out32dll\ssleay32.* %OUTDIR%\bin\
)
xcopy /S /Y inc32 %OUTDIR%\include

ENDLOCAL

EXIT /B 0
