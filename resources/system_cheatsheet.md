# System Cheatsheet

- Switch to kernel TTY
    - `Ctrl` + `Fn` + `Alt` + `F[1-6]`

- Close laptop lid without computer going to sleep
```sh
systemd-inhibit --what=handle-lid-switch sleep infinity
```

- KDE
    - Use `Alt` + `Space` to open KRunner.
    - How I generally organize my desktops
        1. VSCodium (+ terminal windows)
        2. Firefox
        3. Any other application I need
    - Some useful window options (accessible by right clicking the title bar)
        - *Keep above others*
        - *Pin* = window appears on all desktops
        - *Hide from screencast*
        - *Move to Desktop* = sometimes quicker or more precise than clicking and dragging in the application bar desktops widget

- Hardware details
    - CPU: `lscpu`
    - RAM: `free -h`
    - Storgae: `df -h`

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