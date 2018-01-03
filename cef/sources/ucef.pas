// ************************************************************************
// ***************************** CEF4Delphi *******************************
// ************************************************************************
//
// CEF4Delphi is based on DCEF3 which uses CEF3 to embed a chromium-based
// browser in Delphi applications.
//
// The original license of DCEF3 still applies to CEF4Delphi.
//
// For more information about CEF4Delphi visit :
//         https://www.briskbard.com/index.php?lang=en&pageid=cef
//
//        Copyright ?2017 Salvador D韆z Fau. All rights reserved.
//
// ************************************************************************
// ************ vvvv Original license and comments below vvvv *************
// ************************************************************************
(*
 *                       Delphi Chromium Embedded 3
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *
 * Embarcadero Technologies, Inc is not permitted to use or redistribute
 * this source code without explicit permission.
 *
 *)

unit ucef;

{$I cef.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils,System.StrUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ShellAPI, Vcl.Menus,
  {$ELSE}
  Windows, Messages, SysUtils,StrUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,ShellAPI, Menus,
  {$ENDIF}
  uCEFChromium, uCEFWindowParent, uCEFChromiumWindow,inifiles,uCEFApp,uCEFTypes,
  uCEFConstants,uCEFLibFunctions, uCEFMiscFunctions, uCEFCommandLine, uCEFClient,
  uCEFSchemeHandlerFactory, uCEFCookieManager,uCEFBrowser,uCEFChromiumEvents,
  uCEFContextMenuHandler,uCEFInterfaces,
  uCEFBrowserProcessHandler, uCEFResourceBundleHandler, uCEFRenderProcessHandler;
const 
  NIF_INFO        = $00000010;          //气泡显示标志 
  NIIF_NONE       = $00000000;          //无图标 
  NIIF_INFO       = $00000001;          //信息图标 
  NIIF_WARNING    = $00000002;          //警告图标 
  NIIF_ERROR      = $00000003;          //错误图标 
  NIIF_USER       = $00000004;          //XP使用hIcon 
type 
  TNotifyIconDataEx = record 
    cbSize: DWORD; 
    Wnd: HWND; 
    uID: UINT; 
    uFlags: UINT; 
    uCallbackMessage: UINT; 
    hIcon: HICON; 
    szTip: array [0..127] of AnsiChar; 
    dwState: DWORD; 
    dwStateMask: DWORD; 
    szInfo: array [0..255] of AnsiChar; 
    case Integer of 
      0: ( 
        uTimeout: UINT); 
      1: (uVersion: UINT; 
        szInfoTitle: array [0..63] of AnsiChar; 
        dwInfoFlags: DWORD);  
  end;
const 
  WM_TRAYMSG = WM_USER + 101;                   //自定义托盘消息
type
  TForm1 = class(TForm)
    ChromiumWindow1: TChromiumWindow;
    Timer1: TTimer;
    Chromium1: TChromium;
    pm1: TPopupMenu;
    m_exit: TMenuItem;
   
    procedure FormDestroy(Sender: TObject); 
    procedure m_exitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ChromiumWindow1AfterCreated(Sender: TObject);
    procedure Chromium1LoadEnd(Sender: TObject; const browser: ICefBrowser;
      const frame: ICefFrame; httpStatusCode: Integer);
    procedure Chromium1BeforePopup(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
      targetFrameName: ustring;
      targetDisposition: TCefWindowOpenDisposition; userGesture: Boolean;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var client: ICefClient; var settings: TCefBrowserSettings;
      var noJavascriptAccess: Boolean; out Result: Boolean);
    procedure Chromium1ContextMenuCommand(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; commandId: Integer;
      eventFlags: Cardinal; out Result: Boolean);
    procedure Chromium1RunContextMenu(Sender: TObject;
      const browser: ICefBrowser; const frame: ICefFrame;
      const params: ICefContextMenuParams; const model: ICefMenuModel;
      const callback: ICefRunContextMenuCallback; var aResult: Boolean);

  private
    // You have to handle this two messages to call NotifyMoveOrResizeStarted or some page elements will be misaligned.
    procedure WMMove(var aMessage : TWMMove); message WM_MOVE;
    procedure WMMoving(var aMessage : TMessage); message WM_MOVING;
    // You also have to handle these two messages to set GlobalCEFApp.OsmodalLoop
    procedure WMEnterMenuLoop(var aMessage: TMessage); message WM_ENTERMENULOOP;
    procedure WMExitMenuLoop(var aMessage: TMessage); message WM_EXITMENULOOP;
    procedure WMTrayMsg(var Msg: TMessage);message WM_TRAYMSG;    //声明托盘消息
    procedure WMSysCommand(var Msg: TMessage);message WM_SYSCOMMAND;
    function GetDomain(URL:string):string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  iniConfig:TInifile;
  filename,ftitle,url,fCanResize,inject_js_url:string;
  fwidth, fheight:integer;
  NotifyIcon: TNotifyIconDataEx;                    //定义托盘图标结构体 
implementation

{$R *.dfm}

uses
  uCEFApplication;


procedure TForm1.FormShow(Sender: TObject);
begin
  if not(ChromiumWindow1.CreateBrowser) then Timer1.Enabled := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  if not(ChromiumWindow1.CreateBrowser) and not(ChromiumWindow1.Initialized) then
    Timer1.Enabled := True;
end;

procedure TForm1.WMMove(var aMessage : TWMMove);
begin
  inherited;

  if (ChromiumWindow1 <> nil) then ChromiumWindow1.NotifyMoveOrResizeStarted;
end;

procedure TForm1.WMMoving(var aMessage : TMessage);
begin
  inherited;

  if (ChromiumWindow1 <> nil) then ChromiumWindow1.NotifyMoveOrResizeStarted;
end;

procedure TForm1.WMEnterMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then
    begin
          GlobalCEFApp.FrameworkDirPath:='cef';
          GlobalCEFApp.OsmodalLoop := True;
    end
end;

procedure TForm1.WMExitMenuLoop(var aMessage: TMessage);
begin
  inherited;
  if (aMessage.wParam = 0) and (GlobalCEFApp <> nil) then GlobalCEFApp.OsmodalLoop := False;
end;

procedure TForm1.ChromiumWindow1AfterCreated(Sender: TObject);
begin
      ChromiumWindow1.ChromiumBrowser.LoadURL(url);
end;

procedure TForm1.Chromium1LoadEnd(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  httpStatusCode: Integer);
var jsCode:String;
begin
     //inject_js_url:='';
     jsCode:='var xxx___xxx="'+inject_js_url+'";var ___script___ = document.createElement("script");___script___.src = xxx___xxx;document.getElementsByTagName("head")[0].appendChild(___script___);';
    if ( inject_js_url <> '' ) and ( frame.Url <> 'about:blank') and (GetDomain(inject_js_url) <> GetDomain(frame.Url))  then
    begin
        frame.ExecuteJavaScript(jsCode,frame.Url,0);
    end;
    //ShowMessage(jsCode);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
        filename:=ExtractFilePath(Paramstr(0))+'cef_launcher.ini';
        if not(FileExists(filename)) then
        begin
            ShowMessage(filename+' not exists');
            Form1.Close;
        end;
        iniConfig:=TInifile.Create(filename);
        url:=iniConfig.ReadString('config','url','');
        inject_js_url:=iniConfig.ReadString('config','inject_js_url','');
        ftitle:=iniConfig.ReadString('config','title','');
        fheight:=iniConfig.ReadInteger('config','height',500);
        fwidth:=iniConfig.ReadInteger('config','width',800);
        fCanResize:=iniConfig.ReadString('config','resize','false');

        if fCanResize = 'false' then
        begin
          Form1.BorderIcons := [biSystemMenu,biMinimize];
          BorderStyle := bsSingle;
        end
        else
         Form1.BorderIcons :=[biSystemMenu,biMinimize,biMaximize];
         
        Width:=fwidth;
        Height:=fheight;
        
        Form1.Caption:=ftitle+' - Powered by snail007';
        //inject js for every opened url
        ChromiumWindow1.ChromiumBrowser.OnLoadEnd:=Form1.Chromium1LoadEnd;
        //control open link in popup window 
        ChromiumWindow1.ChromiumBrowser.OnBeforePopup:=Form1.Chromium1BeforePopup;
        //control right click menu item click
        ChromiumWindow1.ChromiumBrowser.OnContextMenuCommand:=Form1.Chromium1ContextMenuCommand;
        //control right click menu
        ChromiumWindow1.ChromiumBrowser.OnRunContextMenu:=Form1.Chromium1RunContextMenu
       
end;

procedure TForm1.Chromium1BeforePopup(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame; const targetUrl,
  targetFrameName: ustring; targetDisposition: TCefWindowOpenDisposition;
  userGesture: Boolean; var popupFeatures: TCefPopupFeatures;
  var windowInfo: TCefWindowInfo; var client: ICefClient;
  var settings: TCefBrowserSettings; var noJavascriptAccess: Boolean;
  out Result: Boolean);
begin
     Result:=True;
     if not browser.IsPopup then
     begin
     ChromiumWindow1.ChromiumBrowser.LoadURL(targetUrl);
     end
end;

procedure TForm1.Chromium1ContextMenuCommand(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; commandId: Integer;
  eventFlags: Cardinal; out Result: Boolean);
begin
      Result:=True;
end;

procedure TForm1.Chromium1RunContextMenu(Sender: TObject;
  const browser: ICefBrowser; const frame: ICefFrame;
  const params: ICefContextMenuParams; const model: ICefMenuModel;
  const callback: ICefRunContextMenuCallback; var aResult: Boolean);
begin
       aResult:=True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE,@NotifyIcon); 
