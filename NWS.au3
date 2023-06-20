; Numan's Word Searcher
; Copyright (C) 2023  Numan's Hand Tools
;
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

#NoTrayIcon
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StringConstants.au3>

Func GetDefaultBorderSize()
	Local $guiTemp = GUICreate("", 800, 600)
	Local $guiSizes = WinGetPos($guiTemp)
	GUIDelete($guiTemp)
	Local $ret[2]
	$ret[0] = $guiSizes[2] - 800
	$ret[1] = $guiSizes[3] - 600
	Return $ret
EndFunc

Func IsWidgetFocused(Const $hWindow, Const $controlID)
	Return (GUICtrlGetHandle($controlID) = ControlGetHandle($hWindow, "", ControlGetFocus($hWindow)) ? True : False)
EndFunc

Func IsPanelVisible(Const ByRef $pPanel)
	Return ((BitAND(GUIGetStyle($pPanel)[0], $WS_VISIBLE) = 0) ? False : True)
EndFunc

Func FnInspirassion(Const $pWords, Const $pPrefixLink, Const $pSuffixLink)
	Return ($pPrefixLink & (StringSplit($pWords, " ", $STR_NOCOUNT)[0]))
EndFunc

Func FnInspirassionGT(Const $pWords, Const $pPrefixLink, Const $pSuffixLink)
	Return ($pPrefixLink & (StringSplit($pWords, " ", $STR_NOCOUNT)[0]) & $pSuffixLink)
EndFunc

Func FnYouGlish(Const $pWords, Const $pPrefixLink, Const $pSuffixLink)
	Return ($pPrefixLink & (StringReplace($pWords, " ", "%20")) & $pSuffixLink)
EndFunc

