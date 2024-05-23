# waycwd

Print the current working directory of the active window under [Wayland](https://wayland.freedesktop.org/). Inspired by [xcwd](https://github.com/schischi/xcwd).
<p align="center">

![Usage visulization of waycwd](/assets/waycwd.png)

</p>

## Usage
Using waycwd you can start a new terminal emulator in the same directory as the current active window. 
For example using [Sway](https://swaywm.org/) and [Alacritty](https://alacritty.org/) this could be achived by adding this to your *~/.config/sway/config*
```sway
# ~/.config/sway/config
bindsym Mod1+Backspace exec alacritty --working-directory="$(waycwd)"
```

## Supported Platforms

|Window Manager|Support|
|----------|-|
|[Sway](https://swaywm.org/)|:white_check_mark:|
|Other|:x:|

## About
This repo also doubles as a playground for me to mess around with different programming languages. 
