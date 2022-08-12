# !/usr/bin/env bash

# Check to make sure script is being sourced otherwise exit
SOURCED=0

# zsh
if [ -n "$ZSH_EVAL_CONTEXT" ]; then
    case $ZSH_EVAL_CONTEXT in *:file) SOURCED=1;; esac

# ksh
elif [ -n "$KSH_VERSION" ]; then
    [ "$(cd $(dirname -- "$0") && pwd -P)/$(basename -- "$0")" != "$(cd $(dirname -- ${.sh.file}) && pwd -P)/$(basename -- ${.sh.file})" ] && SOURCED=1

# bash
elif [ -n "$BASH_VERSION" ]; then
    (return 0 2>/dev/null) && SOURCED=1

# All other shells: examine $0 for known shell binary filenames
else
    # Detects `sh` and `dash`; add additional shell filenames as needed.
    case ${0##*/} in sh|dash) SOURCED=1;; esac
fi


SCRIPT_PATH="${BASH_SOURCE[0]:-${(%):-%x}}"

check_env_setup_update() {

	local remote_md5sum=$(curl -sL https://raw.githubusercontent.com/Nathan-ma/check_update_script/main/test_script.sh | md5sum | cut -d ' ' -f 1)
	local local_md5sum=$(md5sum "$1" | cut -d ' ' -f 1)
  echo "$local_md5sum"
  echo "$remote_md5sum"
  # return the comparison's result
  [[ "$remote_md5sum" == "$local_md5sum" ]]
  return
}

check_env_setup_update $SCRIPT_PATH
update_result=$?
if ! (exit $update_result); then
  echo "Content is different, this should be an update"
  wget "https://raw.githubusercontent.com/Nathan-ma/check_update_script/main/test_script.sh" -O "test_script.tmp"
  source test_script.tmp
  mv test_script.tmp "$PWD/$SCRIPT_PATH"
fi

[ "$SOURCED" -eq 1 ] && echo "Sourced" || echo "Not Sourced"
