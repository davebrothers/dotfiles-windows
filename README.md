# dotfiles-windows
Windows dotfiles

## Installation
Run `install.ps1`:
- Copies `.gticonfig` to $env:HOME directory (default user location).
- Checks if [`Shan.code-settings-sync`](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync) is installed for VS Code.
- Checks if [`davebrothers.powertools`](https://github.com/davebrothers/PowerTools) is installed.
  - If not and you accept the clone, any existing $env:HOME\Documents\WindowsPowerShell directory will be replaced.
  
  You will need to copy `ConEmu.xml` to wherever ConEmu is installed.
