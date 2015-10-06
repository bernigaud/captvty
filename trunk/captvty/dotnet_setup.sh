#!/bin/sh

export WINEARCH=win32
export WINEPREFIX=/tmp/.wine
# set -x 

mkdir -p $WINEPREFIX
ls -alsd /tmp/*

#debug 
# mkdir /home/luser/.wine
wine cmd.exe /c echo '%ProgramFiles%'


# wine reg add "HKCU\\Environment" /v "SystemDrive" /t REG_SZ /d "C:" /f
# wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment\\Environment" /v "SystemDrive" /t REG_SZ /d "C:" /f
# wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment\\Environment" /v "ProgramFiles" /t REG_SZ /d "C:\\Program Files" /f
# wine regedit programfiles.reg

winetricks -q comctl32


# Warning:  HOME must be correctly defined before calling this
winetricks -q dotnet40

wget http://captvty.fr/getgdiplus -O kb975337.exe
wine kb975337.exe /x:kb975337 /q

cp kb975337/asms/10/msft/windows/gdiplus/gdiplus.dll ~/.wine/drive_c/windows/system32
wine reg add HKCU\\Software\\Wine\\DllOverrides /v gdiplus /d native,builtin /f

winetricks -q comctl32
winetricks -q ie8 

# wget http://captvty.fr/getflash -O fplayer.exe
wget http://fpdownload.macromedia.com/pub/flashplayer/latest/help/install_flash_player_ax.exe -O fplayer.exe
wine fplayer.exe -install -au 2
# ENTRYPOINT wine /home/captvty/Captvty.exe
