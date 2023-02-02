#tag Class
Protected Class App
Inherits WebApplication
	#tag Method, Flags = &h0
		Sub debuglog(msg as string)
		  Var now As DateTime=DateTime.Now
		  system.debugLog(msg)
		End Sub
	#tag EndMethod


	#tag ViewBehavior
	#tag EndViewBehavior
End Class
#tag EndClass
