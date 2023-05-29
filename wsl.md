# Before start
- **Command Line Run at Administrator**

## WinGet
> Documentation (https://learn.microsoft.com/en-us/windows/package-manager/winget/)  
> GitHub (https://github.com/microsoft/winget-cli)

- Check the packages currently installed on your PC
  ```sh
  winget list Microsoft.PowerShell
  winget list Microsoft.WindowsTerminal
  winget list "Windows Subsystem for Linux" 
  ```
- Find a package in the package repository  
  ```sh
  winget search Microsoft.PowerShell
  winget search Microsoft.WindowsTerminal
  winget search "Windows Subsystem for Linux" 
  ```

## PowerShell
> Documentation (https://learn.microsoft.com/en-us/powershell/)  
> GitHub (https://github.com/PowerShell/PowerShell)  

- Remove Old Version
  - Korean
    - Search > 윈도우 기능 켜기/끄기
  - English
    - Search > Turn windows Features on or off
  - Unchecked
    - Window PowerShell 2.0  

- Install New Version (Preview)
  ```
  winget install Microsoft.PowerShell.Preview
  ```

## Window Terminal 
> Documentation (https://learn.microsoft.com/en-us/windows/terminal/install)  
> GitHub (https://github.com/microsoft/terminal)  

- Install Preview Version
  ```sh
  winget install --id Microsoft.WindowsTerminal.Preview
  ```

- Install Nerd Fonts (https://www.nerdfonts.com/)
  - Download [MesloG Neard Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.1/Meslo.zip)
  - Unzip Meslo.zip and Install

- Settings (Ctrl + ,)
  - Korean
    ```sh
    시작 >
      기본 프로필 > PowerShell
      기본 터미널 응용 프로그램 > Windows 터미널 미리 보기
    색 구성표 > 
      Tango Dark > 기본값으로 설정
    프로필 > 
      기본값 > 추가 설정
        모양 >
          글꼴 > LesloLGS Nerd Font
          투명성 > 배경 불투명도 > 90%
        고급 >
          프로필 종료 동작 > 프로세스가 종료, 실패 또는 충돌 시 닫기
    저장
    ```
  - English
    ```sh
    Startup >
      Default profile > PowerShell
      Default terminal application > Windows Terminal Preview
    color schemes > 
      Tango Dark > Set as default
    Profiles > 
      Defaults > Additional settings
        Appearance >
          Font face > LesloLGS Nerd Font
          Transparency > Background opacity > 90%
        Advanced >
          Profile termination behavior > Close when precess exits, fails, or crashes
    Save
    ```

## OhMyPosh (PowerShell Theme)
> Documentation (https://ohmyposh.dev/docs/installation/windows)  

- Run WindowsTerminal 
  - Open a new tab > `<Ctrl>` + PowerShell 
  ```sh
  winget install JanDeDobbeleer.OhMyPosh -s winget
  ```
  
- Setting theme
  > Themes (https://ohmyposh.dev/docs/themes)
  - Check theme
    ```
    oh-my-posh init pwsh --config '~\AppData\Local\Programs\oh-my-posh\themes\<theme_name>.omp.json' | Invoke-Expression
    ```
  
  - Save (powerlevel10k_rainbow)
    ```sh
    mkdir ~/Documents/PowerShell
    notepad $PROFILE
    -----------------------------------------------------------------------------------------------------------------------------
    oh-my-posh init pwsh --config '~\AppData\Local\Programs\oh-my-posh\themes\powerlevel10k_rainbow.omp.json' | Invoke-Expression
    -----------------------------------------------------------------------------------------------------------------------------
    ```

# WSL
> Documentation (https://learn.microsoft.com/en-us/windows/wsl)  
> GitHub (https://github.com/microsoft/WSL)  
>> Linux-Kernel (https://github.com/microsoft/WSL2-Linux-Kernel)  

- Update
  ```
  wsl --update
  ```

- Run when **wsl command not found** (at Administrator)
  ```sh
  winget install "Windows Subsystem for Linux" 
  ```

## Ubuntu-22.04
- Install
  ```
  wsl --install -d Ubuntu-22.04
  ...
  {add user (id, password) processing...}
  ...  
  exit
  ```

- How to Login as <account>
  ```sh
  ubuntu2204 config --default-user <account>
  ```
## Advanced settings
> Documentation (https://learn.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig)

```sh
sudo vi /etc/wsl.conf
-----------------------------
[user]
default = <your_account>

[network]
hostname = <your_hostname>

[boot]
systemd = true
-----------------------------  
```
  
## Connected to USB Device
> Documentation (https://learn.microsoft.com/en-us/windows/wsl/connect-usb)
> GitHub (https://github.com/dorssel/usbipd-win)
  
- Run WindowsTerminal > PowerShell at Administrator
  - Install USBIPD
    ```sh
    winget install usbipd
    usbipd wsl list
    ```
  
  - Delegating Windows' USB Devices to WSL  
    ```sh
    usbipd wsl attach --busid <BUSID>
    ```

- Run Ubuntu-22.04
  - Install USBIP
    ```sh
    sudo apt install linux-tools-generic hwdata
    sudo update-alternatives --install /usr/local/bin/usbip usbip /usr/lib/linux-tools/$(ls /usr/lib/linux-tools/)/usbip 20
    ```
  
  - Check
    ```
    lsusb
    ```   

# Linux Kernel Build
> GitHub (https://github.com/microsoft/WSL2-Linux-Kernel)  

- Dependency
  ```sh
  sudo apt install git bc build-essential flex bison libssl-dev libelf-dev
  ```
  
- Download kernel source
  ```sh
  KERVER=$(uname -r -v | cut -d '-' -f1) 
  
  git clone --depth 1 -b linux-msft-wsl-${KERVER} https://github.com/microsoft/WSL2-Linux-Kernel.git ${KERVER}-microsoft-standard
  cd ${KERVER}-microsoft-standard
  ```
  
- Configuration kernel  
  ```sh
  make KCONFIG_CONFIG=Microsoft/config-wsl menuconfig 
  ...
  {select feature}
  ...
  ```
  
- Build
  ```sh
  make -j$(nproc)
  ```  

- Kernel Install
  ```
  sudo make install -j$(nproc)
  sudo cp -rf vmlinux /mnt/c/Users/<login_account>
  ```
  
- (Option) Module Install
  ```sh
  sudo make modules_install -j$(nproc)
  ```

- Run WindowsTerminal > PowerShell  
  ```sh
  cd ~
  wsl --shutdown
  notepad .wslconfig
  ---------------------------------
  [wsl2]
  networkingMode = bridged
  kernel = ~/vmlinux
  ---------------------------------
  ```
  
## USB Camera 
- Configuration kernel  
  ```sh
  - Device Drivers
    - <*> Multimedia support
      - [*] Filter media drivers
      - [*] Autoselect ancillary drivers
      - Media device types ---> [*] Cameras and video grabbers
      - Video4Linux options ---> [*] V4L2 sub-device userspace API
      - Media drivers -> [*] Media USB Adapters      
        - Media USB Adapters
          - <*> USB Video Class (UVC)
          - [*] UVC input events device support
          - <*> GSPCA based webcams
  ```

## CAN  
- Configuration kernel  
  ```sh
  - Networking support -> Enable CAN bus subsystem support
    - [*] Raw CAN Protocol
    - [*] Broadcast Manager
    - [*] SAE J1939
    - ISO 1576-2:2016 CAN transport protocol
    - CAN Device Drivers ->
      - [*] Virtual Local CAN Interface
      - [*] Serial / USB serial CAN Adaptors
      - [*] Platform CAN drivers with Netlink support
      - [*] CAN bit-timing calculation
      - CAN USB interfaces ->
        - [*] Kvaser CAN/USB interface
        - [*] Microchip CAN BUS Analyzer interface
        - [*] PEAK PCAN-USB/USB Pro interfaces for CAN 2.0b/CAN-FD
  ```
  
