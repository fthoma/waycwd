# waycwd

Print the current working directory of the active window under
[Wayland](https://wayland.freedesktop.org/). Inspired by
[xcwd](https://github.com/schischi/xcwd).

![Usage visulization of waycwd](/assets/waycwd.gif)

## Installation
- Get the latest binary from the [release page](release/latest)
- Or build from source ```make``` (using zig)

## Usage
Using waycwd start a new terminal emulator in the same directory as the current
active window. For example using [Sway](https://swaywm.org/) and
[Alacritty](https://alacritty.org/) this could be achived with this line in
*~/.config/sway/config*.
```sway
bindsym Mod1+Backspace exec alacritty --working-directory="$(waycwd)"
```

### Supported Window Managers

- [Sway](https://swaywm.org/)
- Others migh follow as needed
