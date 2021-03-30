Write-Host "`n"

#################################
#          .gitconfig
#
#################################
Function copyGitConfig {
  Write-Host -ForegroundColor Yellow "Copying global .gitconfig..."
  $gitUsername = Read-Host "Git username: "
  $gitEmail = Read-Host "Git email address: "

  try {
    Copy-Item .\.gitconfig $HOME\.gitconfig -ErrorAction 'Stop'
    Add-Content -Path $HOME\.gitconfig -Value ("`r`n[user]`r`n  name = $($gitUsername)`r`n  email = $($gitEmail)") -ErrorAction 'Stop'
    Write-Host -ForegroundColor Green ".gitconfig installed at $($HOME)\.gitconfig`n"
  }
  catch {
    Write-Host -ForegroundColor Red "An error occurred installing .gitconfig:"
    Write-Host "$_`n";
  }
}

if (!(Test-Path $HOME\.gitconfig)) {
  copyGitConfig
}
else {
  $gitconfigChoice = Read-Host "Global .gitconfig exists. Replace with dotfiles version? (Y/n)"
  if ($gitconfigChoice -ne "n" -and $gitconfigChoice -ne "N") {
    copyGitConfig
  }
  else {
    Write-Host -ForegroundColor Yellow ".gitconfig will not be replaced.`n"
  }
}

#################################
#          GIT HOOKS
#    
#################################
try {
  $hooksPath = $(git config --global --get core.hooksPath)
  if ([String]::IsNullOrEmpty($hooksPath) -or !$hooksPath.Contains("dotfiles-windows")) {
    $copyGitHooksChoice = Read-Host "git global core.hooksPath is not set to dotfiles-windows. Update config? (Y/n)"
    if ($copyGitHooksChoice -ne "N" -and $copyGitHooksChoice -ne "n") {
      $(git config --global core.hooksPath "$((Get-Item -Path .).FullName)\githooks")
    }
  }
}
catch { }

#################################
#           VS CODE
#    Shan.code-settings-sync
#################################

Function vsCodeSettings {
  $settingsSyncExtensionName = "Shan.code-settings-sync"
  $settingsSyncInstalled = code --list-extensions | ? { $_ -eq $settingsSyncExtensionName }

  if (![String]::IsNullOrEmpty($settingsSyncInstalled)) {
    Write-Host -ForegroundColor Yellow "VS Code Extension $settingsSyncExtensionName is installed.`nUse it to manage VS Code user settings.`n"
  }
  else {
    Write-Host -ForegroundColor Yellow "Installing VS Code extension $settingsSyncExtensionName..."
    code --install-extension "$settingsSyncExtensionName"
  }
}

if ($env:Path.ToLower().Contains("microsoft vs code")) {
  vsCodeSettings
}
else {
  Write-Host -ForegroundColor Red "Could not find code in PATH. Either VS Code is not installed or has  not been added to your PATH."
}

#################################
#           ConEmu
#    
#################################
$conEmuInstallPath = "C:\Program Files\ConEmu"
if (Test-Path $conEmuInstallPath) {
  Write-Host "ConEmu found at $($conEmuInstallPath).`nInstalling config..."
  Copy-Item .\conemu\ConEmu.xml "$($conEmuInstallPath)\ConEmu.xml"
}
else {
  Write-Host -ForegroundColor Yellow "Could not find ConEmu in C:\ProgramFiles.`nAre you using a portable installation?"
}


#################################
#          POWERTOOLS
#    
#################################
$psScriptHome = Join-Path $(Split-Path $PROFILE) Scripts

if (-Not (Test-Path $(Join-Path $psScriptHome davebrothers.powertools))) {
    Write-Host -ForegroundColor Yellow "Could not find davebrothers.powertools in $psScriptHome."
    $installPowerToolsChoice = Read-Host "Clone powertools into $($psScriptHome)? (Y/n)"
    if ($installPowerToolsChoice -ne "N" -and $installPowerToolsChoice -ne "n") {
      if (Test-Path $(Join-Path $psScriptHome davebrothers.powertools)) {
        Remove-Item $(Join-Path $psScriptHome davebrothers.powertools)
      }
      git clone git@github.com:davebrothers/PowerTools.git $psScriptHome davebrothers.powertools
    }
  }
