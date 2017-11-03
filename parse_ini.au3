#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.1
 Author:         Freeman

 Script Function:
	parse_ini_file($filename, $process_section)
	Similar to php parse_ini_file loads in the ini file specified in filename, and returns the settings in it in an associative dictionary object.
	*** Dictionaries object cannot be multidimensional, Arrays can
	The variable type of All of the value in the ini file is STRING.
 Return Values
	If $process_section = true
	
		$ini[0] = {	0	 	: n,	(total numbers of sections)
					1		: "Name of Section 1"
					...
					n		: "Name of Section n"
					"Name of Section 1"	:	1,
					...
					"Name of Section n"	:	n }
		$ini[1] = {	0		: n1,	(total numbers of section 1)
					"key"	: value	}
		...
		$ini[n] = {	0		: nn,	(total numbers of section n)
					"key"	: value }
	
		An example to take the value of keyB of sectionA 
		$ini[ $ini[0]("sectionA") ]("keyB")
	
	Else 
		$ini =  {	"key"	: value	}
		取 keyB 的值
		$ini["keyB"]
	EndIf

#ce ----------------------------------------------------------------------------

Func parse_ini_file($filename, $process_section)
	Local $i, $j, $key, $debugStr =""
	Local $readSectionNames, $readSection
	$readSectionNames = IniReadSectionNames($filename)
	If @error Then 
		MsgBox(4096, "Parse ini file", "Error occurred, probably " & $filename & " is not a INI file.")
		return false
		exit 
	EndIf
	If $process_section Then
		Local $parsedini[$readSectionNames[0] + 1]
		$parsedini[0] = ObjCreate("Scripting.Dictionary")
		$parsedini[0](0) = $readSectionNames[0]
		For $i = 1 To $readSectionNames[0]
			; 設定 ini[0] 的其餘數值
			$parsedini[0]($i) = $readSectionNames[$i]
			$parsedini[0]($readSectionNames[$i]) = $i
			; 設定 ini[$i]
			$parsedini[$i] = ObjCreate("Scripting.Dictionary")
			$readSection =  IniReadSection($filename, $readSectionNames[$i])
			If @error Then
				$parsedini[$i](0) = 0		; 此段解讀錯誤，所以設為 0
			Else
				$parsedini[$i](0) = $readSection[0][0]
				For $j = 1 To $readSection[0][0]
					$parsedini[$i]($j)	=	$readSection[$j][0]
					$parsedini[$i]($readSection[$j][0]) = $readSection[$j][1]
				Next
			EndIf
		Next
	Else
		Local $parsedini = ObjCreate("Scripting.Dictionary")
		For $i = 1 To $readSectionNames[0]
			$readSection =  IniReadSection($filename, $readSectionNames[$i])
			If @error Then
				; 此段解讀錯誤
			Else
				For $j = 1 To $readSection[0][0]
					$parsedini($readSection[$j][0]) = $readSection[$j][1]
				Next
			EndIf
		Next
	EndIf
	return $parsedini
EndFunc
