unit WebCookies;

interface

uses
   System.Classes,
   System.SysUtils,
   Vcl.Forms,
   CoreWebView2;

type
   TMyCookieHandler = class(TInterfacedObject, ICoreWebView2GetCookiesCompletedHandler)
   public
      function Invoke(errorCode: HResult; const cookieList: ICoreWebView2CookieList): HResult; stdcall;
   end;

var
   FSecure1PSID: string;
   FSecure1PSIDTS: string;
   FSecure1PSIDCC: string;

const
   cSecure1PSID = '__Secure-1PSID';
   cSecure1PSIDTS = '__Secure-1PSIDTS';
   cSecure1PSIDCC = '__Secure-1PSIDCC';

implementation

function TMyCookieHandler.Invoke(errorCode: HResult; const cookieList: ICoreWebView2CookieList): HResult;
var
   LInt: Integer;
   LCookie: ICoreWebView2Cookie;
   LCookieName: PWideChar;
   LCookieValue: PWideChar;
   LCookieCount: LongWord;
begin
   FSecure1PSID := EmptyStr;
   FSecure1PSIDTS := EmptyStr;
   FSecure1PSIDCC := EmptyStr;

   try

   cookieList.Get_Count(LCookieCount);

   for LInt := 0 to Pred(LCookieCount) do
   begin
      Application.ProcessMessages;

      cookieList.GetValueAtIndex(LInt, LCookie);

      LCookie.Get_name(LCookieName);
      LCookie.Get_value(LCookieValue);

      if (LowerCase(cSecure1PSID) = LowerCase(LCookieName)) then
         FSecure1PSID := Trim(LCookieValue);

      if (LowerCase(cSecure1PSIDTS) = LowerCase(LCookieName)) then
         FSecure1PSIDTS := Trim(LCookieValue);

      if (LowerCase(cSecure1PSIDCC) = LowerCase(LCookieName)) then
         FSecure1PSIDCC := Trim(LCookieValue);
   end;

   result := S_OK;
   finally
      Screen.Cursor := 0;
   end;
end;

end.
