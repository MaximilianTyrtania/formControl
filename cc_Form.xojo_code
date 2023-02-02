#tag WebContainerControl
Begin WebContainer cc_Form
   Compatibility   =   ""
   ControlID       =   ""
   Enabled         =   True
   Height          =   250
   Indicator       =   0
   LayoutDirection =   0
   LayoutType      =   0
   Left            =   0
   LockBottom      =   False
   LockHorizontal  =   False
   LockLeft        =   True
   LockRight       =   False
   LockTop         =   True
   LockVertical    =   False
   ScrollDirection =   0
   TabIndex        =   0
   Top             =   0
   Visible         =   True
   Width           =   250
   _mDesignHeight  =   0
   _mDesignWidth   =   0
   _mName          =   ""
   _mPanelIndex    =   -1
End
#tag EndWebContainerControl

#tag WindowCode
	#tag Method, Flags = &h21
		Private Function getCurControl(curValueName as string, curValueType as integer, curValue as Variant) As cc_ControlWithLabel
		  Var curControl As cc_ControlWithLabel
		  Var controlLabel As String
		  Var controlType As cc_Form.controlTypes
		  Var curValuesToChooseFrom() As String
		  Var curValuesToChooseFromAreSupplied As Boolean=Me.valuesToChooseFrom IsA Dictionary And valuesToChooseFrom.HasKey(curValueName) And valuesToChooseFrom.value(curValueName).IsArray
		  Var inferControlTypeFromData As Boolean
		  
		  If Me.fieldNameMap IsA Dictionary And Me.fieldNameMap.HasKey(curValueName) Then
		    controlLabel=Me.fieldNameMap.Value(curValueName).StringValue
		  Else
		    controlLabel=curValueName
		  End If
		  
		  If Me.controlTypeMap IsA Dictionary And Me.controlTypeMap.HasKey(curValueName) Then
		    controlType=cc_Form.controlTypes(Me.controlTypeMap.Value(curValueName).IntegerValue)
		  Else
		    controlType=Me.inferControlTypeFromValueType(curValueType,curValuesToChooseFromAreSupplied)
		  End If
		  
		  If curValuesToChooseFromAreSupplied Then
		    curValuesToChooseFrom=valuesToChooseFrom.value(curValueName)
		  end if
		  
		  Select Case controlType
		  Case cc_Form.controlTypes.TextArea
		    curControl= New cc_textArea(curValueName,controlLabel,curValue.StringValue)
		  Case cc_Form.controlTypes.TextField 
		    curControl= New cc_textfield(curValueName,controlLabel,curValue.StringValue)
		  Case cc_Form.controlTypes.NumberField 
		    curControl= New cc_numberfield(curValueName,controlLabel,curValue.IntegerValue)
		  Case cc_Form.controlTypes.PhoneField 
		    curControl= New cc_Phonefield(curValueName,controlLabel,curValue.StringValue)
		  Case cc_Form.controlTypes.emailField 
		    curControl= New cc_emailfield(curValueName,controlLabel,curValue.StringValue)
		  Case cc_Form.controlTypes.CheckBox 
		    curControl=New cc_CheckBox(curValueName,controlLabel,curValue.BooleanValue)
		  Case cc_Form.controlTypes.DatePicker  
		    curControl=New cc_DatePicker(curValueName,controlLabel,curValue.DateTimeValue)
		  Case cc_Form.controlTypes.PopupMenu 
		    curControl=New cc_PopupMenu(curValueName,controlLabel,curValuesToChooseFrom,curvalue)
		  Case cc_Form.controlTypes.RadioButtonGroup 
		    curControl=New cc_RadioButtonGroup(curValueName,controlLabel,curValuesToChooseFrom,curvalue.StringValue)
		  Case cc_Form.controlTypes.Listbox 
		    curControl=New cc_Listbox(curValueName,controlLabel,curValuesToChooseFrom,curvalue.StringValue)
		  Case cc_Form.controlTypes.NoControl
		    Return Nil//for now, please provide entry in controlTypeMap
		  Else
		    Break
		  End select
		  
		  curControl.LockLeft=True
		  curControl.LockTop=True
		  
		  Return curControl
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getValues(modifiedOnly as Boolean = false) As Dictionary
		  Var values As New Dictionary
		  For Each curControl As cc_ControlWithLabel In Me.myControls
		    If modifiedOnly=False Or curControl.IsModified Then
		      values.value(curControl.fieldName)=curControl.getValue
		    end if
		  Next
		  
		  Return values
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function inferControlTypeFromValueType(curValueType as integer, curValuesToChooseFromAreSupplied as Boolean) As cc_Form.controlTypes
		  Var controlType As cc_Form.controlTypes
		  
		  If (curValueType=Variant.TypeString And curValuesToChooseFromAreSupplied=False) Then
		    controlType=cc_Form.controlTypes.TextField
		  ElseIf curValueType=Variant.TypeInteger Or curValueType=Variant.TypeInt64 Then
		    controlType=cc_Form.controlTypes.NumberField
		  ElseIf curValueType=Variant.TypeBoolean Then
		    controlType=cc_Form.controlTypes.CheckBox
		  ElseIf curValueType=Variant.TypeDateTime Then
		    controlType=cc_Form.controlTypes.DatePicker
		  ElseIf curValuesToChooseFromAreSupplied Then
		    controlType=cc_Form.controlTypes.PopupMenu
		  End If
		  
		  Return controlType
		  
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init(values as Dictionary, fieldnameMap as dictionary = nil, controlTypeMap as dictionary = Nil, valuesToChooseFrom as dictionary = Nil)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From WebView
		  // Constructor() -- From WebUIControl
		  // Constructor() -- From WebControl
		  Var start As DateTime=DateTime.Now
		  Var curValue As Variant
		  Var curValueType As Integer
		  Var curValueName As String
		  Var curTop As Integer
		  Var curControl As cc_ControlWithLabel
		  Var preferredControlType As cc_Form.controlTypes
		  If controlTypeMap IsA Dictionary Then
		    Me.controlTypeMap=controlTypeMap
		  End If
		  If fieldnameMap IsA Dictionary Then
		    Me.fieldNameMap=fieldnameMap
		  End If
		  If valuesToChooseFrom IsA Dictionary Then
		    Me.valuesToChooseFrom=valuesToChooseFrom
		  End If
		  Const kMargin=14
		  For colct As Integer=0 To values.KeyCount-1
		    curValueName=values.key(colct).StringValue
		    curValue=values.value(curValueName)
		    curValueType=curValue.Type
		    curControl=Me.getCurControl(curValueName,curValueType,curValue)
		    If curControl Is Nil Then Continue
		    Me.myControls.Add(curControl)
		  Next
		  Me.setLabelandControlWidths()
		  Var endtime As DateTime=DateTime.Now
		  Var ittook As New DateDifferenceMBS(start,endtime)
		  Var bp As Boolean //took 0.4 seconds for 85 controls
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub positionControls()
		  Var numberOfAvailableColumns As Integer=Floor(Me.Width/(myControls(0).Width+kMarginBetweenColumns))
		  Var numberOfControlsToPutIntoOneColumn As Integer=Ceiling(myControls.Count/numberOfAvailableColumns)
		  Var curColumnIndex As Integer
		  Var curControlIndex As Integer
		  Var curControlInColumnIndex As Integer
		  Var curTop As Integer
		  Var curLeft As Integer
		  
		  
		  For Each curControl As cc_ControlWithLabel In Me.myControls
		    If curControl.Parent Is Nil Then
		      curControl.EmbedWithin(Me,curLeft,curTop,curControl.Width,curControl.Height)
		    Else
		      curControl.Left=curLeft
		      curControl.top=curTop
		    End If
		    If curControlInColumnIndex=numberOfControlsToPutIntoOneColumn Then
		      curColumnIndex=curColumnIndex+1
		      curControlInColumnIndex=0
		      curTop=0
		      curLeft=curColumnIndex*(curControl.Width+kMarginBetweenColumns)
		    Else
		      curTop=curTop+curControl.Height+kVerticalMarginBetweenControls
		    End If
		    curControlIndex=curControlIndex+1
		    curControlInColumnIndex=curControlInColumnIndex+1
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setLabelandControlWidths()
		  Var curLongestLabelWidthInPixel As Integer
		  Var curLongestFieldWidthInPixel As Integer
		  
		  For Each curControl As cc_ControlWithLabel In Me.myControls
		    If curControl.getLabelControl.Width>curLongestLabelWidthInPixel Then
		      curLongestLabelWidthInPixel=curControl.getLabelControl.Width
		    End If
		    If curControl.getFieldControl.Width>curLongestFieldWidthInPixel Then
		      curLongestFieldWidthInPixel=curControl.getFieldControl.Width
		    End If
		  Next
		  
		  For Each curControl As cc_ControlWithLabel In Me.myControls
		    curControl.setLabelWidth(curLongestLabelWidthInPixel)
		    curControl.setFieldWidth(curLongestFieldWidthInPixel)
		    If curControl.getWidth>Me.Width Then
		      Me.Width=curControl.getWidth
		    End If
		  Next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function validate() As Boolean
		  For Each curControl As cc_ControlWithLabel In Me.myControls
		    If curControl.validate=False Then
		      Return False
		    End If
		  Next
		  Return True
		End Function
	#tag EndMethod


	#tag Property, Flags = &h21
		#tag Note
			cc_dyamic will display arrays As webpopup menus. If you'd rather display them as, say a radionbuttongroup or a combobox then
			
			Me.controlTypeMap.Value("cities")="radiobuttongroup"
			
			Or 
			
			Me.controlTypeMap.Value("cities")="combobox"
		#tag EndNote
		Private controlTypeMap As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			supply user friendly values like this:
			
			me.fieldNameMap.Value("company_id")="company"
		#tag EndNote
		Private fieldNameMap As Dictionary
	#tag EndProperty

	#tag Property, Flags = &h0
		myControls() As cc_ControlWithLabel
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			say you got a field named "color" And you want your users To pick one Of red,blue Or green Then you'd supply
			the valuesToChooseFrom here like this
			
			valuesToChooseFrom.value("color")=Array("red","blue","green")
			
		#tag EndNote
		Private valuesToChooseFrom As Dictionary
	#tag EndProperty


	#tag Constant, Name = kMarginBetweenColumns, Type = Double, Dynamic = False, Default = \"14", Scope = Public
	#tag EndConstant

	#tag Constant, Name = kVerticalMarginBetweenControls, Type = Double, Dynamic = False, Default = \"14", Scope = Public
	#tag EndConstant


	#tag Enum, Name = controlTypes, Type = Integer, Flags = &h0
		NoControl
		  TextField
		  TextArea
		  CheckBox
		  PopupMenu
		  DatePicker
		  RadioButtonGroup
		  NumberField
		  EMailField
		  PhoneField
		Listbox
	#tag EndEnum


