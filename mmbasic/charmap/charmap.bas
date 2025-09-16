' --------------------------------------
' Character Map program 
'   written in MMBasic For PicoCalc
' --------------------------------------
' Copyright (c) 2025 Vurdalakov
' https://github.com/vurdalakov/picocalc
' --------------------------------------

Option Explicit
Option Default None

Const FALSE = 0
Const TRUE = -1

Const COLOR_BLACK = Rgb(0,0,0)
Const COLOR_WHITE = Rgb(255,255,255)
Const COLOR_BLUE = Rgb(0,0,255)
Const COLOR_CYAN = Rgb(0,255,255)
Const COLOR_YELLOW = Rgb(255,255,0)
Const COLOR_LITEGRAY = Rgb(210,210,210)

Const SCREEN_WIDTH = 40

Const KEY_UP = 128
Const KEY_DOWN = 129
Const KEY_LEFT = 130
Const KEY_RIGHT = 131
Const KEY_F1 = 145
Const KEY_F2 = 146
Const KEY_F9 = 153

Const AppTitle = "Character Map 1.0"

Dim Integer CurPos = 65 ' "A"

On Key KEY_F9,SaveScreenshot

ShowMainScreen

MainLoop

Sub MainLoop
  Local String keyChar
  Local Integer keyCode
  
  Do
    keyChar = Inkey$
    
    If keyChar <> "" Then
      keyCode = Asc(keyChar)
      
      If keyCode = KEY_UP Then
        UpdateTable(CurPos - 16)
      ElseIf keyCode = KEY_DOWN Then
        UpdateTable(CurPos + 16)
      ElseIf keyCode = KEY_LEFT Then
        UpdateTable(CurPos - 1)
      ElseIf keyCode = KEY_RIGHT Then
        UpdateTable(CurPos + 1)
      ElseIf keyCode = KEY_F1 Then
        ShowAboutScreen
        ShowMainScreen
      ElseIf keyCode = KEY_F2 Then
        Cls COLOR_BLACK
        End
      End If
    End If
    
    Pause 50
  Loop
End Sub

Sub ShowMainScreen
  Font 1,1
  Cls COLOR_BLUE

  Color COLOR_YELLOW,COLOR_BLUE
  PrintCenteredText 1,AppTitle

  PrintTable

  PrintChar CurPos,TRUE
  PrintInfo

  PrintFooter
End Sub

Sub PrintTable
  SetCursor 0,2
  
  Color COLOR_LITEGRAY,COLOR_BLUE
  PrintHexLine
  
  Local Integer i
  For i = 32 To 255
    If 0 = (i Mod 16) Then
      Color COLOR_LITEGRAY,COLOR_BLUE
      Print ""
      Print " ";Hex$(i);" ";
    End If
    
    Color COLOR_WHITE,COLOR_BLUE
    Print Chr$(i);" ";
    
    If 15 = (i Mod 16) Then
      Color COLOR_LITEGRAY,COLOR_BLUE
      Print Hex$(Int(i/16)*16);
    End If
  Next
  
  Color COLOR_LITEGRAY,COLOR_BLUE
  PrintHexLine
End Sub
  
Sub PrintHexLine
  Print ""
  Print "    ";
  
  Local Integer i
  For i = 0 To 15
    Print Hex$(i);" ";
  Next
End Sub
  
Sub UpdateTable(newPos As Integer)
  Local Integer oldPos = CurPos
  CurPos = newPos

  If CurPos < 32 Then CurPos = 32
  If CurPos > 255 Then CurPos = 255
  
  If oldPos <> CurPos Then
    PrintChar(oldPos,FALSE)
    PrintChar(CurPos,TRUE)
    
    PrintInfo
  End If
End Sub
  
Sub PrintChar(charIndex As Integer, isSelected As Integer)
  Local Integer x = 3 + (charIndex Mod 16) * 2
  Local Integer y = 2 + Int(charIndex / 16)
  SetCursor x,y

  If TRUE = isSelected Then
    Color COLOR_CYAN,COLOR_BLUE
    Print Chr$(222);
    Color COLOR_BLACK,COLOR_CYAN
    Print CHR$(charIndex);
    Color COLOR_CYAN,COLOR_BLUE
    Print Chr$(221);
  Else
    Color COLOR_WHITE,COLOR_BLUE
    Print " ";Chr$(charIndex);" "
  End If
End Sub
  
Sub PrintInfo
  Local String c
  If CurPos < 32 Then c = " " Else c = Chr$(CurPos)

  Font 1,4
  Color COLOR_YELLOW,COLOR_BLUE
  PrintText 8,20,c
  Font 1,1

  Color COLOR_WHITE,COLOR_BLUE
  PrintText 23,20,"Char: '"+c+"'"+"   "
  PrintText 23,21,"Dec:  "+Str$(CurPos)+"   "
  PrintText 23,22,"Hex:  "+Hex$(CurPos)+"   "
  PrintText 23,23,"Oct:  "+Oct$(CurPos)+"   "
End Sub
  
Sub PrintFooter
  ClearLastLine

  SetCursor 0,25
  
  Color COLOR_WHITE,COLOR_BLACK
  Print Chr$(149);Chr$(146);Chr$(147);Chr$(148);
  Color COLOR_BLACK,COLOR_CYAN
  Print "Move";
  
  Color COLOR_BLACK,COLOR_BLACK
  Print Space$(17);

  Color COLOR_WHITE,COLOR_BLACK
  Print " F1";
  Color COLOR_BLACK,COLOR_CYAN
  Print "About";
  
  Color COLOR_WHITE,COLOR_BLACK
  Print " F2";
  Color COLOR_BLACK,COLOR_CYAN
  Print "Exit";
End Sub
  
Sub ClearLine(lineNumber As Integer)
  SetCursor 0,lineNumber
  Print Space$(SCREEN_WIDTH);
End Sub
  
Sub ClearLastLine
  Color COLOR_BLACK,COLOR_BLACK
  ClearLine 25
  ClearLine 26
End Sub
  
Sub SetCursor(x As Integer, y As Integer)
  Print @(x*8,y*12);
End Sub
  
Sub PrintText(x As Integer, y As Integer, text$ As String)
  Print @(x*8,y*12);text$;
End Sub
  
Sub PrintCenteredText(y As Integer, text$ as String)
  Local Integer x = (SCREEN_WIDTH - Len(text$)) / 2
  PrintText x,y,text$
End Sub

Sub WaitAnyKey
  Do
    Pause 50
  Loop While Inkey$ = ""
End Sub
  
Sub ShowAboutScreen
  Cls COLOR_BLUE

  Color COLOR_YELLOW,COLOR_BLUE
  PrintCenteredText 1,AppTitle

  Color COLOR_WHITE,COLOR_BLUE
  PrintCenteredText 3,"Copyright (c) 2025 Vurdalakov"
  PrintCenteredText 5,"https://github.com/vurdalakov/picocalc"
  
  ClearLastLine

  Color COLOR_WHITE,COLOR_BLACK
  PrintCenteredText 25,"Press any key To continue"

  WaitAnyKey
End Sub

Sub SaveScreenshot
  Static Integer n = 0
  Local String fileName
  
  Do
    fileName = "b:/screenshot"+Str$(n,3,0,"0")+".bmp"
    
    n = n + 1

    If Not MM.Info(Exists File fileName) Then
      Save Image fileName
      Exit Sub
    End If
  Loop
End Sub
