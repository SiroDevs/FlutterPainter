; FlutterPainter installer – CI-friendly. Values are injected with ISCC /D switches:
;   /DMyAppVersion=1.0.0  /DSourceDir=<Release folder>  /DRepoRoot=<repo root>
;   /DOutputDir=<dist>    /DArch=x64|arm64
; Defaults below let you still compile locally from windows\packaging.

#ifndef MyAppVersion
  #define MyAppVersion "1.0.0"
#endif
#ifndef Arch
  #define Arch "x64"
#endif
#ifndef RepoRoot
  #define RepoRoot "..\.."
#endif
#ifndef SourceDir
  #define SourceDir RepoRoot + "\build\windows\" + Arch + "\runner\Release"
#endif
#ifndef OutputDir
  #define OutputDir RepoRoot + "\dist"
#endif

#define MyAppName "FlutterPainter"
#define MyAppPublisher "Siro Devs"
#define MyAppURL "https://sirodevs.com/flutterpainter"
#define MyAppExeName "FlutterPainter.exe"

[Setup]
; Must stay different from SongLib's {884424F7-F8DD-4CF6-8BC3-5E8126A7893D}
AppId={{9B6E2B7D-7B3B-4E9E-9E2F-2E7B7B6B7B3F}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
#if Arch == "arm64"
ArchitecturesAllowed=arm64
ArchitecturesInstallIn64BitMode=arm64
#else
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
#endif
OutputDir={#OutputDir}
OutputBaseFilename={#MyAppName}_{#MyAppVersion}_{#Arch}
; One installer: defaults to a per-user install, and offers
; "Install for all users" (UAC prompt) at the start of the wizard.
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
SetupIconFile={#RepoRoot}\windows\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#SourceDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent
