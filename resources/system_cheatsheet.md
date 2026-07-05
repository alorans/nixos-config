# System Cheatsheet

- Switch to kernel TTY
    - `Ctrl` + `Fn` + `Alt` + `F[1-6]`

- Close laptop lid without computer going to sleep
```sh
systemd-inhibit --what=handle-lid-switch sleep infinity
```

- KDE
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