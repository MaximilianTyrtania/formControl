#tag Module
Protected Module DB
	#tag Method, Flags = &h0
		Sub closeDBConnection(fromApp as Boolean = false)
		  //use fromApp= false if you want to close the SessionsConnection
		  
		  Var didCloseConnection As Boolean=False
		  If Session Is Nil And (fromApp=false) Then
		    Break//huh?
		    Return
		  end if
		  Var dbConnection As IQPDBConnection=getDB(False,fromApp)
		  If dbConnection IsA IQPDBConnection Then
		    dbConnection.Close
		    didCloseConnection=True
		  End If
		  Var connectionHandle As String=getConnectionHandle
		  
		  If connectionPool.HasKey(connectionHandle) Then
		    connectionPool.Remove(connectionHandle)
		    App.debugLog("dbConnection "+connectionHandle+" removed from App.connectionpool")
		  End If
		  
		  If didCloseConnection Then
		    If fromApp=False Then
		      App.debugLog("session db Connection closed.")
		      logNumberOfConnections
		    Else
		      App.debugLog("App db Connection closed.")
		    End If
		  Else
		    If fromApp=False Then
		      App.debugLog("session db Connection could not be closed.")
		    Else
		      App.debugLog("App db Connection could not be closed.")
		    End If
		  End If
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getConnectionHandle(useAppConnection as Boolean = false) As string
		  Var threadID As Integer
		  Var sessionID As String
		  Var connectionHandle As String
		  
		  If Session<>nil and useAppConnection=False Then
		    sessionID=Session.Identifier
		    connectionHandle="session:"+sessionID
		  Else
		    If App.CurrentThread Is Nil or useAppConnection Then
		      threadID=0
		    Else
		      threadID=App.CurrentThread.ThreadID
		    End If
		    connectionHandle="thread:"+threadID.ToText
		  End If
		  
		  If DebugBuild Then
		    connectionHandle=connectionHandle+":debug"
		  end
		  
		  Return connectionHandle
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getDB(createIfNil as Boolean = true, useAppConnection as Boolean = false) As IQPDBConnection
		  //the useAppConnection parameter allows for getting the Apps Db connection, even in cases where a session is available
		  //useful in cases where the sessuins db connection has already beeen closed
		  
		  Var connectionHandle As String
		  Var result As IQPDBConnection
		  
		  connectionHandle=getConnectionHandle(useAppConnection)
		  
		  If connectionPool.HasKey(connectionHandle) Then
		    result=IQPDBConnection(connectionPool.Value(connectionHandle))
		  Else
		    If createIfNil Then
		      result= getNewConnection
		      If result IsA IQPDBConnection Then
		        connectionPool.Value(connectionHandle)=result
		        logNumberOfConnections
		      Else
		        result=Nil
		      End If
		    Else 
		      Return Nil
		    End If
		  End If
		  
		  If result Is Nil Or result.ErrorMessage.BeginsWithAny("no connection to the server","server closed the connection","connection pointer") Then
		    App.debugLog("Had to create new connection, cause the old one was broken in DB.getDB")
		    result=DB.getNewConnection
		    connectionPool.Value(connectionHandle)=result
		  End If
		  
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getNewConnection() As IQPDBConnection
		  Var result As New IQPDBConnection
		  
		  If result.Connect=False Then
		    Break
		  End If
		  
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function getPreparedStatement(SQL as String, dbc as IQPDBConnection) As PostgreSQLPreparedStatement
		  Var pgps As PostgreSQLPreparedStatement
		  'If preparedStatements.HasKey(sql) Then
		  'pgps=PostgreSQLPreparedStatement(preparedStatements.Value(sql))
		  'this doesn't appear to work reliably yet, just got "statement does not exist"?!
		  'that's because the server doesn't save them - you'd have to do it on a per connection basis, 
		  'and as we are going through pgBouncer, this is too messy for prime time
		  'Else
		  pgps=dbc.Prepare(sql)//looks like this: "INSERT INTO Persons (Name, Age) VALUES ($1, $2)")
		  preparedStatements.value(sql)=pgps
		  'End If
		  
		  Return pgps
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub logNumberOfConnections()
		  Var sql As String="Select count(*) from pg_stat_activity"
		  Var Rs As RowSet=SelectSQL(sql,true,true)
		  If rs IsA RowSet Then
		    App.debugLog("number of dbconnections is now "+rs.columnAt(0).IntegerValue.ToText)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function saveBinaryData(extends db as IQPDBConnection, f as FolderItem) As Integer
		  If f.IsFolder Then
		    system.DebugLog(f.DisplayName+" ist ein Ordner und keine Datei, bitte wähle eine Datei aus.")
		    Return 0
		  End If
		  Var ReadStream As BinaryStream
		  Try
		    ReadStream = BinaryStream.Open(f, False)
		  Catch err As IOException
		    system.DebugLog("Konnte die Datei nicht öffnen, der Support wurde informiert.")
		  End
		  If ReadStream<>Nil Then
		    Var m As New memoryblock(ReadStream.length)
		    
		    m.stringvalue(0,m.size) = ReadStream.read(m.size)
		    ReadStream.close
		    
		    Return db.saveBinaryData(m)
		  Else
		    Return 0
		  End If
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function saveBinaryData(extends db as IQPDBConnection, mb as MemoryBlock) As Integer
		  Try
		    db.SQLExecute("BEGIN TRANSACTION")
		  Catch err As databaseexception
		    system.DebugLog("couldn't start transaction: " + db.ErrorMessage)
		    Return 0
		  End
		  
		  // create a large object
		  Var oid As Integer
		  Try
		    oid = db.CreateLargeObject
		  Catch err As databaseexception
		    System.DebugLog("couldn't create large object: " + db.ErrorMessage)
		    App.debugLog(db.errormessage)
		    Return 0
		  End
		  
		  // any errors after this point will result in an exception being thrown
		  // so that we can be sure to delete the large object we just created
		  // open the large object
		  Var lo As PostgreSQLLargeObject
		  Try
		    lo = db.OpenLargeObject(oid)
		  Catch err As DatabaseException
		    system.DebugLog("couldn't open large object " + Str(oid) + ": " + db.ErrorMessage)
		    App.debugLog(db.errormessage)
		    db.SQLExecute("ROLLBACK")
		    Return 0
		  End
		  
		  Var blobstring As String
		  Try
		    blobstring=mb.StringValue(0,mb.Size)
		  Catch err As OutOfBoundsException
		    system.DebugLog("couldn't read blob " + Str(oid) + " - out of bound exception! mb.size is "+Str(mb.Size))
		    db.SQLExecute("ROLLBACK")
		    Return 0
		  End
		  
		  Try
		    lo.Write(blobstring)
		  Catch err As DatabaseException
		    system.DebugLog("couldn't write blobstring to large object " + db.ErrorMessage)
		    App.debugLog(db.errormessage)
		    db.SQLExecute("ROLLBACK")
		    Return 0
		  End
		  
		  Try
		    db.SQLExecute("END TRANSACTION")
		  Catch err As DatabaseException
		    system.DebugLog(db.ErrorMessage)
		    App.debugLog(db.errormessage)
		    db.SQLExecute("ROLLBACK")
		    Return 0
		  End
		  
		  
		  Return oid
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function saveBinaryData(f as FolderItem) As Integer
		  Var db As IQPDBConnection=getDB
		  If db Is Nil Then 
		    Return 0
		  End
		  Return db.saveBinaryData(f)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function saveBinaryData(mb as MemoryBlock) As Integer
		  Var db As IQPDBConnection=getDB
		  If db Is Nil Then 
		    Return 0
		  End
		  Return db.saveBinaryData(mb)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectSQL(SQL as String, createIfNil as boolean = true, useAppConnection as boolean = False) As RowSet
		  Var db As IQPDBConnection=getDB(createIfNil,useAppConnection)
		  
		  If db Is Nil Then
		    If createIfNil Then 
		      App.debugLog("got no db connection!")
		    end if
		    Return Nil
		  End If
		  Var result As RowSet
		  Try
		    result= db.SelectSQL(sql)
		  Catch err As DatabaseException
		    If err.Message.beginsWithAny("server closed the connection","connection pointer is null") And db.mTriedToReconnect=False Then
		      db.Close
		      If db.Connect Then
		        db.mTriedToReconnect=True
		        Return db.SelectSQL(sql)
		      Else
		        App.debuglog("couldn't reconnect connection")
		      End If
		    Else
		      break
		    end if
		  End
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SelectSQLPreparedStatement(PreparedSQL as String, ParamArray values as Variant) As RowSet
		  Var db As IQPDBConnection=getDB
		  if db is nil then
		    break
		    Return nil
		  end
		  Var pgps As PostgreSQLPreparedStatement=getPreparedStatement(PreparedSQL,db)
		  
		  Var i as integer
		  for each curValue as variant in values
		    Var vt as integer=curValue.type
		    if curValue.IsNull then
		      pgps.Bind(i, nil)
		    else
		      select case vt
		      case Variant.TypeString
		        pgps.Bind(i, curValue.stringvalue)
		      case Variant.TypeInteger
		        pgps.Bind(i, curValue.Integervalue)
		      case Variant.TypeDate
		        pgps.Bind(i, curValue.datevalue)
		      case Variant.TypeInt64
		        pgps.Bind(i, curValue.Int64Value)
		      case Variant.TypeBoolean
		        pgps.Bind(i, curValue.BooleanValue)
		      Case Variant.TypeText
		        pgps.Bind(i, curValue.TextValue)
		      Case Variant.TypeDateTime
		        pgps.Bind(i, curValue.DateTimeValue)
		      else
		        //please support
		        Break
		        pgps.Bind(i, curValue)
		      end
		    end if
		    i=i+1
		  Next
		  Var rs As RowSet
		  Try
		    rs =pgps.SelectSQL
		  Catch err As databaseexception
		    Break
		    Return Nil
		  End
		  
		  Return rs
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLExecute(SQL as String, ParamArray values() as Variant) As Boolean
		  Var db As IQPDBConnection=getDB
		  If db Is Nil Then Return False
		  Try
		    db.ExecuteSQL(sql,values)//we're using the API 2.0 way here
		  Catch err As databaseexception
		    Break
		    Return False
		  End
		  Return True
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLExecutePreparedStatement(PreparedSQL as String,paramarray values as Variant) As Boolean
		  Var valueArray() As Variant
		  
		  For Each curValue As Variant In values
		    valueArray.Append curValue
		  Next
		  
		  Return SQLExecutePreparedStatementWithValueArray(PreparedSQL,valueArray)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLExecutePreparedStatementWithValueArray(PreparedSQL as String,values() as Variant) As Boolean
		  Var db As IQPDBConnection=getDB
		  if db is nil then Return false
		  Var now As dateTime=DateTime.now()
		  
		  Var pgps As PostgreSQLPreparedStatement=getPreparedStatement(PreparedSQL,db)
		  
		  Var i as integer
		  for each curValue as variant in values
		    Var vt as integer=curValue.type
		    if curValue.IsNull then
		      pgps.Bind(i, nil)
		    else
		      select case vt
		      case Variant.TypeString
		        If curValue.stringvalue="" Then
		          pgps.Bind(i, Nil)
		        Else
		          pgps.Bind(i, curValue.stringvalue)
		        End If
		      case Variant.TypeInteger
		        pgps.Bind(i, curValue.Integervalue)
		      Case Variant.TypeDate
		        pgps.Bind(i, curValue.datevalue)
		      Case Variant.TypeDateTime
		        pgps.Bind(i, curValue.DateTimeValue)
		      case Variant.TypeObject//probably a xojo.core.date
		        if curValue isa xojo.Core.Date then
		          Var dateAsInParamArray as xojo.Core.Date=xojo.Core.Date(curValue)
		          Var d As dateTime=new DateTime(dateAsInParamArray.Year,dateAsInParamArray.month,dateAsInParamArray.Day,dateAsInParamArray.Hour,dateAsInParamArray.Minute,dateAsInParamArray.Second)
		          //don't know how else to do this, binding the curvalue directly gives syntax error
		          pgps.Bind(i, d)
		        Else
		          App.debugLog(" unknown type in SQLExecutePreparedStatement at i="+i.ToText)
		          break//what's this?
		        end if
		      case Variant.TypeBoolean
		        pgps.Bind(i, curValue.BooleanValue)
		      case Variant.TypeInt64
		        pgps.Bind(i, curValue.int64Value)
		      case Variant.TypeText
		        pgps.Bind(i, curValue.TextValue)
		      Else
		        pgps.Bind(i, curValue)//maybe this works, it is supposed to...
		        //it appears to be working with datetimes
		      end
		    end if
		    i=i+1
		  next
		  
		  Try
		    pgps.SQLExecute
		  Catch err As DatabaseException
		    Break
		    Return False
		  End
		  
		  Return true
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLInsert(tableName as string, values as Dictionary) As Integer
		  Var dbc As IQPDBConnection=getDB
		  If dbc Is Nil Then Return -1
		  Var valueParts() As String
		  Var fieldNames() As String
		  Var valuesAsVariants() As Variant
		  Var sql As String="Insert into "+tableName+"( "
		  For i As Integer=0 To values.Count-1
		    Var curKey As Variant=values.Key(i)
		    Var curFieldName As String=curKey.StringValue
		    Var curValue As Variant=values.Value(curKey)
		    fieldNames.Append(curFieldName)
		    If curFieldName="passwordhash" Then
		      valueParts.Append("crypt($"+Str(i+1)+", gen_salt('md5'))")
		    Else
		      valueParts.Append("$"+Str(i+1))
		    End If
		    valuesAsVariants.Append curValue
		  Next
		  
		  
		  SQL=SQL+Join(fieldNames,",")+") values ("+join(valueParts,",")+") returning id"
		  Var Rs As RowSet
		  Try
		    Rs=dbc.SelectSQL(sql,valuesAsVariants)//we're using the API 2.0 way here
		  Catch err As DatabaseException
		    Break
		    Return -1
		  End
		  
		  Return rs.columnAt(0).IntegerValue//returns new id
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLUpdate(tableName as string, id as integer, dirtyValues as Dictionary) As Boolean
		  If dirtyValues.KeyCount=0 Then 
		    Return True//nothing to do
		  End If
		  
		  Var dbc As IQPDBConnection=getDB
		  Var valuesAsVariants() As Variant
		  If dbc Is Nil Then Return False
		  
		  Var fieldNameParts() As String
		  Var sql As String="UPDATE "+tableName+" set "
		  For i As Integer=0 To dirtyValues.Count-1
		    Var curKey As Variant=dirtyValues.Key(i)
		    Var curFieldName As String=curKey.StringValue
		    Var curValue As Variant=dirtyValues.Value(curKey)
		    If curFieldName="passwordhash" Then
		      fieldNameParts.Append(curFieldName+"=crypt($"+Str(i+1)+", gen_salt('md5'))")
		    Else
		      fieldNameParts.Append(curFieldName+"=$"+Str(i+1))
		    End If
		    If curFieldName.EndsWith("_id") And curValue=0 Then
		      valuesAsVariants.Append Nil
		      Dim bp As Boolean//please fix
		    Else
		      valuesAsVariants.Append curValue
		    End If
		  Next
		  SQL=SQL+Join(fieldNameParts,",")+" where id="+id.ToText
		  
		  Try
		    dbc.ExecuteSQL(SQL,valuesAsVariants)
		  Catch err As DatabaseException
		    break
		    Return False
		  End
		  Return True
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function SQLUpdate_old(tableName as string, id as integer, values as Dictionary, usePreparedStatement as boolean = true) As Boolean
		  '//usePreparedStatement=False not yet supported
		  'If usePreparedStatement=False Then
		  'Break
		  'Return False
		  'End If
		  '
		  'Var dbc As IQPDBConnection=getDB
		  'If dbc Is Nil Then Return False
		  'Var valueParts() As String
		  'Var sql As String="UPDATE "+tableName+" set "
		  'For i As Integer=0 To values.Count-1
		  'Var curFieldName As String=values.Key(i).StringValue
		  'If curFieldName="passwordhash" Then
		  'valueParts.Append(curFieldName+"=crypt($"+Str(i+1)+", gen_salt('md5'))")
		  'Else
		  'valueParts.Append(curFieldName+"=$"+Str(i+1))
		  'End If
		  'Next
		  'SQL=SQL+Join(valueParts,",")+" where id="+id.ToText
		  'Var pgps As PostgreSQLPreparedStatement
		  ''If preparedStatements.HasKey(sql) Then
		  ''pgps=PostgreSQLPreparedStatement(preparedStatements.Value(sql))
		  ''this doesn't appear to work reliably yet, just got "statement does not exist"?!
		  ''that's because the server doesn't save them - you'd have to do it on a per connection basis, 
		  ''and as we are going through pgBouncer, this is too messy for prime time
		  ''Else
		  'pgps=dbc.Prepare(sql)
		  '
		  'Var i as integer
		  'For Each curValue As Variant In values.Values
		  'Var vt as integer=curValue.type
		  'if curValue.IsNull then
		  'pgps.Bind(i, nil)
		  'else
		  'select case vt
		  'Case Variant.TypeString
		  'If curValue.stringvalue="" Then
		  'pgps.Bind(i, Nil)
		  'Else
		  'pgps.Bind(i, curValue.stringvalue)
		  'End If
		  'case Variant.TypeInteger
		  'pgps.Bind(i, curValue.Integervalue)
		  'case Variant.TypeDate
		  'pgps.Bind(i, curValue.datevalue)
		  'case Variant.TypeObject//probably a xojo.core.date
		  'If curValue IsA xojo.Core.Date Then
		  'Var dateAsInParamArray as xojo.Core.Date=xojo.Core.Date(curValue)
		  'Var d As dateTime=new DateTime(dateAsInParamArray.Year,dateAsInParamArray.month,dateAsInParamArray.Day,dateAsInParamArray.Hour,dateAsInParamArray.Minute,dateAsInParamArray.Second)
		  '//don't know how else to do this, binding the curvalue directly gives syntax error
		  'pgps.Bind(i, d)
		  'else
		  'App.debugLog(" unknown type in SQLExecutePreparedStatement at i="+i.ToText)
		  'break//what's this?
		  'end if
		  'case Variant.TypeBoolean
		  'pgps.Bind(i, curValue.BooleanValue)
		  'case Variant.TypeInt64
		  'pgps.Bind(i, curValue.int64Value)
		  'Case Variant.TypeText
		  'pgps.Bind(i, curValue.TextValue)
		  'else
		  '//please support
		  'App.debugLog(" unknown type in SQLExecutePreparedStatement at i="+i.ToText)
		  'break
		  'pgps.Bind(i, curValue)//maybe this works, it is supposed to...
		  'end
		  'end if
		  'i=i+1
		  'next
		  '
		  'Try
		  'pgps.SQLExecute
		  'Catch err As DatabaseException
		  'dbc.handleError("SQLExecutePreparedStatement")
		  'Return False
		  'End
		  'Return True
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mConnectionPool Is Nil Then
			    mConnectionPool=New Dictionary
			  End If
			  
			  Return mConnectionPool
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //
			End Set
		#tag EndSetter
		connectionPool As Dictionary
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		mConnectionPool As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		mPreparedStatements As Dictionary
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  If mPreparedStatements Is Nil Then
			    mPreparedStatements=New Dictionary
			  End If
			  
			  Return mPreparedStatements
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  //
			End Set
		#tag EndSetter
		preparedStatements As Dictionary
	#tag EndComputedProperty


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
