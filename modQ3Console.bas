Attribute VB_Name = "modQ3Console"
Option Explicit

' Win32 Structures
Public Type RECT
   Left As Long
   Top As Long
   Right As Long
   Bottom As Long
End Type

Public Type WINDOWINFO
    cbSize As Long
    rcWindow As RECT
    rcClient As RECT
    dwStyle As Long
    dwExStyle As Long
    dwWindowStatus As Long
    cxWindowBorders As Long
    cyWindowBorders As Long
    atomWindowType As Long
    wCreatorVersion As Long
End Type


'Win32 constants used throughout
Public Const MAX_PATH = 260
Public Const LB_SETTABSTOPS As Long = &H192

'For SetWindowPos()
Public Const HWND_TOPMOST = -1
Public Const HWND_NOTOPMOST = -2
Public Const HWND_BOTTOM = 1
Public Const HWND_TOP = 0
Public Const SWP_FRAMECHANGED = &H20
Public Const SWP_DRAWFRAME = SWP_FRAMECHANGED
Public Const SWP_HIDEWINDOW = &H80
Public Const SWP_NOACTIVATE = &H10
Public Const SWP_NOCOPYBITS = &H100
Public Const SWP_NOMOVE = &H2
Public Const SWP_NOOWNERZORDER = &H200
Public Const SWP_NOREDRAW = &H8
Public Const SWP_NOREPOSITION = SWP_NOOWNERZORDER
Public Const SWP_NOSIZE = &H1
Public Const SWP_NOZORDER = &H4
Public Const SWP_SHOWWINDOW = &H40
Public Const SWP_NOSENDCHANGING = &H400
Public Const SWP_DEFERERASE = &H2000

'Button related messages
Public Const STN_DBLCLK = &H1&
Public Const MK_LBUTTON = &H1
Public Const MK_MBUTTON = &H10
Public Const MK_RBUTTON = &H2
Public Const BM_CLICK = &HF5
Public Const BM_SETSTYLE = &HF4
Public Const BN_DOUBLECLICKED = 5
Public Const BN_CLICKED = 0

'Button styles
Public Const BS_AUTOCHECKBOX = &H3&
Public Const BS_AUTORADIOBUTTON = &H9&
Public Const BS_AUTO3STATE = &H6&
Public Const BS_CHECKBOX = &H2&
Public Const BS_DEFPUSHBUTTON = &H1&
Public Const BS_GROUPBOX = &H7&
Public Const BS_PUSHLIKE = &H1000&
Public Const BS_LEFTTEXT = &H20&
Public Const BS_3STATE = &H5&
Public Const BS_PUSHBUTTON = &H0&
Public Const BS_RADIOBUTTON = &H4&
Public Const BS_SOLID = 0
Public Const BS_BOTTOM = &H800&
Public Const BS_CENTER = &H300&
Public Const BS_LEFT = &H100&
Public Const BS_MULTILINE = &H2000&
Public Const BS_RIGHT = &H200&
Public Const BS_TOP = &H400&
Public Const BS_VCENTER = &HC00&

'Window Messages
Public Const WM_CHAR = &H102
Public Const WM_NCLBUTTONDBLCLK = &HA3
Public Const WM_NCLBUTTONDOWN = &HA1
Public Const WM_NCLBUTTONUP = &HA2
Public Const WM_NCRBUTTONDOWN = &HA4
Public Const WM_NCRBUTTONUP = &HA5
Public Const WM_COMMAND = &H111
Public Const WM_DESTROY = &H2
Public Const WM_ENABLE = &HA
Public Const WM_HSCROLL = &H114
Public Const WM_LBUTTONDBLCLK = &H203
Public Const WM_LBUTTONDOWN = &H201
Public Const WM_LBUTTONUP = &H202
Public Const WM_MBUTTONDBLCLK = &H209
Public Const WM_MBUTTONDOWN = &H207
Public Const WM_MBUTTONUP = &H208
Public Const WM_PASTE = &H302
Public Const WM_QUIT = &H12
Public Const WM_RBUTTONDBLCLK = &H206
Public Const WM_RBUTTONDOWN = &H204
Public Const WM_RBUTTONUP = &H205
Public Const WM_SETFOCUS = &H7
Public Const WM_VSCROLL = &H115
Public Const WM_CLOSE = &H10
Public Const WM_COPY = &H301
Public Const WM_GETTEXT = &HD
Public Const WM_GETTEXTLENGTH = &HE
Public Const WM_SETTEXT = &HC
Public Const WM_CLEAR = &H303
Public Const WM_CUT = &H300
Public Const WM_FONTCHANGE = &H1D
Public Const WM_GETFONT = &H31
Public Const WM_GETMINMAXINFO = &H24
Public Const WM_KEYDOWN = &H100
Public Const WM_KEYUP = &H101
Public Const WM_SETFONT = &H30
Public Const WM_UNDO = &H304

