;if you have changed the script,please save it in the utf-8(with bom) format,ensuring its running
;修改脚本后,请保存为utf-8(带签名)格式,以确保程序的运行
#noenv
#singleInstance force
#persistent

程序名称:= "taskSwicher.exe"
程序路径:=A_ScriptDir . "\" . 程序名称
图标路径:= A_ScriptDir . "\taskSwicher.ico"

if (A_language==0804 or A_language==0404 or A_language==0c04 or A_language==1004 or A_language==1404){
	界面语言:="zh"
}else 	界面语言:="en"
if (界面语言=="zh"){								;中文支持
	标签_软件说明:="(&D)软件说明"
	标签_编辑脚本:="(&E)编辑脚本"
	标签_开机启动:="(&S)开机启动"
	标签_程序重启:="(&R)程序重启"
	标签_程序暂停:="(&P)程序暂停"
	标签_显示执行信息:="(&I)显示执行信息"
	标签_退出程序:="(&X)退出程序"
}else{										;language support
	标签_软件说明:="(&D)Application_Direction"				;you can just change the menus below in your own language
	标签_编辑脚本:="(&E)Edit_the_script"
	标签_开机启动:="(&S)Auto_Start"
	标签_程序重启:="(&R)Restart"
	标签_程序暂停:="(&P)Pause"
	标签_显示执行信息:="(&I)Information_of_the_running"
	标签_退出程序:="(&X)Exit_The_App"
}

;不能忍,自己做个编辑菜单
Menu,tray, NoStandard
Menu,tray,Add,%标签_软件说明%
Menu,tray,Add,%标签_编辑脚本%
Menu,tray,Add,%标签_开机启动%
Menu,tray,Add,%标签_程序重启%
Menu,tray,Add,%标签_程序暂停%
Menu,tray,Add,%标签_显示执行信息%
Menu,tray,Add,%标签_退出程序%
开机启动路径 =%A_Startup%\%程序名称%.lnk

IfExist, %开机启动路径%
	Menu,tray,Check,%标签_开机启动%
else
	Menu,tray,UnCheck,%标签_开机启动%

goto,开始运行

(&E)编辑脚本:
(&E)Edit_the_script:
run,%编辑器路径% %A_ScriptFullPath%		
return

(&D)软件说明:
(&D)Application_Direction:
MsgBox,%软件说明%
Return
(&S)开机启动:
(&S)Auto_Start:
IfExist, %开机启动路径%
{
	FileDelete,%开机启动路径%
	Menu,tray,UnCheck,%标签_开机启动%
}Else{
	IfNotExist, %图标路径%
		图标路径:=""
	FileCreateShortcut,%程序路径%,%开机启动路径%,%A_ScriptDir%\,,没有说明哈哈,%图标路径%
	Menu,tray,Check,%标签_开机启动%
}
Return

(&P)程序暂停:
(&P)Pause:
pause
return
(&R)程序重启:
(&R)Restart:
reload
return
(&I)显示执行信息:
(&I)Information_of_the_running:
ListLines 
return
(&X)退出程序:
(&X)Exit_The_App:
ExitApp

开始运行:

;程序真正开始的位置
;-------------------------------------------------------------------------------------------------------------------------------

编辑器路径:="D:\绿色软件\emeditor\emeditor.exe"	;这里请改成你常用的编辑器
						;repalce the editor here with your usual editor 
if (界面语言=="zh"){
	软件说明:=	"软件说明:`n`n1
			.改进windows任务窗口操作，按右ctrl键启动)`n`n2
			.不支持win10以上系统`n    也可以按键盘右侧ctrl键启动。 `n`n3
			.启动启动后，鼠标左键选择窗口，滚轮或上下方向键可滚动窗口`n    鼠标中键或右键可关闭窗口`n`n4
			.也可以再按右ctrl键或enter键，以选择默认窗口`n`n5
			.如果你想在win10或更高系统中使用,`n    你可以把脚本中的""#""符号全部换成""!""符号,再把""Lwin""全部换成""Lalt"".(不过我没怎么测试)"
}else{
	软件说明:=	"Apllication Direction:`n`n1
			.this tool improves the task switching operation of the Windows System
			. press the right control key,then you can switch the windows`n`n2
			.it do not support Win10 or above system. And you can also start it with the right-ctrl key.`n`n3
			.After its start, you can choose a window by click on it
			, scroll the windows by wheelup or wheeldown or the up or the down key,and close a window by right click on it.`n`n4
			.you can alse choose the front window by pressing the enter key or the right-ctrl key.`n`n5
			.if you want to use it in the win10 or above system
			, you can repalce the ""#"" sysbom with ""!"" and the ""Lwin"" with ""Lalt"" in the scripts
			.(I have not do some test)		"
}

menu,tray,Icon,%图标路径%
CoordMode, mouse,screen
右下角x:=A_ScreenWidth-2,右下角y:=A_ScreenHeight-2
鼠标不动次数:=0,降低频率:=0
return

rctrl::gosub,启动窗口选择

#Lbutton::选择窗口("选择")
#enter::
#esc::选择窗口("退出")

#rctrl::
	选择窗口("退出")
	send,{rctrl up}
return


#backspace::
#delete::
#mButton::
#rButton::选择窗口("关闭")

#up::send,#{tab}
#down::send,#+{tab}

#wheelup::#wheeldown
#wheeldown::#wheelup		;调转鼠标滚轮键的方向,感觉默认的方向有点奇怪

启动窗口选择:
;IfWinExist, ahk_class Shell_TrayWnd	;判断程序是否是全屏，但是这句不起作用
	send,{LWin down}{tab}
return

选择窗口(控制码){
	if (控制码=="选择"){
		send,{Lbutton}
		退出()
	}else if (控制码=="退出"){
		退出()
	}else if (控制码=="关闭"){
		send,{Lbutton}{Lwin up}
		关闭窗口()
		gosub,启动窗口选择
	}else if (控制码=="默认窗口"){
		send,{enter}
		sleep,300
		send,{Lwin up}{Lwin up}
	}
}

关闭窗口(){
	WinWaitClose,ahk_class Flip3D
	winGetClass,类名,A
	if(类名 == "WorkerW"){
		异步通知("桌面关闭不了",3000)
	}else{
		sleep,300
		WinClose,A
		异步通知("关闭窗口",2000)
	}
}

退出(){
	send,{Lwin up}
}

异步通知(内容,时间:=2000){
	时间:=0-时间
	tooltip,%内容%
	settimer,关闭通知,%时间%
}

关闭通知:
tooltip
return
