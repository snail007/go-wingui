#RequireAdmin
#NoTrayIcon
#Region
#AutoIt3Wrapper_Icon=favicon.ico
#AutoIt3Wrapper_Res_Fileversion=1.0.0.11
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
Run("chrome/chrome.exe --chrome-frame --kiosk "&$url&"&w="&$width&"&h="&$height)
WinWait($flag, "")
Opt('wintitlematchmode', 4)
Local $hWnd = WinGetHandle($flag)
Local $pWnd = GUICreate($title,$width,$height)
_WinAPI_SetParent($hWnd,$pWnd)
GUISetState(@SW_SHOW,$pWnd)
Opt("TrayMenuMode",11)
Local $showHide = TrayCreateItem("显示/隐藏")
Local $idExit = TrayCreateItem("退出")
TraySetState($TRAY_ICONSTATE_SHOW) ; 
TraySetToolTip($title)
Local Const $sCLSID_TaskbarList = "{56FDF344-FD6D-11D0-958A-006097C9A090}"
Local Const $sIID_ITaskbarList = "{56FDF342-FD6D-11D0-958A-006097C9A090}"
Local Const $sTagITaskbarList = "HrInit hresult(); AddTab hresult(hwnd); DeleteTab hresult(hwnd); ActivateTab hresult(hwnd); SetActiveAlt hresult(hwnd);"
Local $oTaskbarList = ObjCreateInterface($sCLSID_TaskbarList, $sIID_ITaskbarList, $sTagITaskbarList)
$oTaskbarList.HrInit()
$oTaskbarList.DeleteTab($hWnd)
While 1
	$msg = GUIGetMsg()
	$imsg = TrayGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			GUISetState(@SW_HIDE,$pWnd)
		Case $imsg = 0
			ContinueLoop
		Case $imsg = $idExit
			Exit(0)
		Case $imsg = $showHide
			Local $iState = WinGetState($hWnd)
			If BitAND($iState,2) Then
				GUISetState(@SW_HIDE,$pWnd)
			Else
				GUISetState(@SW_SHOW,$pWnd)
				WinActivate($pWnd)
			EndIf
	EndSelect
WEnd
