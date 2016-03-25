


##########
# colors #
##########


function style_reset {
	echo "\033[00m"
}

function style_bold {
	echo "\033[01m"
}

function style_unterline {
	echo "\033[04m"
}

function style_standout {
	echo "\033[07m"
}

function style_no_bold {
	echo "\033[22m"
}

function style_no_unterline {
	echo "\033[24m"
}

function style_no_standout {
	echo "\033[27m"
}

function FG {
	echo "\033[38;5;$1m"
}

function FG_BOLD {
	echo -ne "$(style_bold)\033[38;5;$1m"
}

function FG_UNDERLINE {
	echo "$(style_underline)\033[38;5;$1m"
}

function FG_STANDOUT {
	echo "$(style_standout)\033[38;5;$1m"
}

function FG_NO_BOLD {
	echo "$(style_no_bold)\033[38;5;$1m"
}

function FG_NO_UNDERLINE {
	echo "$(style_no_underline)\033[38;5;$1m"
}

function FG_NO_STANDOUT {
	echo "$(style_no_standout)\033[38;5;$1m"
}

function BG {
	echo "\033[48;5;$1m"
}



#######
# ℊit #
#######


ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[grey]%}⎇ [%{$fg_bold[cyan]%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg_bold[grey]%}]"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[grey]%}] %{$fg_bold[green]%}✔"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_UNTRACKED="$(FG_BOLD 131) ⚐"
ZSH_THEME_GIT_PROMPT_ADDED="$(FG_BOLD 106) ➕"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg_bold[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_UNMERGED="$(FG_BOLD 176) ✂"
ZSH_THEME_GIT_PROMPT_RENAMED="$(FG_NO_BOLD 69) ➦"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg_bold[red]%} ✗"

function git_short_sha() {
  sha=$(git rev-parse --short HEAD 2> /dev/null)
  echo "$sha"
}

function git_number_of_changed_files {
  echo "$(git status --porcelain 2>/dev/null | wc -l)"
}

# 12=𝍖
function git_changed_files_indicator {
  changes="$(git_number_of_changed_files)"
  if [ "$changes" -gt 249 ]; then
    echo "%{$fg_bold[white]%} █ "
  elif if [ "$changes" -gt 99 ]; then
    echo "%{$fg_bold[white]%} ▓ "
  elif if [ "$changes" -gt 49 ]; then
    echo "%{$fg_bold[white]%} ▒ "
  elif if [ "$changes" -gt 9 ]; then
    echo "%{$fg_bold[white]%} ░ "
  elif if [ "$changes" -eq 9 ]; then
    echo "%{$fg_bold[white]%} ፧፧፧"
  elif if [ "$changes" -eq 8 ]; then
    echo "%{$fg_bold[white]%} ⣿"
  elif if [ "$changes" -eq 7 ]; then
    echo "%{$fg_bold[white]%} ፨"
  elif if [ "$changes" -eq 6 ]; then
    echo "%{$fg_bold[white]%} ⠿"
  elif if [ "$changes" -eq 5 ]; then
    echo "%{$fg_bold[white]%} ⁙"
  elif if [ "$changes" -eq 4 ]; then
    echo "%{$fg_bold[white]%} ⁘"
  elif if [ "$changes" -eq 3 ]; then
    echo "%{$fg_bold[white]%} ⁖"
  elif if [ "$changes" -eq 2 ]; then
    echo "%{$fg_bold[white]%} ፡"
  elif if [ "$changes" -eq 1 ]; then
    echo "%{$fg_bold[white]%} ‧"
  else
    echo ""
  fi
}

function git_indicator_status {
  local COLOR=$1
  local COUNT=$2
  local SYMBOL=$3
  echo " $(FG_NO_BOLD $COLOR)${COUNT}$(FG_BOLD $COLOR)${SYMBOL} "
}

