# 부팅

## 부트 파일 시스템
rpi는 fat32 형식의 부트 파일 시스템과 ext4 형식의 리눅스 루트 파일 시스템으로 구성됩니다.
부트 파일 시스템인 /boot는 윈도우 PC에서 접근 가능합니다. 

<details>
<summary>rpi 부트 파일 시스템</summary>
  
boot의 역할은 다음과 같습니다.  

- 부팅 프로세스 시작: 라즈베리 파이에 전원이 공급되면 GPU가 부트 파일 시스템에서 필요한 파일들을 로드하여 부팅 프로세스 시작
- 커널 로드 및 실행: GPU는 kernel.img를 로드하고, cmdline.txt 및 config.txt에 지정된 설정에 따라 커널 실행
- 루트 파일 시스템 마운트: 커널은 cmdline.txt에 지정된 위치에서 루트 파일 시스템을 찾아 마운트하고, 사용자 공간 프로세스를 시작하여 운영 체제를 완전히 부팅

boot에 포함된 핵심 파일의 의미입니다.

- kernel.img: 라즈베리 파이의 운영 체제 커널 이미지. 시스템 부팅 과정에서 로드되어 메모리에 실행됨
- config.txt: 라즈베리 파이의 하드웨어 설정을 담당하는 중요한 파일. GPU 메모리 할당, 오버클럭 설정, 부팅 장치 선택 등 다양한 설정 포함
- cmdline.txt: 커널 부팅 시 전달되는 커널 매개변수 지정. 콘솔 장치, 루트 파일 시스템 위치, 네트워크 설정 등 포함
- userconf.txt: 첫 번째 부팅 시 추가할 계정 포함. id와 암호화된 passwd로 구성
- ssh: 빈 파일로, 해당 파일이 있으면 SSH 서버 실행
- bcm2711-rpi-4-b.dtb: 라즈베리 파이 4 모델 B의 장치 트리 정의. 하드웨어 구성 정보를 커널에 제공
- start.elf: GPU 펌웨어 파일로, GPU 초기화 및 비디오 출력 설정 담당
- bootcode.bin: GPU 부트 로더 파일로, start.elf를 로드하고 실행 역할
- fixup.dat: GPU 펌웨어 패치 파일로, 특정 하드웨어 문제를 해결하거나 기능을 추가하기 위해 사용
- overlays: 장치 트리 오버레이 파일들을 저장하는 디렉터리. 특정 하드웨어 기능을 활성화하거나 설정을 변경하기 위해 사용
</details>  


다음과 같이 윈도우 PC의 파워쉘에서 부트 파일 시스템의 설정 파일을 수정합니다.

1. 윈도우용 wget을 설치합니다.
```sh
winget install --id GNU.Wget2
```

2. Raspberry Pi Imager로 T-Flash 카드(이하 T-Flash)에 이미지를 설치합니다.
- OS는 Rsaspberry Pi OS (other) > Raspberry Pi OS Lite (64-bit)를 선택합니다.
- id는 tos, 호스트 이름은 toheaven으로 가정합니다.

3. 설치가 완료되면 T-Flash의 부트 파일 시스템 경로(D:)로 이동해 기존 설정 파일을 삭제합니다.
```sh
cd D:
del cmdline.txt
del config.txt
```

4. 새로운 설정 파일을 다운로드 합니다.
- cmdline.txt에는 이더넷 주소를 192.168.101.101로 설정하는 커널 옵션이 포함되어 있습니다.

```sh
wget2 https://github.com/PlanXStudio/tos/raw/main/rpi/boot/cmdline.txt
wget2 https://github.com/PlanXStudio/tos/raw/main/rpi/boot/config.txt
```

5. T-Flash를 rpi에 삽입한 후 전원을 공급해 부팅합니다.

6. 약 1분 30초 후 PC와 rpi를 이더넷 케이블로 연결합니다.

7. rpi에 접속할 수 있도록 PC의 이더넷 주소를 192.168.101.120 등으로 설정합니다.
- <WIN><r> > ncpa.cpl > 이더넷 어댑터 > IPv4 속성

8. rpi에 ping 테스트를 수행해 봅니다.
```sh
ping 192.168.101.101
```

- 만약 응답이 없다면 IP 주소 대신 호스트 이름을 이용(toheaven.local)합니다.
```sh
ping tos.local
```

## SSH 키 생성
SSH 통신에 필요한 비대칭 키를 생성한 후 하나(private)는 PC, 나머지(public)는 rpi에 복사하면 PC에서 rpi에 원격 접속할 때 fingerprint 생성과 패스워드 요구를 생략합니다.

윈도우에서 키를 생성한 후 rpi에 복사하는 방법은 다음과 같습니다.

1. <WIN><r>을 누른 후 cmd를 입력해 명령창을 실행합니다.
2. ssh-keygen 명령으로 키를 생성합니다.
```sh
ssh-keygen -t rsa -b 4096
```

3. 키 저장 경로를 물으면 <Enter>를 눌러 디폴트 경로를 사용합니다. (디폴트 경로는 홈 폴더 아래 .ssh)
```sh
Generating public/private rsa key pair.
Enter file in which to save the key (C:\Users\devca/.ssh/id_rsa): <Enter>
```

4. 저장된 키에 대한 일종의 패스워드인 passphrase를 물으면 <Enter>를 눌러 생략합니다.
```sh
Enter passphrase (empty for no passphrase): <Enter>
Enter same passphrase again: <Enter>
```

5. 홈 폴더 아래 .ssh 폴더에 생성된 키가 보관되어 있습니다.
```sh
dir .ssh/*
```
```out
-a---      2024-04-05   오후 1:56           3369   id_rsa
-a---      2024-04-05   오후 1:56            734   id_rsa.pub
```

6. scp 명령을 이용해 PC에서 생성한 public 키를 rpi의 IP 주소와 id를 이용해 복사합니다. authorized_keys는 키를 보관하는 일종의 지갑입니다.
```sh
ssh tos@192.168.101.101 mkdir -p ~/.ssh

scp .ssh/id_rsa.pub tos@192.168.101.101:~/.ssh/authorized_keys
```

