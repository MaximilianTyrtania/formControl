#tag Class
Protected Class ControlDescriptorSelection
Inherits dictionary
	#tag Method, Flags = &h0
		Function createControls() As cc_FormControl()
		  Var result() As cc_FormControl
		  Var curControl As cc_FormControl
		  
		  For Each curControlDescriptor As controlDescriptor In controlDescriptorSelection.Values
		    curControl=ControlDescriptor.createControl(curControlDescriptor)
		    If curControl Is Nil Then Continue
		    result.Add(curControl)
		  Next
		  Return result
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Function getControlDescriptor(fieldName as string) As controlDescriptor
		  return me.Lookup(fieldName,nil)
		End Function
	#tag EndMethod


End Class
#tag EndClass
