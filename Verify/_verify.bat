@echo off

set "file=checksums.md5"

echo Verifying %file%...

gchecksum-0.13.0.exe verify -a MD5 -d ../Files -f %file%

@pause
