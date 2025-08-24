# Development Setup DWM

This is my development setup that automatically installs all of the tools and window manager I like to use with it's own keyboard shortcuts.

I am trying to make the scripts work on a lot of different distro's so that it does not matter which distro I choose.

This setup was inspired by ThePrimeagen's My setup is much better than yours course on Frontendmasters.
- [dev](https://github.com/ThePrimeagen/dev)

I really enjoy learning things from ThePrimeagen's courses, they're very informational and very well explained.


I've also taken inspiration for the ricing of my system from:
- [dwm + rofi](https://github.com/siduck/chadwm)
- [st](https://github.com/siduck/st)
- [grub](https://www.pling.com/p/1482847/)

For the colorscheme, I'm a big fan of Radium.
- [Radium nvchad theme](https://nvchad.com/themes)

I'm not nessecarely a big fan of nvchad as in the entire configuration. 
Some parts of it are pretty nice, I like the visual appeal.

## Getting Started

Want to know how to get this up and running?

### Prerequisites

This setup assumes a distribution is setup with systemd, gnome and gdm.

So whichever distribution you attempt to install, it should be a base install with gnome, gdm and systemd working.

**I want to move away from this later, but for now it helps in speeding up the creation of the wm setup**

### Installation

Install git with your package manager of the distribution that you have installed and do:
```
cd $HOME
git clone https://github.com/simbaclaws/dev-linux.git dev
cd dev
./run
```

Follow the entire installation process until the end. 
**Most of it is automated, some parts still requires pressing some keys**

Reboot the machine afterwards, then at the gdm login screen, change the DE to DWM and login.

Afterwards, run the script again (I know... I have to fix this...)

## Tested Distributions

The following distro's have been tested:

### - Pop OS (working)
![Pop OS Setup](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/tested_pop_os.png)

### - Ubuntu (working)
![Ubuntu Setup](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/tested_ubuntu.png)

### - Fedora (working)
![Fedora Setup](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/tested_fedora.png)

### - Manjaro (semi-working)

There is a weird rendering glitch in neovim as well as an issue with a library causing the asciicam not to work.

![Manjaro Setup](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/tested_manjaro.png)

### - OpenSuse Tumbleweed (semi-working)

On tumbleweed I haven't yet figured out how to build the st terminal configuration and the asciicam.

![Tumbleweed Setup](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/tested_tumbleweed.png)

## Neovim Configuration

I'm still learning how to use neovim, so please be gentle when judging my configuration, I'm quite new to this.
I'm taking inspiration from [ThePrimeagen](https://github.com/ThePrimeagen/) as well as [Josean](https://github.com/josean-dev/dev-environment-files)

### - Neovim (semi-working)

I still have some errors in my configuration, and I haven't done everything I wanted to yet.

![Neovim Setup](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/neovim.png)

## Fun

Some things are just fun in the terminal, which is why I included them in the repo.

### - Asciicam (working)
![Asciicam](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/asciicam.png)

### - Asciiquarium (working)
![Asciiquarium](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/asciiquarium.png)

### - CBonsai (working)
![Cbonsai](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/cbonsai.png)

### - CMatrix (working)
![CMatrix](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/cmatrix.png)

## IRC

I added a terminal based IRC client as well.

### - Irssi (working)
![Irssi](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/irssi.png)

## Resource Monitors

I installed some resource monitors to look at.

### - Htop (working)
![Htop](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/htop.png)

### - Glances (working)
![Glances](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/glances.png)

### - Bashtop (working)
![Bashtop](https://raw.githubusercontent.com/simbaclaws/dev-linux/main/examples/bashtop.png)



## TODO

- Make the grub theming script ask you which theme you want to install, instead of having to change the script manually!
**Currently set to system76 for my laptop**
- Add mpd and ncmpcpp with visualisations for listening to music.
- Get BSD based distro's working
