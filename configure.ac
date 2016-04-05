dnl (C) Copyright IBM Corporation 2011, 2016

AC_PREREQ(2.57)

dnl AC_GREP_SYMBOL(VARIABLE, SYMBOL, FILE)
AC_DEFUN([AC_GREP_SYMBOL],
[AC_REQUIRE([AC_PROG_AWK])dnl
cat > conftest.awk <<EOF
[/^# *define *]$2[[ \t]]/ { print [\$][3] }
EOF
$1=`${AWK} -f conftest.awk $3`
rm -rf conftest*])


dnl Process this file with autoconf to produce a configure script.
AC_INIT(LICENSE)

dnl Set the top-level source directory
TOP_DIR=`cd ${srcdir}; pwd;`
AC_SUBST(TOP_DIR)
abs_top_srcdir=$TOP_DIR
abs_top_builddir=$TOP_DIR
AC_SUBST(abs_top_srcdir)
AC_SUBST(abs_top_builddir)

AC_CANONICAL_HOST
HOST_CPU=host_cpu
HOST_VENDOR=host_vendor
HOST_OS=host_os
AC_SUBST(host_cpu)
AC_SUBST(host_vendor)
AC_SUBST(host_os)
AC_MSG_RESULT(cpu is $host_cpu)
AC_MSG_RESULT(vendor is $host_vendor)
AC_MSG_RESULT(os is $host_os)

dnl Checks for programs.
dnl AC_PROG_CC
dnl AC_PROG_MAKE_SET
dnl AC_PROG_RANLIB
dnl AC_PROG_AWK # required by AC_GREP_SYMBOL in aclocal.m4


dnl Checks for libraries.
dnl Replace `main' with a function in -lm:
dnl AC_CHECK_LIB(m, main)


dnl case $host in
dnl   *-*-cygwin*|*-*-mingw*)
dnl    if test "${mambo_enable_cygwin}" = "no" ; then
dnl      CC="${CC} -mno-cygwin"
dnl    fi
dnl    ;;
dnl esac


find . -prune -noleaf > /dev/null 2>&1
if test $? == 0 ; then
    NOLEAF=-noleaf
else
    NOLEAF=
fi

files=`cd $srcdir; find . $NOLEAF \( -name '*.in' -o -name '.*.in' \) -a ! \( -name CVS -o -name 'config.h.in' -o -name configure.in \) \
	-print | sed 's/\.in$//g'`

echo "files = $files"

AC_OUTPUT($files,
		# things to do in config.status (from configure.in)
	)


