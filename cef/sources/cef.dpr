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
//        Copyright ?2017 Salvador Díaz Fau. All rights reserved.
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
 
program cef;

{$I cef.inc}

uses
  Forms,
  uCEFApplication,
  ucef in 'ucef.pas' {Form1};


{$R *.res}

// CEF3 needs to set the LARGEADDRESSAWARE flag which allows 32-bit processes to use up to 3GB of RAM.
{$SetPEFlags $20}

begin
  GlobalCEFApp := TCefApplication.Create;

  GlobalCEFApp.FrameworkDirPath     := 'bin';
  GlobalCEFApp.ResourcesDirPath     := 'bin';
  GlobalCEFApp.LocalesDirPath       := 'bin\locales';
  GlobalCEFApp.cache                := '';
  GlobalCEFApp.cookies              := '';
  GlobalCEFApp.UserDataPath         := '';
  GlobalCEFApp.NoSandbox            :=False;
  GlobalCEFApp.PersistSessionCookies:=False;
  GlobalCEFApp.PersistUserPreferences:=False;
  GlobalCEFApp.PersistUserPreferences:=False;
  GlobalCEFApp.IgnoreCertificateErrors:=True;
  GlobalCEFApp.DeleteCache:=True;
  GlobalCEFApp.DeleteCookies:=True;
  GlobalCEFApp.FlashEnabled:=True;
  GlobalCEFApp.EnableGPU:=False;
  GlobalCEFApp.CheckCEFFiles:=False;
  GlobalCEFApp.CheckDevToolsResources:=False;
  GlobalCEFApp.DisableGPUCache:=True;
 

  if GlobalCEFApp.StartMainProcess then
    begin
      Application.Initialize;
      Application.Title := 'CEF¼ÓÔØÆ÷';
  Application.CreateForm(TForm1, Form1);
      Application.Run;
    end;

  GlobalCEFApp.Free;
end.
