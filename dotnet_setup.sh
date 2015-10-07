#!/bin/sh

export WINEPREFIX=/home/luser/.wine
export WINEARCH=win32
export HOME=/home/luser

# Avoid mono gecko alerts
export WINEDLLOVERRIDES="mscoree,mshtml="

# set -x 


# ls -alsd /tmp/*

#debug 
# mkdir /home/luser/.wine
# wine cmd.exe /c echo '%ProgramFiles%'
# echo CLEANUP
# wineserver -k 
# rm -Rf $WINEPREFIX
# # mkdir -p $WINEPREFIX

# exit 0

# wine reg add "HKCU\\Environment" /v "SystemDrive" /t REG_SZ /d "C:" /f
# wine reg add "HKCU\\Environment" /v "ProgramFiles" /t REG_SZ /d "C:\\Program Files" /f

# echo DONE-3
winetricks -q vcrun2010 
# corefonts

# echo DONE-2
# # wine reg /?
# echo DONE-1 
# # wine cmd /c "set"
# echo DONE0
# # wine reg query "HKCU\\Environment" /v "ProgramFiles"
# echo DONE1
# # wine reg add "HKCU\\Environment" /v "ProgramFiles" /t REG_SZ /d "C:\\Program Files" /f
# # wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment\\Environment" /v "SystemDrive" /t REG_SZ /d "C:" /f
# # wine reg add "HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Session Manager\\Environment\\Environment" /v "ProgramFiles" /t REG_SZ /d "C:\\Program Files" /f
# # wine regedit programfiles.reg

# # winetricks -q comctl32

# echo DONE2


# Warning:  HOME must be correctly defined before calling this
winetricks -q dotnet40 corefonts

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

wine reg add "HKCU\\Environment" /v "SystemDrive" /t REG_SZ /d "C:" /f