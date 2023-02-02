#tag Module
Protected Module StringExtensions
	#tag Method, Flags = &h0
		Function After(extends s as string, target as string) As string
		  
		  // Returns the portion of the input string that comes after
		  // the first occurrence of target, or if target does not occur,
		  // an empty string.
		  
		  Var pos as integer = s.InStr(target)
		  if pos > 0 then
		    return s.Mid(pos + target.Len)
		  end if
		  
		  return ""
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function Before(extends s as string, target as string) As string
		  
		  // Returns the portion of the input string that comes before
		  // the first occurrence of target, or if target does not occur,
		  // an empty string.
		  
		  return s.NthField(target, 1)
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function beginsWithAny(extends s as String, ParamArray StringsToBeFound as String) As boolean
		  if s="" then Return false
		  
		  for each CurFindString as string in StringsToBeFound
		    if s.beginswith(CurFindString) then Return true
		  next
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function beginsWithDigit(extends s as String) As boolean
		  Return s.BeginsWithAny("0","1","2","3","4","5","6","7","8","9")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function coalesce(paramarray strings as String) As String
		  for each curvalue as string in strings
		    if curvalue<>"" then Return curvalue
		  next
		  
		  Return ""
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsAll(extends s as String, ParamArray StringsToBeFound as String) As boolean
		  for each CurFindString as string in StringsToBeFound
		    if s.contains(CurFindString)=false then Return false
		  next
		  
		  Return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsAny(extends s as String, StringsToBeFound() as String) As boolean
		  If s="" Then Return False
		  
		  For Each CurFindString As String In StringsToBeFound
		    If s.contains(CurFindString) Then 
		      Return True
		    end if
		  next
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsAny(extends s as String, ParamArray StringsToBeFound as String) As boolean
		  For Each CurFindString As String In StringsToBeFound
		    if s.contains(CurFindString) then Return true
		  next
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsCapitalLetters(extends FullString as String) As Boolean
		  Var letters() As String=FullString.Split("")
		  For Each curLetter As String In letters
		    If Asc(curLetter)>=65 And Asc(curLetter)<=90 Then Return True
		  Next
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsDigits(extends FullString as String) As Boolean
		  Var letters() As String=FullString.Split("")
		  For Each curLetter As String In letters
		    Dim asciiValue As Integer=Asc(curLetter)
		    If asciiValue>=48 And asciiValue<=57 Then Return True
		  Next
		  
		  //19=57
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsSmallLetters(extends FullString as String) As Boolean
		  Var letters() As String=FullString.Split("")
		  For Each curLetter As String In letters
		    If Asc(curLetter)>=97 And Asc(curLetter)<=122 Then Return True
		  Next
		  
		  //122="z"
		  
		  Return false
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function containsUmlaut(extends FullString as String) As Boolean
		  Var letters() as string=FullString.Split("")
		  
		  Return letters.IndexOf("ä")<>-1 OR letters.IndexOf("ö")<>-1 OR letters.IndexOf("ü")<>-1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function DefineEncodingByReadingBOM(extends s as String) As String
		  const EncodingUnknown=0
		  const EncodingUTF8=1
		  const EncodingUTF16be=3
		  const EncodingUTF16le=4
		  const EncodingUTF32be=6
		  const EncodingUTF32le=7
		  
		  select case DetectUnicodeMarkersMBS(s)
		  case EncodingUTF8
		    Return DefineEncoding(s,Encodings.UTF8)
		  case EncodingUTF16be
		    Return DefineEncoding(s,Encodings.UTF16BE)
		  case EncodingUTF16le
		    Return DefineEncoding(s,Encodings.UTF16le)
		  case EncodingUTF32be
		    Return DefineEncoding(s,Encodings.UTF32be)
		  case EncodingUTF32le
		    Return DefineEncoding(s,Encodings.UTF32le)
		  case EncodingUnknown
		    if s.contains("PRODID:Microsoft Exchange") and (Encodings.UTF8.IsValidData(s)=false) then
		      Return DefineEncoding(s,Encodings.ISOLatin1)//getestet, hat immerhin mal funktioniert
		    else
		      Return DefineEncoding(s,Encodings.UTF8)
		    end if
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getFirstRow(extends s as String) As String
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  if s="" then Return s
		  Var Rows() as string=Split(s,EndOfLine)
		  
		  Return rows(0)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getHeightInPixel(extends s as string, textfont as string, textHeight as integer, wrapwidth as Integer) As Integer
		  Var p As New Picture(1,1)
		  Var g As Graphics=p.Graphics
		  g.TextFont = textfont//"Helvetica" deactivated, as it seems to generate fontconfig errors on the server
		  g.TextSize = textHeight
		  
		  Dim height As Integer
		  height = g.TextHeight(s, wrapwidth)
		  
		  Return height
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getLastPart(extends FullString as String, delimiter as string) As string
		  Var parts() As String=FullString.Split(delimiter)
		  
		  If parts.Count>0 Then
		    Return parts(parts.count-1)
		  Else
		    Return ""
		  end
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getNumberOfOccurances(extends s as string, stringToFind as string) As Integer
		  Var result As Integer
		  Var parts() As String=Split(s,stringToFind)
		  Return parts.Count
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getWidthInPixel(extends s as string, font as string = "System", size as integer = 0, bold as Boolean = false) As integer
		  #Pragma DisableBoundsChecking
		  #Pragma NilObjectChecking False
		  #Pragma StackOverflowChecking False
		  
		  Var p as picture
		  Var g as graphics
		  
		  p=new picture(1,1,1)
		  g=p.graphics
		  g.FontName=Font
		  g.TextSize=if(size=0,kDefaultFontSize,size)
		  g.Bold=bold
		  
		  Return g.StringWidth(s)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function hexPad(s as string) As string
		  // takes a string and pads it if necessary
		  // used with colorToString
		  // makes F into 0F, etc.
		  
		  if len(s) = 2 then return s
		  return "0"+s
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAnyOf(extends s as string, tests() as string) As boolean
		  // Returns true if the input string is any
		  // of the strings in the tests array.
		  
		  Return tests.indexof(s)<>-1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsAnyOf(extends s as string, paramArray tests as string) As boolean
		  // Returns true if the input string is any
		  // of the strings in the tests array.
		  
		  Return tests.indexof(s)<>-1
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsASCIILetter(extends s as string) As Boolean
		  #if DebugBuild
		    if len(s)<>1 then
		      break
		    end if
		  #endif
		  
		  Return instr("abcdefghijklmnopqrstuvwx",s)>0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDigit(extends s as string) As Boolean
		  #if DebugBuild
		    if len(s)<>1 then
		      break
		    end if
		  #endif
		  
		  Return instr("0123456789",s)>0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsDoubleQuoted(extends s as String) As boolean
		  Return s.BeginsWith("""") AND s.EndsWith("""") AND s<>"'"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0, CompatibilityFlags = API1Only or true
		Function IsEmpty(extends s as String) As Boolean
		  Return lenb(s)=0
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsQuoted(extends s as String) As boolean
		  Return s.BeginsWith("'") AND s.EndsWith("'") AND s<>"'"
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsUppercase(extends Key as String) As Boolean
		  Return (ASC(Key)>64 AND ASC(key)<91)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function IsValidFontName(extends FontNameToCheck as String) As Boolean
		  If FontNameToCheck.IsAnyOf("system","systemsmall") then Return true
		  
		  Var i,n as Integer
		  n=FontCount-1
		  For i=0 to n
		    If Font(i)=FontNameToCheck Then
		      Return True
		      Exit
		    End If
		  Next
		  
		  Return False
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function looksLikeDate(extends s as string, checkwithParseDate as boolean = false) As Boolean
		  //allow "1.1.2000","01.1.2000" and 01.01.2000"
		  
		  if checkwithParseDate=false then
		    Var t as text=s.ToText
		    if ubound(t.Split("."))<>2 then Return false
		    Return (lenb(s)=10 OR lenb(s)=9 OR lenb(s)=8) AND s.BeginsWith("00")=False
		  else
		    Var d As datetime
		    Try
		      d=DateTime.FromString(s)
		    Catch err As RuntimeException
		      Return False
		    End 
		    Return d isa DateTime
		  end if
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function looksLikeHTML(extends s as String) As Boolean
		  Return s.ContainsAny("<br>","nbsp","<p>","<b>","<style","&amp;","<a href")
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function looksLikeInteger(extends s as string) As Boolean
		  if s="" then return false
		  
		  Var allChars() as string=split(s,"")
		  
		  for each curChar as string in allChars
		    if curChar.IsDigit=false and curChar="." =false then Return false
		  next
		  
		  Return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function looksLikeNumber(extends s as string) As Boolean
		  Var allChars() as string=split(trim(s),"")
		  
		  for each curChar as string in allChars
		    if curChar.IsDigit=false and curChar="." =false and curChar=","=false then Return false
		  next
		  
		  Return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function looksLikeTime(extends s as string) As Boolean
		  Var Timeparts() as String=s.Split(":")
		  if UBound(Timeparts)<>1 and UBound(Timeparts)<>2 then Return False
		  Var Hourvalue as Integer=val(trim(Timeparts(0)))
		  If Hourvalue<0 or Hourvalue>23 then Return false
		  
		  Var Minutevalue as Integer=val(trim(Timeparts(1)))
		  If Minutevalue<0 or Minutevalue>59 then Return false
		  
		  Return true
		End Function
	#tag EndMethod


	#tag Property, Flags = &h1
		Protected HTMLEscapeDict As Dictionary
	#tag EndProperty


	#tag Constant, Name = kDefaultFontSize, Type = Double, Dynamic = False, Default = \"14", Scope = Public
	#tag EndConstant


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Module
#tag EndModule
