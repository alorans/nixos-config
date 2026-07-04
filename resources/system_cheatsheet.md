# System Cheatsheet

- Switch to kernel TTY
    - `Ctrl` + `Fn` + `Alt` + `F[1-6]`

- Close laptop lid without computer going to sleep
```sh
systemd-inhibit --what=handle-lid-switch sleep infinity
```

- KDE window settings (these are accessible by right clicking the title bar of the window)
    - *Keep above others*
    - *Pin*
    - *Hide from screencast*