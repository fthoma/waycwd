# waycwd

Print the current working directory of the active window under
[Wayland](https://wayland.freedesktop.org/). Inspired by
[xcwd](https://github.com/schischi/xcwd).

![Usage visulization of waycwd](/assets/waycwd.png)

## Usage
Using waycwd start a new terminal emulator in the same directory as the current
active window. For example using [Sway](https://swaywm.org/) and
[Alacritty](https://alacritty.org/) this could be achived with this line in
*~/.config/sway/config*.
```sway
bindsym Mod1+Backspace exec alacritty --working-directory="$(waycwd)"
```

## Supported Platforms

|Window Manager|Support|
|-|-|
|[Sway](https://swaywm.org/)|:white_check_mark:|
|Other|:x:|

## Programming Language Showcase
This repo also doubles as a playground for me to mess around with different
programming languages. waycwd uses
[sway-ipc](https://man.archlinux.org/man/sway-ipc.7.en) for window
introspection. Its an RPC style unix socket responding with json messages. This
makes waycwd an ideal starter project to learn about socket communication, file
handling and serialization in a new programming language. In their respective
directories there are implemantations in
- [ ] [Zig](/zig)
- [x] [Rust](/rust)
- [ ] [Go](/go)
- [ ] [Python](/python)