'GetWindow()
Public Const GW_CHILD = 5
Public Const GW_HWNDFIRST = 0
Public Const GW_HWNDLAST = 1
Public Const GW_HWNDNEXT = 2
Public Const GW_HWNDPREV = 3
Public Const GW_MAX = 5
Public Const GW_OWNER = 4

Dim Message As String

'API declarations
Public Declare Function SetActiveWindow Lib "user32" (ByVal hWnd As Long) As Long

Public Declare Function GetWindowRect Lib "user32" (ByVal hWnd As Long, lpRect As RECT) As Long

Public Declare Function GetWindowInfo Lib "user32" (ByVal hWnd As Long, ByRef pwi As WINDOWINFO) As Long

Public Declare Function GetWindow Lib "user32" (ByVal hWnd As Long, ByVal wCmd As Long) As Long

Public Declare Function SetWindowText Lib "user32" Alias "SetWindowTextA" (ByVal hWnd As Long, ByVal lpString As String) As Long

Public Declare Function SetWindowPos Lib "user32" (ByVal hWnd As Long, ByVal hWndInsertAfter As Long, ByVal x As Long, ByVal y As Long, ByVal cx As Long, ByVal cy As Long, ByVal wFlags As Long) As Long
    
Public Declare Function EnumWindows Lib "user32" (ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long

Public Declare Function GetClassName Lib "user32" Alias "GetClassNameA" (ByVal hWnd As Long, ByVal lpClassName As String, ByVal nMaxCount As Long) As Long

Public Declare Function GetWindowText Lib "user32" Alias "GetWindowTextA" (ByVal hWnd As Long, ByVal lpString As String, ByVal cch As Long) As Long

Public Declare Function GetWindowTextLength Lib "user32" Alias "GetWindowTextLengthA" (ByVal hWnd As Long) As Long

Public Declare Function SendMessage Lib "user32" Alias "SendMessageA" (ByVal hWnd As Long, ByVal wMsg As Long, ByVal wParam As Long, lParam As Any) As Long

Public Declare Function EnumChildWindows Lib "user32" (ByVal hWndParent As Long, ByVal lpEnumFunc As Long, ByVal lParam As Long) As Long

Public Declare Function FindWindow Lib "user32" Alias "FindWindowA" (ByVal lpClassName As String, ByVal lpWindowName As String) As Long

Public Function FindConsole() As Long
    FindConsole = FindWindow(vbNullString, "Quake 3 Console")
End Function

Public Function WriteConsole(Data As String)
Dim Consolehwnd As Long
Consolehwnd = FindConsole
If Consolehwnd <> 0 Then
Message = "echo " & Data
Call EnumChildWindows(Consolehwnd, AddressOf EnumChildWindowProc, 0&)
End If
End Function

'Callback function for EnumChildWindows
Public Function EnumChildWindowProc(ByVal hWnd As Long, ByVal lParam As Long) As Long
Dim dummy() As Byte
Dim txt As String

txt = Space$(MAX_PATH)

Call GetWindowText(hWnd, txt, MAX_PATH)

If TrimNull(txt) = "" Then

ReDim dummy(Len(Message) + 1)

'The string has to be converted to a byte array to be passed to the function
dummy = StringToByteArray(Message)

'dummy(0) points to the first byte of the array
Call SendMessage(hWnd, WM_SETTEXT, 0&, dummy(0))
Call SendMessage(hWnd, WM_CHAR, 13, 1)

Message = ""
EnumChildWindowProc = 1
End If
End Function

Public Function EnumWindowProc(ByVal hWnd As Long, ByVal lParam As Long) As Long

  
  'to continue enumeration, we must return True
  '(in C that's 1).  If we wanted to stop (perhaps
  'using if this as a specialized FindWindow method,
  'comparing a known class and title against the
  'returned values, and a match was found, we'd need
  'to return False (0) to stop enumeration. When 1 is
  'returned, enumeration continues until there are no
  'more windows left.
   EnumWindowProc = 1

End Function


Private Function TrimNull(item As String)

  'remove string before the terminating null(s)
   Dim pos As Integer
   
   pos = InStr(item, Chr$(0))
   
   If pos Then
         TrimNull = Left$(item, pos - 1)
   Else: TrimNull = item
   End If
   
End Function

'Pass the message as string and get the LONG equivalent.
'Used to determine what has been selected from comboboxes and elsewhere
Public Function GetMessageValue(strMessage As String) As Long
Dim msg As Long

Select Case strMessage
    Case "WM_DESTROY":
        msg = WM_DESTROY
    Case "WM_ENABLE":
        msg = WM_ENABLE
    Case "WM_HSCROLL":
        msg = WM_HSCROLL
    Case "WM_LBUTTONDBLCLK":
        msg = WM_LBUTTONDBLCLK
    Case "WM_LBUTTONDOWN":
        msg = WM_LBUTTONDOWN
    Case "WM_LBUTTONUP":
        msg = WM_LBUTTONUP
    Case "WM_MBUTTONDBLCLK":
        msg = WM_MBUTTONDBLCLK
    Case "WM_MBUTTONDOWN":
        msg = WM_MBUTTONDOWN
    Case "WM_MBUTTONUP":
        msg = WM_MBUTTONUP
    Case "WM_PASTE":
        msg = WM_PASTE
    Case "WM_QUIT":
        msg = WM_QUIT
    Case "WM_RBUTTONDBLCLK":
        msg = WM_RBUTTONDBLCLK
    Case "WM_RBUTTONDOWN":
        msg = WM_RBUTTONDOWN
    Case "WM_RBUTTONUP":
        msg = WM_RBUTTONUP
    Case "WM_SETFOCUS":
        msg = WM_SETFOCUS
    Case "WM_VSCROLL":
        msg = WM_VSCROLL
    Case "WM_CLOSE":
        msg = WM_CLOSE
    Case "WM_COPY":
        msg = WM_COPY
    Case "WM_GETTEXT":
        msg = WM_GETTEXT
    Case "WM_GETTEXTLENGTH":
        msg = WM_GETTEXTLENGTH
    Case "WM_SETTEXT":
        msg = WM_SETTEXT
    Case "WM_CLEAR":
        msg = WM_CLEAR
    Case "WM_CUT":
        msg = WM_CUT
    Case "WM_FONTCHANGE":
        msg = WM_FONTCHANGE
    Case "WM_GETFONT":
        msg = WM_GETFONT
    Case "WM_GETMINMAXINFO":
        msg = WM_GETMINMAXINFO
    Case "WM_KEYDOWN":
        msg = WM_KEYDOWN
    Case "WM_KEYUP":
        msg = WM_KEYUP
    Case "WM_SETFONT":
        msg = WM_SETFONT
    Case "WM_UNDO":
        msg = WM_UNDO
End Select

GetMessageValue = msg
End Function

'Converts a string into a Byte Array
Public Function StringToByteArray(str As String) As Variant
Dim bray() As Byte
Dim cnt As Integer
Dim ln As Integer

ln = Len(str)

ReDim bray(ln)

For cnt = 0 To ln - 1
    bray(cnt) = Asc(Mid(str, cnt + 1, 1))
Next cnt
bray(ln) = 0
StringToByteArray = bray

End Function

'Converts a Byte Array to a string
Public Function ByteArrayToString(bry As Variant) As String
Dim cnt As Integer
Dim dummy As String

For cnt = 0 To UBound(bry)
    dummy = dummy & Chr$(bry(cnt))
Next cnt
ByteArrayToString = dummy
End Function

