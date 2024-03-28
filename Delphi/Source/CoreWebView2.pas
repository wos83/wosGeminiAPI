unit CoreWebView2;

interface

uses Winapi.Windows, System.Classes, System.Variants, System.Win.StdVCL,
     Vcl.Graphics, Winapi.ActiveX, Winapi.WebView2;

const
  IID_ICoreWebView2_4: TGUID = '{20D02D59-6DF2-42DC-BD06-F98A694B1302}';
  COREWEBVIEW2_DOWNLOAD_STATE_IN_PROGRESS = $00000000;
  COREWEBVIEW2_DOWNLOAD_STATE_INTERRUPTED = $00000001;
  COREWEBVIEW2_DOWNLOAD_STATE_COMPLETED = $00000002;

type
  COREWEBVIEW2_COOKIE_SAME_SITE_KIND = TOleEnum;
  COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND = TOleEnum;
  COREWEBVIEW2_DOWNLOAD_STATE = TOleEnum;
  COREWEBVIEW2_DOWNLOAD_INTERRUPT_REASON = TOleEnum;

  ICoreWebView2Frame = interface;
  ICoreWebView2DownloadOperation = interface;


// *********************************************************************//
// Interface: ICoreWebView2WebResourceResponseViewGetContentCompletedHandler
// Flags:     (0)
// GUID:      {875738E1-9FA2-40E3-8B74-2E8972DD6FE7}
// *********************************************************************//
  ICoreWebView2WebResourceResponseViewGetContentCompletedHandler = interface(IUnknown)
    ['{875738E1-9FA2-40E3-8B74-2E8972DD6FE7}']
    function Invoke(errorCode: HResult; const Content: IStream): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2WebResourceResponseView
// Flags:     (0)
// GUID:      {79701053-7759-4162-8F7D-F1B3F084928D}
// *********************************************************************//
  ICoreWebView2WebResourceResponseView = interface(IUnknown)
    ['{79701053-7759-4162-8F7D-F1B3F084928D}']
    function Get_Headers(out Headers: ICoreWebView2HttpResponseHeaders): HResult; stdcall;
    function Get_StatusCode(out StatusCode: SYSINT): HResult; stdcall;
    function Get_ReasonPhrase(out ReasonPhrase: PWideChar): HResult; stdcall;
    function GetContent(const handler: ICoreWebView2WebResourceResponseViewGetContentCompletedHandler): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2WebResourceResponseReceivedEventArgs
// Flags:     (0)
// GUID:      {D1DB483D-6796-4B8B-80FC-13712BB716F4}
// *********************************************************************//
  ICoreWebView2WebResourceResponseReceivedEventArgs = interface(IUnknown)
    ['{D1DB483D-6796-4B8B-80FC-13712BB716F4}']
    function Get_Request(out Request: ICoreWebView2WebResourceRequest): HResult; stdcall;
    function Get_Response(out Response: ICoreWebView2WebResourceResponseView): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2WebResourceResponseReceivedEventHandler
// Flags:     (0)
// GUID:      {7DE9898A-24F5-40C3-A2DE-D4F458E69828}
// *********************************************************************//
  ICoreWebView2WebResourceResponseReceivedEventHandler = interface(IUnknown)
    ['{7DE9898A-24F5-40C3-A2DE-D4F458E69828}']
    function Invoke(const sender: ICoreWebView2;
                    const args: ICoreWebView2WebResourceResponseReceivedEventArgs): HResult; stdcall;
  end;


// *********************************************************************//
// Interface: ICoreWebView2DOMContentLoadedEventArgs
// Flags:     (0)
// GUID:      {16B1E21A-C503-44F2-84C9-70ABA5031283}
// *********************************************************************//
  ICoreWebView2DOMContentLoadedEventArgs = interface(IUnknown)
    ['{16B1E21A-C503-44F2-84C9-70ABA5031283}']
    function Get_NavigationId(out NavigationId: Largeuint): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2DOMContentLoadedEventHandler
// Flags:     (0)
// GUID:      {4BAC7E9C-199E-49ED-87ED-249303ACF019}
// *********************************************************************//
  ICoreWebView2DOMContentLoadedEventHandler = interface(IUnknown)
    ['{4BAC7E9C-199E-49ED-87ED-249303ACF019}']
    function Invoke(const sender: ICoreWebView2; const args: ICoreWebView2DOMContentLoadedEventArgs): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2Cookie
