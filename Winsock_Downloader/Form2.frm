VERSION 5.00
Object = "{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.0#0"; "MSCOMCTL.OCX"
Object = "{F9043C88-F6F2-101A-A3C9-08002B2F49FB}#1.2#0"; "COMDLG32.OCX"
Begin VB.Form Form2 
   Caption         =   "Priyan's Downloader"
   ClientHeight    =   5685
   ClientLeft      =   3915
   ClientTop       =   1980
   ClientWidth     =   5145
   LinkTopic       =   "Form2"
   ScaleHeight     =   5685
   ScaleWidth      =   5145
   Begin MSComDlg.CommonDialog CommonDialog1 
      Left            =   4080
      Top             =   1080
      _ExtentX        =   847
      _ExtentY        =   847
      _Version        =   393216
   End
   Begin Project1.ctlwinsckdownloader ctlwinsckdownloader1 
      Left            =   1320
      Top             =   4560
      _ExtentX        =   3651
      _ExtentY        =   529
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Cancel"
      Height          =   375
      Left            =   1440
      TabIndex        =   5
      Top             =   3960
      Width           =   1695
   End
   Begin MSComctlLib.ProgressBar ProgressBar1 
      Height          =   375
      Left            =   240
      TabIndex        =   0
      Top             =   3360
      Width           =   4095
      _ExtentX        =   7223
      _ExtentY        =   661
      _Version        =   393216
      Appearance      =   1
   End
   Begin VB.TextBox txturl 
      Height          =   375
      Left            =   840
      TabIndex        =   2
      Text            =   "http://download.microsoft.com/download/e/2/8/e2843736-feff-4188-a9e0-87c06db3c6bd/VS6sp61.exe"
      Top             =   600
      Width           =   2895
   End
   Begin VB.CommandButton Command1 
      Caption         =   "Download"
      Height          =   375
      Left            =   1080
      TabIndex        =   1
      Top             =   1560
      Width           =   2175
   End
   Begin VB.Label lblstatus 
      Caption         =   "lblstatus"
      Height          =   975
      Left            =   120
      TabIndex        =   6
      Top             =   2160
      Width           =   4815
      WordWrap        =   -1  'True
   End
   Begin VB.Label Label2 
      Caption         =   "Save to"
      Height          =   255
      Left            =   1320
      TabIndex        =   4
      Top             =   1080
      Width           =   1815
   End
   Begin VB.Label Label1 
      Caption         =   "Url"
      Height          =   255
      Left            =   1320
      TabIndex        =   3
      Top             =   240
      Width           =   1815
   End
End
Attribute VB_Name = "Form2"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Command1_Click()
Dim pos%, temp$
temp = StrReverse(Replace(LCase(txturl), "http://", ""))
If Left(temp, 1) = "/" Then temp = Mid(temp, 2)
pos = InStr(1, temp, "/")
If pos Then
    temp = StrReverse(Left(temp, pos - 1))
Else
    temp = ""
End If
On Error Resume Next
Me.CommonDialog1.Filename = temp
Me.CommonDialog1.CancelError = True
Me.CommonDialog1.ShowOpen
If Err Then Exit Sub

On Error GoTo 0
Me.ctlwinsckdownloader1.Filename = Me.CommonDialog1.Filename
Me.ctlwinsckdownloader1.URL = txturl
Me.ctlwinsckdownloader1.Readheaders
With ctlwinsckdownloader1

End With
End Sub

Private Sub Command2_Click()
ctlwinsckdownloader1.Cancel_Download
End Sub

Private Sub ctlwinsckdownloader1_Disconnected()
MsgBox "Disconnected", vbCritical, "Error!"
End Sub

Private Sub ctlwinsckdownloader1_Downloaded(ByVal dfile$)

lblstatus.Caption = "Downloaded"
MsgBox "Downloaded"
End Sub



Private Sub ctlwinsckdownloader1_DownloadError(ByVal description As String, ByVal SERVER_ERROR As Boolean)
MsgBox description, vbCritical, "Error!"
If ctlwinsckdownloader1.Responsecode = "302" Or ctlwinsckdownloader1.Responsecode = 301 Then
    MsgBox "The url was moved to " & ctlwinsckdownloader1.getheader("location"), vbInformation
End If
End Sub

Private Sub ctlwinsckdownloader1_headerread()
If ctlwinsckdownloader1.IsServerOk Then
    ctlwinsckdownloader1.downloadfile
End If
End Sub

Private Sub ctlwinsckdownloader1_progress(ByVal downloaded As Double, ByVal Total As Double)
On Error Resume Next
If ctlwinsckdownloader1.Resuming Then
    lblstatus.Caption = "Resuming Download "
Else
    lblstatus.Caption = "Downloading.."
End If

lblstatus.Caption = lblstatus.Caption & Round(downloaded / 1024, 2) & " KB OF " & Round(Total / 1024, 2) & " KB"
ProgressBar1.Value = downloaded / Total * 100
End Sub

Private Sub Form_Load()
lblstatus.Caption = ""
End Sub

