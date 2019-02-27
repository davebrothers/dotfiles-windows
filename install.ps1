Write-Host "`n"

#################################
#          .gitconfig
#################################

if (!(Test-Path $HOME\.gitconfig)) {
   copyGitConfig

} else {
    $gitconfigChoice = Read-Host "Global .gitconfig exists. Replace with dotfiles version? (Y/n)"
    if (!$gitconfigChoice -eq 'n' -and !$gitconfigChoice -eq 'N') {
        copyGitConfig
    } else {
        Write-Host -ForegroundColor Yellow ".gitconfig will not be replaced.`n"
    }
}

Function copyGitConfig {
    Write-Host -ForegroundColor Yellow "Copying global .gitconfig..."
    $gitUsername = Read-Host "Git username: "
    $gitEmail = Read-Host "Git email address: "

    try {
        Copy-Item .\.gitconfig $HOME\.gitconfig -ErrorAction 'Stop'
        Add-Content -Path $HOME\.gitconfig -Value ("`r`n[user]`r`n  name = $($gitUsername)`r`n  email = $($gitEmail)") -ErrorAction 'Stop'
        Write-Host -ForegroundColor Green ".gitconfig installed at $($HOME)\.gitconfig`n"
    } catch {
        Write-Host -ForegroundColor Red "An error occurred installing .gitconfig:"
        Write-Host "$_`n";
    }
}

#################################
#           VS CODE
#    Shan.code-settings-sync
#################################

if ($env:Path.ToLower().Contains("microsoft vs code")) {
    vsCodeSettings
} else {
    Write-Host -ForegroundColor Red "Could no find code in PATH. Either VS Code is not installed or has  not been added to your PATH."
}

Function vsCodeSettings {
    $settingsSyncExtensionName = "Shan.code-settings-sync"
    $settingsSyncInstalled = code --list-extensions | ? { $_ -eq $settingsSyncExtensionName }

    if (![String]::IsNullOrEmpty($settingsSyncExtensionName)) {
        Write-Host -ForegroundColor Yellow "VS Code Extension $settingsSyncExtensionName is installed.`nUse it to manage user settings.`n"
    } else {
        Write-Host -ForegroundColor Yellow "Installing VS Code extension $settingsSyncExtensionName..."
        code --install-extension "$settingsSyncExtensionName"
    }
}