7. rpi에 로그인합니다.
```sh
ssh tos@192.168.101.101
```

## 패키지 정리

1. 패키지 정리 스크립트를 작성합니다.
```sh
vi rpi4-lite-pkg
```
```in
#!/bin/bash

PKG_LIST=" \
  avahi-daemon \
  bash-completion \
  cifs-utils \
  dc \
  dmidecode \
  dos2unix \
  dosfstools \
  ed \
  eject \ 
  fakeroot \
  fbset \
  firmware-atheros \
  firmware-libertas \
  firmware-misc-nonfree \
  firmware-realtek \
  gdisk \
  iptables \
  kbd \
  keyboard-configuration \
  keyutils \
  linux-headers-* \
  linux-kbuild-* \
  lua5.1 \
  luajit \
  manpages* \
  media-types \
  nano \
  nftables \ 
  p7zip* \
  parted \
  pi-bluetooth \
  triggerhappy \
  xkb-data \
  vim-*
  zstd \
"

FILE_LIST=" \
  /var/lib/apt/lists/* \
  /var/cache/debconf/*-old \
  /var/lib/dpkg/*-old \
  /var/log/* \
  /var/tmp/* \
  /var/swap/* \
  /tmp/* \
  /usr/games \
  /usr/share/locale \
  /usr/share/doc \
  /usr/share/man \
  /usr/share/terminfo \
  /usr/share/icons \
  /usr/share/pixmaps \
  /usr/share/menu \
  /usr/share/applications \
  /usr/local/games \
  /usr/local/man \
  /usr/local/share/man \
  /etc/xdg \
"

echo "===================="
echo "Package Cleaning"
echo "===================="

apt purge -y ${PKG_LIST}
find /lib/modules -maxdepth 1 -type d -not -name `uname -r` -exec apt purge -y {} +
apt autoremove

echo "==================="
echo "ReInstall Package"
echo "==================="

apt update
yes | apt -y upgrade

apt -y install vim git

echo "==================="
echo "FileSystem Cleaning"
echo "==================="

rm -rf ${FILE_LIST}
```

2. 실행 권한을 부여한 후 root 권한으로 실행합니다.

```sh
chmod 755 rpi4-lite-pkg
sudo ./rpi4-lite-pkg
```

3. 결과를 확인합니다.
```sh
df -h
```
```out
ilesystem      Size  Used Avail Use% Mounted on
udev            1.6G     0  1.6G   0% /dev
tmpfs           380M  5.9M  374M   2% /run
/dev/mmcblk0p2   59G  1.7G   54G   4% /
tmpfs           1.9G     0  1.9G   0% /dev/shm
tmpfs           5.0M   16K  5.0M   1% /run/lock
/dev/mmcblk0p1  510M   64M  447M  13% /boot/firmware
tmpfs           380M     0  380M   0% /run/user/1000
```

## vim 설정 

<details>
<summary>vim 기본 사용법</summary>

vim은 텍스트 편집기인 vi를 개선한 대표적인 리눅스 편집기로 명령어를 통해 텍스트를 효율적으로 편집하고 탐색하는 명령 모드와 일반적인 텍스트 편집기처럼 텍스트를 입력하는 입력 모드를 구분하여 사용합니다. 매크로를 비롯해 정규 표현식, 텍스트 객체, 플러그인 등 다양한 기능을 제공하여 복잡한 편집 작업을 효율적으로 수행할 수 있도록 도와줍니다.

```sh
vi
```

모든 파일 편집은 vim을 사용하므로 다음 내용만이라도 숙지한다면, 편리하게 작업을 완료할 수 있습니다.

1. vim은 다음과 같이 4가지 모드가 있습니다.
- Normal 모드: 커서 이동, 명령 입력 (기본 모드)
- Insert 모드: 텍스트 입력 (i, a, o 등으로 진입, Esc로 Normal 모드 복귀)
- Visual 모드: 텍스트 블록 선택 및 조작 (v, V, Ctrl-v로 진입, Esc로 Normal 모드 복귀)
- Command-line 모드: 명령 실행 (:로 진입, Enter 실행, Esc로 Normal 모드 복귀)

2. Normal 모드에서 수행하는 이동은 기본 이동과 검색으로 나뉩니다.
- 기본 이동
  - h, j, k, l: 좌, 하, 상, 우 이동
  - w, b: 다음 단어/이전 단어로 이동
  - e: 현재 단어 끝으로 이동
  - 0, $: 줄 시작/끝으로 이동
  - gg, G: 파일 시작/끝으로 이동
  - Ctrl-f, Ctrl-b: 화면 단위 아래/위로 이동
  - H, M, L: 화면 맨 위/중간/맨 아래로 이동
- 검색
  - /검색어: 앞으로 검색
  - ?검색어: 뒤로 검색
  - n: 다음 검색 결과
  - N: 이전 검색 결과

3. Insert 모드에서 수행하는 편집은 기능은 입력/삭제, 복사/붙여넣기로 나뉩니다.
- 입력 및 삭제
  - i, a, o: Insert 모드 진입 (현재 위치, 다음 문자, 다음 줄)
  - x: 현재 문자 삭제
  - dw: 현재 단어 삭제
  - dd: 현재 줄 삭제
  - D: 현재 커서부터 줄 끝까지 삭제
  - cc: 현재 줄 삭제 후 Insert 모드
- 복사 및 붙여넣기
  - yy: 현재 줄 복사
  - yw: 현재 단어 복사
  - p: 붙여넣기
  - P: 현재 줄 앞에 붙여넣기
- 실행 취소 및 재실행
  - u: 실행 취소
  - Ctrl-r: 재실행

4. Normal 모드에서 수행하는 저장 및 종료는 다음과 같습니다.
- :w: 저장
- :q: 종료
- :wq: 저장 후 종료
- :q!: 저장하지 않고 종료
- ZZ: 저장 후 종료 (Normal 모드에서)

5. 끝으로 기타 유용한 기능입니다.
- Visual 모드
  - v: 문자 단위 선택
  - V: 줄 단위 선택
  - Ctrl-v: 블록 단위 선택
  - 선택 후 d, y, c 등 편집 명령 적용
