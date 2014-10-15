function ssh_auth_env
  echo set -x SSH_AUTH_SOCK /run/user/(id -u $USER)/ssh_auth_sock
  echo set -x SSH_AGENT_PID (systemctl show --user -p MainPID ssh-agent | sed "s/MainPID=//")
end
