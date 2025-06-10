#/usr/bin/env /bin/bash
SITE_LISP="./site-lisp/"
INIT_EL="$SITE_LISP/init.el"
ELPA="$SITE_LISP/elpa/"
EMACSD='~/.emacs.d/'
EMACSBAK="~/.emacs.d.bak/"

echo "[Script] Cleaning old site-lisp/, backup old ~/.emacs.d/..."
if [ -d $SITE_LISP ]; then
  rm -r $SITE_LISP
fi
if [ -d $EMACSD ]; then
  mv $EMACSD $EMACSBAK
fi
mkdir -p $SITE_LISP

echo "[Script] Producing init.el..."
OIFS=$IFS
IFS=""
while read -r LINE; do
  if [[ $LINE != *":ensure"* && $LINE != *"package-vc-install"* ]]; then
    echo $LINE >>"$INIT_EL"
  fi
done <./init-bootstrap.el
IFS=$OIFS

echo "[Script] Running '/usr/bin/emacs --script ./init-bootstrap.el'..."
/usr/bin/emacs --script ./init-bootstrap.el

echo "[Script] Copying new elpa directory..."
cp "~/.emacs.d/elpa/" $ELPA

echo "[Script] Restoring ~/.emacs.d/..."
if [ -f $EMACSBAK ]; then
  mv $EMACSBAK $EMACSD
fi
