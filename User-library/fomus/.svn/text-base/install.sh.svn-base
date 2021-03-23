#!/bin/sh

if [[ ! -e "fomus.asd" ]]
then
    echo "You must run this script from the FOMUS directory"
    exit 1
fi

for A in $*
do
  case $A in
      --uninstall)
	  UNINST=1
	  ;;
      --bindir=)
	  BINDIR=`echo $A | sed -e "s/^--bindir=//"`
	  ;;
      --libdir=)
	  LIBDIR=`echo $A | sed -e "s/^--libdir=//"`
	  ;;
      --sbcl)
	  LISP=sbcl
	  ;;
      --cmucl)
	  LISP=cmucl
	  ;;
      --clisp)
	  LISP=clisp
	  ;;
      --openmcl)
	  LISP=openmcl
	  ;;
      --cm=*)
	  CMDIR=`echo $A | sed -e "s/^--cm=//"`
	  ;;
      --cmn=*)
	  CMNDIR=`echo $A | sed -e "s/^--cmn=//"`
	  ;;
      --prefix=*)
	  PREFIX=`echo $A | sed -e "s/^--prefix=//"`
	  ;;
      *)
	  echo
	  echo "This installs FOMUS as a command-line executable."
	  echo
	  echo "Usage Examples:"
	  echo "./install.sh --sbcl                                                     --install using SBCL into /usr/local (you need to be root)"
	  echo "./install.sh --sbcl --cm=/mylispdir/cm                                  --install using SBCL and include CM"
	  echo "./install.sh --sbcl --cmn=/mylispdir/cmn                                --install using SBCL and include CMN"
	  echo "./install.sh --cmucl --prefix=/mybasedir                                --install using CMUCL into /mybaseinstalldir"
	  echo "./install.sh --cmucl --prefix=/mybasedir --bindir=/mybasedir/mybin      --install using CMUCL with special bin directory"
	  echo "./install.sh --openmcl --prefix=/mybasedir --libdir=/mybasedir/mylib    --install using OpenMCL with special lib directory"
	  echo "./install.sh --uninstall                                                --uninstall from /usr/local"
	  echo "./install.sh --uninstall --prefix=/mybasedir                            --uninstall from /mybaseinstalldir"
	  echo "./install.sh --uninstall --prefix=/mybasedir --bindir=/mybasedir/mybin  --uninstall from /mybaseinstalldir and special bin directory"
	  echo
	  echo "Lisp options are --sbcl, --cmucl, --openmcl and --clisp"
	  echo
	  echo "If you get stuck in Lisp while compiling, try the following command:"
	  echo "(cl-user::quit)"
	  exit 1
	  ;;
  esac
done

if [[ -z "$PREFIX" ]]
then
    PREFIX="/usr/local"
fi
if [[ -z "$BINDIR" ]]
then
    BINDIR="$PREFIX/bin"
fi
if [[ -z "$LIBDIR" ]]
then
    LIBDIR="$PREFIX/lib"
fi

if [[ "$UNINST" = "1" ]]
then
    echo
    echo "Uninstalling..."
    echo "rm -f $LIBDIR/fomus.img"
    rm -f $LIBDIR/fomus.img
    echo "rm -f $BINDIR/fomus"
    rm -f $BINDIR/fomus
    echo
    echo "Done!"
    exit 0
fi

if [[ -z "$LISP" ]]
then
    echo "No Lisp was specified (use --sbcl, --cmucl or --openmcl, or type --help for more options)"
    exit 1
fi

LOADCM="src/cm.lisp"
LOADCMN="cmn-all.lisp"

case "$LISP" in
    sbcl)
	LISPEXE=sbcl
	LOADARG="--load"
	EVALARG="--eval"
	EXITCMD="(quit)"
	COREARG="--core"
	EXTRAARG="--noinform"
	DUMPCMD='(sb-ext:save-lisp-and-die "fomus.img" :purify t)'
	;;
    cmucl)
	LISPEXE=lisp
	LOADARG="-load"
	EVALARG="-eval"
	EXITCMD="(quit)"
	COREARG="-core"
	EXTRAARG="-quiet"
	DUMPCMD='(ext:save-lisp "fomus.img" :purify t)'
	;;
    openmcl)
	LISPEXE=openmcl
	LOADARG="-l"
	EVALARG="-e"
	EXITCMD="(quit)"
	COREARG="-I"
	DUMPCMD='(ccl:save-application "fomus.img" :purify t)'
	;;
    clisp)
	LISPEXE=clisp
	EVALARG="-x"
	EXITCMD="(quit)"
	COREARG="-M"
	EXTRAARG="-q"
	DUMPCMD='(ext:saveinitmem "fomus.img")'
	;;
esac

if [[ -e fomus.img ]]
then
    rm fomus.img
fi