end; 
{------------------------------------------------------------------------------- 
 Description: 截获窗体最小化消息，最小化到托盘 
-------------------------------------------------------------------------------} 
procedure TForm1.WMSysCommand(var Msg: TMessage);
begin
  with NotifyIcon do 
  begin 
    cbSize := SizeOf(TNotifyIconDataEx); 
    Wnd := Self.Handle; 
    uID := 1;
    uFlags := NIF_ICON + NIF_MESSAGE + NIF_TIP + NIF_INFO;   //图标、消息、提示信息
    uCallbackMessage := WM_TRAYMSG;
    hIcon := Application.Icon.Handle;
    strpcopy(@szTip,ftitle+'正在运行...');
    strpcopy(@szInfo,ftitle+'正在运行...');
    szInfoTitle := '运行提示';
    dwInfoFlags := NIIF_USER;
  end;

  
  if Msg.WParam = SC_ICON then
  begin
    Shell_NotifyIcon(NIM_ADD,@NotifyIcon);
    Self.Visible := False
  end
  else
    DefWindowProc(Self.Handle,Msg.Msg,Msg.WParam,Msg.LParam); 
end; 
{------------------------------------------------------------------------------- 
 Description: 自定义的托盘消息 
-------------------------------------------------------------------------------} 
procedure TForm1.WMTrayMsg(var Msg: TMessage); 
var 
  p: TPoint; 
begin 
  case Msg.LParam of 
    WM_LBUTTONDOWN: Self.Visible := True;   //显示窗体 
    WM_RBUTTONDOWN: 
      begin 
        SetForegroundWindow(Self.Handle);   //把窗口提前 
        GetCursorPos(p); 
        pm1.Popup(p.X,p.Y); 
      end; 
  end;     
end; 

procedure TForm1.m_exitClick(Sender: TObject);
begin
 Form1.Close;
end;

function TForm1.GetDomain(URL:string):string;
begin
  Result := LowerCase(URL);
  if (Pos('https://', Result) = 0) and (Pos('http://', Result) = 0) then
  Result := URL else
  if Pos('https://', URL) > 0 then
  Result := Copy(URL,9,PosEx('/', URL, 9)-9) else
  Result := Copy(URL, 8, PosEx('/', URL, 8)-8);
end;

end.

