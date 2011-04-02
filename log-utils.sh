#! /bin/bash

# Colorfull print of tail
function tail()
{
	tail "${@}" | awk '/^[0-9]/{if(/ERROR|FATAL/){n=1;s="\033[31;1m";e="\033[0m"}else if(/WARN/){n=1;s="\033[33m";e="\033[0m"}else if(/Started|Shutdown/){n=1;s="\033[1m";e="\033[0m"}else{n=0;s="";e=""}}{if(1)print s $0 e}'
}

# Colofull less 
function view-file()
{
	cat $1 | awk '/^[0-9]/{if(/ERROR|FATAL|Exception/){n=1;s="\033[31;1m";e="\033[0m"}else if(/WARN/){n=1;s="\033[33m";e="\033[0m"}else if(/Started|Shutdown/){n=1;s="\033[1m";e="\033[0m"}else{n=0;s="";e=""}}{if(1)print s $0 e}' | less -r
}