- 숫자 활용: 명령 앞에 숫자를 붙이면 반복 실행 (예: 3dd = 3줄 삭제)
- :help 명령: vim 도움말 확인

터미널에서 vimtutor 실행하여 기본 튜토리얼 학습을 진행해도 됩니다.
```sh
vimtutor
```
</details>


vim은 vimrc(또는 .vimrc) 파일을 통해 사용자의 취양에 맞게 vim의 동작 방식과 외관을 자유롭게 설정할 수 있습니다.  
vim은 설치되어 있으므로 설정 파일을 다운로드해 적용합니다.

1. /etc 경로에 vim 폴더를 만듧니다. 만약 /etc/vim 폴더가 존재한다면 삭제한 후 다시 만듦니다.
```sh
sudo mkdir /etc/vim
```

2. 사전 설정 파일인 vimrc를 다운로드 합니다.
```sh
sudo wget https://github.com/PlanXStudio/tos/raw/main/etc/vim/vimrc -O /etc/vim/vimrc
```

3. 플러그인 관리자인 Vundle을 다운로드 합니다.
```sh
sudo git clone https://github.com/VundleVim/Vundle.vim.git -O  /etc/vim/bundle/Vundle.vim
```

4. root 권한으로 vi를 실행합니다. 
```sh
sudo vi
```

5. 오류 메시지가 출력되는데, \<Enter>를 누릅니다.
```out
Error detected while processing VimEnter Autocommands for "*":
E185: Cannot find color scheme 'gruvbox'
Press ENTER or type command to continue
```

6. Command-line에서 다음과 같이 플러그인 설치 명령을 실행합니다.
```
PluginInstall
```

<details>
<summary>사전 설정 내용</summary>
  
- 터미널의 색상 기능을 지원하는 경우, 24비트 색상을 사용하도록 설정
- 구문 강조 기능 활성화 (파일 형식에 따라 코드를 색상으로 구분)
- 명령어 히스토리를 256개까지 저장 (이전에 입력한 명령어를 빠르게 불러와 재사용)
- 편집 중인 파일의 각 줄 왼쪽에 줄 번호 표시
- 창의 오른쪽 아래에 현재 커서의 위치 표시(행:열)
- 창 하단에 항상 상태 표시줄 표시(파일 이름, 파일 형식, 현재 모드 등)
- 상태 표시줄 사용자 정의(현재 줄/열 번호, 파일 경로, 수정 여부 등) 
- 커서가 화면 상하단에 가까워지면 자동으로 화면을 스크롤하여 커서 주변에 3줄 여백 유지
- Command-line 모드에서 탭 키를 누르면 사용 가능한 명령어 목록 표시. (자동 완성 기능 제공)
- 가장 긴 공통 부분까지 자동 완성하고, 가능한 모든 항목을 목록으로 표시
- 백업 파일, 스왑 파일, 쓰기 백업 파일 생성 비활성화
- 스마트 들여쓰기 기능을 활성화하여 코드의 논리적인 구조에 맞춰 자동으로 들여쓰기 설정
- 탭 문자 대신 공백 문자 사용
- 탭 문자 및 들여쓰기 너비를 4칸으로 설정
- 검색 시 대소문자 구분 않함
- 검색어에 대문자가 포함된 경우에만 대소문자 구분
- 검색 결과 강조 표시
- 검색 시 파일 끝에 도달하면 파일 처음부터 다시 검색
- 다른 프로그램에서 파일을 수정한 경우 자동으로 저장
- 다른 프로그램에서 파일을 수정한 경우 자동으로 다시 읽음
- 파일 인코딩을 UTF-8로 설정
- 파일 저장 전에 모든 줄 끝의 공백 문자 자동 제거
- \<Ctrl>+\<방향키>를 사용하여 분할 창 사이 이동
- 터미널 버퍼 크기를 100,000줄로 설정
- 터미널 모드에서 \<Ctrl>+\<R>을 눌렀을 때 특수 문자를 입력할 수 있도록 설정
- \<Alt>+\<방향키>를 사용하여 창 또는 패널 사이 이동
- Python 파일을 편집할 때 \<Ctrl>+\<F5>를 눌러 현재 파일 저장, 실행
</details>

## 관리자(root) 원격 접속 허용

