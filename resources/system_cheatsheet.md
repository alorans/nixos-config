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

- yt-dlp
    - `yt-dlp -f "bestvideo[height<=1080]+bestaudio/best[height<=1080]" --merge-output-format mp4 "VIDEO_URL"`: This is generally how you want to do it.

- direnv
    - `direnv allow`, `direnv disallow`: allow and disallow a .envrc file from executing.
    - `direnv prune`: prune .envrc files that no longer exist from the allow list.

- `xdg-open` on Linux is the same as `open` on Mac, that is, it opens a file in the default application.