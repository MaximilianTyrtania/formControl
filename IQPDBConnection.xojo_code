#tag Class
Protected Class IQPDBConnection
Inherits PostgresqlDatabase
	#tag Event
		Sub ReceivedNotification(aName as String, aPid as Integer, aExtra as String)
		  
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Constructor()
		  Me.UserName="inquaplaner"
		  Me.host="inqua-planer.de"
		  Me.DatabaseName="inquaplaner_db"//"IQP2"
		  Me.Port=5432
		  Me.SSLMode=Me.SSLRequire
		  
		  If Session<>Nil Then
		    Me.AppName="INQUA-Client"//+Session.UserName macht beim connection-Pool nicht viel Sinn, man sieht dann immer nur den Namen des zuletzt Eingeloggten
		  Else
		    Me.AppName="INQUA-App"//+Session.UserName macht beim connection-Pool nicht viel Sinn, man sieht dann immer nur den Namen des zuletzt Eingeloggten
		  End If
		  Me.Password="Iagalcik65"
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub listenToClientChanges()
		  Try 
		    Me.SQLExecute("listen client_insert")
		    Me.SQLExecute("listen client_update")
		    Me.SQLExecute("listen client_delete")
		    Me.notificationChecker=New Timer
		    me.notificationChecker.Period=250//4 times a second
		  Catch err As databaseexception
		    Break
		  End
		End Sub
	#tag EndMethod


	#tag Property, Flags = &h0
		mTriedToReconnect As Boolean = false
	#tag EndProperty

	#tag Property, Flags = &h0
		notificationChecker As Timer
	#tag EndProperty


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
			InitialValue=""
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
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Port"
			Visible=true
			Group=""
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLMode"
			Visible=true
			Group=""
			InitialValue=""
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLCertificate"
			Visible=true
			Group=""
			InitialValue=""
			Type="FolderItem"
			EditorType="FolderItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLKey"
			Visible=true
			Group=""
			InitialValue=""
			Type="FolderItem"
			EditorType="FolderItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="SSLAuthority"
			Visible=true
			Group=""
			InitialValue=""
			Type="FolderItem"
			EditorType="FolderItem"
		#tag EndViewProperty
		#tag ViewProperty
			Name="MultiThreaded"
			Visible=true
			Group=""
			InitialValue=""
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="AppName"
			Visible=true
			Group=""
			InitialValue=""
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="mTriedToReconnect"
			Visible=false
			Group="Behavior"
			InitialValue="false"
			Type="Boolean"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
