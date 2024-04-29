@echo off
set cypress=0
set synaptics=0
set ts=0

:start
echo waiting for device . . .
adb wait-for-device
sleep 3

adb shell "dmesg | grep cyttsp" >cypress.txt
adb shell "dmesg | grep synaptics" >synaptics.txt

echo.
adb shell "dmesg | grep cyttsp_core_init | grep -o -e Successful" >cypress
set /p cypress=<cypress
if "%cypress%" == "Successful" (
echo Cypress digitizer detected . . .
set cypress=1
) else (
echo Cypress digitizer NOT detected . . .
)

echo.
adb shell "dmesg | grep synaptics_ts_probe | grep -o -e Start" >synaptics
set /p synaptics=<synaptics
if "%synaptics%" == "Start" (
echo Synaptics digitizer detected . . .
set synaptics=1
) else (
echo Synaptics digitizer NOT detected . . .
)

echo.
set /a ts=%cypress%+%synaptics% >nul
if %ts% == 0 (
echo detection failed . . .
echo rebooting device for redetection . . .
adb reboot
adb wait-for-device
echo waiting for device to boot . . .
sleep 30
goto start
)
echo check cypress.txt and synaptics.txt for more information
echo.
if exist cypress del cypress
if exist synaptics del synaptics
pause