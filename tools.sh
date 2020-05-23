BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"


# COLOR HELPERS
# =============
RESET=$(tput sgr0)

LIGHT_GREY=$(tput setaf 246)

BRACKET_GREEN=$(tput setaf 40)
TEXT_GREEN=$(tput setaf 46)

BRACKET_RED=$(tput setaf 160)
TEXT_RED=$(tput setaf 196)

TEXT_SUCCESS=$(tput setaf 10)

# TOOLING
# =======

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

exit_on_error () {
  fail "$@"
  exit 1
}

success () {
  log "${TEXT_SUCCESS}${script_name} succeeded !${RESET}"
}

copy_file () {
  sudo cp "$BASE_DIR/files/$1" "$2"
}
export $(cat .env | xargs)
