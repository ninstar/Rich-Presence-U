; RunnerInstaller.nsi
;
; This script is based on example1.nsi, but it remember the directory, 
; has uninstall support and (optionally) installs start menu shortcuts.
;
; It will install example2.nsi into a directory that the user selects,

;--------------------------------
!ifndef FULL_VERSION
!define FULL_VERSION      "1.0.0.0"
!endif
!ifndef SOURCE_DIR
!define SOURCE_DIR        "C:\source\temp\InstallerTest\runner"
!endif
!ifndef INSTALLER_FILENAME
!define INSTALLER_FILENAME    "C:\source\temp\InstallerTest\RunnerInstaller.exe"
!endif

!ifndef MAKENSIS
!define MAKENSIS          "%appdata%\GameMaker-Studio\makensis"
!endif

!ifndef COMPANY_NAME
!define COMPANY_NAME      ""
!endif

!ifndef COPYRIGHT_TXT
!define COPYRIGHT_TXT     "(c)Copyright 2013"
!endif

!ifndef FILE_DESC
!define FILE_DESC         "Created with GameMaker:Studio"
!endif

!ifndef LICENSE_NAME
!define LICENSE_NAME      "License.txt"
!endif

!ifndef ICON_FILE
!define ICON_FILE       "icon.ico"
!endif

!ifndef IMAGE_FINISHED
!define IMAGE_FINISHED      "Runner_finish.bmp"
!endif

!ifndef IMAGE_HEADER
!define IMAGE_HEADER      "Runner_header.bmp"
!endif

!ifndef PRODUCT_NAME
!define PRODUCT_NAME      "Runner"
!endif

!define APP_NAME        "${PRODUCT_NAME}"
!define SHORT_NAME        "${PRODUCT_NAME}"

!ifndef EXE_NAME
!define EXE_NAME "${PRODUCT_NAME}"
!endif

;..................................................................................................
;Following two definitions required. Uninstall log will use these definitions.
;You may use these definitions also, when you want to set up the InstallDirRagKey,
;store the language selection, store Start Menu folder etc.
;Enter the windows uninstall reg sub key to add uninstall information to Add/Remove Programs also.

!define INSTDIR_REG_ROOT "HKLM"
!define INSTDIR_REG_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
;..................................................................................................

;..................................................................................................
;..................................................................................................

;;USAGE:
!define MIN_FRA_MAJOR "2"
!define MIN_FRA_MINOR "0"
!define MIN_FRA_BUILD "*"

!addplugindir   "."

#************************************* Include NSIS Headers ***********************************#

!include MUI.nsh
#
#
;..................................................................................................
;include the Uninstall log header
!include AdvUninstLog.nsh
;..................................................................................................




;--------------------------------

; The name of the installer
Name "${APP_NAME}"
Caption "${APP_NAME}"
BrandingText "${APP_NAME}"

; The file to write
OutFile "${INSTALLER_FILENAME}"

; The default installation directory
InstallDir "$PROGRAMFILES\${APP_NAME}"

; Registry key to check for directory (so if you install again, it will 
; overwrite the old one automatically)
InstallDirRegKey ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "InstallDir"

; Request application privileges for Windows Vista
RequestExecutionLevel admin


VIProductVersion "${FULL_VERSION}"
VIAddVersionKey /LANG=1033 "FileVersion" "${FULL_VERSION}"
VIAddVersionKey /LANG=1033 "ProductVersion" "${FULL_VERSION}"
VIAddVersionKey /LANG=1033 "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=1033 "CompanyName" "${PRODUCT_PUBLISHER}"
VIAddVersionKey /LANG=1033 "LegalCopyright" "${COPYRIGHT_TXT}"
VIAddVersionKey /LANG=1033 "FileDescription" "${FILE_DESC}"



!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP_NOSTRETCH
!define MUI_ICON            "${ICON_FILE}"
!define MUI_WELCOMEFINISHPAGE_BITMAP  "${IMAGE_FINISHED}"
!define MUI_HEADERIMAGE_BITMAP      "${IMAGE_HEADER}"
!define MUI_WELCOMEFINISHPAGE_BITMAP_NOSTRETCH


;--------------------------------

