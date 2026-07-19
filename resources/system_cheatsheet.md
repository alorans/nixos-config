# System Cheatsheet

- KDE
    - Use `Alt` + `Space` to open KRunner.
    - Hold `Shift` while pressing the volume keys to adjust in increments of 1% as opposed to 5%.
    - `Ctrl` + `Meta` + arrow keys:
    - How I generally organize my desktops
        1. VSCodium (+ terminal windows)
        2. Firefox
        3. Any other application I need
    - Some useful window options (accessible by right clicking the title bar)
        - *Keep above others*
        - *Pin* = window appears on all desktops
        - *Hide from screencast*
        - *Move to Desktop* = sometimes quicker or more precise than clicking and dragging in the application bar desktops widget

- Kernel
    - TTY
        - `Ctrl` + `Alt` + `F[1-6]`, `sudo chvt [1-6]`: switch virtual console.
        

- Clipboard
    - `Ctrl` + `C` = regular apps, e.g. browser.
    - `Ctrl` + `Shift` + `C` = terminals
    - `"+y` = vim

- Git
    - `git merge`: You generally want to rebase because it makes the commit history much easier to follow.
    - `git rm --cached`: This removes a file from the git cache. For example, so new .gitignore rules can take effect.
    - `git commit --amend`: Amend the previous commit.
    - `git log`: List commit hashes and messages.
    - `git blame`: See the commits at which different lines of a file were touched. This is sometimes automatically integrated into code editors.
    - `git diff HEAD`: See differences between the current state of the code and the last commit.
        - `--shortstat`: only print files changed, line insertions, and line deletions.
    - `git rebase -i`: Interactive rebase
        - This is kinda complicated and has a lot of internal commands in the repl.
        - I primarily use it to squash commits. See [this section of the git book](https://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#_squashing).

- Vim
    - This is not intended to be a remotely complete list. It is pretty much just commands that I think are useful but often forget.
    - How I use it
        - I learned the vim keybindings by printing and taping a whole bunch of vim cheatsheets on the wall behind my desk. I'm certainly not an expert at Vim, but I'm as proficient as I want to be, so I would say it was a success.
        - I use VSCodium with the vim extension for real code editing work that needs LSPs, extensions and the like, but I use just plain vim for "on-the-fly" editing when I'm navigating in terminal.
    - Essential (but not obvious) keybindings
        - `}` and `{`: go back and forward by a paragraph.
        - `+` and `-`: go to the start of the previous and next lines (after whitespace).
        - `^` and `$`: go to the start and end of the current line, respectively (based on regex, I think).
        - `*`: search for word under cursor.
        - `J`: join line with the next one.
        - `.` and `@@`: repeat previous command and repeat previous macro, respectively.
        - `ctrl` + `i` (or `tab`) and `ctrl` + `o`: navigate forward and back in the jump list ("old").
    - Scrolling
        - `ctrl` + `e` and `ctrl` + `y`: scroll up and down by one line. I use these the most.
        - `ctrl` + `u` and `ctrl` + `d`: scroll up and down by a half screen ("up" and "down").
        - `ctrl` + `b` and `ctrl` + `f`: scroll up and down by a full screen ("back" and "forward").
    - Buffer management
        - `:e`: open a file in a new buffer.
        - `:wa`: write all modified buffers.
        - `:ls`: list all current buffers and their ids.
        - `:bn` and `:bp`: next buffer and previous buffer.
        - `:b <id or name>` jump to buffer via id or partial file name.
        - `:bd`: buffer delete.
    - Split view
        - `:sb <id or name>`: horizontal split view via id or partial file name.
        - `:ba`: horizontal split view all open buffers.
            - Prepend `vert` to either previous command to use vertical split-views.
        - `ctrl` + `w` then `c`: close window.
        - `:on`: close all other windows ("only").
        - `ctrl` + `w` then `s` or `v`: split horizontally or vertically.
        - `ctrl` + `w` then `h`, `j`, `k`, or `l`: move between windows.
            - Prepend `shift` to the previous command to rearrange windows.

- Systemd
    - `systemctl list-units` = list all available units and targets that you can use in systemd services.
    - `man systemd.service` and `man systemd.unit` show many options.

- Hardware
    - `Fn` + `Space`: toggle the key backlight (Lenovo laptops).
    - `systemd-inhibit --what=handle-lid-switch sleep infinity`: close laptop lid without computer going to sleep
    - Get details
        - CPU: `lscpu`
        - RAM: `free -h`
        - Storage: `df -h`

- Bash
    - yt-dlp
        - `yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 "VIDEO_URL"`: This is generally how you want to do it.
    - direnv
        - `direnv allow`, `direnv disallow`: allow and disallow a .envrc file from executing.
        - `direnv prune`: prune .envrc files that no longer exist from the allow list.
    - `xdg-open` on Linux is the same as `open` on Mac, that is, it opens a file in the default application.
    - `ctrl` + `a`: go to start of line (Emacs mode)

- Firefox
    - NoScript is set to strict by default. I permamently allow websites I visit often (eg: github), and temporarily allow the rest when I need them.
        - Even if you put it to default allow all JS, the cross-site scripting (XSS) protection is good to have.
    - Middle-click a link to open it in a new tab.
    - Sidebar keybindings
        - `ctrl` + `b`: bookmarks
        - `ctrl` + `h`: history
        - `f1`: tree-style tab
        - If a website overrides some of these keybindings (eg: Google docs), click in the sidebar before using them.
    - Tab keybindings
        - `ctrl` + `t`: new tab
        - `ctrl` + `w`: close tab
        - `ctrl` + `shift` + `t`: reopen previously closed tab
        - `alt` + `click` (on another tab): open split view (in Firefox version 149 or greater)