if [[ -n "$CMDIR" ]]
then
    if [[ "$LISP" = 'clisp' ]]; then
	$LISPEXE $EXTRAARG $EVALARG "(progn (load \"$CMDIR/$LOADCM\") $EXITCMD)"
	INCCM="(load \"$CMDIR/$LOADCM\")"
    else
	$LISPEXE $EXTRAARG $LOADARG "$CMDIR/$LOADCM" $EVALARG $EXITCMD
	INCCM1=$LOADARG
	INCCM2="$CMDIR/$LOADCM"
    fi
fi
if [[ -n "$CMNDIR" ]]
then
    if [[ "$LISP" = 'clisp' ]]; then
	$LISPEXE $EXTRAARG $EVALARG "(progn (load \"$CMNDIR/$LOADCMN\") $EXITCMD)"
	INCCMN="(load \"$CMNDIR/$LOADCMN\")"
    else    
	$LISPEXE $EXTRAARG $LOADARG "$CMNDIR/$LOADCMN" $EVALARG $EXITCMD
	INCCMN1=$LOADARG
	INCCMN2="$CMNDIR/$LOADCMN"
    fi
fi

INSTFLAG='(intern "+FOMUS-INSTALL+" :common-lisp-user)'
if [[ "$LISP" = 'clisp' ]]; then
    $LISPEXE $EXTRAARG $EVALARG "(progn $INSTFLAG (load \"load.lisp\") $EXITCMD)"
    $LISPEXE $EXTRAARG $EVALARG "(progn $INCCM $INCCMN $INSTFLAG (load \"load.lisp\") $DUMPCMD $EXITCMD)"
else
    $LISPEXE $EXTRAARG $EVALARG "$INSTFLAG" $LOADARG "load.lisp" $EVALARG $EXITCMD
    $LISPEXE $EXTRAARG $INCCM1 $INCCM2 $INCCMN1 $INCCMN2 $EVALARG "$INSTFLAG" $LOADARG "load.lisp" $EVALARG "$DUMPCMD"
fi

if [[ ! -e "fomus.img" ]]
then
    echo
    echo "Couldn't create FOMUS Lisp image :("
    exit 1
fi

echo '#!/bin/sh' > fomus.sh
echo 'usage () {' >> fomus.sh
echo '    echo "Usage: fomus [-lxfscmw] [-o basefilename] [-v value] [-q value] filename [filename]..."' >> fomus.sh
echo '    echo' >> fomus.sh
echo '    echo "  -l        Output to LilyPond"' >> fomus.sh
echo '    echo "  -x        Output to MusicXML"' >> fomus.sh
echo '    echo "  -f        Output to MusicXML w/ Finale kludges"' >> fomus.sh
echo '    echo "  -s        Output to MusicXML w/ Sibelius kludges"' >> fomus.sh
echo '    echo "  -c        Output to CMN"' >> fomus.sh
echo '    echo "  -m        Output to FOMUS input file"' >> fomus.sh
echo '    echo' >> fomus.sh
echo '    echo "  -w        View output"' >> fomus.sh
echo '    echo "  -o        Base filename (w/o extension)"' >> fomus.sh
echo '    echo "  -v        Verbosity level (0, 1 or 2, default = 1 or value in .fomus file)"' >> fomus.sh
echo '    echo "  -q        Quality value (real number, default = 1 or value in .fomus file)"' >> fomus.sh
echo '    echo' >> fomus.sh
echo '    echo "Report bugs to <fomus-devel@common-lisp.net>."' >> fomus.sh
echo '}' >> fomus.sh
echo 'while getopts lxfscmwo:v:q: opt; do' >> fomus.sh
echo '    case $opt in' >> fomus.sh
echo '        [lxfscmw]) o="$opt$o";;' >> fomus.sh
echo '        o) n="$OPTARG";;' >> fomus.sh
echo '        v) v="$OPTARG";;' >> fomus.sh
echo '        q) q="$OPTARG";;' >> fomus.sh
echo '        ?) usage; exit 2;;' >> fomus.sh
echo '    esac' >> fomus.sh
echo 'done' >> fomus.sh
echo 'shift $(($OPTIND - 1))' >> fomus.sh
echo 'if [[ $# -ne 1 ]]; then usage; exit 2; fi' >> fomus.sh
echo 'fls="\"$1\""' >> fomus.sh
echo 'while [[ -n "$2" ]]; do fls="$fls \"$2\""; shift; done' >> fomus.sh
echo "$LISPEXE $COREARG \"$LIBDIR/fomus.img\" $EXTRAARG $EVALARG \"(fm::fomus-exe \\\"\$HOME/.fomus\\\" \\\"\$o\\\" \\\"\$n\\\" \\\"\$q\\\" \\\"\$v\\\" \$fls)\"" >> fomus.sh

echo
echo "Installing..."
echo install -d $BINDIR
install -d $BINDIR
echo install -m 755 fomus.sh $BINDIR/fomus
install -m 755 fomus.sh $BINDIR/fomus
echo install -d $LIBDIR
install -d $LIBDIR
echo install -m 644 fomus.img $LIBDIR
install -m 644 fomus.img $LIBDIR

rm fomus.sh
rm fomus.img

echo
echo "Done!"