function git_indicator_changes {
  INDEX=$(git status --porcelain -b 2> /dev/null)
  STATUS=""
  
  UNTRACKED=$(echo "$INDEX" | grep -E '^\?\? ' | wc -l)
  ADDED=$({ echo "$INDEX" | grep '^A  '; } | cat | wc -l)
  MODIFIED=$({ echo "$INDEX" | grep '^M  '; echo "$INDEX" | grep '^ M '; echo "$INDEX" | grep '^AM '; echo "$INDEX" | grep '^ T '; } | cat | wc -l)
  RENAMED=$(echo "$INDEX" | grep -E '^R  ' | wc -l)
  DELETED=$({ echo "$INDEX" | grep '^ D '; echo "$INDEX" | grep '^D  '; echo "$INDEX" | grep '^AD '; } | cat | wc -l)  
  STASHED=$(git rev-parse --verify refs/stash 2> /dev/null | wc -l)
  UNMERGED=$(echo "$INDEX" | grep '^UU ' | wc -l)
  AHEAD=$(echo "$INDEX" | grep '^## .*ahead' | wc -l)
  BEHIND=$(echo "$INDEX" | grep '^## .*behind' | wc -l)
  DIVERGED=$(echo "$INDEX" | grep '^## .*diverged' | wc -l)
  
  if [[ $UNTRACKED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 206 $UNTRACKED ⚐)"
  fi
  if [[ $ADDED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 106 $ADDED ➕)"
  fi
  if [[ $MODIFIED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 184 $MODIFIED ✭)"
  fi
  if [[ $RENAMED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 69 $RENAMED ➦)"
  fi
  if [[ $DELETED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 160 $DELETED ✗)"
  fi
  if [[ $STASHED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 57 $STASHED ⛁)"
  fi
  if [[ $UNMERGED -gt 0 ]]; then
    STATUS="$STATUS$(git_indicator_status 176 $UNMERGED ✂)"
  fi
  if [[ $AHEAD -gt 0 ]]; then
    #STATUS="$STATUS$(git_indicator_status 248 $AHEAD A)"
  fi
  if [[ $BEHIND -gt 0 ]]; then
    #STATUS="$STATUS$(git_indicator_status 248 $BEHIND B)"
  fi
  if [[ $DIVERGED -gt 0 ]]; then
    #STATUS="$STATUS$(git_indicator_status 248 $DIVERGED D)"
  fi
  echo $STATUS
}

function git_indicator_sync {
  remotes="$(git branch -r 2>/dev/null | wc -l)"
  if [ "$remotes" -gt 0 ]; then
    branch=$(git name-rev --name-only HEAD)
	  unpushed="$(git log --branches --not --remotes=origin 2>/dev/null | wc -l)"
	  integer unpulled=0
	  git remote 2>/dev/null | while IFS= read -r origin; do
	    unpulled+=$(git rev-list HEAD..$origin/$branch --count 2>/dev/null)
	  done
	  if [[ "$unpushed" -gt 0 && "$unpulled" -gt 0 ]]; then
		echo "%{$fg_bold[magenta]%} ⇣⇡"
	  elif if [ "$unpulled" -gt 0 ]; then
		echo "%{$fg_bold[magenta]%} ⇣"
	  elif if [ "$unpushed" -gt 0 ]; then
	    echo "%{$fg_bold[magenta]%} ⇡"
	  fi
  fi
}

function git_time_since_last_commit {
  sha="$(git_short_sha)"
  if [ -n "$sha" ]; then
    last="$(git log --pretty=format:'%at' -1 2> /dev/null)"
    now="$(date +%s)"
    echo "$((now - last))"
  fi
}

function git_indicator_for_time_since_last_commit {
  changes="$(git_number_of_changed_files)"
  if [ "$changes" -gt 0 ]; then
	  seconds="$(git_time_since_last_commit)"
	  if [ "$seconds" -gt 31536000 ]; then # 1 year
		echo "%{$fg_bold[grey]%} ‹$(FG_BOLD 75)⌚ $(FG_NO_BOLD 189)$(($seconds/31536000))y%{$fg_bold[grey]%}›"
	  elif if [ "$seconds" -gt 2592000 ]; then # 1 month
		echo "%{$fg_bold[grey]%} ‹$(FG_BOLD 75)⌚ $(FG_NO_BOLD 189)$(($seconds/2592000))m%{$fg_bold[grey]%}›"
	  elif if [ "$seconds" -gt 604800 ]; then # 1 week
		echo "%{$fg_bold[grey]%} ‹$(FG_BOLD 75)⌚ $(FG_NO_BOLD 189)$(($seconds/604800))w%{$fg_bold[grey]%}›"
#	  elif if [ "$seconds" -gt 86400 ]; then # 1 day
#		echo "%{$fg_bold[grey]%} ‹$(FG_BOLD 75)⌚ $(FG_NO_BOLD 189)$(($seconds/86400))d%{$fg_bold[grey]%}›"
#	  elif if [ "$seconds" -gt 3600 ]; then # 1 hour
#		echo "%{$fg_bold[grey]%} ‹$(FG_BOLD 75)⌚ $(FG_NO_BOLD 189)$(($seconds/3600))h%{$fg_bold[grey]%}›"
	  fi
  fi
}

# $(git_changed_files_indicator) $(git_prompt_status)
function git_prompt {
  sha="$(git_short_sha)"
  if [ -n "$sha" ]; then
#	echo "$(git_prompt_info)$(git_indicator_changes)$(git_indicator_sync)$(git_indicator_for_time_since_last_commit)"
	echo "$(git_prompt_info)$(git_indicator_changes)$(git_indicator_sync)"
  fi
}



###############
# system info #
###############


function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo "%{$fg_bold[magenta]%}[%{$fg_no_bold[magenta]%}"`basename $VIRTUAL_ENV`"%{$fg_bold[magenta]%}]%{$reset_color%}"
}

function system_warning {
	echo "%{$bg[blue]%}%{$fg_bold[white]%} $1 %{$bg[red]%}%{$fg_bold[white]%} $2 %{$bg[red]%}%{$fg_no_bold[white]%}$3 %{$bg[red]%}%{$fg_bold[white]%}$4 %{$reset_color%} "
}

function diskfree {
  local dfout=""

  local dfroot="$(df -k /$1 | tail -1 | nawk '{print $5}' | sed 's/.$//')"
  if [[ $dfroot -gt 89 ]]; then
    dfout="$dfout$(system_warning '⛁ ' $dfroot%% on /)"
  fi
  
  local dfhome="$(df -k | grep ' /home' | nawk '{print $5}' | sed 's/.$//')" 
  if [[ $dfhome -gt 89 ]]; then
    dfout="$dfout$(system_warning '⛁ ' $dfhome%% on /home)"
  fi
  
  local dfbackuplinux="$(df -k | grep ' /backup/linux' | nawk '{print $5}' | sed 's/.$//')" 
  if [[ $dfbackuplinux -gt 79 ]]; then
    dfout="$dfout$(system_warning '⛁ ' $dfbackuplinux%% on /backup/linux)"
  fi

  local dfbackupwin="$(df -k | grep ' /backup/win' | nawk '{print $5}' | sed 's/.$//')" 
  if [[ $dfbackupwin -gt 79 ]]; then
    dfout="$dfout$(system_warning '⛁ ' $dfbackupwin%% on /backup/win)"
  fi

  local dfbackupnas="$(df -k | grep ' /backup/nas' | nawk '{print $5}' | sed 's/.$//')" 
  if [[ $dfbackupnas -gt 79 ]]; then
    dfout="$dfout$(system_warning '⛁ ' $dfbackupnas%% on /backup/nas)"
  fi

  local dfgalaxy="$(df -k | grep ' /media/Galaxy' | nawk '{print $5}' | sed 's/.$//')" 
  if [[ $dfgalaxy -gt 98 ]]; then
    dfout="$dfout$(system_warning '⛁ ' $dfgalaxy%% on /media/Galaxy)"
  fi

  echo $dfout
}

function cpuusage {
  local cores=$(grep 'model name' /proc/cpuinfo | wc -l)
  local usage=$(ps -eo pcpu | awk '{cpu_usage+=$1} END {print cpu_usage}')
  usage=$(echo "scale=1; $usage/$cores" | bc)

  if [[ $usage -gt 75 ]]; then
#    echo "$(FG_BOLD 255)$(BG 124) ㎓ $(BG 52) $usage%% $(FG_NO_BOLD 252)CPU usage %{$reset_color%} "
    echo "$(system_warning ㎓ $usage%% 'CPU usage')"
  fi
}

function cpuload {
  local cores=$(grep 'model name' /proc/cpuinfo | wc -l)
  local load1m=$(uptime | awk -F'[, ]' '{ print $17 }')
  local load5m=$(uptime | awk -F'[, ]' '{ print $19 }')
  local load15m=$(uptime | awk -F'[, ]' '{ print $21 }')

  if [[ $load5m -gt ($cores+1) ]]; then
#    echo "$(FG_BOLD 255)$(BG 124) ㎓ $(BG 52) $load5m $(FG_NO_BOLD 252)CPU load %{$reset_color%} "
    echo "$(system_warning ㎓ $load5m 'CPU load')"
  fi
}

function ssh_connection {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[blue]%}☁ %{$fg_no_bold[yellow]%}%n%{$fg_no_bold[white]%}@%{$fg_bold[white]%}%M "
  fi
}

function backup_state {
  local backupfile="/backup/linux/arch-lastbackup"
  if [[ -f $backupfile ]]; then
    lastbackup=$(cat $backupfile)
    days=$(( ($(date +%s) - $lastbackup )/(60*60*24) ))
    if [[ $days -ge 2 ]]; then
      echo $(system_warning ▖▘ 'last backup:' %{$bg[red]%}%{$fg_bold[yellow]%}"$days" 'days')
    fi
  fi
}

# return code: %?
local return_code="%(?..%{$bg[red]%}%{$fg_bold[white]%} ⚡ %{$reset_color%} )"

#local time_indicator="%{$fg_bold[blue]%}-%{$fg_bold[yellow]%}⌚ %{$fg_bold[white]%}%*%{$fg_bold[blue]%}-%{$reset_color%}"
local time_indicator="%{$fg_no_bold[yellow]%}⌚ %{$fg_no_bold[white]%}%*%{$reset_color%}"

function prompt_character {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$fg_bold[red]%} >  %{$reset_color%}"
  else
    echo "%{$fg_bold[blue]%} >%{$reset_color%}"
  fi
}


##########
# prompt #
##########


#PROMPT='${return_code}$(cpuusage)$(cpuload)$(diskfree)
# $(FG_BOLD 123)↪  $(ssh_connection)${time_indicator} %{$fg_bold[green]%}${PWD/#$HOME/~} %{$fg_bold[blue]%}% $(git_prompt)%{$reset_color%}
#%{$fg_no_bold[white]%}$(virtualenv_info)$(FG_BOLD 39)⌨  %{$reset_color%} '

#PROMPT='${return_code}$(cpuusage)$(cpuload)$(diskfree)
# $(FG_BOLD 123)↪  $(ssh_connection)${time_indicator} %{$fg_bold[green]%}${PWD/#$HOME/~} %{$fg_bold[blue]%}% $(git_prompt)%{$reset_color%}
#%{$fg_no_bold[white]%}$(virtualenv_info)%{$fg_no_bold[blue]%}⌨  %{$reset_color%} '

PROMPT='
 ${return_code}$(ssh_connection)%{$fg_bold[green]%}${PWD/#$HOME/~} %{$fg_bold[blue]%}% $(git_prompt)%{$reset_color%}
%{$fg_no_bold[white]%}$(virtualenv_info)$(prompt_character)%{$reset_color%} '

if [[ -n $SSH_CONNECTION ]]; then
	RPROMPT='${time_indicator}'
else
	RPROMPT='$(backup_state)$(cpuusage)$(cpuload)$(diskfree) ${time_indicator}'
fi
#RPROMPT='%{$fg_bold[white]%}%*%{$reset_color%}'
#RPROMPT='%{$fg[green]%}$(virtualenv_info)%{$reset_color%}%'

SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# λ ⌨
# ☁ ⚡ ⎇ ✂ ✈ ✱ ⚐ ⚑ ⚙ ✎ ⚠
# ⛀ ⛁ ⛂ ⛃ ✓ ✔ ✅ ✕ ✖ ✗ ✘ ⟲ ⟳
# ㎓ ㎳ ㏈
# ★ ☆ ✦ ✧ ✨ ✩ ✪ ✫ ✬ ✭ ✮ ✯ ✰
# ✱ ✲ ✳ ✴ ✵ ✶ ✷ ✸ ✹ ✺ ✻ ✼ ✽
# ⚔ ⚖ ⚒ ⚓ ☄ ☕ ☠ ⚱ ☢ ⚛ ☣ ☮ ☯
# ♫ 𝄞 𝆑 𝆏 𝆒 𝆓
# 〘 〙 〖 〗 〔 〕
# ▢ ▣ ▤ ▩  ⎗ ⎘ ⎚ ☑ ☒ ◌ ╼ ╾ ⒰ 
# ⚀ ⚁ ⚂ ⚃ ⚄ ⚅
# █ ▉ ▊ ▋ ▌ ▍ ▎ ▏
# 😁 😂 😃 😄 😅 😆 😇 😈 😉 😊 😋 😌 😍 😎 😏 😐 😒 😓 😔 😖 😘 😚 😜 😝 😞 😠 😡 😢 😣 😥 😨 😩 😪 😫 😭 😰 😱 😲 😳 😵 😶 😷 
# 🐱 🐭 🐮 🐵 😸 😹 😺 😻 😼 😽 😾 😿 🙀 
