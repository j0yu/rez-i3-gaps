# i3-gaps

[![CI](../..//workflows/CI/badge.svg?branch=master)](../../actions?query=workflow%3ACI+branch%3Amaster)
[![Code style: black](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)


[rez] package to install [i3 with _gaps_ fork][i3].

Here are some beginners instructions on how to use this repository.

## Installation

1. Install [rez] via `python install.py` method
1. Clone/download this repository
1. Ensure at least the folder printed by
   this command `rez config local_packages_path`
1. Open terminal in (extracted) repository folder,
   run `rez build --install`

i3 should now be installed as a [rez] package named `i3_gaps`.

Then to install the system dependencies, i.e. on CentOS 7, you would then 
run `rez env i3_gaps -- i3-deps`

## Usage

If you're using a custom X11 startup, i.e. running `startx` directly after
logging into `tty1` (`multi-user` target in CentOS 7 `systemd`):

1. At the end of your `~/.bash_profile`, add `rez env i3_gaps -- startx`
2. At the end of your `~/.xinitrc`: `exec i3 -V >> /tmp/i3.log`.

## Maintenance

Whenever new official release come out, update the `__version__`
in `package.py` then re-run `rez build --install`.

If you decide to make another install, e.g. new `commands()` environment
setup, you can instead just update the `+local.` version number to indicate
new releases/versions of your own. See [PEP 540 local version segments].

Also, you can rename `+local.` to something more relevant to you
e.g. `+mystudio.` or  `+mygithubname.`

----

Want more rez packages? Checkout [my GitHub repositories][j0yu-rez-packages]

[rez]: https://github.com/nerdvegas/rez
[requirement]: https://github.com/nerdvegas/rez/wiki/Package-Definition-Guide#requires
[j0yu-rez-packages]: https://github.com/j0yu?tab=repositories&q=topic%3Arez+topic%3Apackage
[i3]: https://github.com/Airblader/i3
[PEP 540 local version segments]: https://www.python.org/dev/peps/pep-0440/#local-version-segments
