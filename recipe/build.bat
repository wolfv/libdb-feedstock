pushd build_windows

devenv /Upgrade Berkeley_DB_vs2015.sln
set SLN_FILE=Berkeley_DB_vs2015.sln

msbuild %SLN_FILE% /p:Configuration=Release /p:Platform=x64
IF %ERRORLEVEL% NEQ 0 exit 1

robocopy x64\Release\ %LIBRARY_BIN%
DEL %LIBRARY_BIN%\*.pdb
MOVE %LIBRARY_BIN%\*.lib %LIBRARY_LIB%
COPY *.h %LIBRARY_INC%
