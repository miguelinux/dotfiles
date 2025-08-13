# How to turn off alert sounds/sound effects on Gnome from terminal?

  * `dconf write /org/gnome/desktop/sound/event-sounds false`

# Alt+Tab all windows across workspaces

  * `gsettings get org.gnome.shell.window-switcher current-workspace-only`
  * `gsettings set org.gnome.shell.window-switcher current-workspace-only false`
