@echo off
set BIOUTPUT=1

if exist a3 (
  rmdir a3
)
mklink /j a3 include\a3

mkdir x
mkdir x\gc_websiteFunctionsClient
if exist x\gc_websiteFunctionsClient\addons (
  rmdir x\gc_websiteFunctionsClient\addons
)
mklink /j x\gc_websiteFunctionsClient\addons addons

IF [%1] == [] (
  tools\hemtt release
) ELSE (
  tools\hemtt build %1
)

set BUILD_STATUS=%errorlevel%

rmdir a3
rmdir x\gc_websiteFunctionsClient\addons
rmdir x\gc_websiteFunctionsClient
rmdir x

if %BUILD_STATUS% neq 0 (
  echo Build failed
  exit /b %errorlevel%
) else (
  echo Build successful
  EXIT
)
