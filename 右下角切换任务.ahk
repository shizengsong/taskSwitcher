#noenv
#singleInstance force
#persistent

编辑器路径:="C:\Windows\notepad.exe"	;这里请改成你常用的编辑器
程序路径:=substr(A_ScriptFullPath,1,-4) . ".exe"
图标路径:=substr(A_ScriptFullPath,1,-4) . ".ico"
程序名称:=substr(A_ScriptName,1,-4) . ".exe"

;不能忍,自己做个编辑菜单
Menu,tray, NoStandard
Menu,tray,Add,(&D)软件说明
Menu,tray,Add,(&E)编辑脚本
Menu,tray,Add,(&S)开机启动
Menu,tray,Add,(&R)程序重启
Menu,tray,Add,(&P)程序暂停
Menu,tray,Add,(&I)显示执行信息
Menu,tray,Add,(&X)退出程序
开机启动路径 =%A_Startup%\%程序名称%.lnk

IfExist, %开机启动路径%
	Menu,tray,Check,(&S)开机启动
else
	Menu,tray,UnCheck,(&S)开机启动

goto,开始运行

(&E)编辑脚本:
;run,%编辑器路径% %A_ScriptFullPath%		;编辑器位置自己填
return

(&D)软件说明:
MsgBox,%软件说明%
Return

(&S)开机启动:
IfExist, %开机启动路径%
{
	FileDelete,%开机启动路径%
	Menu,tray,UnCheck,(&S)开机启动
}Else{
	IfNotExist, %图标路径%
		图标路径:=""
	FileCreateShortcut,%程序路径%,%开机启动路径%,%A_ScriptDir%\,,没有说明哈哈,%图标路径%
	Menu,tray,Check,(&S)开机启动
}
Return

(&P)程序暂停:
pause
return

(&R)程序重启:
reload
return

(&I)显示执行信息:
ListLines 
return

(&X)退出程序:
ExitApp

开始运行:

;程序真正开始的位置
;-------------------------------------------------------------------------------------------------------------------------------

menu,tray,Icon,%图标路径%
CoordMode, mouse,screen
右下角x:=A_ScreenWidth-10,右下角y:=A_ScreenHeight-20
鼠标不动次数:=0,降低频率:=0

setTimer,循环检测,100
return

rctrl::	gosub,启动窗口选择

#esc::选择窗口("退出")
#Lbutton::选择窗口("选择")

#mButton::
#rButton::选择窗口("关闭")

#up::#tab
#down::#+tab

#wheelup::#wheeldown
#wheeldown::#wheelup		;调转鼠标滚轮键的方向,感觉默认的方向有点奇怪

#enter::
#ctrl::选择窗口("默认窗口")

#del::
#backSpace::
send,{enter}{Lwin up}
关闭窗口()
gosub,启动窗口选择
return

循环检测:
winGetClass,类名,A
if(类名 == "Flip3D")
	return
mouseGetPos,x,y
if(x==上次x && y==上次y){
	鼠标不动次数+=1
	if(鼠标不动次数>500 && 降低频率==0){		;100*500=50000ms,50秒不动
		setTimer,循环检测,off
		setTimer,循环检测,1000		;鼠标长时间不动,降低检测频率
		降低频率:=1
	}
}else{
	鼠标不动次数:=0
	if(降低频率==1){
		setTimer,循环检测,off
		setTimer,循环检测,100		;恢复检测频率
		降低频率:=0
	}
}
上次x:=x,上次y:=y
if(y>右下角y && x >右下角x ){
	gosub,启动窗口选择
}
return

启动窗口选择:
IfWinExist, ahk_class Shell_TrayWnd
	send,{LWin down}{tab}
return

选择默认窗口并退出(){
}
选择窗口(控制码){
	if (控制码=="选择"){
		send,{Lbutton}
		退出()
	}else if (控制码=="退出"){
		退出()
	}else if (控制码=="关闭"){
		send,{Lbutton}{Lwin up}
		关闭窗口()
		;sleep,500
		gosub,启动窗口选择
	}else if (控制码=="默认窗口"){
		send,{enter}
		sleep,300
		send,{Lwin up}{Lwin up}
	}
	
}

关闭窗口(){
	WinWaitClose,ahk_class Flip3D
;	sleep,500
	winGetClass,类名,A
	if(类名 == "WorkerW"){
		异步通知("桌面关闭不了",3000)
	}else{
		;send,!{F4}
		sleep,300
		WinClose,A
		异步通知("关闭窗口",2000)
	}
}

退出(){
	send,{Lwin up}
	return
	;exitapp
}
异步通知(内容,时间:=2000){
	时间:=0-时间
	tooltip,%内容%
	settimer,关闭通知,%时间%
}

关闭通知:
tooltip
return
