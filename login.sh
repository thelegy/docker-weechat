#!/bin/bash

function start_weechat()
{
	if [ -f \"/home/weechat/.weechat/irc.conf\" ] ; then
		weechat
	else
		local config=$(cat config.txt | tr \"\\n\" \"\;\")
		weechat -r "${config}"
	fi
}

function start_tmux()
{
	if tmux has-session -t WeeChat 2>/dev/null; then
		tmux attach -t WeeChat
	else
		tmux new -s WeeChat "$0"
	fi	
}

if test $TMUX; then
	start_weechat
else
	start_tmux
fi