; Pages
;..................................................................................................
;Specify the preferred uninstaller operation mode, either unattended or interactive.
;You have to type either !insertmacro UNATTENDED_UNINSTALL, or !insertmacro INTERACTIVE_UNINSTALL.
;Be aware only one of the following two macros has to be inserted, neither both, neither none.

  !insertmacro UNATTENDED_UNINSTALL
!insertmacro MUI_PAGE_LICENSE "${LICENSE_NAME}"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
    # These indented statements modify settings for MUI_PAGE_FINISH
    !define MUI_FINISHPAGE_NOAUTOCLOSE
    !define MUI_FINISHPAGE_RUN_TEXT "Start ${PRODUCT_NAME}"
    !define MUI_FINISHPAGE_RUN "$INSTDIR\${EXE_NAME}.exe"
!insertmacro MUI_PAGE_FINISH

Var VCRedistSetupError

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH


!insertmacro MUI_LANGUAGE "English"
;--------------------------------

; The stuff to install
Section `${APP_NAME}`
  SectionIn RO
  
  ; Set output path to the installation directory.
  SetOutPath $INSTDIR
  
  !insertmacro UNINSTALL.LOG_OPEN_INSTALL

  File "${LICENSE_NAME}"
  File /r "${SOURCE_DIR}\*.*"

  !insertmacro UNINSTALL.LOG_CLOSE_INSTALL

  WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "InstallDir" "$INSTDIR"
  WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "DisplayName" "${APP_NAME}"
  ;Same as create shortcut you need to use ${UNINST_EXE} instead of anything else.
  WriteRegStr ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}" "UninstallString" "${UNINST_EXE}"
  WriteRegDWORD ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}"  "NoModify" 1
  WriteRegDWORD ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}"  "NoRepair" 1


SectionEnd

Section "Visual C++ Redistributable" SEC_VCREDIST
SectionIn RO

SetOutPath "$TEMP"
File "${MAKENSIS}\vcredist_x86_2015.exe"
DetailPrint "Running Visual Studio 2015 x86 Redistributable Setup..."
ExecWait '"$TEMP\vcredist_x86_2015.exe" /quiet /norestart' $VCRedistSetupError
DetailPrint "end VS2015 x86"
Delete "$TEMP\vcredist_x86_2015.exe"

SetOutPath "$INSTDIR"
SectionEnd

; Optional section (can be disabled by the user)
Section "Start Menu Shortcuts"

    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\${EXE_NAME}.exe"
    ;create shortcut for uninstaller always use ${UNINST_EXE} instead of uninstall.exe
    CreateShortcut "$SMPROGRAMS\${APP_NAME}\uninstall.lnk" "${UNINST_EXE}"
    CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME} License.lnk" "notepad.exe" "$INSTDIR\License.txt"
  
SectionEnd


; Optional section (can be enabled by the user)
Section /o "Desktop shortcut"

  CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\${EXE_NAME}.exe" ""
  
SectionEnd


Function .onInit

        ;prepare log always within .onInit function
        !insertmacro UNINSTALL.LOG_PREPARE_INSTALL

FunctionEnd


Function .onInstSuccess

         ;create/update log always within .onInstSuccess function
         !insertmacro UNINSTALL.LOG_UPDATE_INSTALL

FunctionEnd

#######################################################################################

Section UnInstall

         ;begin uninstall, especially for MUI could be added in UN.onInit function instead
         ;!insertmacro UNINSTALL.LOG_BEGIN_UNINSTALL

         ;uninstall from path, must be repeated for every install logged path individual
         !insertmacro UNINSTALL.LOG_UNINSTALL "$INSTDIR"

         ;uninstall from path, must be repeated for every install logged path individual
         !insertmacro UNINSTALL.LOG_UNINSTALL "$APPDATA\${APP_NAME}"

         ;end uninstall, after uninstall from all logged paths has been performed
         !insertmacro UNINSTALL.LOG_END_UNINSTALL

        Delete "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk"
        Delete "$SMPROGRAMS\${APP_NAME}\uninstall.lnk"
        RmDir "$SMPROGRAMS\${APP_NAME}"

        DeleteRegKey /ifempty ${INSTDIR_REG_ROOT} "${INSTDIR_REG_KEY}"

SectionEnd


Function UN.onInit

         ;begin uninstall, could be added on top of uninstall section instead
         !insertmacro UNINSTALL.LOG_BEGIN_UNINSTALL

FunctionEnd