1. root 패스워드(#tos!) 설정합니다.
```sh
yes '#tos!' | sudo passwd root
```

2./etc/ssh/sshd_config 파일에서 root 로그인을 허용합니다.
```sh
sudo sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/" /etc/ssh/sshd_config
```

3. SSH 서버를 재시작합니다.
```sh
sudo systemctl restart ssh.service
``` 

## CPU 스케일링 및 LED 부팅 완료 설정 
CPU governor는 CPU 주파수를 어떤 방식으로 조절할지 결정하는 알고리즘 또는 정책입니다. 각 governor는 다음과 같이  성능, 전력 소비, 반응 속도 등에 대한 다른 특성을 가지고 있습니다.
- performance: CPU를 항상 최대 주파수로 동작시킵니다. 최고의 성능을 제공하지만 전력 소비가 높습니다.
- powersave: CPU를 항상 최저 주파수로 동작시킵니다. 전력 소비를 최소화하지만 성능이 낮습니다.
- userspace: 사용자가 직접 CPU 주파수를 설정할 수 있도록 허용합니다.
- ondemand: CPU 사용량에 따라 주파수를 동적으로 조절합니다. 균형 잡힌 성능과 전력 소비를 제공합니다.
- conservative: ondemand와 비슷하지만 주파수 변경이 더 느리게 이루어집니다.

또한 rpi는 sysfs를 통해 녹색 플래시 카드 R/W LED(led0 or ACT)와 빨간색 파워 LED(led1 or PWR)에 대한 사용자 정의가 가능합니다. 

1. /etc/rc.local 파일의 마지막 줄(exit 0)을 삭제합니다.
```sh
sudo sed '$ d' /etc/rc.local -i
```

2. /etc/rc.local에 CPU 스케일링 및 LED 부팅 완료 설정을 추가합니다.
```sh
echo -e "echo performance | tee /sys/devices/system/cpu/cpufreq/policy0/scaling_governor\necho none > /sys/class/leds/ACT/trigger\necho 255 > /sys/class/leds/ACT/brightness\n\nexit 0" | sudo tee -a /etc/rc.local > /dev/null
```  

3. rpi를 다시 시작하면, 녹색 LED가 깜빡이지 않고 켜짐 상태를 유지합니다.
```sh
sudo reboot
```

## 메모리 스와핑 변경
메모리 스와핑은 자주 사용되지 않는 부분을 플래시 카드의 파일에 일시적으로 배치하여(dphys-swap) 작업 메모리를 늘립니다. 하지만 플래시 카드로 메모리에 로드할 데이터를 전송하는 것은 매우 느린 메커니즘입니다. 또한 플래시 카드가 견딜 수 있는 쓰기 횟수가 제한되어 빠르게 손상될 수 있습니다.
메모리 스와핑 문제를 해결하기 위해 zram을 사용합니다. zram은 메모리의 일부를 플래시 카드에 쓰는 대신 zip 파일로 압축하여 결과를 다시 RAM에 저장합니다. 압축된 데이터 크기와 원래 크기의 차이는 해제되는 메모리 양입니다. 번거롭게 들릴 수 있지만 실제로는 플래시 메모리에 쓰는 것보다 훨씬 빠른 메커니즘입니다. 단점은 더 큰 압축 파일을 저장할 공간이 없을 때의 RAM 크기입니다. 반면 원래 dphys-swap 파일은 2GB 플래시 메모리로 제한됩니다.

1. zram-tools을 설치합니다.
```sh
sudo apt install zram-tools
```

2. 기존 플래시 카드의 스왑 파일을 제거합니다.
```sh
sudo /etc/init.d/dphys-swapfile stop
sudo apt purge dphys-swapfile
sudo rm /var/swap
```

3. 결과를 확인합니다.
```sh
cat /proc/swaps
```
```out
Filename                                Type            Size            Used            Priority
/dev/zram0                              partition       262140          0               100
```

4. 만약 ZRAM 설정을 변경하려면 /etc/default/zramswap을 수정합니다.

5. ZRAM을 더 잘 활용하기 위해 vi로 /etc/sysctl.conf를 열고 끝에 다음 내용을 추가해 커널 매개변수를 수정합니다. 
```sh
vm.vfs_cache_pressure=500
vm.swappiness=100
vm.dirty_background_ratio=1
vm.dirty_ratio=50
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
```

<details>
<summary>ZRAM 커널 매개변수</summary>

- 더 높은 vm.vfs_cache_pressure 값은 시스템이 dentry와 inode에 사용된 메모리를 회수하는 데 더 공격적으로 만듭니다. 반대로, 더 낮은 값은 다른 캐시된 데이터를 희생하여 메모리에 보관하는 것을 우선시한다는 것을 의미합니다.
- vm.swappiness 는 시스템 페이지 캐시에서 페이지를 삭제하는 것과는 달리 런타임 메모리를 스왑 아웃하는 데 주어지는 상대적 가중치를 제어하는 ​​Linux의 커널 매개변수입니다. 값이 높을수록 커널이 물리적 메모리에서 프로세스를 적극적으로 스왑 아웃하여 스왑 공간으로 옮길 것입니다.
- vm.dirty_background_ratio 는 커널이 백그라운드에서 디스크에 쓰기 시작하기 전에 "더티" 페이지로 채울 수 있는 시스템 메모리의 백분율을 결정하는 조정 가능한 매개변수입니다. "더티" 페이지는 수정(또는 "더티")되었지만 아직 디스크의 해당 파일에 다시 쓰여지지 않은 메모리 페이지입니다. vm.dirty_background_ratio 는 백분율로 표현됩니다.
- vm.dirty_ratio 는 백분율을 나타내는 조정 가능한 매개변수입니다. 프로세스가 이러한 페이지를 디스크에 쓰기 시작하도록 강제하기 전에 "더티" 페이지로 채울 수 있는 총 시스템 메모리(RAM)의 최대 양을 지정합니다.
- Linux의 vm.page -cluster 커널 매개변수는 스왑 공간에서 스왑 인 또는 파일 페이지 회수 중에 단일 작업으로 디스크에서 읽거나 디스크에 쓰는 페이지 수를 제어합니다. 
</details>

6. vi를 종료한 후 새 매개변수를 활성화 합니다.
```sh
sudo sysctl --system
```  

# CLI 환경 개선
리눅스는 30년이 넘는 시간 동안 꾸준히 발전해 왔습니다. 오픈소스 기반의 운영체제인 리눅스는 개방성, 유연성, 안정성을 바탕으로 서버, 임베디드 시스템, 개인용 컴퓨터 등 다양한 분야에서 널리 사용되고 있습니다. 하지만 기술의 발전과 사용자의 요구 변화에 따라 기존 리눅스 툴의 한계를 지적하는 사용자도 많습니다.
이들의 요구사항을 수용해 최근에는 직관적인 사용자 인터페이스와 다양하고 강력한 기능 및 뛰어난 성능과 안전성을 바탕으로 한 현대적인 리눅스 툴 들이 개발되고 있습니다.

## 쉘
작업 효율성을 높이기 위해 고전적인 bash 대신 현대적인 zsh 환경을 구성합니다. 쉘 환경은 계정마다 독립적으로 구성할 수 있지만, rpi은 여러 계정을 사용하더라도 동일한 환경을 유지하는 것을 권장합니다. 따라서 모든 계정이 동일한 쉘 환경을 공유하는 전역 설정을 먼저 적용하고, 필요에 따라 개별 계정에 대한 지역 설정을 추가하는 방식으로 진행합니.다.

전역 설정은 /etc 폴더에, 지역 설정은 각 사용자의 홈 폴더에 설정 파일을 저장하여 관리합니다. 두 가지 설정 파일이 모두 존재하는 경우, 전역 설정이 먼저 적용된 후 지역 설정이 추가로 적용됩니다.

### zsh
zsh은 강력한 자동 완성과 맞춤 설정, 히스토리 검색, 파일 이름 패턴 매칭을 통해 여러 파일을 한 번에 선택하는 글로빙(Globbing) 지원을 비롯해 각종 플러그인 및 테마로 기능을 확장하는 현대적인 리눅스 쉘입니다. 

1. apt 명령으로 zsh을 설치합니다.
```sh
sudo apt install zsh -y
```

2. zsh을 설치했으면, 기본 쉘을 zsh로 변경합니다.
```sh
chsh -s $(which zsh) 
```

3. zsh을 실행합니다. 
```sh
zsh
```

4. 설정 파일 생성 메시지가 출력되면 \<2>를 누르는데, 이렇게 하면 전역 설정 파일(/etc/zsh/zshrc)과 지역 설정 파일(~/.zshrc)이 자동으로 만들어 집니다.
```
...
You can:

(q)  Quit and do nothing.  The function will be run again next time.

(0)  Exit, creating the file ~/.zshrc containing just a comment.
     That will prevent this function being run again.

(1)  Continue to the main menu.

(2)  Populate your ~/.zshrc with the configuration recommended
     by the system administrator and exit (you will need to edit
     the file by hand, if so desired).

--- Type one of the keys in parentheses --- 
```

5. 전역 설정만 사용하기 위해 ~/.zshrc 내용을 빈 파일로 만듦니다.
```sh
cat /dev/null > ~/.zshrc
```

6. 환경변수 PATH의 디폴트 값(/etc/zsh/zshenv)을 수정합니다.
```sh
sudo sed -i "s/\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/games/\/usr\/local\/bin:\/usr\/bin:\/bin:\/usr\/local\/sbin:\/usr\/sbin:\/sbin/g" /etc/zsh/zshenv
```

### tmux
tmux은 터미널 멀티플렉서의 일종으로 하나의 터미널 창 안에서 여러 개의 터미널 세션을 만들고 관리할 수 있게 해주는 도구입니다. 각 세션은 독립적으로 동작하며, 창 분할, 탭 기능 등을 통해 여러 작업을 동시에 효율적으로 처리할 수 있습니다.

처음 tmux를 실행하면 백그라운드에서 새로운 쉘과 함께 tmux 서버가 실행되고, 사용자 쉘에는 tmux 클라이언트가 실행됩니다. 이 후 사용자가 실행한 모든 명령은 tmux 클라이언틀 통해 tmux 서버에 전달되고, tmux 서버는 이를 자신의 쉘에 전달해 실행합니다. 만약 이 과정에서 원격 연결이 끊어지면 사용자 쉘과 tmux 클라이언트만 종료되고 tmux 서버는 백그라운드에서 계속 실행되므로 tmux 세션 내의 프로그램들은 계속 실행 상태를 유지합니다.

tmux를 실행한 상태에서 명령 모드로 진입하려면 프리픽스(prefix)로 불리는 컨트롤 키(\<Ctrl>)와 b 키(\<b>)를 함께 누르면 됩니다. 이후 누른 키에 따라 해당 기능이 동작합니다.

1. tmux를 설치합니다.
```sh
sudo apt install tmux
```

2. 사전 설정 파일인 tmux.conf를 다운로드 합니다.
```sh
sudo wget https://github.com/PlanXStudio/tos/raw/main/etc/tmux.conf -O /etc/tmux.conf
```

3. 플러그인 관리자인 tpm을 다운로드 합니다.
```sh
sudo git clone https://github.com/tmux-plugins/tpm /etc/tmux/plugins/tpm
```

4. vi로 variables.sh를 엶니다. 
```
sudo vi /etc/tmux/plugins/tpm/scripts/variables.sh
```

5. 파일이 열리면 DEFAULT_TPM_PATH를 다음과 같이 수정합니다.
```sh
DEFAULT_TPM_PATH="/etc/tmux/plugins/"
```

6. vi를 종료합니다.

7. root 권한으로 tmux를 실행합니다.
```sh
sudo tmux
```

8. 프리픽스를 누른 후 \<I>를 눌러 플러그인을 설치합니다. 몇 초 후 환경 변경 메시지가 표시되면 <Enter>를 누릅니다.
```out

TMUX environment reloaded.
Done, press ENTER to continue.
<Enter>
```

9. exit 명령으로 tmux를 종료한 후 다시 실행합니다.
```sh
exit
```

<details>
<summary>사전 설정 내용</summary>

사전 설정 파일에 의한 tmux 적용 내용은 다음과 같습니다.
- 이스케이프 키 입력 후 다음 명령 인식까지의 지연 시간을 10ms로 변경 (기본값은 500ms)
- 마우스 모드 활성화해 창, 패널 클릭 및 패널 크기 조정 가능. 마우스 우 클릭으로 팝업 메뉴 실행
  - [주의] 내용을 선택하려면 \<Ctrl>을 누른 상태에서 마우스로 내용 선택(선택 범위 끓어다 놓기)
- 스크롤 시 한 번에 이동하는 줄 수를 5로 설정
- 창 이름 자동 변경 비활성화
- 창 번호를 자동으로 다시 매김
- tmux 명령 모드에서 vim 키 바인딩 사용
- 창 및 패널 번호를 1부터 시작 (기본값은 0부터 시작)
- 256색 터미널 사용, xterm 키 활성화와 모든 터미널에서 256색 지원
- 내부 쉘로 zsh 사용
- 스크롤 백 히스토리(이전 명령 기록)를 10000줄까지 저장
- 반복 가능한 명령어의 반복 시간을 600ms로 설정
- 창 크기를 해당 창에 연결된 클라이언트의 최대 크기로 제한 (기본값은 세션에 연결된 모든 클라이언트의 최대 크기로 제한)
- 창 크기 조절 시 패널 크기를 적극적으로 조절
- 윈도우 창에서 패널 수평 분할을 \<|>, 수직 분할을 \<->로 변경
- \<Shift>+\<방향키>를로 현재 패널 크기 조절
- \<Alt>+\<방향키>로 여러 창 사이 전환
- \<L>을 눌러 마지막으로 사용한 창 열기
- 마우스 휠 스크롤 시 패널 내용을 스크롤하거나 복사 모드 시작
- \<Home>은 커서를 줄 맨 앞으로 이동, \<End>는 줄 맨 뒤로 이동하도록 설정
 </details>

  
만약 프리픽스를 \<Ctrl>+\<b> 대신 \<`>로 바꾸고 싶으면 vi로 tmux.conf를 열고 다음 부분의 주석(#)을 제거합니다.
```sh
unbind C-b
set -g prefix `
bind ` send-prefix
```

### fzf
fzf는 퍼지 검색(fuzzy search) 도구로, zsh의 강력한 자동 완성과 fzf의 퍼지 검색 기능을 결합하여 명령어, 파일, 디렉토리 등을 더욱 빠르고 정확하게 찾을 수 있으며, fzf를 zsh 플러그인으로 추가하면 히스토리 검색이나 프로세스 관리에 퍼지 검색 기능을 통합할 수 있습니다. 또한 fzf를 통해 선택한 결과를 zsh 명령어에 바로 전달하여 작업 흐름을 끊김 없이 이어갈 수 있어 쉘 작업을 더욱 효율적으로 만들어 줍니다.

fzf에서 주요 검색 패턴을 다음과 같습니다.
- 'word: 정확히 일치
- ^word: word로 시작
- word$: word로 끝남
- !word: word 제외

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/junegunn/fzf/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export FZF_VER=0.54.3
wget https://github.com/junegunn/fzf/releases/download/v$FZF_VER/fzf-$FZF_VER-linux_arm64.tar.gz
tar xzvf fzf-$FZF_VER-linux_arm64.tar.gz
rm fzf-*.gz
```

3. /usr/bin 경로로 옮깁니다.
```sh
sudo mv fzf /usr/bin
```

4. fzf 옵션 설정을 위해 vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 마지막 줄에 다음 내용을 추가해 tmux로 팝업 창을 만듦니다.
```
export FZF_DEFAULT_OPTS="--layout=reverse --tmux 90%,60% --border horizontal"
```

6. vi를 종료합니다.

7. 현재 실행 중인 쉘 환경에 zshrc 내용을 읽어 들여 실행하는 소싱 작업을 수행합니다.
```sh
source /etc/zsh/zshrc
```

<details>
<summary>oh-my-zsh 설치 후 동작</summary>

oh-my-zsh에는 fzf 플러그인이 내장되어, 설치가 완료되면 단추키를 통해 다음 기능을 사용할 수 있습니다.

- \<Ctrl>\<r>: fzf가 히스토리 표시
- \<Ctrl>\<t>: fzf가 현재 폴더를 기준으로 폴더와 파일 목록 표시
- \<Alt>\<c>: fzf가 현재 폴더를 기준으로 이동할(cd) 폴더 목록 표시

또한 명령 옵션에 와일드 카드(**)와 함께 <TAB>을 누르면 fzf가 파일 목록을 표시하고, 
kill 명령에 프로세스 번호 대신 \<TAB>을 누르면 fzf가 프로세스 목록을 표시합니다.

```sh
cat **<TAB>
sudo vim /etc/**<TAB>
cd /usr/share/**<TAB>
```

```sh
kill -9 <TAB>
```
</details>

### oh-my-zsh
oh-my-zsh은 zsh을 위한 오픈소스 프레임워크입니다. zsh는 강력하고 유연한 쉘이지만, 설정 및 관리가 복잡할 수 있습니다. oh-my-zsh은 이러한 zsh의 설정을 쉽게 관리하고, 다양한 플러그인과 테마를 제공하여 사용자 경험을 향상시키는 역할을 합니다.

1. oh-my-zsh 설치 스크립트를 다운로드한 후 실행합니다.
```sh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended --keep-zshrc
```

2. 디폴트 쉘을 zsh로 변경할지 묻는 메시지가 표시되면 \<Y>\<Enter>를 누릅니다.
```out
Looking for an existing zsh config...
Found /home/soda/.zshrc. Keeping...
Time to change your default shell to zsh:
Do you want to change your default shell to zsh? [Y/n] Y<Enter>
```

3. 현재 폴더에 설치된 oh-my-zsh을 /usr/local/share로 옮깁니다.
```sh
sudo mv .oh-my-zsh /usr/local/share/oh-my-zsh 
```

4. 내장된 플러그인 중 git과 fzf을 제외한 나머지는 삭제합니다.
```sh
sudo find /usr/local/share/oh-my-zsh/plugins -mindepth 1 -maxdepth 1 ! -name git ! -name fzf -type d -exec rm -rf {} +
```

5. 별도 테마를 사용할 것이므로 내장된 테마를 삭제합니다.
```sh
sudo rm /usr/local/share/oh-my-zsh/themes/*
```

### pwerlevel10k
powerlevel10k는 zsh을 위한 인기있는 테마 중 하나로 인스턴트 프롬프트 지원으로 oh-my-zsh 테마보다 빠르고, 다양한 세그먼트와 스타일을 제공하여 사용자가 원하는 대로 프롬프트를 구성할 수 있습니다. 또한 설정 마법사를 통해 롬프트 스타일, 아이콘, 색상 등을 선택할 수 있습니다.

1. 내장된 테마보다 더 멋진 powerlevel10k를 설치합니다.
```sh
sudo git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /usr/local/share/oh-my-zsh/custom/themes/powerlevel10k
```

2. 필수 플러그인을 추가로 설치합니다.
```sh
git clone https://github.com/zsh-users/zsh-autosuggestions /usr/local/share/oh-my-zsh/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /usr/local/share/oh-my-zsh/plugins/zsh-syntax-highlighting
```
- 플러그인 의미
  - zsh_autosuggestins: 입력하는 동안 자동으로 명령어 제안
  - zsh-syntax-hightlighting: 읽고 이해하기 쉽도록 명령어 구문 강조 표시

3. zsh 설정에 oh-my-zsh과 powerlevel10k를 추가하기 위해 vi로 zshrc 파일을 엶니다. 
```sh
sudo vi /etc/zsh/zshrc
```

4. 파일이 열리면 다음 내용을 입력합니다. plugins 내용 중 git은 사전 설치되어 있으며, fzf는 앞서 설치했습니다.
```sh
# These are the oh-my-zsh settings.
export ZSH="/usr/local/share/oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
```

5. vi를 종료합니다.

7. powrlevel10k를 zsh 테마로 지정한 후 설정 마법사를 실행하기 위해 원격 접속을 닫은 후 다시 연결합니다.

8. 설정 마법사가 실행되면 다음과 같이 설정합니다.
```sh
diamond: y (Yes)
lock: y (Yes)
upwards arrow y (Yes)
What digit is the downwards arrow pointing at? (아래로 향하는 화살표가 1 또는 2중 하나를 가르키는데, 여기에 맞게 선택함)
fit between the crosses: y (Yes)

Prompt Style: 3 (Rainbow)
Character Set: 1 (Unicode)
Show current time: 2 (24-hour format)
Prompt Separators: 4 (Round)
Prompt Heads: 4 (Slanted)
Prompt Tails: 5 (Round)
Prompt Height: 2 (Two lines)
Prompt Connection: 2 (Dotted)
Prompt Frame: 3 (Right)
Connection & Frame Color: 4 (Darkest)
Prompt Spacing: 2 (Sparse)
Icons: 2 (Many icons)
Prompt Flow: 2 (Fluent)
Enable Transient Prompt: y (Yes)
Instant Prompt Mode: 2 (Quiet)
Apply changes to ~/.zshrc: y (Yes)
```

8. 설정이 완료되면 홈 폴더의 .p10k.zsh에 저장되어 있으므로 이를 /etc/zsh로 옮기고, ~/.zshrc 내용을 빈 파일로 만듦니다.
```sh
sudo mv ~/.p10k.zsh /etc/zsh/p10k.zsh
cat /dev/null > ~/.zshrc
```

9. powerlevel10k 설정을 위해 vi로 zshrc 파일을 엶니다. 
```sh
sudo vi /etc/zsh/zshrc
```

10. 파일이 열리면 다음 내용을 입력합니다.
```sh
# These are the powerlevel10k settings.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
[[ ! -f /etc/zsh/p10k.zsh ]] || source /etc/zsh/p10k.zsh

# Add your custom settings from here
```

11. vi를 종료합니다.

이 후 powerlevel10k 설정 마법사를 실행할 때는 root 사용자로 전환한 후 p10k 명령과 configure 옵션을 사용합니다.
```sh
sudo su

p10k configure
```

## 기본 툴 대체
### ls 대체 eza(exa fork)
1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/eza-community/eza/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export EZA_VER=0.19.1

wget https://github.com/eza-community/eza/releases/download/v$EZA_VER/eza_aarch64-unknown-linux-gnu.tar.gz
tar xzvf eza_aarch64-unknown-linux-gnu.tar.gz
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv eza /usr/bin
rm -rf eza_*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias l='eza --icons --color=always'
alias la='eza -a --icons --color=always'
alias ll='eza -lagh --icons --grid --total-size --color=always'
alias ls='eza --icons --color=always'
```

6. vi를 종료합니다.

7. dir 명령을 삭제합니다.
```sh
sudo rm /bin/dir
```

### cat 대체 bat
1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/sharkdp/bat/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export BAT_VER=0.24.0

wget https://github.com/sharkdp/bat/releases/download/v$BAT_VER/bat-v$BAT_VER-aarch64-unknown-linux-gnu.tar.gz
tar xzvf bat-v$BAT_VER-aarch64-unknown-linux-gnu.tar.gz 
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv bat-v$BAT_VER-aarch64-unknown-linux-gnu/bat /usr/bin
rm -rf bat-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias cat='bat --color=always'
```

6. vi를 종료합니다.

### du 대체 dust

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/bootandy/dust/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export DUST_VER=1.1.1

wget https://github.com/bootandy/dust/releases/download/v$DUST_VER/dust-v$DUST_VER-aarch64-unknown-linux-gnu.tar.gz
tar xzvf dust-v$DUST_VER-aarch64-unknown-linux-gnu.tar.gz
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv dust-v$DUST_VER-aarch64-unknown-linux-gnu/dust /usr/bin
rm -rf dust-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias du='dust'
```

6. vi를 종료합니다.

### tree 대체 broot

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/Canop/broot/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export BROOT_VER=1.41.1

wget https://github.com/Canop/broot/releases/download/v$BROOT_VER/broot_$BROOT_VER.zip
unzip broot_$BROOT_VER.zip aarch64-unknown-linux-gnu/broot
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv aarch64-unknown-linux-gnu/broot /usr/bin
rm -rf broot_* aarch64-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias tree='broot -p -s'
```

6. vi를 종료합니다.

### ping 대체 gping

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/orf/gping/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export GPING_VER=1.17.3

wget https://github.com/orf/gping/releases/download/gping-v$GPING_VER/gping-aarch64-unknown-linux-gnu.tar.gz
tar xzvf gping-aarch64-unknown-linux-gnu.tar.gz
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv gping /usr/bin
rm -rf gping-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias ping='gping'
```

6. vi를 종료합니다.

### find 대체 fd

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/sharkdp/fd/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export FD_VER=10.1.0

wget https://github.com/sharkdp/fd/releases/download/v$FD_VER/fd-v$FD_VER-aarch64-unknown-linux-gnu.tar.gz
tar xzvf fd-v$FD_VER-aarch64-unknown-linux-gnu.tar.gz
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv fd-v$FD_VER-aarch64-unknown-linux-gnu/fd /usr/bin
rm -rf fd-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias find='fd'
```

6. vi를 종료합니다.

### grep 대체 ripgrep

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/BurntSushi/ripgrep/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export RIPGREP_VER=14.1.0

wget https://github.com/BurntSushi/ripgrep/releases/download/$RIPGREP_VER/ripgrep-$RIPGREP_VER-aarch64-unknown-linux-gnu.tar.gz
tar xzvf ripgrep-$RIPGREP_VER-aarch64-unknown-linux-gnu.tar.gz
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv ripgrep-$RIPGREP_VER-aarch64-unknown-linux-gnu/rg /usr/bin
rm -rf ripgrep-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias grep='rg'
```

6. vi를 종료합니다.

### od 대체 hexyl

1. 다음 사이트에서 최신 버전을 확인합니다.
```sh
https://github.com/sharkdp/hexyl/releases
```

2. 버전을 환경 변수에 추가한 후 설치 파일을 다운 받아 압축을 해제합니다.
```sh
export HEXYL_VER=0.14.0

wget https://github.com/sharkdp/hexyl/releases/download/v$HEXYL_VER/hexyl-v$HEXYL_VER-aarch64-unknown-linux-gnu.tar.gz
tar xzvf hexyl-v$HEXYL_VER-aarch64-unknown-linux-gnu.tar.gz
```

3. 실행 파일을 /usr/bin 경로로 옮깁니다.
```sh
sudo mv hexyl-v$HEXYL_VER-aarch64-unknown-linux-gnu/hexyl /usr/bin
rm -rf hexyl-*
```

4. vi로 zshrc를 엶니다.
```sh
sudo vi /etc/zsh/zshrc
```

5. 다음과 같이 별칭을 추가합니다.
```sh
alias od='hexyl'
```

6. vi를 종료합니다.

### zshrc 소싱
/etc/zsh/zshrc를 수정한 후 이를 zsh에 반영하려면 시스템을 재 시작하거나 현재 zsh에 소싱하면 됩니다.
소싱은 해당 파일 내용을 현재 쉘에서 실행하는 것으로, 새로 설정한 환경 변수를 업데이트하거나 별칭 등을 추가할 때 사용합니다.

```sh
source /etc/zsh/zshrc
```

# GUI 환경 설정
Xorg는 X Window System의 핵심 구성 요소로, 그래픽 사용자 인터페이스(GUI)를 제공하는 역할을 합니다. 사용자 입력을 받아 화면에 출력하고, 창 관리자와 통신하여 창을 관리합니다.

창 관리자의 일종인 Openbox는 X 서버 위에서 동작하며, 창의 모양, 위치, 동작 등을 관리합니다. X 서버가 창을 그리고 사용자 입력을 처리하는 동안, Openbox는 창의 배치, 제목 표시줄, 테두리 등을 담당하는데, 다른 창 관리자에 비해 가볍고 빠릅니다. 즉, Xorg는 GUI 환경의 기반을 제공하고, Openbox는 그 위에서 창을 관리하는 역할을 수행합니다.

GUI 응용프로그램과 OpenBox, Xorg의 역할은 다음과 같습니다.
- 사용자가 GUI 애플리케이션을 실행하면, 해당 애플리케이션은 X 서버에 창 생성 요청
- X 서버는 창을 생성하고, 창의 기본적인 속성(크기, 위치 등) 설정
- Openbox는 X 서버로부터 창 생성 이벤트를 받고, 해당 창에 대한 관리 시작
- Openbox는 X 서버를 통해 창에 제목 표시줄, 테두리, 버튼 등을 추가하여 사용자가 창을 쉽게 조작할 수 있도록 지원
- Openbox는 X 서버를 통해 사용자의 입력에 따라 창의 위치를 변경하거나, 크기를 조절하거나, 다른 창 위에 겹쳐서 배치하는 등 창 관리 작업 수행
- 사용자가 창을 닫으면 Openbox는 해당 창을 화면에서 제거하고, X 서버에 창 삭제 요청

## X 서버 설치 및 실행 
임베디드 장치는 창 관리자 없이 X 서버만으로도 충분합니다.

1. X 서버를 설치합니다. 
```sh
sudo apt-get install --no-install-recommends xserver-xorg xinit
```

2. X 서버를 실행합니다.
```sh
sudo Xorg :0 &
```

## 원격 데스크탑 설치
PC에서 원격으로 serbot의 GUI 환경을 사용할 때는 VNC를 비롯해 RDP등 다양한 솔루션이 있지만, 네트워크 환경에 따라 가변 압축을 지원하는 nomachine을 권장합니다.
nomachine은 상업, 비상업 버전으로 나뉘는데, 두 버전의 기본적인 기능은 같고 비상업 버전은 세션당 한명의 사용자만 연결할 수 있습니다.

1. rpi에 nomachine 서버를 설치합니다.
```sh
wget https://www.nomachine.com/free/arm/v8/deb -O nomachine.deb
sudo dpkg -i nomachine.deb
rm nomachine.deb
```

2. PC에서 nomachine 클라이언트를 설치합니다.
```sh
winget install NoMachine.NoMachineClient -s winget
```

3. PC에서 namachine 클라이언트를 실행한 후 rpi의 IP 주소를 이용해 원격 접속합니다.
- Search 창에 serbot IP 주소를 입력한 후 목록에서 <connect to new host ...> 선택
- Verify host identification 창이 표시되면 ok 선택
- 연결 창에 Username과 Password에 모두 tos을 입력 한 후 Ok 선택
  - Auto streaming 창이 표시되면 Dont't show.. 체크 후 Ok 선택
  - Display resolution 창이 표시되면 Dont't show.. 체크와 하단에서 resize remote display 선택 후 Ok 선택

4. 화면 해상도를 설정를 설정합니다.   
- 마우스를 화면 오른쪽 상단 끝으로 이동하면 페이지 넘김이 표시되는데, 이를 클릭해 설정 화면으로 이동
- 아이콘 목록에서 Display 선택
  - Resize remote display를 선택한 후 오른쪽 끝 Change settings 선택
  - Resolution을 1024x600으로 변경 후 Modify 선택
- 왼쪽 상단 뒤로 가기 버튼을 처음 화면이 표시될 때까지 누름

rpi에 X 서버가 실행 중일 때만 PC에서 nomachine 클라이언트로 rpi에 접속할 수 있습니다.
nomachine 서버는 systemd 서비스로 관리하므로 rpi를 다시 시작하면 자동으로 실행됩니다. 