// Flags:     (0)
// GUID:      {AD26D6BE-1486-43E6-BF87-A2034006CA21}
// *********************************************************************//
  ICoreWebView2Cookie = interface(IUnknown)
    ['{AD26D6BE-1486-43E6-BF87-A2034006CA21}']
    function Get_name(out name: PWideChar): HResult; stdcall;
    function Get_value(out value: PWideChar): HResult; stdcall;
    function Set_value(value: PWideChar): HResult; stdcall;
    function Get_Domain(out Domain: PWideChar): HResult; stdcall;
    function Get_Path(out Path: PWideChar): HResult; stdcall;
    function Get_Expires(out Expires: Double): HResult; stdcall;
    function Set_Expires(Expires: Double): HResult; stdcall;
    function Get_IsHttpOnly(out IsHttpOnly: Integer): HResult; stdcall;
    function Set_IsHttpOnly(IsHttpOnly: Integer): HResult; stdcall;
    function Get_SameSite(out SameSite: COREWEBVIEW2_COOKIE_SAME_SITE_KIND): HResult; stdcall;
    function Set_SameSite(SameSite: COREWEBVIEW2_COOKIE_SAME_SITE_KIND): HResult; stdcall;
    function Get_IsSecure(out IsSecure: Integer): HResult; stdcall;
    function Set_IsSecure(IsSecure: Integer): HResult; stdcall;
    function Get_IsSession(out IsSession: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2CookieList
// Flags:     (0)
// GUID:      {F7F6F714-5D2A-43C6-9503-346ECE02D186}
// *********************************************************************//
  ICoreWebView2CookieList = interface(IUnknown)
    ['{F7F6F714-5D2A-43C6-9503-346ECE02D186}']
    function Get_Count(out Count: SYSUINT): HResult; stdcall;
    function GetValueAtIndex(index: SYSUINT; out cookie: ICoreWebView2Cookie): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2GetCookiesCompletedHandler
// Flags:     (0)
// GUID:      {5A4F5069-5C15-47C3-8646-F4DE1C116670}
// *********************************************************************//
  ICoreWebView2GetCookiesCompletedHandler = interface(IUnknown)
    ['{5A4F5069-5C15-47C3-8646-F4DE1C116670}']
    function Invoke(result: HResult; const cookieList: ICoreWebView2CookieList): HResult; stdcall;
  end;


// *********************************************************************//
// Interface: ICoreWebView2CookieManager
// Flags:     (0)
// GUID:      {177CD9E7-B6F5-451A-94A0-5D7A3A4C4141}
// *********************************************************************//
  ICoreWebView2CookieManager = interface(IUnknown)
    ['{177CD9E7-B6F5-451A-94A0-5D7A3A4C4141}']
    function CreateCookie(name: PWideChar; value: PWideChar; Domain: PWideChar; Path: PWideChar;
                          out cookie: ICoreWebView2Cookie): HResult; stdcall;
    function CopyCookie(const cookieParam: ICoreWebView2Cookie; out cookie: ICoreWebView2Cookie): HResult; stdcall;
    function GetCookies(uri: PWideChar; const handler: ICoreWebView2GetCookiesCompletedHandler): HResult; stdcall;
    function AddOrUpdateCookie(const cookie: ICoreWebView2Cookie): HResult; stdcall;
    function DeleteCookie(const cookie: ICoreWebView2Cookie): HResult; stdcall;
    function DeleteCookies(name: PWideChar; uri: PWideChar): HResult; stdcall;
    function DeleteCookiesWithDomainAndPath(name: PWideChar; Domain: PWideChar; Path: PWideChar): HResult; stdcall;
    function DeleteAllCookies: HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2_2
// Flags:     (0)
// GUID:      {9E8F0CF8-E670-4B5E-B2BC-73E061E3184C}
// *********************************************************************//
  ICoreWebView2_2 = interface(ICoreWebView2)
    ['{9E8F0CF8-E670-4B5E-B2BC-73E061E3184C}']
    function add_WebResourceResponseReceived(const eventHandler: ICoreWebView2WebResourceResponseReceivedEventHandler;
                                             out token: EventRegistrationToken): HResult; stdcall;
    function remove_WebResourceResponseReceived(token: EventRegistrationToken): HResult; stdcall;
    function NavigateWithWebResourceRequest(const Request: ICoreWebView2WebResourceRequest): HResult; stdcall;
    function add_DOMContentLoaded(const eventHandler: ICoreWebView2DOMContentLoadedEventHandler;
                                  out token: EventRegistrationToken): HResult; stdcall;
    function remove_DOMContentLoaded(token: EventRegistrationToken): HResult; stdcall;
    function Get_CookieManager(out CookieManager: ICoreWebView2CookieManager): HResult; stdcall;
    function Get_Environment(out Environment: ICoreWebView2Environment): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2TrySuspendCompletedHandler
// Flags:     (0)
// GUID:      {00F206A7-9D17-4605-91F6-4E8E4DE192E3}
// *********************************************************************//
  ICoreWebView2TrySuspendCompletedHandler = interface(IUnknown)
    ['{00F206A7-9D17-4605-91F6-4E8E4DE192E3}']
    function Invoke(errorCode: HResult; isSuccessful: Integer): HResult; stdcall;
  end;


// *********************************************************************//
// Interface: ICoreWebView2_3
// Flags:     (0)
// GUID:      {A0D6DF20-3B92-416D-AA0C-437A9C727857}
// *********************************************************************//
  ICoreWebView2_3 = interface(ICoreWebView2_2)
    ['{A0D6DF20-3B92-416D-AA0C-437A9C727857}']
    function TrySuspend(const handler: ICoreWebView2TrySuspendCompletedHandler): HResult; stdcall;
    function Resume: HResult; stdcall;
    function Get_IsSuspended(out IsSuspended: Integer): HResult; stdcall;
    function SetVirtualHostNameToFolderMapping(hostName: PWideChar; folderPath: PWideChar;
                                               accessKind: COREWEBVIEW2_HOST_RESOURCE_ACCESS_KIND): HResult; stdcall;
    function ClearVirtualHostNameToFolderMapping(hostName: PWideChar): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2FrameNameChangedEventHandler
// Flags:     (0)
// GUID:      {435C7DC8-9BAA-11EB-A8B3-0242AC130003}
// *********************************************************************//
  ICoreWebView2FrameNameChangedEventHandler = interface(IUnknown)
    ['{435C7DC8-9BAA-11EB-A8B3-0242AC130003}']
    function Invoke(const sender: ICoreWebView2Frame; const args: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2FrameDestroyedEventHandler
// Flags:     (0)
// GUID:      {59DD7B4C-9BAA-11EB-A8B3-0242AC130003}
// *********************************************************************//
  ICoreWebView2FrameDestroyedEventHandler = interface(IUnknown)
    ['{59DD7B4C-9BAA-11EB-A8B3-0242AC130003}']
    function Invoke(const sender: ICoreWebView2Frame; const args: IUnknown): HResult; stdcall;
  end;


// *********************************************************************//
// Interface: ICoreWebView2Frame
// Flags:     (0)
// GUID:      {F1131A5E-9BA9-11EB-A8B3-0242AC130003}
// *********************************************************************//
  ICoreWebView2Frame = interface(IUnknown)
    ['{F1131A5E-9BA9-11EB-A8B3-0242AC130003}']
    function Get_name(out name: PWideChar): HResult; stdcall;
    function add_NameChanged(const eventHandler: ICoreWebView2FrameNameChangedEventHandler;
                             out token: EventRegistrationToken): HResult; stdcall;
    function remove_NameChanged(token: EventRegistrationToken): HResult; stdcall;
    function AddHostObjectToScriptWithOrigins(name: PWideChar; const object_: OleVariant;
                                              originsCount: SYSUINT; var origins: PWideChar): HResult; stdcall;
    function RemoveHostObjectFromScript(name: PWideChar): HResult; stdcall;
    function add_Destroyed(const eventHandler: ICoreWebView2FrameDestroyedEventHandler;
                           out token: EventRegistrationToken): HResult; stdcall;
    function remove_Destroyed(token: EventRegistrationToken): HResult; stdcall;
    function IsDestroyed(out destroyed: Integer): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2FrameCreatedEventArgs
// Flags:     (0)
// GUID:      {4D6E7B5E-9BAA-11EB-A8B3-0242AC130003}
// *********************************************************************//
  ICoreWebView2FrameCreatedEventArgs = interface(IUnknown)
    ['{4D6E7B5E-9BAA-11EB-A8B3-0242AC130003}']
    function Get_Frame(out Frame: ICoreWebView2Frame): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2FrameCreatedEventHandler
// Flags:     (0)
// GUID:      {38059770-9BAA-11EB-A8B3-0242AC130003}
// *********************************************************************//
  ICoreWebView2FrameCreatedEventHandler = interface(IUnknown)
    ['{38059770-9BAA-11EB-A8B3-0242AC130003}']
    function Invoke(const sender: ICoreWebView2; const args: ICoreWebView2FrameCreatedEventArgs): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2BytesReceivedChangedEventHandler
// Flags:     (0)
// GUID:      {828E8AB6-D94C-4264-9CEF-5217170D6251}
// *********************************************************************//
  ICoreWebView2BytesReceivedChangedEventHandler = interface(IUnknown)
    ['{828E8AB6-D94C-4264-9CEF-5217170D6251}']
    function Invoke(const sender: ICoreWebView2DownloadOperation; const args: IUnknown): HResult; stdcall;
  end;


// *********************************************************************//
// Interface: ICoreWebView2EstimatedEndTimeChangedEventHandler
// Flags:     (0)
// GUID:      {28F0D425-93FE-4E63-9F8D-2AEEC6D3BA1E}
// *********************************************************************//
  ICoreWebView2EstimatedEndTimeChangedEventHandler = interface(IUnknown)
    ['{28F0D425-93FE-4E63-9F8D-2AEEC6D3BA1E}']
    function Invoke(const sender: ICoreWebView2DownloadOperation; const args: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2StateChangedEventHandler
// Flags:     (0)
// GUID:      {81336594-7EDE-4BA9-BF71-ACF0A95B58DD}
// *********************************************************************//
  ICoreWebView2StateChangedEventHandler = interface(IUnknown)
    ['{81336594-7EDE-4BA9-BF71-ACF0A95B58DD}']
    function Invoke(const sender: ICoreWebView2DownloadOperation; const args: IUnknown): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2DownloadOperation
// Flags:     (0)
// GUID:      {3D6B6CF2-AFE1-44C7-A995-C65117714336}
// *********************************************************************//
  ICoreWebView2DownloadOperation = interface(IUnknown)
    ['{3D6B6CF2-AFE1-44C7-A995-C65117714336}']
    function add_BytesReceivedChanged(const eventHandler: ICoreWebView2BytesReceivedChangedEventHandler;
                                      out token: EventRegistrationToken): HResult; stdcall;
    function remove_BytesReceivedChanged(token: EventRegistrationToken): HResult; stdcall;
    function add_EstimatedEndTimeChanged(const eventHandler: ICoreWebView2EstimatedEndTimeChangedEventHandler;
                                         out token: EventRegistrationToken): HResult; stdcall;
    function remove_EstimatedEndTimeChanged(token: EventRegistrationToken): HResult; stdcall;
    function add_StateChanged(const eventHandler: ICoreWebView2StateChangedEventHandler;
                              out token: EventRegistrationToken): HResult; stdcall;
    function remove_StateChanged(token: EventRegistrationToken): HResult; stdcall;
    function Get_uri(out uri: PWideChar): HResult; stdcall;
    function Get_ContentDisposition(out ContentDisposition: PWideChar): HResult; stdcall;
    function Get_MimeType(out MimeType: PWideChar): HResult; stdcall;
    function Get_TotalBytesToReceive(out TotalBytesToReceive: Int64): HResult; stdcall;
    function Get_BytesReceived(out BytesReceived: Int64): HResult; stdcall;
    function Get_EstimatedEndTime(out EstimatedEndTime: PWideChar): HResult; stdcall;
    function Get_ResultFilePath(out ResultFilePath: PWideChar): HResult; stdcall;
    function Get_State(out downloadState: COREWEBVIEW2_DOWNLOAD_STATE): HResult; stdcall;
    function Get_InterruptReason(out InterruptReason: COREWEBVIEW2_DOWNLOAD_INTERRUPT_REASON): HResult; stdcall;
    function Cancel: HResult; stdcall;
    function Pause: HResult; stdcall;
    function Resume: HResult; stdcall;
    function Get_CanResume(out CanResume: Integer): HResult; stdcall;
  end;



// *********************************************************************//
// Interface: ICoreWebView2DownloadStartingEventArgs
// Flags:     (0)
// GUID:      {E99BBE21-43E9-4544-A732-282764EAFA60}
// *********************************************************************//
  ICoreWebView2DownloadStartingEventArgs = interface(IUnknown)
    ['{E99BBE21-43E9-4544-A732-282764EAFA60}']
    function Get_DownloadOperation(out DownloadOperation: ICoreWebView2DownloadOperation): HResult; stdcall;
    function Get_Cancel(out Cancel: Integer): HResult; stdcall;
    function Set_Cancel(Cancel: Integer): HResult; stdcall;
    function Get_ResultFilePath(out ResultFilePath: PWideChar): HResult; stdcall;
    function Set_ResultFilePath(ResultFilePath: PWideChar): HResult; stdcall;
    function Get_Handled(out Handled: Integer): HResult; stdcall;
    function Set_Handled(Handled: Integer): HResult; stdcall;
    function GetDeferral(out deferral: ICoreWebView2Deferral): HResult; stdcall;
  end;

  TCoreWebView2DownloadStartingEventArgs = class(TInterfacedObject, ICoreWebView2DownloadStartingEventArgs)
  private
    FArgsInterface: ICoreWebView2DownloadStartingEventArgs;
  public
    constructor Create(const Args: ICoreWebView2DownloadStartingEventArgs);
    property ArgsInterface: ICoreWebView2DownloadStartingEventArgs
      read FArgsInterface implements ICoreWebView2DownloadStartingEventArgs;
  end;

//  TCoreWebView2DownloadStartingEvents = procedure (Sender: TCustomEdgeBrowser; Args: TCoreWebView2DownloadStartingEventArgs) of object;


// *********************************************************************//
// Interface: ICoreWebView2DownloadStartingEventHandler
// Flags:     (0)
// GUID:      {EFEDC989-C396-41CA-83F7-07F845A55724}
// *********************************************************************//
  ICoreWebView2DownloadStartingEventHandler = interface(IUnknown)
    ['{EFEDC989-C396-41CA-83F7-07F845A55724}']
    function Invoke(const sender: ICoreWebView2; const args: ICoreWebView2DownloadStartingEventArgs): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: ICoreWebView2_4
// Flags:     (0)
// GUID:      {20D02D59-6DF2-42DC-BD06-F98A694B1302}
// *********************************************************************//
  ICoreWebView2_4 = interface(ICoreWebView2_3)
    ['{20D02D59-6DF2-42DC-BD06-F98A694B1302}']
    function add_FrameCreated(const eventHandler: ICoreWebView2FrameCreatedEventHandler;
                              out token: EventRegistrationToken): HResult; stdcall;
    function remove_FrameCreated(token: EventRegistrationToken): HResult; stdcall;
    function add_DownloadStarting(const eventHandler: ICoreWebView2DownloadStartingEventHandler;
                                  out token: EventRegistrationToken): HResult; stdcall;
    function remove_DownloadStarting(token: EventRegistrationToken): HResult; stdcall;
  end;

  GWSCallback<T1, T2> = record
    type
      TStdProc1 = reference to function(const P1: T1): HResult stdcall;
      TStdProc2 = reference to function(const P1: T1; const P2: T2): HResult stdcall;
      TStdProc3 = reference to function(P1: T1; P2: T2): HResult stdcall;
      TStdMethod1 = function(P1: T1): HResult of object stdcall;
      TStdMethod2 = function(P1: T1; const P2: T2): HResult of object stdcall;
    class function CreateAs<INTF>(P: TStdProc1): INTF; overload; static;
    class function CreateAs<INTF>(P: TStdProc2): INTF; overload; static;
    class function CreateAs<INTF>(P: TStdProc3): INTF; overload; static;
    class function CreateAs<INTF>(P: TStdMethod1): INTF; overload; static;
    class function CreateAs<INTF>(P: TStdMethod2): INTF; overload; static;
  end;


implementation


class function GWSCallback<T1, T2>.CreateAs<INTF>(P: TStdProc1): INTF;
type
  PIntf = ^INTF;
begin
  Result := PIntf(@P)^;
end;

class function GWSCallback<T1, T2>.CreateAs<INTF>(P: TStdProc2): INTF;
type
  PIntf = ^INTF;
begin
  Result := PIntf(@P)^;
end;

class function GWSCallback<T1, T2>.CreateAs<INTF>(P: TStdProc3): INTF;
type
  PIntf = ^INTF;
begin
  Result := PIntf(@P)^;
end;

class function GWSCallback<T1, T2>.CreateAs<INTF>(P: TStdMethod1): INTF;
begin
  Result := CreateAs<INTF>(
    function(const P1: T1): HResult stdcall
    begin
      Result := P(P1)
    end);
end;

class function GWSCallback<T1, T2>.CreateAs<INTF>(P: TStdMethod2): INTF;
begin
  Result := CreateAs<INTF>(
    function(const P1: T1; const P2: T2): HResult stdcall
    begin
      Result := P(P1, P2)
    end);
end;

{ TCoreWebView2DownloadStartingEventArgs }

constructor TCoreWebView2DownloadStartingEventArgs.Create(
  const Args: ICoreWebView2DownloadStartingEventArgs);
begin
  FArgsInterface := Args;
end;

end.
