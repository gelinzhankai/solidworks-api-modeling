# SolidWorks COM Patterns

## Environment Checks

Use PowerShell first:

```powershell
Get-ItemProperty -Path 'Registry::HKEY_CLASSES_ROOT\SldWorks.Application*' -ErrorAction SilentlyContinue
py -0p
py -3.12 -c "import win32com.client; print('pywin32 OK')"
```

SolidWorks 2024 commonly registers as:

```text
SldWorks.Application.32
```

If `win32com` is missing:

```powershell
py -3.12 -m pip install pywin32
```

## Connection Pattern

Prefer a running manual session:

```python
import pythoncom
import win32com.client

pythoncom.CoInitialize()
try:
    sw = win32com.client.GetActiveObject("SldWorks.Application.32")
except Exception:
    sw = win32com.client.Dispatch("SldWorks.Application.32")
sw.Visible = True
```

`RevisionNumber` may be a property, not a method:

```python
revision = str(sw.RevisionNumber)
```

## Document Cleanup

Iterate open documents with `GetFirstDocument` / `GetNext`, but use a `com_get` helper because `pywin32` may expose no-argument methods as properties.

Only auto-close documents that are clearly automation-owned:

- Unsaved temp parts named `零件\d+` or `Part\d+`.
- Saved parts under the configured automation output directory.

Never close user documents outside the automation output directory.

## Saving

`SaveAs3` return values can be misleading. Verify:

- Output path exists.
- File size is non-zero.
- `model.GetPathName` matches expected output when possible.
- Existing locked files are closed/deleted only if they are automation-owned.

## Snapshots

Use `model.SaveBMP(path, width, height)` after setting the view.

For feature results:

```python
model.ClearSelection2(True)
model.ShowNamedView2("*Isometric", 7)
model.ViewZoomtofit2()
model.SaveBMP(path, 1400, 1000)
```

For sketch checks, capture before leaving the sketch:

```python
model.ShowNamedView2("*Normal To", -1)
model.ViewZoomtofit2()
model.SaveBMP(path, 1400, 1000)
```
