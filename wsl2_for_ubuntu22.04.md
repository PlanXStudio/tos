# Change PowerShell to V7.x from V2.0
- Search > Turn windows Features on or off
  - Disable Window PowerShell 2.0
- https://github.com/PowerShell/PowerShell
  - Windows (x64) | Downloads (LTS)
  - install

# Window Terminal (https://github.com/microsoft/terminal)
- Microsoft Store
  - Search > Windows Terminal Preview
  - install
- Run > Setting
  - Start > Default Profile > PowerShell 
    - Save

# WSL2 Install or upgrade
- PowerShell
```shell
wsl --install
wsl --upgrade
```

# Ubuntu 22.04 with WSL2
- Custom
  - Microsoft Store
    - Search > Ubuntu 22.04 LTS
    - install
- Tos Lite for Ubuntu 22.04
  - [Link](https://koreaoffice-my.sharepoint.com/:u:/g/personal/devcamp_korea_edu/EU4SYg8BnTlNmw5FOOqXJkwBWjKSLI70lRymqrlPLTA6Rg?e=Ag7mic)

# How to Login as <account> on Ubuntu-22.04 with Windows WSL2
- PowerShell
```shell
ubuntu2204 config --default-user <account>
```
