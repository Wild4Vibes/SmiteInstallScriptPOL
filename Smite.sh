#!/usr/bin/env playonlinux-bash
# Date : (2015-08-18 03-02)
# Last revision : (2015-08-18 03-02)
# Wine version used : 1.7.47
# Distribution used to test : Ubuntu 14.10
# Author : rolandoislas

[ "$PLAYONLINUX" = "" ] && exit 0
source "$PLAYONLINUX/lib/sources"

TITLE="SMITE"
PREFIX="Smite"
WINEVERSION="1.7.47"
 
POL_SetupWindow_Init
POL_Debug_Init

POL_SetupWindow_presentation "$TITLE" "Hi-Rez Studios" "http://www.smitegame.com/" "rolandoislas" "Smite"

POL_SetupWindow_InstallMethod "DOWNLOAD,LOCAL"

if [ "$INSTALL_METHOD" = "LOCAL" ]; then
    cd "$HOME"
    POL_SetupWindow_browse "$(eval_gettext 'Please select the setup file to run.')" "$TITLE" "" "Windows Executables (*.exe)|*.exe;*.EXE"
    FULL_INSTALLER="$APP_ANSWER"
else
   POL_System_TmpCreate "$PREFIX"
 
    DOWNLOAD_URL="http://hirez.http.internapcdn.net/hirez/InstallSmite.exe"
    DOWNLOAD_MD5="70c865599331410ae8bbcf7d7f74ecbb"
    DOWNLOAD_FILE="$POL_System_TmpDir/$(basename "$DOWNLOAD_URL")"
 
    POL_Call POL_Download_retry "$DOWNLOAD_URL" "$DOWNLOAD_FILE" "$DOWNLOAD_MD5" "$TITLE installer"
 
    FULL_INSTALLER="$DOWNLOAD_FILE"
fi

POL_System_SetArch "x86"
POL_Wine_SelectPrefix "$PREFIX"
POL_Wine_PrefixCreate "$WINEVERSION"

if [ "$POL_OS" = "Linux" ]; then
	POL_Call POL_Function_RootCommand "echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope; exit"
fi

POL_Call POL_Install_d3dx10
POL_Call POL_Install_d3dx11
POL_Call POL_Install_d3dx9_43
POL_Call POL_Install_directx9
POL_Call POL_Install_dotnet35sp1
POL_Call POL_Install_dotnet40
POL_Call POL_Install_flashplayer
POL_Call POL_Install_gdiplus
POL_Call POL_Install_vcrun2008
POL_Call POL_Install_vcrun2010
POL_Call POL_Install_xact

Set_OS "win7"

POL_Wine_WaitBefore "$TITLE"
POL_Wine "$FULL_INSTALLER"

Set_OS winxp

POL_Call POL_Function_OverrideDLL builtin,native dnsapi
POL_Shortcut "HiRezLauncherUI.exe" "$TITLE" "" "game=300 product=17"

if [ "$INSTALL_METHOD" = "DOWNLOAD" ]; then
    POL_System_TmpDelete
fi

POL_SetupWindow_Close
exit