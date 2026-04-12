## chezmoi
我使用 chezmoi 来管理我的配置文件。 官网 https://www.chezmoi.io/

Chezmoi 是一个跨端的配置文件管理工具，可以帮助你在多台设备之间同步配置文件。

## 日常常用操作
编辑配置

```
chezmoi edit $FILENAME
```

应用配置
```
chezmoi apply
```

Chezmoi 在编辑配置的时候只会修改 Source State。

拉取更新
```
chezmoi update
```


### 在新机器上配置 Chezmoi
以 macOS 为例：

#### 安装 chezmoi
```
brew install chezmoi
```
如果没有 Homebrew，可以参考 官方安装指南，里面有各种系统的安装方法。

#### 初始化 Chezmoi
```
chezmoi init
```

运行后会在本地 ~/.local/share/chezmoi 下创建一个 git 仓库，用于存储所有由 Chezmoi 跟踪的文件。

#### 添加需要跟踪的文件
```
chezmoi add $FILEPATH
```
在 GitHub 中新建一个配置仓库 这个仓库通常命名为 dotfiles，但是也可以根据自己的喜好修改成自己想要的名字。后续只需要修改 git remote url 即可。

#### 配置 GitHub 仓库 
注意替换 `$GITHUB_USERNAME` 和 `$REPOSITORY_NAME`
```
chezmoi cd
git remote add origin https://github.com/$GITHUB_USERNAME/$REPOSITORY_NAME.git
git push -u origin main
exit
```
#### 在另一台机器上快速初始化
```
chezmoi init https://github.com/$GITHUB_USERNAME/dotfiles.git
chezmoi apply
```
这样就能快速把配置同步到新机器上。

### chezmoi 的配置

- 源文件存储路径：`~/.local/share/chezmoi`
- 配置文件路径：`~/.config/chezmoi/chezmoi.toml` 配置文件支持 TOML / JSON / YAML 格式。

修改文件后自动提交更新到仓库

打开或新建 `~/.config/chezmoi/chezmoi.toml`，添加：

```toml
[git]
autoCommit = true
autoPush = true
```
这样在 chezmoi apply 后，修改会自动提交并推送到仓库。

### 配置默认编辑器

例如设置为 VS Code：

```toml
[edit]
command = "code"
args = ["--wait"]
```

### 合并配置文件

如果不小心直接修改了 `~/.zshrc`，可以执行：
```
chezmoi merge ~/.zshrc
```
将更改合并回 Chezmoi 管理的文件中。

### 过滤无效文件

在 `~/.local/share/chezmoi/.chezmoiremove` 中添加规则来忽略文件。 例如自动删除 `.DS_Store`：

```
**/.DS_Store
```
### 其他操作

```
取消管理但保留文件：chezmoi forget $FILEPATH
移除管理并删除文件：chezmoi remove $FILEPATH
```
文件映射的原理
Chezmoi 通过 文件名映射规则 管理配置文件：

`dot_filename → $HOME/.filename dir/file → $HOME/dir/file`

例如 dot_zshrc 对应 ~/.zshrc。

因此也可以直接编辑 ~/.local/share/chezmoi 下的文件，再执行：
```
chezmoi apply
```
将修改应用到实际配置中。

使用 `chezmoi cd` 可以快速跳转到 `~/.local/share/chezmoi` 目录。

> Chezmoi 在 Why doesn’t chezmoi use symlinks like GNU Stow? 详细介绍了为什么不适用符号链接。


### 忽略不应该添加的文件

在 ~/.local/share/chezmoi/.chezmoiignore 中配置：

```ignore
**/.DS_Store
**/.AppleDouble
**/.LSOverride

**/Thumbs.db
**/ehthumbs.db

**/*~
**/#*#
**/.TemporaryItems

**/Library/Application Support/com.mitchellh.ghostty/*.tmp

**/.vscode
**/.idea
**/.history

**/node_modules
**/package-lock.json
**/pnpm-lock.yaml
**/yarn.lock

**/tmp
**/temp

**/*.cache
```
## 机器

### WSL 


### windows


### Mac OS
