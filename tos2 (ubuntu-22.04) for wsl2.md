# WinGet
> Documentation (https://learn.microsoft.com/en-us/windows/package-manager/winget/)
> GitHub (https://github.com/microsoft/winget-cli)

- Command Line Run at Administrator
  - Check the packages currently installed on your PC
    ```sh
    winget list PowerShell
    winget list WindowsTerminal
    ```
  - Korean
    ```sh
    winget list "Linux용 Windows 하위 시스템"
    ```

  - English
    ```
    winget list "Windows Subsystem for Linux" 
    ```

# PowerShell
> Documentation (https://learn.microsoft.com/en-us/powershell/)  
> GitHub (https://github.com/PowerShell/PowerShell)  

- Remove Old Version
  - Search > <윈도우 기능 켜기/끄기(Korean) | Turn windows Features on or off(English)>
  - Window PowerShell 2.0 [Unckecked]

- Install New Version
  ```
  winget install --id Microsoft.PowerShell
  ```

# Window Terminal 
> Documentation (https://learn.microsoft.com/en-us/windows/terminal/install)  
> GitHub (https://github.com/microsoft/terminal)  

- Install Preview Version
```sh
winget install --id Microsoft.WindowsTerminal.Preview
```

# WSL
> Documentation (https://learn.microsoft.com/en-us/windows/wsl)  
> GitHub (https://github.com/microsoft/WSL)  
>> Linux-Kernel (https://github.com/microsoft/WSL2-Linux-Kernel)  

- Update
```
wsl --update
```

- Run when **wsl command not found**
  - Korean
    ```sh
    winget list "Linux용 Windows 하위 시스템"
    ```

  - English
    ```
    winget list "Windows Subsystem for Linux" 
    ```

## 
# WSL Ubuntu
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

# Connected to USB Device
- PowerShell for Administrator
```shell
> winget install usbipd
...
Found usbipd-win [dorssel.usbipd-win] Version 2.3.0
This application is licensed to you by its owner.
Microsoft is not responsible for, nor does it grant any licenses to, third-party packages.
Downloading https://github.com/dorssel/usbipd-win/releases/download/v2.3.0/usbipd-win_2.3.0.msi
  ██████████████████████████████  10.4 MB / 10.4 MB
Successfully verified installer hash
Starting package install...
Installed successfully

> usbipd wsl list
BUSID  VID:PID    DEVICE                                                        STATE
1-1    04d9:a0f8  USB Input Device                                             Not attached
1-6    0955:7e19  APX                                                          Not attached

> usbipd wsl attach --busid 1-6
```
  
- Tos
```shell
> sudo apt install linux-tools-generic hwdata
> sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/$(ls /usr/lib/linux-tools/)/usbip 20       

> lsusb
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
Bus 001 Device 003: ID 0955:7e19 NVIDIA Corp. APX
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
```

# USB Camera & CAN with Kernel Build
```shell
> sudo apt install git bc build-essential flex bison libssl-dev libelf-dev libncurses-dev
```
  
```shell
> KERVER=$(uname -r -v | cut -d '-' -f1) 
  
> git clone --depth 1 -b linux-msft-wsl-${KERVER} https://github.com/microsoft/WSL2-Linux-Kernel.git ${KERVER}-microsoft-standard
> cd ${KERVER}-microsoft-standard

> make KCONFIG_CONFIG=Microsoft/config-wsl menuconfig (should have an '*')
  - Device Drivers -> Enable Multimedia support
    - Multimedia support -> Media Drivers: Enable Media USB Adapters
      - Media USB Adapters: Enable USB Video Class (UVC)
  - Networking support -> Enable CAN bus subsystem support
    - Enable Raw CAN Protocol
    - Enable Broadcast Manager
    - Enable SAE J1939
    - ISO 1576-2:2016 CAN transport protocol
    - CAN Device Drivers ->
      - Enable Virtual Local CAN Interface
      - Enable Serial / USB serial CAN Adaptors
      - Enable Platform CAN drivers with Netlink support
      - Enable CAN bit-timing calculation
      - CAN USB interfaces ->
        - Enable Kvaser CAN/USB interface
        - Enable Microchip CAN BUS Analyzer interface
        - Enable PEAK PCAN-USB/USB Pro interfaces for CAN 2.0b/CAN-FD
  
> make -j8
  
```  
