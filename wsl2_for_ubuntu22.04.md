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

# Ubuntu 22.04 or Tos with WSL2
- Ubuntu 22.04
  - Microsoft Store
    - Search > Ubuntu 22.04 LTS
    - install
- Tos Lite with Ubuntu 22.04
  - [Link](https://koreaoffice-my.sharepoint.com/:u:/g/personal/devcamp_korea_edu/EU4SYg8BnTlNmw5FOOqXJkwBWjKSLI70lRymqrlPLTA6Rg?e=Ag7mic)
    - Download > Unzip at C:\Users\<login_name>\
  - PowerShell
    - change folder to C:\Users\<login_name>\
    ```shell
    wsl --import tos ./ tos_ubuntu-22.04.tar
    
    wsl -l -v
      NAME    STATE           VERSION
    * tos     Stopped         2    

    ls -l ext4.vhdx
    Mode            LastWriteTime         Length Name
    ----            -------------         ------ ----
    -a---     2022-05-02 am 11:03      535822336 ext4.vhdx    
    ```
    
# How to Login as <account> on Ubuntu 22.04 or Tos with WSL2
- Ubuntu 22.04 (default new account)
  - PowerShell
  ```shell
  ubuntu2204 config --default-user <account>
  ```
- Tos (default root)
  - Window Terminal > Setting > Tos
    - Command Line > wsl.exe -d tos -u tos --cd ~
    - icon > ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png
