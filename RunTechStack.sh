#!/bin/bash

# Variables
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'

 function elite
  {

  local GRAY="\[\033[1;30m\]"
  local LIGHT_GRAY="\[\033[0;37m\]"
  local CYAN="\[\033[0;36m\]"
  local LIGHT_CYAN="\[\033[1;36m\]"

  case $TERM in
      xterm*)
          local TITLEBAR='\[\033]0;\u@\h:\w\007\]'
          ;;
      *)
          local TITLEBAR=""
          ;;
  esac

  local GRAD1=$(tty|cut -d/ -f3)
  PS1="$TITLEBAR\
  $GRAY-$CYAN-$LIGHT_CYAN(\
  $CYAN\u$GRAY@$CYAN\h\
  $LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
  $CYAN\#$GRAY/$CYAN$GRAD1\
  $LIGHT_CYAN)$CYAN-$LIGHT_CYAN(\
  $CYAN\$(date +%H%M)$GRAY/$CYAN\$(date +%d-%b-%y)\
  $LIGHT_CYAN)$CYAN-$GRAY-\
  $LIGHT_GRAY\n\
  $GRAY-$CYAN-$LIGHT_CYAN(\
  $CYAN\$$GRAY:$CYAN\w\
  $LIGHT_CYAN)$CYAN-$GRAY-$LIGHT_GRAY "
  PS2="$LIGHT_CYAN-$CYAN-$GRAY-$LIGHT_GRAY "
  }

#ACII ART
#https://patorjk.com/software/taag/#p=display&f=Graffiti&t=First%20Project

firstProjectArt=$'
\033[1;32m
______ _          _    ______          _           _   
|  ___(_)        | |   | ___ \        (_)         | |  
| |_   _ _ __ ___| |_  | |_/ /___ ___  _  ___  ___| |_ 
|  _| | |  __/ __| __| |  __/  __/ _ \| |/ _ \/ __| __|
| |   | | |  \__ \ |_  | |  | | | (_) | |  __/ (__| |_ 
\_|   |_|_|  |___/\__| \_|  |_|  \___/| |\___|\___|\__|
                                     _/ |              
                                    |__/               
'

secondProjectArt=$'
\033[1;34m
 _____                          _  ______          _           _   
/  ___|                        | | | ___ \        (_)         | |  
\ `--.  ___  ___ ___  _ __   __| | | |_/ / __ ___  _  ___  ___| |_ 
 `--. \/ _ \/ __/ _ \|  _ \ / _` | |  __/  __/ _ \| |/ _ \/ __| __|
/\__/ /  __/ (_| (_) | | | | (_| | | |  | | | (_) | |  __/ (__| |_ 
\____/ \___|\___\___/|_| |_|\__,_| \_|  |_|  \___/| |\___|\___|\__|
                                                 _/ |              
                                                |__/               
'

cleaningArt=$'
\033[1;34m
 _____ _                  _             
/  __ \ |                (_)            
| /  \/ | ___  __ _ _ __  _ _ __   __ _ 
| |   | |/ _ \/ _  |  _ \| |  _ \ / _  |
| \__/\ |  __/ (_| | | | | | | | | (_| |
 \____/_|\___|\__,_|_| |_|_|_| |_|\__, |
                                   __/ |
                                  |___/ 
'
## ARGUMENTS

# Help
if [[ "$1" == "help" ]]; then
  echo "- FirstProject      -   First Project Application"
  echo "- SecondProject     -   Second Project Application"
  exit 1
# First Project
elif [[ "$1" == "FirstProject" ]]; then
  currentArt=$firstProjectArt
  title="   - Creating docker stack for FirstProject\n"
  #Variables to Change
  path=~/Dev/Applications/FirstProject # path to the project
  command="./vendor/laravel/sail/bin/sail up -d" #command to docker up the project
# Second Project
elif [[ "$1" == "SecondProject" ]]; then
  currentArt=$secondProjectArt
  title="   - Creating docker stack for SecondProject\n"
  path=~/Dev/Applications/SecondProject # path to the project
  command="docker-compose up -d" #command to docker up the project
# Clean
elif [[ "$1" == "clean" ]]; then
  currentArt=$cleaningArt
  title="   - CleaningAll Services\n"
# Fail
else
  echo "Need a parameter"
  exit 1
fi

# Functions
check_active_dockers() {
  # Check Current Dockers
  echo -e "${GREEN}"
  printf '   - Checking for running dockers ... \n'
  echo -e "${NC}"

  if [ $(docker ps -a -q | wc -l) -ge 1 ]; then
    echo -e "${RED}"
    printf '   - Deleting active dockers.\n'

    OUTPUT=$(docker rm -f $(docker ps -a -q))
    printf "${OUTPUT}"

    echo -e "${NC}"
    printf '   - Deleted all active docker succesfully.\n'
    echo -e "${NC}"

  else
    echo -e "${NC}"
    printf '   - There are not any running docker.\n'
    echo -e "${NC}"
  fi
}

check_active_sql() {
  # Check Active Mysql
  mysqlResponse=$(systemctl status mysql)
  isActive='Active: active'
  if [[ "$mysqlResponse" == *"$isActive"* ]]; then
    echo -e "${RED}"
    printf '   - Deleting active mysql service.\n'
    systemctl stop mysql
    echo -e "${NC}"
    echo
  fi
}

check_active_apache() {
  # Check Active Apache
  apacheResponse=$(systemctl status apache2)
  isActive='Active: active'
  if [[ "$apacheResponse" == *"$isActive"* ]]; then
    echo -e "${RED}"
    printf '   - Deleting active apache service.\n'
    systemctl stop apache2
    echo -e "${NC}"
    echo
  fi
}

echo "$currentArt"
echo -e "${NC}"

check_active_dockers

echo -e "${GREEN}"
printf '   - Checking for other active services ... \n'
echo -e "${NC}"

check_active_sql
check_active_apache

echo -e "${NC}"
if [[ "$1" != "clean" ]]; then
# Docker up
printf "$title"
echo

cd $path
$command

echo -e "${NC}"
printf "   - Docker stack has created succesfully\n \n"

docker ps --format 'table {{ .ID }}\t{{.Image}}\t{{ .Names }}\t{{ .Ports}}\t{{.Status}}'
echo

elif [[ "$1" == "clean" ]]; then
echo -e "${NC}"
printf "   - Clean finish succesfully\n \n"
fi
