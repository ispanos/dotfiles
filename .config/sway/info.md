# How I handle i3 configs on multiple systems | Better sway compatibility

I want my i3 configs to work on multiple hardware configurations. Instead of keeping multiple config files for different computers, I've split up the config file. 

## A different [~/.config/i3/](https://github.com/ispanos/dotfiles/tree/master/.config/i3) :
- [.config/i3/X](https://github.com/ispanos/dotfiles/blob/master/.config/i3/X): Starts some x-related programs, instead of having them in `.xinitrc`[1] and some variables that are used in other files, that are sway compatible.
- `hostname`_X: Contains mainly `xrandr` commands for my monitor layout on different systems. I use the `hostname` as a system identifier. This file could include `bar{...}`, if you use different bars on each computer.

- [~/.config/i3/config.d](https://github.com/ispanos/dotfiles/tree/master/.config/sway/config.d) is a folder with configurations that work both for i3 and sway (the latter I haven't tested it months). 
    - [1-General](https://github.com/ispanos/dotfiles/blob/master/.config/sway/config.d/1-General): Some variables, a lock `mode` and starts some programs.
    - [2-Bar-theme](https://github.com/ispanos/dotfiles/blob/master/.config/sway/config.d/2-Bar-theme): Starts the `bar{...}` and some other settings related to the looks.
    - [3-keybinds](https://github.com/ispanos/dotfiles/blob/master/.config/sway/config.d/3-keybinds) : Contains all the key-binds. Most programs are variables in this file, set either in [~/.config/i3/config.d/1-General](https://github.com/ispanos/dotfiles/blob/master/.config/sway/config.d/1-General) or [.config/i3/X](https://github.com/ispanos/dotfiles/blob/master/.config/i3/X) to maintain compatibility with `sway`.

### How it all comes together.
[i3confmerg](https://github.com/ispanos/dotfiles/blob/master/.local/bin/wm-scripts/i3confmerge) is a simple script I wrote to combine all the files in [~/.config/i3/config.d/](https://github.com/ispanos/dotfiles/tree/master/.config/sway/config.d), [~/.config/i3/X](https://github.com/ispanos/dotfiles/blob/master/.config/i3/X) and any file in `~/.config/i3/` that starts with the `hostname` of the system. I'm not very proud of the last line in this script, but its a rudimentary check to see if i3 is running and restarts it after that concatenation finishes. 

Since I don't add the `~/.config/i3/config` file in my github repo, I always run `i3confmerge` in my `~/.zprofile` (or `~/.bash_profile`) before I `startx`.

These parts in my [~/.zprofile](https://github.com/ispanos/dotfiles/blob/master/.zprofile) are relevant/ needed for my configs to run:


    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/.local/bin" ]; then
        PATH="$HOME/.local/bin:$PATH"
    fi
    
    # ...
    
    export EDITOR="code"
    export TERMINAL="gnome-terminal"
    export BROWSER="firefox"
    export QT_QPA_PLATFORMTHEME=qt5ct
    export PATH="$HOME/.local/bin/wm-scripts/:$PATH"


    # init function for i3wm
    i3start(){
        [ ! -d "${XDG_DATA_HOME}/xorg" ] && mkdir -p ${XDG_DATA_HOME}/xorg
        logfile="${XDG_DATA_HOME}/xorg/$(date +%Y_%m_%d-%Hh%Mm%Ss).log"
        touch "$logfile"
        i3confmerge
        exec startx /usr/bin/i3 > "$logfile" 2>&1 # See [2] at the bottom
    }

    # init function for Sway
    swaystart() {
        export XKB_DEFAULT_LAYOUT=us,gr
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        #export XKB_DEFAULT_OPTIONS=grp:alt_shift_toggle
        #export QT_QPA_PLATFORM=wayland
        #export MOZ_ENABLE_WAYLAND=1
        [ ! -d "${XDG_DATA_HOME}/sway" ] && mkdir -p "${XDG_DATA_HOME}/sway"
        logfile="${XDG_DATA_HOME}/sway/$(date +%Y_%m_%d-%Hh%Mm%Ss).log"
        sway  > "$logfile" 2>&1
    }

    [[ -z $DISPLAY ]] && [ "$(tty)" = "/dev/tty1" ] || return
    if [ -f /usr/bin/i3 ] && [ ! $(pgrep -x Xorg) ]; then
        i3start

    elif [ -f /usr/bin/sway ] && [ ! $(pgrep -x sway) ]; then
        swaystart
    fi


`Sway` has the `include` key-word, so the custom script isn't needed. However I haven't tried to have hostname-dependant configs in `Sway` since I haven't used it for months.

[1]: I don't know if that is recommended.

[2]: Again, I'm not sure its right to start programs in your i3 config files instead of a `~/.xinitrc`, but I do that to have less dot files in my home folder.