Func LoadEngines()
	Local $array[][] = [ _
		[ 0, 7 ], _
		["Longman Dictionary", 0, 0, "+", "https://www.ldoceonline.com/search/direct/?q=", Null, 0], _
		["Longman Dictionary > GoogleTranslate", 0, 0, "+", "https://www-ldoceonline-com.translate.goog/search/direct/?q=", "&_x_tr_sl=auto&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["Cambridge Dictionary (Türkçe)", 0, 0, "+", "https://dictionary.cambridge.org/tr/search/english-turkish/direct/?q=", Null, 0], _
		["Cambridge Dictionary > GoogleTranslate", 0, 0, "-", "https://dictionary-cambridge-org.translate.goog/dictionary/english/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["Sesli Sözlük", 0, 0, "+", "https://www.seslisozluk.net/?word=", Null, 0], _
		["tureng", 0, 0, "+", "https://tureng.com/tr/turkce-ingilizce/", Null, 0], _
		["Oxford Learner's Dictionaries", 0, 0, "+", "https://www.oxfordlearnersdictionaries.com/search/english/?q=", Null, 0], _
		["Oxford Learner's Dictionaries > Google Translate", 0, 0, "+", "https://www-oxfordlearnersdictionaries-com.translate.goog/search/english/?q=", "&_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["The Free Dictionary", 0, 0, "+", "https://www.thefreedictionary.com/", Null, 0], _
		["The Free Dictionary > Google Translate", 0, 0, "+", "https://www-thefreedictionary-com.translate.goog/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["Merriam Webster Dictionary", 0, 0, "%20", "https://www.merriam-webster.com/dictionary/", Null, 0], _
		["Merriam Webster Dictionary > Google Translate", 0, 0, "%20", "https://www-merriam--webster-com.translate.goog/dictionary/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["Collins Dictionary", 0, 0, "-", "https://www.collinsdictionary.com/dictionary/english/", Null, 0], _
		["Collins Dictionary > Google Translate", 0, 0, "-", "https://www-collinsdictionary-com.translate.goog/dictionary/english/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["Macmillan Dictionary", 0, 0, "-", "https://www.macmillandictionary.com/dictionary/british/", Null, 0], _
		["Macmillan Dictionary > Google Translate", 0, 0, "-", "https://www-macmillandictionary-com.translate.goog/dictionary/british/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["WordReference Dictionary (Türkçe)", 0, 0, "%20", "https://www.wordreference.com/entr/", Null, 0], _
		["WordReference Dictionary > Google Translate", 0, 0, "%20", "https://www-wordreference-com.translate.goog/definition/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["LingoHelp Verb + Prepositions", 0, 0, "+", "https://www.google.com/search?q=", "+site%3A%3Ahttps%3A%2F%2Flingohelp.me%2Fpreposition-after-verb%2F", 0], _
		["Inspirassion Verb + Prepositions", 0, 0, FnInspirassion, "https://inspirassion.com/en/prep/", Null, 0], _
		["Inspirassion Verb + Prepositions > Google Translate", 0, 0, FnInspirassionGT, "https://inspirassion-com.translate.goog/en/prep/", "?_x_tr_sl=en&_x_tr_tl=tr&_x_tr_hl=tr&_x_tr_pto=wapp", 1], _
		["Google Translate", 0, 0, "%20", "https://translate.google.com/?sl=en&tl=tr&text=", Null, 0], _
		["YouGlish (American)", 0, 0, FnYouGlish, "https://youglish.com/pronounce/", "/english/us?", 0] _
	]

	$array[0][0] = UBound($array, 1) - 1

	Return $array
EndFunc

Func GenerateSearchLink(ByRef $paEngines, Const $index, Const $pWords)
	#forceref $paEngines
	If IsFunc($paEngines[$index][3]) Then
		Return ($paEngines[$index][3]($pWords, ($paEngines[$index][4]), ($paEngines[$index][5])))
	Else
		If $paEngines[$index][5] = Null Then ; Is Not Exist Suffix
			Return ($paEngines[$index][4] & StringReplace($pWords, " ", $paEngines[$index][3]))
		Else
			Return ($paEngines[$index][4] & StringReplace($pWords, " ", $paEngines[$index][3]) & $paEngines[$index][5])
		EndIf
	EndIf
EndFunc

Func CalculateFirstRowCount(ByRef $paEngines)
	#forceref $paEngines
	Local $iCount = 0
	For $i = 1 To $paEngines[0][0]
		If $paEngines[$i][6] = 0 Then $iCount += 1
	Next
	Return $iCount
EndFunc

Func Main()

	; First Regularities
	Opt("MustDeclareVars", True)

	Local $iniFile = @LocalAppDataDir & '\' & 'NumansHandTools\NWS\'
	If FileExists ( $iniFile ) = 0 Then DirCreate($iniFile)
	$iniFile &= 'pref.ini'
	Local $inputBox = IniRead($iniFile, "General", "Phrase", "")

	Local $gEngines = LoadEngines()
	; _ArrayDisplay($gEngines)
	Local Const $iWinBorders = GetDefaultBorderSize() ; window border sizes come from default theme

	; Restore CheckBox States
	If Number(IniRead($iniFile, "General", "Count", 0)) = $gEngines[0][0] Then
		For $i = 1 To $gEngines[0][0]
			If Number(IniRead($iniFile, "Data", String($i), 0)) <> 0 Then $gEngines[$i][2] = 1
		Next
	Else
		IniDelete($iniFile, "Data")
	EndIf

	; Window
	Local $guiMain = GUICreate("Numan's Word Searcher", 530, 103)

	; Top Panel
	Local $guiTop = GUICreate("", 516, 86, 7, 8, BitOr($WS_CHILD, $WS_VISIBLE, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS), -1, $guiMain)
	; GUISetBkColor(0xFF0000, $guiTop)
	GUICtrlSetResizing($guiTop, $GUI_DOCKALL)
		$inputBox = GUICtrlCreateInput($inputBox, 0, 0, 516, 30)
		GUICtrlSetFont($inputBox, 16)
		Local $butSearch = GUICtrlCreateButton("Ara", 0, 35, 516, 30)
		GUICtrlSetFont($butSearch, 9)
		GUICtrlCreateGraphic(2, 78, 492, 2, $SS_SUNKEN) ; Local $sepLine =
		Local $butExpand = GUICtrlCreateButton("?", 499, 70, 17, 17)
	GUISetState(@SW_SHOW)
	GUISwitch($guiMain) ; return $guiMain

	; Options Panel
	Local $incH = 30
	Local $iOptionsPanelTotalHeight = ((CalculateFirstRowCount($gEngines) - 1) * $incH) + 23 ; 23 = one button height

	Local $guiOptions = GUICreate("", 516, $iOptionsPanelTotalHeight, 7, 93, BitOr($WS_CHILD, $WS_CLIPCHILDREN, $WS_CLIPSIBLINGS), -1, $guiMain)
	GUICtrlSetResizing($guiOptions, $GUI_DOCKALL)
	; GUISetBkColor(0x0000FF, $guiOptions)

		Local $yChck = 3
		Local $yBut = 0
		Local $bState
		For $i = 1 To $gEngines[0][0]

			If $gEngines[$i][6] = 0 Then ; First Column
				; Button
				$gEngines[$i][1] = GUICtrlCreateButton(">", 0, $yBut, 23, 23)
				; CheckBox
				$bState = $gEngines[$i][2]
				$gEngines[$i][2] = GUICtrlCreateCheckbox($gEngines[$i][0], 30, $yChck, 185, 17)
			Else ; Second Column
				$yBut -= $incH
				$yChck -= $incH
				; Button
				$gEngines[$i][1] = GUICtrlCreateButton(">", 222, $yBut, 23, 23)
				; CheckBox
				$bState = $gEngines[$i][2]
				$gEngines[$i][2] = GUICtrlCreateCheckbox($gEngines[$i][0], 249, $yChck, 260, 17)
			EndIf

			If $bState = 1 Then GUICtrlSetState($gEngines[$i][2], $GUI_CHECKED)

			$yBut += $incH
			$yChck += $incH
		Next
	GUISwitch($guiMain) ; return $guiMain

	; To capture ENTER key
	Local $eventENTER = GUICtrlCreateDummy()
	Dim $aAccels[1][2] = [["{ENTER}", $eventENTER]]
	GUISetAccelerators($aAccels)

	; Save Dimensions for ToogleOptions
	Local Const $iWinHeightMin = $iWinBorders[1] + 103
	Local Const $iWinHeightMax = $iWinBorders[1] + 101 + $iOptionsPanelTotalHeight

	; View & Enter Loop
	GUISetState(@SW_SHOW)
	Local $sLink = 0
	Local $sWords = 0
	Local $nMsg
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop

			Case $butExpand
				GUISwitch($guiMain)
				If IsPanelVisible($guiOptions) Then
					WinMove($guiMain, "", Default, Default, Default, $iWinHeightMin)
					GUISetState(@SW_HIDE, $guiOptions)
				Else
					WinMove($guiMain, "", Default, Default, Default, $iWinHeightMax)
					GUISetState(@SW_SHOW, $guiOptions)
				EndIf

			Case $eventENTER
				If IsWidgetFocused($guiMain, $inputBox) Then ContinueCase ; enter -> Case $butSearch

			Case $butSearch
				$sWords = StringStripWS((GUICtrlRead($inputBox)), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING, $STR_STRIPSPACES))
				If $sWords <> "" Then
					; ConsoleWrite("Ara" & @CRLF)
					For $i = 1 To $gEngines[0][0]
						If GUICtrlRead($gEngines[$i][2]) = 1 Then ; if checkbox selected
							; ConsoleWrite($gEngines[$i][0] & @CRLF)
							$sLink = GenerateSearchLink($gEngines, $i, $sWords)
							ShellExecute($sLink)
						EndIf
					Next
				EndIf

			Case Else
				$sLink = 0
				For $i = 1 To $gEngines[0][0]
					If $gEngines[$i][1] = $nMsg Then ; button clicked check
						If $sLink = 0 Then
							$sWords = StringStripWS((GUICtrlRead($inputBox)), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING, $STR_STRIPSPACES))
							If $sWords = "" Then ExitLoop
						EndIf
						; ConsoleWrite($gEngines[$i][0] & @CRLF)
						$sLink = GenerateSearchLink($gEngines, $i, $sWords)
						ShellExecute($sLink)
					EndIf
				Next
		EndSwitch
	WEnd

	GUISetState(@SW_HIDE)

	IniWrite($iniFile, "General", "Phrase", (StringStripWS((GUICtrlRead($inputBox)), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING, $STR_STRIPSPACES))))
	IniWrite($iniFile, "General", "Count", $gEngines[0][0])
	For $i = 1 To $gEngines[0][0]
		IniWrite($iniFile, "Data", String($i), (GUICtrlRead($gEngines[$i][2]) = 1 ? 1 : 0))
	Next

	Exit
EndFunc

Main()
