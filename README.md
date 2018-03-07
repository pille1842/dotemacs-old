# My Emacs configuration

This is my Emacs configuration. There are many like it, but this is mine.

Personally, I'm using Emacs version 24.5.1 on my Ubuntu 16.04 system. I can't
guarantee it will work with other Emacs versions. The minimum requirement is
Emacs 24.4 because of the straight.el package manager.

## Installation

Make a backup of your original Emacs configuration files:

```
$ for i in ~/.emacs{,.d}; do mv $i{,.BAK}; done
```

Then clone this repository:

```
$ git clone https://github.com/pille1842/dotemacs ~/.emacs.d
```

## License

This configuration is licensed under the MIT License. See LICENSE for more
information.
