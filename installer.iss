; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "WinDynamicDesktop"
#define MyAppVersion GetFileVersion("src\bin\Release\WinDynamicDesktop.exe")
#define MyAppPublisher "Timothy Johnson"
#define MyAppURL "https://github.com/t1m0thyj/WinDynamicDesktop"
#define MyAppExeName "WinDynamicDesktop.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{D457A4A2-5B1B-4767-97DF-F8F4FD36875E}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\{#MyAppName}
DisableProgramGroupPage=yes
LicenseFile=LICENSE
OutputDir=output
OutputBaseFilename={#MyAppName}_{#MyAppVersion}_Setup
Compression=lzma
SolidCompression=yes
ChangesAssociations=yes
CloseApplications=force
PrivilegesRequired=lowest

[Code]
function IsNet45OrNewer(): Boolean;
var
  readVal: Cardinal;
  success: Boolean;
begin
  success := RegQueryDWordValue(HKLM, 'Software\Microsoft\NET Framework Setup\NDP\v4\Full',
    'Release', readVal);
  Result := success and (readVal >= 378389);
end;

function InitializeSetup(): Boolean;
begin
  if not IsNet45OrNewer() then begin
    MsgBox('{#MyAppName} requires Microsoft .NET Framework 4.5 or newer to be installed.'#13#13
      'Download and install .NET Framework from'#13
      'http://www.microsoft.com/net/ and then rerun Setup.', mbCriticalError, MB_OK);
    Result := false;
  end else
    Result := true;
end;

procedure DeleteUserData;
begin
  DelTree(ExpandConstant('{app}\themes'), true, true, true);
  DeleteFile(ExpandConstant('{app}\settings.conf'));
  DeleteFile(ExpandConstant('{app}\{#MyAppExeName}.log'));
  DeleteFile(ExpandConstant('{app}\{#MyAppExeName}.pth'));
  RemoveDir(ExpandConstant('{app}'));
end;

procedure CurUninstallStepChanged(CurUninstallStep : TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then begin
    if MsgBox('Do you want to delete user data ({#MyAppName} settings and theme files)?',
        mbConfirmation, MB_YESNO or MB_DEFBUTTON2) = IDYES then
      DeleteUserData;
  end;
end;

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "startonboot"; Description: "&Start {#MyAppName} with Windows"; GroupDescription: "Other tasks:"
Name: "registerddw"; Description: "&Associate .ddw extension with {#MyAppName}"; GroupDescription: "Other tasks:"

[Files]
Source: "src\bin\Release\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{commonprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Software\Microsoft\Windows\CurrentVersion\Run"; ValueType: string; ValueName: "{#MyAppName}"; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletevalue; Tasks: startonboot
Root: HKCU; Subkey: "Software\Classes\.ddw"; ValueType: string; ValueName: ""; ValueData: "{#MyAppName}.DynamicDesktopWallpaper"; Flags: uninsdeletekeyifempty uninsdeletevalue; Tasks: registerddw
Root: HKCU; Subkey: "Software\Classes\{#MyAppName}.DynamicDesktopWallpaper"; ValueType: string; ValueName: ""; ValueData: "Dynamic Desktop Wallpaper"; Flags: uninsdeletekey; Tasks: registerddw
Root: HKCU; Subkey: "Software\Classes\{#MyAppName}.DynamicDesktopWallpaper\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName}"; Flags: uninsdeletekey; Tasks: registerddw
Root: HKCU; Subkey: "Software\Classes\{#MyAppName}.DynamicDesktopWallpaper\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey; Tasks: registerddw

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[UninstallRun]
Filename: "{sys}\taskkill.exe"; Parameters: "/f /im {#MyAppExeName}"; Flags: runhidden skipifdoesntexist

