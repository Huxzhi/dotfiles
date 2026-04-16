# 设置 gs 代表 git status
Set-Alias gs git-status
Set-Alias cc claude


# 设置 ll 代表 ls -la (通过函数实现，因为别名不支持参数)
function Get-ChildItemLast { Get-ChildItem -Force }
Set-Alias ll Get-ChildItemLast

function Rclone-secret { 
rclone  mount secret: V: --vfs-cache-mode full --network-mode --links --no-console
}
Set-Alias rclone-s Rclone-secret