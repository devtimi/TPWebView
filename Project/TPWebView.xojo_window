#tag DesktopWindow
Begin DesktopContainer TPWebView
   AllowAutoDeactivate=   True
   AllowFocus      =   False
   AllowFocusRing  =   False
   AllowTabs       =   True
   Backdrop        =   0
   BackgroundColor =   &cFFFFFF
   Composited      =   False
   Enabled         =   True
   HasBackgroundColor=   False
   Height          =   100
   Index           =   -2147483648
   InitialParent   =   ""
   Left            =   0
   LockBottom      =   False
   LockLeft        =   True
   LockRight       =   False
   LockTop         =   True
   TabIndex        =   0
   TabPanelIndex   =   0
   TabStop         =   True
   Tooltip         =   ""
   Top             =   0
   Transparent     =   False
   Visible         =   True
   Width           =   100
   Begin DesktopXAMLContainer ctlWinWebView
      Active          =   False
      AllowAutoDeactivate=   True
      Content         =   "<winui:WebView2 Name=""WebViewAlpha"">\n</winui:WebView2>"
      Enabled         =   True
      Height          =   98
      Index           =   -2147483648
      InitialParent   =   ""
      Left            =   1
      LockBottom      =   True
      LockedInPosition=   False
      LockLeft        =   True
      LockRight       =   True
      LockTop         =   True
      PanelIndex      =   0
      Scope           =   2
      TabIndex        =   1
      TabPanelIndex   =   0
      TabStop         =   True
      Tooltip         =   ""
      Top             =   1
      Transparent     =   False
      Visible         =   True
      Width           =   98
      _mIndex         =   0
      _mInitialParent =   ""
      _mName          =   ""
      _mPanelIndex    =   0
   End
End
#tag EndDesktopWindow

