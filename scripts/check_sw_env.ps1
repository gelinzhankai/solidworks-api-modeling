$ErrorActionPreference = "Continue"

Write-Output "SolidWorks COM registrations:"
Get-ItemProperty -Path "Registry::HKEY_CLASSES_ROOT\SldWorks.Application*" -ErrorAction SilentlyContinue |
    Select-Object PSChildName

Write-Output ""
Write-Output "Python launchers:"
py -0p 2>$null

Write-Output ""
Write-Output "Python 3.12 executable and version:"
py -3.12 -c "import sys; print(sys.executable); print(sys.version)" 2>$null

Write-Output ""
Write-Output "pywin32 check:"
py -3.12 -c "import win32com.client; print('pywin32 OK')" 2>$null

Write-Output ""
Write-Output "SolidWorks active object check:"
py -3.12 -c "import pythoncom, win32com.client; pythoncom.CoInitialize(); sw=win32com.client.GetActiveObject('SldWorks.Application.32'); print('Active SW revision:', sw.RevisionNumber)" 2>$null