#tag EndWindowCode

#tag ViewBehavior
	#tag ViewProperty
		Name="_mPanelIndex"
		Visible=false
		Group="Behavior"
		InitialValue="-1"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Name"
		Visible=true
		Group="ID"
		InitialValue=""
		Type="String"
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
	#tag ViewProperty
		Name="ControlID"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockHorizontal"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockLeft"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockVertical"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignHeight"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mDesignWidth"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="_mName"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="ScrollDirection"
		Visible=true
		Group="Behavior"
		InitialValue="ScrollDirections.None"
		Type="WebContainer.ScrollDirections"
		EditorType="Enum"
		#tag EnumValues
			"0 - None"
			"1 - Horizontal"
			"2 - Vertical"
			"3 - Both"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Visual Controls"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Indicator"
		Visible=false
		Group="Visual Controls"
		InitialValue=""
		Type="WebUIControl.Indicators"
		EditorType="Enum"
		#tag EnumValues
			"0 - Default"
			"1 - Primary"
			"2 - Secondary"
			"3 - Success"
			"4 - Danger"
			"5 - Warning"
			"6 - Info"
			"7 - Light"
			"8 - Dark"
			"9 - Link"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutType"
		Visible=true
		Group="View"
		InitialValue="LayoutTypes.Fixed"
		Type="LayoutTypes"
		EditorType="Enum"
		#tag EnumValues
			"0 - Fixed"
			"1 - Flex"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="LayoutDirection"
		Visible=true
		Group="View"
		InitialValue="LayoutDirections.LeftToRight"
		Type="LayoutDirections"
		EditorType="Enum"
		#tag EnumValues
			"0 - LeftToRight"
			"1 - RightToLeft"
			"2 - TopToBottom"
			"3 - BottomToTop"
		#tag EndEnumValues
	#tag EndViewProperty
	#tag ViewProperty
		Name="Width"
		Visible=false
		Group=""
		InitialValue="250"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=false
		Group=""
		InitialValue="250"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
