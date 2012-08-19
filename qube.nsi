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

;!define setup "setup.exe"

; change this to wherever the game executable and associated files reside
;!define srcdir "c:\Program Files\qube\qsdk\samples\demos\qdemo2\"

;!define company "Technicat"
;!define prodname "Game"
;!define exec "qdemo2.exe"

!include "setup.nsi"

; location of qube sdk
!define qdir "c:\Program Files\Qube\QSDK"

; beginning (invisible) section
Section

  SetOutPath $INSTDIR\win32

  File /a /r "${srcdir}\win32\${exec}"

; install the QSDK runtime DLL's
  File /a "${qdir}\win32\bin\*.dll"

  SetOutPath $INSTDIR

; add subdirs as necessary
  File /a /r "${srcdir}\data"

SectionEnd

Section "UninstallQ"

  RMDir /r "$INSTDIR\data"
  RMDir /r "$INSTDIR\win32"
  
SectionEnd
