### --- 1. 环境变量 (使用 fish_add_path 绝对安全) ---
# fish_add_path 会自动去重，且不会因为多次 source 导致卡顿

# 个人 Bin 目录
fish_add_path "$HOME/.local/bin"

# 添加 macOS 的环境变量
if test -d /opt/homebrew/bin
    /opt/homebrew/bin/brew shellenv | source
end

zoxide init fish --cmd cd | source

# 设置默认编辑器为 nvim
set -gx EDITOR nvim
set -gx VISUAL nvim

# 强制 Firefox 使用 Wayland
set -gx MOZ_ENABLE_WAYLAND 1

# 强制 Qt 软件使用 Wayland
set -gx QT_QPA_PLATFORM wayland

# 强制 GTK 软件使用 Wayland
set -gx GDK_BACKEND wayland

# Bun 配置
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

### --- 2. 交互式会话配置 ---
if status is-interactive
    # 关闭欢迎语
    set -g fish_greeting ""

    # --- 启动 Starship (增加安全判断) ---
    # 只有当 starship 命令存在时才加载，防止报错卡死
    if type -q starship
        starship init fish | source
    end

    if type -q fastfetch
        fastfetch -c examples/31.jsonc
    end
end

# --- 缩写 (推荐用 abbr，比 alias 更快且有输入反馈) ---
abbr -a n nvim
abbr -a cc claude
abbr -a gs 'git status'
abbr -a cls clear
abbr -a pac-clean 'sudo pacman -Rns (pacman -Qdtq)'
abbr -a ff fastfetch
abbr -a rclone-s "rclone mount secret: ~/mount-s --vfs-cache-mode full --daemon"

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end

function cat
    command bat $argv
end
function ls
    command eza --icons $argv
end

function lt
    command eza --icons --tree $argv
end
# grub
abbr grub 'LANGUAGE=en_US.UTF-8 LANG=en_US.UTF-8 sudo grub-mkconfig -o /boot/grub/grub.cfg'
# 小黄鸭补帧 需要steam安装正版小黄鸭
abbr lsfg 'LSFG_PROCESS="miyu"'
# fa运行fastfetch

abbr reboot 'systemctl reboot'
function sl
    command sl | lolcat
end
function 滚
    sysup
end
function raw
    command ~/.config/scripts/random-anime-wallpaper.sh $argv
end

function 安装
    command yay -S $argv
end

function 卸载
    command yay -Rns $argv
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/anaconda3/bin/conda
    eval /opt/anaconda3/bin/conda "shell.fish" hook $argv | source
else
    if test -f "/opt/anaconda3/etc/fish/conf.d/conda.fish"
        . "/opt/anaconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH /opt/anaconda3/bin $PATH
    end
end
# <<< conda initialize <<<
