# waycwd - [xcwd](https://github.com/schischi/xcwd) for wayland

<picture>
 <img alt="Usage visulization of waycwd" width="600" src="https://github.com/fthoma/waycwd/assets/347446/429d27b7-a592-4c5b-a0c2-af3d38008753">
</picture>
![Usage visulization of waycwd](/assets/waycwd.png)
Print the current working directory of the active window.

A typical use case would be to start a new program in the same path as the current window. For example using [sway](https://swaywm.org/) and Alacritty(https://alacritty.org/) in your sway/config
```sway
bindsym $mod+Backspace exec alacritty --working-directory="$(waycwd)"
```
