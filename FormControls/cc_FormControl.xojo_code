#tag Class
Protected Class cc_FormControl
Inherits webcontainer
	#tag Method, Flags = &h1
		Protected Sub Constructor(fieldname as string, label as String, value as Variant)
		  // Calling the overridden superclass constructor.
		  // Note that this may need modifications if there are multiple constructor choices.
		  // Possible constructor calls:
		  // Constructor() -- From WebView
		  // Constructor() -- From WebUIControl
		  // Constructor() -- From WebControl
		  Super.Constructor
		  //can't assign to name property for some reason so we have to create our own namefield
		  me.Style=style_default
		  Me.getFieldControl.Style=style_default
		  me.getLabelControl.Style=style_default
		  Me.fieldName=fieldname
		  Me.initialValue=value
		  Me.initLabel(label)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getFieldControl() As WebUIControl
		  Return evGetFieldControl
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getLabelControl() As webLabel
		  Return evGetLabelControl
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getValue() As Variant
		  return evGetValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getWidth() As integer
		  return max(200,me.getLabelControl.Width+14+me.getFieldControl.Width)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub initLabel(label as string)
		  Me.getLabelControl.Text=label
		  Me.getLabelControl.Style=style_default
		  Me.getLabelControl.Width=label.getWidthInPixel(Me.getLabelControl.Style.FontName,Me.getLabelControl.Style.FontSize)+5
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Function isModified() As Boolean
		  Return me.initialValue<>me.getValue
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setFieldWidth(w as Integer)
		  Me.getFieldControl.Width=(w)
		  me.Width=me.getWidth
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setLabelWidth(w as Integer)
		  Me.getLabelControl.Width=w
		  Me.getFieldControl.Left=w+14
		  me.Width=me.getWidth
		End Sub
	#tag EndMethod

	#tag DelegateDeclaration, Flags = &h0
		Delegate Function validate() As Boolean
	#tag EndDelegateDeclaration

	#tag Method, Flags = &h0
		Function validate() As Boolean
		  If Me.validatorMethod Is Nil Then
		    Return True
		  Else
		    Return Me.validatorMethod.invoke()
		  end
		End Function
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event evGetFieldControl() As WebUIControl
	#tag EndHook

	#tag Hook, Flags = &h0
		Event evGetLabelControl() As webLabel
	#tag EndHook

	#tag Hook, Flags = &h0
		Event evGetValue() As Variant
	#tag EndHook


	#tag Property, Flags = &h0
		fieldName As string
	#tag EndProperty

	#tag Property, Flags = &h0
		initialValue As Variant
	#tag EndProperty

	#tag Property, Flags = &h0
		validatorMethod As validate
	#tag EndProperty


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
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
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
			Name="Height"
			Visible=true
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
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
			Name="Width"
			Visible=true
			Group="Behavior"
			InitialValue="300"
			Type="Integer"
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
			Name="fieldName"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="string"
			EditorType="MultiLineEditor"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
