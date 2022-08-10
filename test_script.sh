#!/bin/bash
function check_env_setup_update() {
  local path="${BASH_SOURCE:-$0}"
	local remote_md5sum=$(curl -sL https://raw.githubusercontent.com/Nathan-ma/check_update_script/main/test_script.sh | md5sum | cut -d ' ' -f 1)
	local local_md5sum=$(md5sum $path | cut -d ' ' -f 1)

  # return the comparison's result
  [ $remote_md5sum == $local_md5sum ]
  return
}

check_env_setup_update
update_result=$?
if ! (exit $update_result); then
  echo "Content is different, this should be an update"
fi
