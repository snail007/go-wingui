#RequireAdmin
#NoTrayIcon
#Region
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Fileversion=1.0.0.53
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#EndRegion
#include <WinApi.au3>
#include <GUIConstantsEx.au3>
#Include <GuiToolBar.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <AutoItConstants.au3>
#include <TrayConstants.au3>

If UBound($CmdLine) <> 5 Then
	Exit(0)
EndIf
Local $url=$CmdLine[1]
Local $title=$CmdLine[2]
Local $width=$CmdLine[3]
Local $height=$CmdLine[4]
Local $flag="[CLASS:Chrome_WidgetWin_1]"
Local $args="--disable-translate --no-default-browser-check --disable-background-mode  --chrome-frame --disable-plugins "& '--user-data-dir="'&@TempDir&'/'&Random(10000)&'" '& "--allow-insecure-localhost --allow-running-insecure-content  "& '--disk-cache-dir="'&@TempDir&'" '& "--disable-desktop-notifications  --disable-background-networking  --safebrowsing-disable-auto-update --disable-hang-monitor --disable-device-orientation  --no-first-run "
Run("chrome/chrome.exe "&$args&" --kiosk "&$url&"&w="&$width&"&h="&$height,"chrome/")
WinWait($flag, "")
Opt('wintitlematchmode', 4)
Local $hWnd = WinGetHandle($flag)
Local $pWnd = GUICreate($title,$width,$height)
_WinAPI_SetParent($hWnd,$pWnd)
GUISetState(@SW_SHOW,$pWnd)
Opt("TrayMenuMode",11)
Opt("TrayOnEventMode", 1)
Local $idExit = TrayCreateItem("退出")
TrayItemSetOnEvent($idExit,"ExitApp")
TraySetOnEvent($TRAY_EVENT_PRIMARYUP,"ShowHide")
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE,"ShowHide")
TraySetState($TRAY_ICONSTATE_SHOW) ; 
TraySetClick(8)
TraySetToolTip($title)
Local Const $sCLSID_TaskbarList = "{56FDF344-FD6D-11D0-958A-006097C9A090}"
Local Const $sIID_ITaskbarList = "{56FDF342-FD6D-11D0-958A-006097C9A090}"
Local Const $sTagITaskbarList = "HrInit hresult(); AddTab hresult(hwnd); DeleteTab hresult(hwnd); ActivateTab hresult(hwnd); SetActiveAlt hresult(hwnd);"
Local $oTaskbarList = ObjCreateInterface($sCLSID_TaskbarList, $sIID_ITaskbarList, $sTagITaskbarList)
$oTaskbarList.HrInit()
HideTaskBar()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE,$pWnd)
			TrayTip("",$title & " is running here",3)
		Case $msg = $GUI_EVENT_CLOSE
			Exit(0)
	EndSelect
WEnd
Func ShowHide()
	Local $iState = WinGetState($hWnd)
	If BitAND($iState,2) Then
		GUISetState(@SW_HIDE,$pWnd)
	Else
		GUISetState(@SW_SHOW,$pWnd)
		WinActivate($hWnd)
	EndIf
EndFunc

Func ExitApp()
	Exit(0)
EndFunc
Func HideTaskBar()
$oTaskbarList.DeleteTab($hWnd)
$oTaskbarList.DeleteTab($pWnd)
EndFunc
