; ============================================================
;  AL-TAHIR Showroom ERP - Inno Setup Script
;  Version: 1.0.1
;  Developed by: Creative District
;  Developers: Moazam Samoo & Tameer Ahmed Khyber
; ============================================================

#define AppName      "AL-TAHIR Showroom"
#define AppVersion   "1.0.1"
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
DefaultDirName={pf}\ALTAHIRShowroom
DefaultGroupName={#AppName}
DisableProgramGroupPage=yes

; ---- Output ----
OutputDir=C:\InnoSetup\Output
OutputBaseFilename=ALTahirShowroom_Setup_v1.0.1

; ---- Compression ----
Compression=lzma2/ultra
SolidCompression=yes

; ---- Installer Visuals ----
WizardStyle=modern
ShowLanguageDialog=no

; ---- Version Info (helps reduce SmartScreen warnings) ----
VersionInfoVersion=1.0.1.0
VersionInfoCompany={#AppPublisher}
VersionInfoDescription=AL-TAHIR Showroom ERP Installer
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
Source: "C:\Users\Moazzam Samoo\Desktop\Tahir Showroom\installer\vc_redist.x64.exe"; DestDir: "{tmp}"; Flags: deleteafterinstall

; -- Main App & all DLLs --
Source: "C:\Users\Moazzam Samoo\Desktop\Tahir Showroom\build\windows\x64\runner\Release\{#AppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\Moazzam Samoo\Desktop\Tahir Showroom\build\windows\x64\runner\Release\*.dll";          DestDir: "{app}"; Flags: ignoreversion recursesubdirs
Source: "C:\Users\Moazzam Samoo\Desktop\Tahir Showroom\build\windows\x64\runner\Release\data\*";         DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs

; ============================================================
[Icons]
; -- Desktop Shortcut --
Name: "{autodesktop}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: desktopicon; IconFilename: "{app}\{#AppExeName}"

; -- Start Menu Shortcut --
Name: "{autoprograms}\{#AppName}\{#AppName}";   Filename: "{app}\{#AppExeName}"; Tasks: startmenuicon
Name: "{autoprograms}\{#AppName}\Uninstall";     Filename: "{uninstallexe}"

; -- Startup (optional) --
Name: "{autostartup}\{#AppName}"; Filename: "{app}\{#AppExeName}"; Tasks: startupicon

; ============================================================
[Run]
; -- Install VC++ Redistributable silently (only if not already installed) --
Filename: "{tmp}\vc_redist.x64.exe"; Parameters: "/install /quiet /norestart"; StatusMsg: "Installing Visual C++ Runtime..."; Check: not VCRedistInstalled; Flags: waituntilterminated

; -- Launch app after install --
Filename: "{app}\{#AppExeName}"; Description: "Launch AL-TAHIR Showroom ERP"; Flags: nowait postinstall skipifsilent

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

// On uninstall: ask user if they want to wipe ALL app data
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usUninstall then
  begin
    if MsgBox(
      'Do you want to delete ALL application data?' + #13#10 +
      '(Database, customer records, media files, and settings)' + #13#10 + #13#10 +
      'Click YES to delete everything (fresh start on reinstall).' + #13#10 +
      'Click NO to keep your data for future use.',
      mbConfirmation, MB_YESNO
    ) = IDYES then
    begin
      // 1. Delete Isar Database & Media (Documents\TahirShowroom\)
      DelTreeDir(ExpandConstant('{userdocs}\TahirShowroom'));

      // 2. Delete SharedPreferences (Flutter app data in AppData\Roaming)
      DelTreeDir(ExpandConstant('{userappdata}\com.example\tahir_showroom'));
      DelTreeDir(ExpandConstant('{userappdata}\com.example\AL-TAHIR Showroom'));

      // 3. Try to clean up parent com.example folder if empty
      RemoveDir(ExpandConstant('{userappdata}\com.example'));
    end;
  end;
end;
