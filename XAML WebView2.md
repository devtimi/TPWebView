Properties:
ActualHeight As Double (read-only)
ActualWidth As Double (read-only)
Background As Color
Class As String (read-only)
FontFamily As String
FontSize As Double
FontStyle As Integer (see Windows::UI::Xaml::Controls::FontStyle)
FontWeight As Integer (see Windows::UI::Xaml::Controls::FontWeight)
Handle As Ptr (read-only)
Height As Double
IsEnabled As Boolean
Name As String
Tag As String
Width As Double
---------------------------
DocumentTitle As String (Read-only)
Source As String (Read-only)
UserAgent As String

Methods:
CanGoBack
CanGoForward
Close
ExecuteScriptAsync(script As String) [Note: when finished check for the ExecuteScriptFinished event]
GoBack
GoForward
Navigate(url As String)
NavigateToString(htmlContent As String)
PrintToPdfAsync(filePath As String)
Reload
Stop

Events:
PointerEntered
PointerExited
PointerMoved (Keys: X As Double, Y As Double)
PointerPressed (Keys: X As Double, Y As Double, Button As String)
PointerReleased (Keys: X As Double, Y As Double, Button As String)
---------------------------
DocumentTitleChanged (Keys: DocumentTitle As String)
ExecuteScriptFinished (Keys: Result As String)
Initialized  [Note: triggered when the core WebView2 is finished constructing]
NavigationCompleted (Keys: HTTPStatusCode As Integer)
NavigationStarting (Keys: URI As String)
NewWindowRequested (Keys: [r/w]Handled As Boolean, URI As String)
  [Note: assign True to Handled to manually load the URI in a difference WebView,
       or assign False (which is the default behavior) to let the WebView control
	   load the URI in place]
PrintToPdfFinished (Keys: FilePath As String)
  [Note: if the FilePath key does not exist then something went wrong with printing]
SourceChanged [Note: triggered when navigating to a different site or fragment navigations]
