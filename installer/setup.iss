; ============================================================
;  Showroom Pulse ERP - Inno Setup Script
;  Version: 1.0.4
;  Developed by: Creative District
;  Developers: Moazam Samoo & Tameer Ahmed Khyber
;
;  v1.0.4 - Rebranded app to "Showroom Pulse" (new name, app icon,
;           and window/tray branding), with a safe data-folder
;           migration from the old name. Fixed the dashboard profile
;           avatar dropdown (was not opening). Updated Settings
;           credits footer with IMCS logo.
;  v1.0.3 - Restored Reports/Revenue tabs, fixed session
;           persistence on app minimize, fixed Windows taskbar
;           icon display, updated build paths.
;  v1.0.2 - Dynamic Device Licensing via Firebase Firestore
;           First launch requires internet for one-time registration.
;           After that, app works fully offline.
; ============================================================

#define AppName      "Showroom Pulse"
#define AppVersion   "1.0.4"
#define AppPublisher "Creative District"
#define AppExeName   "tahir_showroom.exe"
#define AppURL       "https://github.com/your-repo/tahir_showroom"

; ============================================================
[Setup]
; ---- Basic Info ----
AppId=A1B2C3D4-E5F6-7890-ABCD-EF1234567890
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} v{#AppVersion}
AppPublisher={#AppPublisher}
AppPublisherURL={#AppURL}
AppSupportURL={#AppURL}
AppUpdatesURL={#AppURL}

; ---- Install Location ----
DefaultDirName={pf}\ShowroomPulse
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes

; ---- Output ----
OutputDir=C:\InnoSetup\Output
OutputBaseFilename=ShowroomPulse_Setup_v1.0.4

; ---- Compression ----
Compression=lzma2/ultra
SolidCompression=yes

; ---- Installer Visuals ----
WizardStyle=modern
ShowLanguageDialog=no

; ---- Version Info (helps reduce SmartScreen warnings) ----
VersionInfoVersion=1.0.4.0
VersionInfoCompany={#AppPublisher}
VersionInfoDescription=Showroom Pulse ERP Installer
VersionInfoCopyright=Copyright (C) 2026 Creative District
VersionInfoProductName={#AppName}
VersionInfoProductVersion={#AppVersion}
AppCopyright=Copyright (C) 2026 Creative District

; ---- Privileges ----
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

; ---- Windows Version Check ----
MinVersion=10.0
ArchitecturesAllowed=x64
ArchitecturesInstallIn64BitMode=x64

; ---- Uninstall ----
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#AppExeName}

; ============================================================
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

; ============================================================
[Tasks]
Name: "desktopicon";    Description: "Create Desktop Shortcut";     GroupDescription: "Additional Shortcuts:"; Flags: checkedonce
Name: "startmenuicon";  Description: "Create Start Menu Shortcut";  GroupDescription: "Additional Shortcuts:"; Flags: checkedonce
Name: "startupicon";    Description: "Launch app on Windows Startup"; GroupDescription: "Additional Shortcuts:"; Flags: unchecked

; ============================================================
[Files]
; -- VC++ Redistributable (bundled) --
Source: "D:\Tahir Showroom\installer\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

; -- App Icon (bundled for shortcuts) --
Source: "D:\Tahir Showroom\assets\app_icon.ico"; DestDir: "{app}"; Flags: ignoreversion

; -- Main App & all DLLs --
Source: "D:\Tahir Showroom\build\windows\x64\runner\Release\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Tahir Showroom\build\windows\x64\runner\Release\*.dll";          DestDir: "{app}"; Flags: ignoreversion recursesubdirs
Source: "D:\Tahir Showroom\build\windows\x64\runner\Release\data\*";         DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

; ============================================================
[Icons]
; -- Desktop Shortcut --
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon; IconFilename: "{app}\app_icon.ico"

; -- Start Menu Shortcut --
Name: "{autoprograms}\{#AppName}\{#AppName}";   Filename: "{app}\{#AppExeName}"; Tasks: startmenuicon; IconFilename: "{app}\app_icon.ico"
Name: "{autoprograms}\{#AppName}\Uninstall";     Filename: "{uninstallexe}"

; -- Startup (optional) --
Name: "{autostartup}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: startupicon; IconFilename: "{app}\app_icon.ico"

; ============================================================
[Run]
; -- Install VC++ Redistributable silently (only if not already installed) --
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Visual C++ Runtime..."; Check: not VCRedistInstalled; Flags: waituntilterminated

; -- Launch app after install --
Filename: "{app}\{#AppExeName}"; Description: "Launch Showroom Pulse ERP"; Flags: nowait postinstall skipifsilent

; ============================================================
[UninstallDelete]
; -- Only clean install directory itself --
Type: dirifempty; Name: "{app}"

; ============================================================
[Code]
// Check if Visual C++ Redistributable is installed
function VCRedistInstalled: Boolean;
begin
  Result := RegKeyExists(HKLM, 'SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64');
end;

// Recursively delete a directory
procedure DelTreeDir(const DirName: string);
begin
  if DirExists(DirName) then
    DelTree(DirName, True, True, True);
end;

// On uninstall: allow selective cleanup for safer support workflows
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    if MsgBox(
      'Do you want to reset ONLY activation/license cache?' + #13#10 +
      '(Keeps database, customer records, and media files)' + #13#10 + #13#10 +
      'Click YES to clear only license cache.' + #13#10 +
      'Click NO to continue.',
      mbConfirmation, MB_YESNO
    ) = IDYES then
    begin
      // Clear only Flutter shared preferences used for activation cache.
      // Covers both the pre-rebrand and current AppData folder names.
      DelTreeDir(ExpandConstant('{userappdata}\com.example\tahir_showroom'));
      DelTreeDir(ExpandConstant('{userappdata}\com.example\AL-TAHIR Showroom'));
      DelTreeDir(ExpandConstant('{userappdata}\com.example\Showroom Pulse'));
      RemoveDir(ExpandConstant('{userappdata}\com.example'));
      Exit;
    end;

    if MsgBox(
      'Do you want to delete ALL application data?' + #13#10 +
      '(Database, customer records, media files, and settings)' + #13#10 + #13#10 +
      'Click YES to delete everything (fresh start on reinstall).' + #13#10 +
      'Click NO to keep your data for future use.',
      mbConfirmation, MB_YESNO
    ) = IDYES then
    begin
      // 1. Delete Isar Database & Media. Covers both the pre-rebrand folder
      //    name (TahirShowroom) and the current one (ShowroomPulse), since
      //    the app migrates the folder on first launch but older installs
      //    that never relaunched after an update may still be on the old name.
      DelTreeDir(ExpandConstant('{userdocs}\TahirShowroom'));
      DelTreeDir(ExpandConstant('{userdocs}\ShowroomPulse'));

      // 2. Delete SharedPreferences (Flutter app data in AppData\Roaming)
      DelTreeDir(ExpandConstant('{userappdata}\com.example\tahir_showroom'));
      DelTreeDir(ExpandConstant('{userappdata}\com.example\AL-TAHIR Showroom'));
      DelTreeDir(ExpandConstant('{userappdata}\com.example\Showroom Pulse'));

      // 3. Try to clean up parent com.example folder if empty
      RemoveDir(ExpandConstant('{userappdata}\com.example'));
    end;
  end;
end;
