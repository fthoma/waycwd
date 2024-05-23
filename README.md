# waycwd

Print the current working directory of the active window under [Wayland](https://wayland.freedesktop.org/). Inspired by [xcwd](https://github.com/schischi/xcwd).

![Usage visulization of waycwd](/assets/waycwd.png)

## Usage
Using waycwd you can start a new terminal emulator in the same directory as the current active window. 
For example using [Sway](https://swaywm.org/) and [Alacritty](https://alacritty.org/) this could be achived with this line in *~/.config/sway/config*
```sway
bindsym Mod1+Backspace exec alacritty --working-directory="$(waycwd)"
```

## Supported Platforms

|Window Manager|Support|
|-|-|
|[Sway](https://swaywm.org/)|:white_check_mark:|
|Other|:x:|

## About
This repo also doubles as a playground for me to mess around with different programming languages. In their respective branches there are implemantations in
- [ ] [Zig](../main)
- [x] [Rust](../rust)
- [ ] [Go](../go)
- [ ] [Python](../python)
