#tag WebContainerControl
Begin WebContainer cc_Form
   Compatibility   =   ""
   ControlCount    =   0
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
   _mPanelIndex    =   -1
End
#tag EndWebContainerControl

#tag WindowCode
	#tag Method, Flags = &h0
		Function getValues(modifiedOnly as Boolean = false) As Dictionary
		  Var values As New Dictionary
		  For Each curControl As cc_FormControl In Me.myControls
		    If modifiedOnly=False Or curControl.IsModified Then
		      values.value(curControl.fieldName)=curControl.getValue
		    end if
		  Next
		  
		  Return values
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub init(controls() as cc_FormControl)
		  Var start As DateTime=DateTime.Now
		  Me.myControls=Controls
		  Me.setLabelandControlWidths()
		  Var endtime As DateTime=DateTime.Now
		  //Var ittook As New DateDifferenceMBS(start,endtime)
		  Var bp As Boolean //took 0.4 seconds for 85 controls on my 2,5 Ghz 2015 Macbook Pro
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub positionControls()
		  var curAvailableWidth as integer=me.Width
		  Var numberOfAvailableColumns As Integer=Floor(Me.Width/(myControls(0).Width+kMarginBetweenColumns))
		  Var numberOfControlsToPutIntoOneColumn As Integer=Ceiling(myControls.Count/numberOfAvailableColumns)
		  Var curColumnIndex As Integer
		  Var curControlIndex As Integer
		  Var curControlInColumnIndex As Integer
		  Var curTop As Integer
		  Var curLeft As Integer
		  Var curLongestLabelWidthInPixel As Integer
		  Var curLongestFieldWidthInPixel As Integer
		  
		  
		  For Each curControl As cc_FormControl In Me.myControls
		    If curControl.Parent Is Nil Then
		      curControl.EmbedWithin(Me,curLeft,curTop,curControl.Width,curControl.Height)
		    Else
		      curControl.Left=curLeft
		      curControl.top=curTop
		      curControl.setLabelWidth(curLongestLabelWidthInPixel)
		      curControl.setFieldWidth(curLongestFieldWidthInPixel)
		    End If
		    If curControlInColumnIndex=numberOfControlsToPutIntoOneColumn Then
		      curColumnIndex=curColumnIndex+1
		      curControlInColumnIndex=0
		      curTop=0
		      curLeft=curColumnIndex*(curControl.Width+kMarginBetweenColumns)
		      curLongestLabelWidthInPixel=0
		      curLongestFieldWidthInPixel=0
		    Else
		      curTop=curTop+curControl.Height+kVerticalMarginBetweenControls
		      If curControl.getLabelControl.Width>curLongestLabelWidthInPixel Then
		        curLongestLabelWidthInPixel=curControl.getLabelControl.Width
		      End If
		      If curControl.getFieldControl.Width>curLongestFieldWidthInPixel Then
		        curLongestFieldWidthInPixel=curControl.getFieldControl.Width
		      End If
		    End If
		    curControlIndex=curControlIndex+1
		    curControlInColumnIndex=curControlInColumnIndex+1
		  Next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub setLabelAndControlWidths()
		  Var curLongestLabelWidthInPixel As Integer
		  Var curLongestFieldWidthInPixel As Integer
		  
		  For Each curControl As cc_FormControl In Me.myControls
		    If curControl.getLabelControl.Width>curLongestLabelWidthInPixel Then
		      curLongestLabelWidthInPixel=curControl.getLabelControl.Width
		    End If
		    If curControl.getFieldControl.Width>curLongestFieldWidthInPixel Then
		      curLongestFieldWidthInPixel=curControl.getFieldControl.Width
		    End If
		  Next
		  
		  For Each curControl As cc_FormControl In Me.myControls
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
		  For Each curControl As cc_FormControl In Me.myControls
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
		myControls() As cc_FormControl
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


#tag EndWindowCode

#tag ViewBehavior
	#tag ViewProperty
		Name="ControlCount"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
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
