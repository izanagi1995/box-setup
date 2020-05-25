BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
# I don't like that but it is required for the second step...
sudo apt-get install curl 2>&1 > /dev/null
PUBLIC_IP=$(curl -s ifconfig.co)

# COLOR HELPERS
# =============
RESET=$(tput sgr0)

LIGHT_GREY=$(tput setaf 246)

BRACKET_GREEN=$(tput setaf 40)
TEXT_GREEN=$(tput setaf 46)

BRACKET_RED=$(tput setaf 160)
TEXT_RED=$(tput setaf 196)

TEXT_SUCCESS=$(tput setaf 10)

BRACKET_CAVEAT=$(tput setaf 208)
TEXT_CAVEAT=$(tput setaf 214)

# TOOLING
# =======

mkdir -p ./.tmp/{vars,target}
rm -f ./.tmp/**/*
mkdir -p ./logs/verbose
rm -f logs/*.log
rm -f logs/verbose/*.log
script_name=`basename "$0"`
logs_path="./logs/${script_name%.*}.log"
verbose_path="./logs/verbose/${script_name%.*}.log"

log () {
    echo -e "${LIGHT_GREY}($(date '+%F %T'))${RESET} $@" | tee -a $logs_path $verbose_path
}

step_info () {
  log "${BRACKET_GREEN}[ ${TEXT_GREEN}$@${BRACKET_GREEN} ]${RESET}"
}

fail () {
  log "${BRACKET_RED}[ ${TEXT_RED}$@${BRACKET_RED} ]${RESET}"
}

caveat () {
  log "${BRACKET_CAVEAT}[ ${TEXT_CAVEAT}CAVEAT${BRACKET_CAVEAT} ]${TEXT_CAVEAT} $@${RESET}"
}

exit_on_error () {
  fail "$@"
  exit 1
}

success () {
  log "${TEXT_SUCCESS}${script_name} succeeded !${RESET}"
}

copy_file () {
  sudo cp -R "$BASE_DIR/files/$1" "$2"
}

store_glob () {
  echo "${@:2}" > "$BASE_DIR/.tmp/vars/$1"
}

get_glob () {
  cat "$BASE_DIR/.tmp/vars/$1"
}

patch_template_file () { # src_file, dest_file
  tmp_file="$BASE_DIR/.tmp/$(basename $1)"
  copy_file $1 $tmp_file
  for f in $BASE_DIR/.tmp/vars/*
  do
    vname=$(basename $f)
    value=$(cat $f)
    sed -i "s~%$vname%~$value~g" $tmp_file
  done
  sudo cp $tmp_file $2
}

argon_hash () {
  printf "$@" | argon2 $(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1) -e
}

export $(cat .env | xargs)
