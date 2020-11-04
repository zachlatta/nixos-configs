export PATH="~/.local/bin:$PATH"

export EDITOR="e"

# If running on Windows in WSL...
if [[ $(grep "microsoft" /proc/version) ]]; then
    # From https://emacsredux.com/blog/2020/09/23/using-emacs-on-windows-with-wsl2/
    export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0
fi
