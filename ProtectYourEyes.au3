#NoTrayIcon
#include <parse_ini.au3>

Global Const $lciWM_SYSCommand = 274		; 0x0112
Global Const $lciSC_MonitorPower = 61808	; 0xF170
Global Const $lciPower_Off = 2
Global Const $lciPower_On = -1
Global $MonitorIsOff = False
Global $powerOn = 0 
Global $screenSaveActive , $screenSaverIsSecure


$ini = parse_ini_file("configure.ini", true, $INI_SCANNER_TYPED)
Local $powerOnTime = $ini[$ini[0]("Time")]("PowerOnTime") *1000
Local $waitTime = $ini[$ini[0]("Time")]("WaitTime") * 1000
Local $delayTime = $ini[$ini[0]("Time")]("DelayTime") * 1000
Local $tempOff = $powerOnTime / $waitTime
Local $powerOnMax = ($powerOnTime + $delayTime) / $waitTime

Global $screenSaver = $ini[$ini[0]("ScreenSaver")]("Process")
Global $restoreScreenSaver = $ini[$ini[0]("ScreenSaver")]("Restore")


HotKeySet($ini[$ini[0]("HotKeys")]("Monitor_OFF"), "_Monitor_OFF")
HotKeySet($ini[$ini[0]("HotKeys")]("Monitor_ON"), "_Monitor_ON")
HotKeySet($ini[$ini[0]("HotKeys")]("Quit"), "_Quit")

If Not $screenSaver Then
	_ScreenSaver_Off()
EndIf
While 1
	If $powerOn > $powerOnMax Then
		;關閉螢幕
		ProgressOff()
		_Monitor_OFF()
	Else
		If $powerOn =  $tempOff Then 
			_Monitor_Temp_Off()
			ProgressOn("Protect Your Eyes", "Screen will turn off", "Press " & $ini[$ini[0]("HotKeys")]("Quit") & " to exit this program.", @DesktopWidth/2-150 ,@DesktopHeight/2-50 , 16)
		EndIf
		$powerOn = $powerOn + 1
		Sleep($WaitTime)
		If $powerOn > $tempOff Then ProgressSet(100*($powerOn-$tempOff)/($powerOnMax-$tempOff))
	EndIf 
WEnd

Func _Monitor_Temp_Off()
	Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')
	DllCall('user32.dll', 'int', 'SendMessage', _
												'hwnd', $Progman_hwnd, _
												'int', $lciWM_SYSCommand, _
												'int', $lciSC_MonitorPower, _
												'int', $lciPower_Off)
	Sleep(100)
	DllCall('user32.dll', 'int', 'SendMessage', _
												'hwnd', $Progman_hwnd, _
												'int', $lciWM_SYSCommand, _
												'int', $lciSC_MonitorPower, _
												'int', $lciPower_On)
EndFunc

Func _Monitor_ON()
	$MonitorIsOff = False
	Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')
	
	DllCall('user32.dll', 'int', 'SendMessage', _
												'hwnd', $Progman_hwnd, _
												'int', $lciWM_SYSCommand, _
												'int', $lciSC_MonitorPower, _
												'int', $lciPower_On)
	$powerOn = 0
	ProgressOff()
EndFunc

Func _Monitor_OFF()
	$MonitorIsOff = True
	Local $Progman_hwnd = WinGetHandle('[CLASS:Progman]')
	
	While $MonitorIsOff = True
		DllCall('user32.dll', 'int', 'SendMessage', _
													'hwnd', $Progman_hwnd, _
													'int', $lciWM_SYSCommand, _
													'int', $lciSC_MonitorPower, _
													'int', $lciPower_Off)
		_IdleWaitCommit(0)
		Sleep(20)
	WEnd
EndFunc

Func _IdleWaitCommit($idlesec)
	Local $iSave, $LastInputInfo = DllStructCreate ("uint;dword")
	DllStructSetData ($LastInputInfo, 1, DllStructGetSize ($LastInputInfo))
	DllCall ("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr ($LastInputInfo))
	Do
		$iSave = DllStructGetData ($LastInputInfo, 2)
		Sleep(60)
		DllCall ("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr ($LastInputInfo))
	Until (DllStructGetData ($LastInputInfo, 2)-$iSave) > $idlesec Or $MonitorIsOff = False
	Return DllStructGetData ($LastInputInfo, 2)-$iSave
EndFunc

Func _Quit()
	_Monitor_ON()
	If $restoreScreenSaver AND Not $screenSaver Then 
		_Restore_ScreenSaver()
	EndIf
	Exit
EndFunc
 
Func _ScreenSaver_Off()
	Local $key="HKEY_CURRENT_USER\Control Panel\Desktop"
	$screenSaverIsSecure = RegRead($key, "ScreenSaverIsSecure")
	$screenSaveActive = RegRead($key, "ScreenSaveActive")
	RegWrite($key, "ScreenSaverIsSecure", "REG_SZ", 0)
	RegWrite($key, "ScreenSaveActive", "REG_SZ", 0)
EndFunc

Func _Restore_ScreenSaver()
	Local $key="HKEY_CURRENT_USER\Control Panel\Desktop"
	RegWrite($key, "ScreenSaverIsSecure", "REG_SZ", $screenSaverIsSecure)
	RegWrite($key, "ScreenSaveActive", "REG_SZ", $screenSaveActive)
EndFunc