#tag WindowCode
	#tag Event
		Sub Closing()
		  if moMacView <> nil then
		    RemoveHandler moMacView.CancelLoad, WeakAddressOf HandleCancelLoad
		    RemoveHandler moMacView.DocumentBegin, WeakAddressOf HandleDocumentBegin
		    RemoveHandler moMacView.DocumentComplete, WeakAddressOf HandleDocumentComplete
		    RemoveHandler moMacView.DocumentProgressChanged, WeakAddressOf HandleDocumentProgressChanged
		    RemoveHandler moMacView.FocusLost, WeakAddressOf HandleFocusLost
		    RemoveHandler moMacView.FocusReceived, WeakAddressOf HandleFocusReceived
		    RemoveHandler moMacView.JavaScriptRequest, WeakAddressOf HandleJavaScriptRequest
		    RemoveHandler moMacView.NewWindow, WeakAddressOf HandleNewWindow
		    RemoveHandler moMacView.PrintComplete, WeakAddressOf HandlePrintComplete
		    RemoveHandler moMacView.PrintError, WeakAddressOf HandlePrintError
		    RemoveHandler moMacView.SecurityChanged, WeakAddressOf HandleSecurityChanged
		    RemoveHandler moMacView.StatusChanged, WeakAddressOf HandleStatusChanged
		    RemoveHandler moMacView.TitleChanged, WeakAddressOf HandleTitleChanged
		    
		    moMacView.Close
		    moMacView = nil
		    
		  end
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusLost()
		  // Implemented to allow for Event Defintion
		  // Sent from platform specific viewer control
		End Sub
	#tag EndEvent

	#tag Event
		Sub FocusReceived()
		  // Implemented to allow for Event Defintion
		  // Sent from platform specific viewer control
		End Sub
	#tag EndEvent

	#tag Event
		Sub Opening()
		  #if TargetMacOS or TargetLinux then
		    // Close XAML control
		    ctlWinWebView.Close
		    
		    // Set up Mac viewer
		    moMacView = new DesktopHTMLViewer
		    moMacView.Top = 1
		    moMacView.Left = 1
		    moMacView.Width = self.Width - 2
		    moMacView.Height = self.Height - 2
		    
		    AddHandler moMacView.CancelLoad, WeakAddressOf HandleCancelLoad
		    AddHandler moMacView.DocumentBegin, WeakAddressOf HandleDocumentBegin
		    AddHandler moMacView.DocumentComplete, WeakAddressOf HandleDocumentComplete
		    AddHandler moMacView.DocumentProgressChanged, WeakAddressOf HandleDocumentProgressChanged
		    AddHandler moMacView.FocusLost, WeakAddressOf HandleFocusLost
		    AddHandler moMacView.FocusReceived, WeakAddressOf HandleFocusReceived
		    AddHandler moMacView.JavaScriptRequest, WeakAddressOf HandleJavaScriptRequest
		    AddHandler moMacView.NewWindow, WeakAddressOf HandleNewWindow
		    AddHandler moMacView.PrintComplete, WeakAddressOf HandlePrintComplete
		    AddHandler moMacView.PrintError, WeakAddressOf HandlePrintError
		    AddHandler moMacView.SecurityChanged, WeakAddressOf HandleSecurityChanged
		    AddHandler moMacView.StatusChanged, WeakAddressOf HandleStatusChanged
		    AddHandler moMacView.TitleChanged, WeakAddressOf HandleTitleChanged
		    
		    moMacView.LockLeft = true
		    moMacView.LockRight = true
		    moMacView.LockTop = true
		    moMacView.LockBottom = true
		    
		    // Make available
		    me.AddControl(moMacView)
		    mbIsAvailable = true
		    
		    // Can now set a custom UserAgent
		    if msUserAgent <> "" then
		      moMacView.UserAgent = msUserAgent
		      
		    end
		    
		  #elseif TargetWindows then
		    
		  #endif
		  
		  RaiseEvent Opening
		End Sub
	#tag EndEvent

	#tag Event
		Sub Paint(g As Graphics, areas() As Rect)
		  #pragma unused areas
		  
		  // Draw border
		  if mbHasBorder then
		    #if TargetMacOS then
		      g.DrawingColor = MacTertiaryLabelColor
		      
		      if MacShouldIncreaseContrast = false then
		        g.DrawingColor = Color.RGB(g.DrawingColor.Red, g.DrawingColor.Green, g.DrawingColor.Blue, 216)
		        
		      end
		      
		    #else
		      g.DrawingColor = if(Color.IsDarkMode, &c535353, &ca0a0a0)
		      
		    #endif
		    
		    g.DrawRectangle(0, 0, g.Width, g.Height)
		    
		  end
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h0
		Sub Cancel()
		  #if TargetMacOS or TargetLinux then
		    moMacView.Cancel
		    
		  #elseif TargetWindows then
		    ctlWinWebView.Invoke("WebViewAlpha.Stop")
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub Error(oSender As DesktopHTMLViewer, error As RuntimeException)
		  #pragma unused oSender
		  RaiseEvent Error(error)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ExecuteJavaScript(js as String)
		  #if TargetMacOS or TargetLinux then
		    moMacView.ExecuteJavaScript(js)
		    
		  #elseif TargetWindows then
		    ctlWinWebView.Invoke("WebViewAlpha.ExecuteScriptAsync", js)
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GoBack()
		  #if TargetMacOS or TargetLinux then
		    moMacView.GoBack
		    
		  #elseif TargetWindows then
		    ctlWinWebView.Invoke("WebViewAlpha.GoBack")
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub GoForward()
		  #if TargetMacOS or TargetLinux then
		    moMacView.GoForward
		    
		  #elseif TargetWindows then
		    ctlWinWebView.Invoke("WebViewAlpha.GoForward")
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleCancelLoad(oSender as DesktopHTMLViewer, URL as String) As Boolean
		  #pragma unused oSender
		  return RaiseEvent CancelLoad(URL)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleDocumentBegin(oSender as DesktopHTMLViewer, url as String)
		  #pragma unused oSender
		  RaiseEvent DocumentBegin(url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleDocumentComplete(oSender as DesktopHTMLViewer, url as String)
		  #pragma unused oSender
		  RaiseEvent DocumentComplete(url)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleDocumentProgressChanged(oSender as DesktopHTMLViewer, URL as String, percentageComplete as Integer)
		  #pragma unused oSender
		  RaiseEvent DocumentProgressChanged(URL, percentageComplete)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleFocusLost(oSender as DesktopHTMLViewer)
		  #pragma unused oSender
		  RaiseEvent FocusLost
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleFocusReceived(oSender as DesktopHTMLViewer)
		  #pragma unused oSender
		  RaiseEvent FocusReceived
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleJavaScriptRequest(oSender as DesktopHTMLViewer, method as String, parameters() as Variant) As String
		  #pragma unused oSender
		  return RaiseEvent JavaScriptRequest(method, parameters)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function HandleNewWindow(oSender as DesktopHTMLViewer, url as String) As DesktopHTMLViewer
		  #pragma unused oSender
		  return RaiseEvent NewWindow(url)
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandlePrintComplete(oSender as DesktopHTMLViewer)
		  #pragma unused oSender
		  RaiseEvent PrintComplete
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandlePrintError(oSender As DesktopHTMLViewer, error As RuntimeException)
		  #pragma unused oSender
		  RaiseEvent PrintError(error)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleSecurityChanged(oSender as DesktopHTMLViewer, isSecure as Boolean)
		  #pragma unused oSender
		  RaiseEvent SecurityChanged(isSecure)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleStatusChanged(oSender as DesktopHTMLViewer, newStatus as String)
		  #pragma unused oSender
		  RaiseEvent StatusChanged(newStatus)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Sub HandleTitleChanged(oSender as DesktopHTMLViewer, newTitle as String)
		  #pragma unused oSender
		  RaiseEvent TitleChanged(newTitle)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadPage(source As String, base As FolderItem)
		  #if TargetMacOS or TargetLinux then
		    moMacView.LoadPage(source, base)
		    
		  #elseif TargetWindows then
		    #pragma unused base
		    ctlWinWebView.Invoke("WebViewAlpha.NavigateToString", source)
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub LoadURL(URL as String)
		  #if TargetMacOS or TargetLinux then
		    moMacView.LoadURL(URL)
		    
		  #elseif TargetWindows then
		    ctlWinWebView.Invoke("WebViewAlpha.Navigate", URL)
		    
		  #endif
		  
		  msLoadedURL = URL
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MacShouldIncreaseContrast() As Boolean
		  #if TargetMacOS then
		    declare function NSClassFromString lib "Foundation" (clsName As CFStringRef) As Ptr
		    declare function sharedWorkspace lib "AppKit" selector "sharedWorkspace" (cls As Ptr) As Ptr
		    declare function accessibilityDisplayShouldIncreaseContrast lib "AppKit" selector _
		    "accessibilityDisplayShouldIncreaseContrast" (ws As Ptr) As Boolean
		    
		    var nsWorkspaceClass as Ptr = NSClassFromString("NSWorkspace")
		    var workspace as Ptr = sharedWorkspace(nsWorkspaceClass)
		    
		    return accessibilityDisplayShouldIncreaseContrast(workspace)
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function MacTertiaryLabelColor() As Color
		  #if TargetMacOS then
		    declare function NSClassFromString lib "Foundation" (clsName as CFStringRef) as Ptr
		    declare function tertiaryLabelColor lib "AppKit" selector "tertiaryLabelColor" (cls as Ptr) as Ptr
		    declare function colorUsingColorSpaceName lib "AppKit" selector "colorUsingColorSpaceName:" (color as Ptr, colorSpaceName as CFStringRef) as Ptr
		    declare function redComponent lib "AppKit" selector "redComponent" (color as Ptr) as CGFloat
		    declare function greenComponent lib "AppKit" selector "greenComponent" (color as Ptr) as CGFloat
		    declare function blueComponent lib "AppKit" selector "blueComponent" (color as Ptr) as CGFloat
		    declare function alphaComponent lib "AppKit" selector "alphaComponent" (color as Ptr) as CGFloat
		    
		    const NSCalibratedRGBColorSpace as String = "NSCalibratedRGBColorSpace"
		    
		    var nsColorClass as Ptr = NSClassFromString("NSColor")
		    var origColor as Ptr = tertiaryLabelColor(nsColorClass)
		    if origColor = nil then return Color.Black
		    
		    // Convert to RGB color space
		    var rgbColor as Ptr = colorUsingColorSpaceName(origColor, NSCalibratedRGBColorSpace)
		    if rgbColor = nil then return Color.Black
		    
		    // Now safe to extract components
		    var r as Double = redComponent(rgbColor)
		    var g as Double = greenComponent(rgbColor)
		    var b as Double = blueComponent(rgbColor)
		    var a as Double = alphaComponent(rgbColor)
		    
		    return Color.RGBA(r * 255, g * 255, b * 255, a * 255)
		    
		  #endif
		End Function
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Print(showPrintDialog As Boolean = True)
		  #if TargetMacOS or TargetLinux then
		    moMacView.Print(showPrintDialog)
		    
		  #elseif TargetWindows then
		    // I did not implement this, I never use HTMLViewer.Print
		    // ctlWinWebView.Invoke("WebViewAlpha.PrintToPdfAsync", filePath as String)
		    break
		    
		  #endif
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Reload()
		  #if TargetMacOS or TargetLinux then
		    moMacView.LoadURL(msLoadedURL)
		    
		  #elseif TargetWindows then
		    ctlWinWebView.Invoke("WebViewAlpha.Reload")
		    
		  #endif
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event CancelLoad(URL as String) As Boolean
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Closing()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DocumentBegin(url as String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DocumentComplete(url as String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event DocumentProgressChanged(URL as String, percentageComplete as Integer)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Error(error As RuntimeException)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FocusLost()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event FocusReceived()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event JavaScriptRequest(method As String, parameters() as Variant) As String
	#tag EndHook

	#tag Hook, Flags = &h0
		Event NewWindow(url as String) As DesktopHTMLViewer
	#tag EndHook

	#tag Hook, Flags = &h0
		Event Opening()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PrintComplete()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event PrintError(error As RuntimeException)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event SecurityChanged(isSecure As Boolean)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event StatusChanged(newStatus as String)
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TitleChanged(newTitle as String)
	#tag EndHook


	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mbHasBorder
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  mbHasBorder = value
			  self.Refresh
			End Set
		#tag EndSetter
		HasBorder As Boolean
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetMacOS or TargetLinux then
			    return moMacView.IsAvailable
			    
			  #elseif TargetWindows then
			    return mbIsAvailable
			    
			  #endif
			End Get
		#tag EndGetter
		IsAvailable As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private mbHasBorder As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private mbIsAvailable As Boolean
	#tag EndProperty

	#tag Property, Flags = &h21
		Private moMacView As DesktopHTMLViewer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private msLoadedURL As String
	#tag EndProperty

	#tag Property, Flags = &h21
		Private msUserAgent As String
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  #if TargetMacOS or TargetLinux then
			    return moMacView.UserAgent
			    
			  #elseif TargetWindows then
			    if mbIsAvailable then return ctlWinWebView.UserAgent
			    return msUserAgent
			    
			  #endif
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  msUserAgent = value
			  
			  #if TargetMacOS or TargetLinux then
			    if mbIsAvailable then moMacView.UserAgent = value
			    
			  #elseif TargetWindows then
			    if mbIsAvailable then ctlWinWebView.UserAgent = msUserAgent
			    
			  #endif
			End Set
		#tag EndSetter
		UserAgent As String
	#tag EndComputedProperty


#tag EndWindowCode

#tag Events ctlWinWebView
	#tag Event
		Sub EventTriggered(eventName As String, parameters As Dictionary)
		  select case eventName
		  case "DocumentTitleChanged"
		    RaiseEvent TitleChanged(parameters.Lookup("DocumentTitle", ""))
		    
		  case "FocusReceived"
		    // Push the focus back to the window
		    self.SetFocus
		    
		  case "FocusLost"
		    RaiseEvent FocusLost
		    
		  case "Initialized"
		    mbIsAvailable = true
		    
		    // Can now set a custom UserAgent
		    if msUserAgent <> "" then
		      ctlWinWebView.UserAgent = msUserAgent
		      
		    end
		    
		  case "PointerPressed"
		    RaiseEvent FocusReceived
		    
		  case  "NavigationStarting"
		    msLoadedURL = parameters.Lookup("URI", "")
		    RaiseEvent DocumentBegin(msLoadedURL)
		    
		  case "NavigationCompleted"
		    RaiseEvent DocumentComplete(msLoadedURL)
		    
		  case "PrintToPdfFinished"
		    RaiseEvent PrintComplete
		    
		  case "ExecuteScriptFinished", "SourceChanged", _
		    "PointerEntered", "PointerExited", "PointerMoved", "PointerReleased"
		    // Ignore these events
		    #pragma unused parameters
		    
		  case else
		    // Log unknown events
		    #if DebugBuild then
		      System.DebugLog(eventName)
		      
		    #endif
		    
		  end select
		End Sub
	#tag EndEvent
#tag EndEvents
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
		Name="Super"
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
		Name="Width"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Height"
		Visible=true
		Group="Size"
		InitialValue="300"
		Type="Integer"
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
		Name="LockLeft"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockTop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockRight"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="LockBottom"
		Visible=true
		Group="Position"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabIndex"
		Visible=true
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabStop"
		Visible=true
		Group="Position"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowAutoDeactivate"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Enabled"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Tooltip"
		Visible=true
		Group="Appearance"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocusRing"
		Visible=true
		Group="Appearance"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBorder"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Visible"
		Visible=true
		Group="Appearance"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowFocus"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="AllowTabs"
		Visible=true
		Group="Behavior"
		InitialValue="True"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Transparent"
		Visible=true
		Group="Behavior"
		InitialValue="False"
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="IsAvailable"
		Visible=false
		Group="Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="UserAgent"
		Visible=true
		Group="Behavior"
		InitialValue=""
		Type="String"
		EditorType="MultiLineEditor"
	#tag EndViewProperty
	#tag ViewProperty
		Name="BackgroundColor"
		Visible=false
		Group="Background"
		InitialValue=""
		Type="ColorGroup"
		EditorType="ColorGroup"
	#tag EndViewProperty
	#tag ViewProperty
		Name="Backdrop"
		Visible=false
		Group="Background"
		InitialValue=""
		Type="Picture"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="HasBackgroundColor"
		Visible=false
		Group="Background"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="Composited"
		Visible=false
		Group="Window Behavior"
		InitialValue=""
		Type="Boolean"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="InitialParent"
		Visible=false
		Group="Position"
		InitialValue=""
		Type="String"
		EditorType=""
	#tag EndViewProperty
	#tag ViewProperty
		Name="TabPanelIndex"
		Visible=false
		Group="Position"
		InitialValue="0"
		Type="Integer"
		EditorType=""
	#tag EndViewProperty
#tag EndViewBehavior
