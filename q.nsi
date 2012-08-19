; basic installer script template for Qube-based game or application
; using NSIS
;
; Written by Philip Chu
; Copyright (c) 2004 Technicat, LLC
;
; This software is provided 'as-is', without any express or implied warranty.
; In no event will the authors be held liable for any damages arising from the use of this software.

; Permission is granted to anyone to use this software for any purpose,
; including commercial applications, and to alter it ; and redistribute
; it freely, subject to the following restrictions:

;    1. The origin of this software must not be misrepresented; you must not claim that
;       you wrote the original software. If you use this software in a product, an
;       acknowledgment in the product documentation would be appreciated but is not required.

;    2. Altered source versions must be plainly marked as such, and must not be
;       misrepresented as being the original software.

;    3. This notice may not be removed or altered from any source distribution.

!define setup "setup.exe"

; change this to wherever the game executable and associated files reside
!define srcdir "c:\Program Files\qube\qsdk\samples\demos\qdemo2\"

!define company "Technicat"
!define prodname "Game"
!define exec "qdemo2.exe"

; text file to open in notepad after installation
; !define notefile "README.txt"

; license text file
;!define licensefile license.txt

; icons must be Microsoft .ICO files
;!define icon "icon.ico"

; installer background screen
;!define screenimage background.bmp

!define regkey "Software\${company}\${prodname}"
!define uninstkey "Software\Microsoft\Windows\CurrentVersion\Uninstall\${prodname}"

!define startmenu "$SMPROGRAMS\${company}\${prodname}"
!define uninstaller "uninstall.exe"

; location of qube sdk
!define qdir "c:\Program Files\Qube\QSDK"

;--------------------------------

Name "${prodname}"
Caption "${prodname}"

!ifdef icon
Icon "${icon}"
!endif

OutFile "${setup}"

SetDateSave on
SetDatablockOptimize on
CRCCheck on
SilentInstall normal

InstallDir "$PROGRAMFILES\${company}\${prodname}"
InstallDirRegKey HKLM "${regkey}" ""

!ifdef licensefile
LicenseText "License"
LicenseData "${srcdir}\${licensefile}"
!endif

; pages
; we keep it simple - leave out selectable installation types

!ifdef licensefile
Page license
!endif

; Page components
Page directory
Page instfiles

UninstPage uninstConfirm
UninstPage instfiles

;--------------------------------

AutoCloseWindow false
ShowInstDetails show


!ifdef screenimage

; set up background image
; uses BgImage plugin

Function .onGUIInit
	; extract background BMP into temp plugin directory
	InitPluginsDir
	File /oname=$PLUGINSDIR\${screenimage} "${screenimage}"

	BgImage::SetBg /NOUNLOAD /FILLSCREEN $PLUGINSDIR\${screenimage}
	BgImage::Redraw /NOUNLOAD
FunctionEnd

Function .onGUIEnd
	; Destroy must not have /NOUNLOAD so NSIS will be able to unload and delete BgImage before it exits
	BgImage::Destroy
FunctionEnd

!endif

; beginning (invisible) section
Section

  WriteRegStr HKLM "${regkey}" "Install_Dir" "$INSTDIR"

  ; write uninstall strings
  WriteRegStr HKLM "${uninstkey}" "DisplayName" "${prodname} (remove only)"
  WriteRegStr HKLM "${uninstkey}" "UninstallString" '"$INSTDIR\${uninstaller}"'

; installation directories are set up to match the q demo layout
; modify as appropriate 

  SetOutPath $INSTDIR\win32

  File /a /r "${srcdir}\win32\${exec}"

; install the QSDK runtime DLL's
  File /a "${qdir}\win32\bin\*.dll"

  SetOutPath $INSTDIR

; add subdirs as necessary
  File /a /r "${srcdir}\data"

  WriteUninstaller "${uninstaller}"
  
SectionEnd

; create shortcuts
Section
  
  CreateDirectory "${startmenu}"
  SetOutPath $INSTDIR ; for working directory
  CreateShortCut "${startmenu}\${prodname}.lnk" "$INSTDIR\win32\${exec}"

!ifdef notefile
  CreateShortCut "${startmenu}\Release Notes.lnk "$INSTDIR\${notefile}"
  Exec "$WINDIR\notepad.exe $INSTDIR\${notefile}"
!endif

SectionEnd

; Uninstaller
; All section names prefixed by "Un" will be in the uninstaller

UninstallText "This will uninstall ${prodname}."

!ifdef icon
UninstallIcon "${icon}"
!endif

Section "Uninstall"

  DeleteRegKey HKLM "${uninstkey}"
  DeleteRegKey HKLM "${regkey}"
  
  Delete "${startmenu}\*.*"

  Delete "$INSTDIR\*.*"
  RMDir /r "$INSTDIR\data"
  RMDir /r "$INSTDIR\win32"
  
SectionEnd
