@echo off
::Copyright @Charlie Ding
::E-mail:lostinternet@gmail.com

setlocal enabledelayedexpansion

set _keyboard_path="HKLM\SYSTEM\CurrentControlSet\Control\Keyboard layout"
set _scan_code_key="Scancode Map"
set _scan_code_value=0000000000000000030000003A001D001D003A0000000000


set _temp_file_name=temp9527.txt

set _b_change=0
set _b_revert=0

if "%1" == "" (
   set _b_change=1
) else if "%1" == "revert" (
   set _b_revert=1
) else (
  echo the parameter is wrong.
  echo usage: ChangeCtrlCaps.bat [revert]
)

reg query %_keyboard_path% >%_temp_file_name%


for /f "delims=," %%i in (%_temp_file_name%) do (
    set _b_find=0
    call :FindPath %%i
    if !_b_find! == 0 (
       reg add %_keyboard_path% /f
    )
    goto :NEXT
)
:NEXT
if %_b_change% == 1 (
   reg add %_keyboard_path% /v %_scan_code_key% /t REG_BINARY /d %_scan_code_value% /f
) else if %_b_revert% == 1 (
  reg delete %_keyboard_path% /v %_scan_code_key% /f
)  

del /s %_temp_file_name%
goto :eof

:FindPath
echo %1
set _esape=%1
set _remark=%_esape:~0,1%
if %_remark% == H set _b_find=1
goto :eof

