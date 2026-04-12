### --- 1. 环境变量 (使用 fish_add_path 绝对安全) ---
# fish_add_path 会自动去重，且不会因为多次 source 导致卡顿

# 个人 Bin 目录
fish_add_path "$HOME/.local/bin"

set -gx GALLIUM_DRIVER d3d12
set -gx MESA_D3D12_DEFAULT_ADAPTER_NAME 1

# 设置默认编辑器为 nvim
set -gx EDITOR nvim
set -gx VISUAL nvim

# Bun 配置
set -gx BUN_INSTALL "$HOME/.bun"
fish_add_path "$BUN_INSTALL/bin"

### --- 2. 交互式会话配置 ---
if status is-interactive
    # 关闭欢迎语
    set -g fish_greeting ""

    # --- 缩写 (推荐用 abbr，比 alias 更快且有输入反馈) ---
    abbr -a n nvim
    abbr -a cc claude
    abbr -a gs 'git status'
    abbr -a cls clear
    abbr -a pac-clean 'sudo pacman -Rns (pacman -Qdtq)'

    # --- 启动 Starship (增加安全判断) ---
    # 只有当 starship 命令存在时才加载，防止报错卡死
    if type -q starship
        starship init fish | source
    end
end

function y
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    command yazi $argv --cwd-file="$tmp"
    if read -z cwd <"$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
