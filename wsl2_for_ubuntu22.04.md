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

# Connected to USB Device
- PowerShell for Administrator
```shell
> winget install usbipd
'msstore' 원본을 사용하려면 다음 계약을 확인해야 합니다.
Terms of Transaction: https://aka.ms/microsoft-store-terms-of-transaction
원본이 제대로 작동하려면 현재 컴퓨터의 두 글자 지리적 지역을 백 엔드 서비스로 보내야 합니다(예: "미국").

모든 원본 사용 약관에 동의하십니까?
[Y] 예  [N] 아니요: <y>
찾음 usbipd-win [dorssel.usbipd-win] 버전 2.3.0
이 응용 프로그램의 라이선스는 그 소유자가 사용자에게 부여했습니다.
Microsoft는 타사 패키지에 대한 책임을 지지 않고 라이선스를 부여하지도 않습니다.
Downloading https://github.com/dorssel/usbipd-win/releases/download/v2.3.0/usbipd-win_2.3.0.msi
  ██████████████████████████████  10.4 MB / 10.4 MB
설치 관리자 해시를 확인했습니다.
패키지 설치를 시작하는 중...
설치 성공

> usbipd wsl list
BUSID  VID:PID    DEVICE                                                        STATE
1-1    04d9:a0f8  USB 입력 장치                                                 Not attached
1-6    0955:7e19  APX                                                           Not attached
1-8    152d:0562  UAS(USB Attached SCSI) 대용량 저장 장치                       Not attached
1-10   0000:0538  USB 입력 장치                                                 Not attach

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
