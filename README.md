## Here's a list of programs whose configs can be found here
 - i3 (i3-gaps)
 - i3blocks
 - dunst
 - pcmanfm
 - pulseaudio-ctl
 - zathura
 - mpv
 - termite
 - guvcview2 (either remove this folder or change the "profile_path=")

There are also dotfiles like
  - .bashrc
  - .xinitrc
  - .profile
  - .inputrc

These configs are deployed by [YARBS](https://github.com/ispanos/YARBS/blob/master/yarbs.sh), a fork of [LARBS](https://github.com/LukeSmithxyz/LARBS).

I haven't updated the script since my last format, and Luke's updates are useful. Right now if you want to set-up your system like mine, you are better off using [larbs.sh](https://github.com/LukeSmithxyz/LARBS/blob/master/larbs.sh). Download it and edit it to use my [progs.csv](https://raw.githubusercontent.com/ispanos/YARBS/master/progs.csv) file and [dotfiles](https://github.com/ispanos/Yar) repo if you like them. 

## [my list of programs](https://github.com/namesyiannis/YARBS/blob/master/progs.csv).
I keep this list always up to date. It helps me track what I have installed on my system. In order for my configs to work as they are, you probably need most of those programs too. However if you don't like them I tried to make it as easy as possible to change the programs needed in i3's config.

# What's up with .config/i3 ?
I am experimenting with splitting the config file into [multiple smaller parts](https://github.com/ispanos/Yar/tree/master/.config/i3/conf.d). All edits must be done on those files, otherwise they will be deleted once i3 reloads using the keybind. [1-general](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/1-General) includes the most important configs, since there I set the "default" programs as variables. This way any changes to the preferred programs (and/or options) can be done in [1-general](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/1-General). [4-keybinds](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/4-keybinds) includes all the key-binds (`bindsym`). The only reason to edit it would be to change the actual key-binds, since the `exec` commands call the variables mentioned previously. 

A few things you may want to changed are:
  - [1-general](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/1-General) `setxkbmap` sets `shift+alt` to toggle between greek and english. You may want to **remove** the line or **change the "gr"** to your language.
  - [2-Bar-theme](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/2-Bar-theme) I added a wallpaper in `.config/`. You can change `$wallpaper` to change it.
  - [3-Gaps](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/3-Gaps) If you use `i3-wm` instead of `i3-gaps` you can delete that file.
  - [6-Monitors-X](https://github.com/ispanos/Yar/blob/master/.config/i3/conf.d/6-Monitors-X) **Delete the file** because it will probably cause you trouble.

## [Extra packages (bloat)](https://gist.github.com/ispanos/cd64a41bfb01aa4e645099bc11908303)
There I have archived some programs that I used in the past. In case you need some ideas check the gist. The most interesting stuff there are probably the Wayland packages if you plan to try Sway. I do plan to change to [Sway](https://github.com/swaywm/sway) when Navi comes out because it sounds good.

## Last but not least
I use Manjaro for now, not Arch. I don't think it makes any difference besides the `steam-manjaro` package. I use it in part because I am comfortable there and because Manjaro-Architect handles the proprietary nvidia drivers and multilib for me. Also manjaro's forum is great. If you want to use Manjaro too, I would highly recommend installing it using Architect and do as many things as you can manually to avoid having both my programs and those that come with a pre-configured desktop too.


##### I do plan to add better documentation for my configs and programs. However I'm very new to i3 and linux in general, so I need to settle and stop changing stuff every day. Then I will start adding more information and maybe have time to keep my YARBS script up to date.
