#!/usr/bin/env bash

languages=$(echo "html svg golang c cpp typescript rust javascript java python" | tr " " "\n")
core_utils=$(echo "find xargs sed awk ls grep")
selected=$(echo -e "$languages\n$core_utils" | fzf)

read -p "GIMMIE YOUR QUERY: " query

if echo "$languages" | grep -qs $selected; then
  tmux split-window -v bash -c "curl cht.sh/$selected/$(echo "$query" | tr " " "+") | less"
else
  tmux split-window -v bash -c "curl cht.sh/$selected~$query | less"
fi
