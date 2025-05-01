#tag Class
Protected Class ControlDescriptor
	#tag Method, Flags = &h0
		Sub Constructor(fieldName as string, value as variant, controltype as cc_FormControl.controlTypes = cc_FormControl.controlTypes.noControl, label as string = "", valuesToChooseFrom() as string = Nil)
		  Me.fieldName=fieldName
		  Me.value=value
		  Me.label=label
		  Me.valuesToChooseFrom=valuesToChooseFrom
		  Var curValuesToChooseFromAreSupplied As Boolean=(Me.valuesToChooseFrom Is Nil)=False
		  If controlType<>cc_FormControl.controlTypes.NoControl Then
		    Me.controlType=controlType
		  Else
		    me.controlType=Me.inferControlTypeFromValueType(VarType(value),curValuesToChooseFromAreSupplied)
		  End If
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Shared Function createControl(cc as ControlDescriptor) As cc_FormControl
		  Var curControl As cc_FormControl
		  Var controlLabel As String
		  Var controlType As cc_FormControl.controlTypes
		  
		  
		  If cc.label<>"" Then
		    controlLabel=cc.label
		  Else
		    controlLabel=cc.fieldName
		  End If
		  
		  
		  Select Case cc.controlType
		  Case cc_FormControl.controlTypes.TextArea
		    curControl= New cc_textArea(cc.fieldName,controlLabel,cc.Value.StringValue)
		  Case cc_FormControl.controlTypes.TextField 
		    curControl= New cc_textfield(cc.fieldName,controlLabel,cc.Value.StringValue)
		  Case cc_FormControl.controlTypes.NumberField 
		    curControl= New cc_numberfield(cc.fieldName,controlLabel,cc.Value.IntegerValue)
		  Case cc_FormControl.controlTypes.PhoneField 
		    curControl= New cc_Phonefield(cc.fieldName,controlLabel,cc.Value.StringValue)
		  Case cc_FormControl.controlTypes.emailField 
		    curControl= New cc_emailfield(cc.fieldName,controlLabel,cc.Value.StringValue)
		  Case cc_FormControl.controlTypes.CheckBox 
		    curControl=New cc_CheckBox(cc.fieldName,controlLabel,cc.Value.BooleanValue)
		  Case cc_FormControl.controlTypes.DatePicker  
		    curControl=New cc_DatePicker(cc.fieldName,controlLabel,cc.Value.DateTimeValue)
		  Case cc_FormControl.controlTypes.PopupMenu 
		    curControl=New cc_PopupMenu(cc.fieldName,controlLabel,cc.ValuesToChooseFrom,cc.Value.StringValue)
		  Case cc_FormControl.controlTypes.RadioButtonGroup 
		    curControl=New cc_RadioButtonGroup(cc.fieldName,controlLabel,cc.ValuesToChooseFrom,cc.Value.StringValue)
		  Case cc_FormControl.controlTypes.Listbox 
		    curControl=New cc_Listbox(cc.fieldName,controlLabel,cc.ValuesToChooseFrom,cc.Value.StringValue)
		  Else
		    Break
		  End select
		  
		  curControl.LockLeft=True
		  curControl.LockTop=True
		  
		  Return curControl
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function inferControlTypeFromValueType(curValueType as integer, curValuesToChooseFromAreSupplied as Boolean) As cc_FormControl.controlTypes
		  Var controlType As cc_FormControl.controlTypes
		  
		  If (curValueType=Variant.TypeString And curValuesToChooseFromAreSupplied=False) Then
		    controlType=cc_FormControl.controlTypes.TextField
		  ElseIf curValueType=Variant.TypeInteger Or curValueType=Variant.TypeInt64 Then
		    controlType=cc_FormControl.controlTypes.NumberField
		  ElseIf curValueType=Variant.TypeBoolean Then
		    controlType=cc_FormControl.controlTypes.CheckBox
		  ElseIf curValueType=Variant.TypeDateTime Then
		    controlType=cc_FormControl.controlTypes.DatePicker
		  ElseIf curValuesToChooseFromAreSupplied Then
		    controlType=cc_FormControl.controlTypes.PopupMenu
		  End If
		  
		  Return controlType
		  
		  
		End Function
	#tag EndMethod


	#tag Property, Flags = &h0
		controltype As cc_FormControl.controlTypes
	#tag EndProperty

	#tag Property, Flags = &h0
		fieldName As string
	#tag EndProperty

	#tag Property, Flags = &h0
		label As string
	#tag EndProperty

	#tag Property, Flags = &h0
		value As variant
	#tag EndProperty

	#tag Property, Flags = &h0
		valuesToChooseFrom() As string
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
		#tag ViewProperty
			Name="fieldName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
		#tag ViewProperty
			Name="controltype"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="cc_FormControl.controlTypes"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="label"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
