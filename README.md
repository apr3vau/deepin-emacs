# Deepin Emacs

**Description**: Is a customized emacs for Deepin

Emacs is hackable OS for top hackers, most of emacs extensions are
written in elisp. This version of Deepin Emacs fully uses the most
updated features and community support, with minimal design as
well. We believe it can give you better experience.

Deepin Emacs’s target is to build a development environment that users
don’t need to config elisp code line by line, all configurations are
initially prepared.  Deepin Emacs provides below features:

- Code auto completion with most languages. (by corfu extension and complete-at-point feature)
- Code template system. (by yasnippet extension)
- Anything search system. (by consult extension)
- Kill ring search. (by consult extension)
- File manager. (by dirvish extension)
- Music player. (by emms extensions)
- Pdf viewer. (by doc-view extension)
- Irc client. (by erc extension)
- Minibuffer tray and disable fringe. (by minibuffer-tray extension)
- Web browser. (by eww extension)
- Tab manager. (by awesome-tab extension)
- Powerful syntax edit. (by electric-pair extension)
- Org GTD manager. (by org extensions)
- News reader. (by gnus extension)
- Code search and replace.
- Quick global jump. (by isearch and consult extension)
- Man manual reader. (by woman extension)
- Project navigator. (by treemacs extension)
- API document helper. (by eldoc extension)
- Tag search. (by etags extension)
- Code checker. (by flycheck extension)
- Git manage. (by magit extension)
- Mailing reader. (by gnus extension)
- Code folding. (by yafolding extension)
- Command completion. (by vertico and orderless extensions)
- Info reader. (by info extension)
- Elisp package manager. (by use-package and package extension)
- Regex real-time matcher. (by consult extension)
- Smooth scroll. (by smooth-scrolling extension)

## Dependencies

### Packaging dependencies

 - debhelper
 - dh-autoreconf
 - devscripts
 - build-essential
 - git
 - autoconf
 - texinfo
 - libxaw7-dev
 - libxpm-dev
 - libpng12-dev
 - libjpeg-dev
 - libtiff5-dev
 - libgif-dev
 - libncurses5-dev
 - libdbus-1-dev
 - libgtk-3-dev
 - libgnutls28-dev
 - librsvg2-common
 - libtree-sitter-dev
 - gcc-14
 - libgccjit-14-dev
 - sbcl
 - emacs

### Runtime dependencies

 - gcc-14
 - libgccjit0
 - ripgrep
 - locate

## Install rtags for C/C++
git clone --recursive https://github.com/Andersbakken/rtags.git
cd rtags
mkdir build
cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 ..
make
sudo make install

## Packaging

### Debian-like system

Install prerequisites
```
$ sudo apt-get install \
               build-essential \
               git \
               autoconf \
               texinfo \
               libxaw7-dev \
               libxpm-dev \
               libpng-dev \
               libjpeg-dev \
               libtiff5-dev \
               libgif-dev \
               libncurses5-dev \
               libdbus-1-dev \
               libgtk-3-dev \
               gcc-14 \
               libgccjit0 \
               libgnutls28-dev \
               librsvg2-common \
               sbcl \
               ripgrep \
               locate \
               fakeroot \
               devscripts
```

Run `debuild`
```
cd deepin-emacs && debuild 
```

## Usage

Run deepin emacs with the command below
```
$ deepin-emacs
```

## Getting help

Any usage issues can ask for help via

* [Gitter](https://gitter.im/orgs/linuxdeepin/rooms)
* [IRC channel](https://webchat.freenode.net/?channels=deepin)
* [Forum](https://bbs.deepin.org)
* [WiKi](http://wiki.deepin.org/)

## Getting involved

We encourage you to report issues and contribute changes

* [Contribution guide for users](http://wiki.deepin.org/index.php?title=Contribution_Guidelines_for_Users)
* [Contribution guide for developers](http://wiki.deepin.org/index.php?title=Contribution_Guidelines_for_Developers).

## License

Deepin Emacs is licensed under [GPLv3](LICENSE).
