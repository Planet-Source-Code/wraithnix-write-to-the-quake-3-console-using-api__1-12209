VERSION 5.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   420
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   1620
   LinkTopic       =   "Form1"
   ScaleHeight     =   420
   ScaleWidth      =   1620
   StartUpPosition =   3  'Windows Default
   Begin VB.Timer Timer1 
      Interval        =   500
      Left            =   0
      Top             =   0
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Timer1_Timer()
WriteConsole ("Hello world!")
WriteConsole ("Here's how you write to the Q3 Console!")
End Sub
