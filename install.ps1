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
#           VS CODE
#    Shan.code-settings-sync
#################################

Function vsCodeSettings {
  $settingsSyncExtensionName = "Shan.code-settings-sync"
  $settingsSyncInstalled = code --list-extensions | ? { $_ -eq $settingsSyncExtensionName }

  if (![String]::IsNullOrEmpty($settingsSyncInstalled)) {
    Write-Host -ForegroundColor Yellow "VS Code Extension $settingsSyncExtensionName is installed.`nUse it to manage user settings.`n"
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
  Write-Host -ForegroundColor Red "Could no find code in PATH. Either VS Code is not installed or has  not been added to your PATH."
}

#################################
#          POWERTOOLS
#    
#################################
$powertoolsInstallLocation = "$env:HOME\Documents\WindowsPowerShell"

if (!(Get-Module "davebrothers.powertools")) {
  Write-Host -ForegroundColor Yellow "Could not find davebrothers.powertools."
  $installPowerToolsChoice = Read-Host "Clone powertools into $($powertoolsInstallLocation)? (Y/n)"
  if ($installPowerToolsChoice -ne "N" -and $installPowerToolsChoice -ne "n") {
    if (Test-Path $powertoolsInstallLocation) {
      Remove-Item $powertoolsInstallLocation
    }
    git clone git@github.com:davebrothers/PowerTools.git $powertoolsInstallLocation
  }
}
