#/usr/bin/env /bin/bash
SITE_LISP="./site-lisp/"
INIT_EL="$SITE_LISP/init.el"
ELPA="$SITE_LISP/elpa/"
EMACSD='~/.emacs.d/'
EMACSBAK="~/.emacs.d.bak/"

echo "[Script] Cleaning old site-lisp/, backup old ~/.emacs.d/..."
if [ -f $SITE_LISP ]; then
    rm -r $SITE_LISP
fi
if [ -f $EMACSD ]; then
    mv $EMACSD $EMACSBAK
fi
mkdir -p $SITE_LISP

echo "[Script] Producing init.el..."
while IFS=read -r line; do 
    if [[  $IFS != "*:ensure*" && $IFS != "*package-vc-install*" ]]; then
        echo $IFS >> $INIT_EL
    fi
done

echo "[Script] Running '/usr/bin/emacs --script ./init-bootstrap.el'..."
/usr/bin/emacs --script ./init-bootstrap.el

echo "[Script] Copying new elpa directory..."
cp "~/.emacs.d/elpa/" $ELPA

echo "[Script] Restoring ~/.emacs.d/..."
if [ -f $EMACSBAK ]; then
    mv $EMACSBAK $EMACSD
fi
