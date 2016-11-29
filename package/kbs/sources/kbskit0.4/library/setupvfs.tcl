#***F* KBS/setupvfs.tcl
#
# NAME
#  Kitgen Build System
#
# FUNCTION
#  Launch with 'kitexe -init- setupvfs.tcl vfs cli|dyn|gui ?package ..?
#  All internal functions and variables start with '_'.
#
# AUTHOR
#  <jcw@equi4.com> -- Initial ideas and original source
#  <r.zaumseil@freenet.de> -- rewrite and development
#
# VERSION
#   $Id: setupvfs.tcl,v 1.7 2009/05/19 17:56:58 r_zaumseil Exp $
#
#===============================================================================

#***iv* ::/_files()
# FUNCTION
#  Variable to collect all files to copy.
# SOURCE
set _files boot.tcl
#===============================================================================

#***if* ::/_libdir()
# FUNCTION
#  Return source lib dir of given name.
# INPUTS
#  * name -- internal package name
# SOURCE
proc _libdir {name} {return $::_libdir($name)} 
#-------------------------------------------------------------------------------

#***if* ::/_filelist()
# FUNCTION
#  Return recursive filelist of given directory.
# INPUTS
#  * dir -- name of dir to start with
#  * regexp -- regular expression to remove not needed files from return list
# SOURCE
proc _filelist {dir {regexp {}}} {
  set list [list]
  foreach f [glob -nocomplain -tails -dir $dir -type f *] {
    if {$regexp ne {} && [regexp $regexp $f]} continue
    lappend list $dir/$f
  }
  foreach d [glob -nocomplain -type d $dir/*] {;# go into subdirs
    set list [concat $list [_filelist $d $regexp]]
  }
  return $list
}
#-------------------------------------------------------------------------------

#***if* ::/_vfscopy()
# FUNCTION
#  Copy files from list in internal vfs.
# INPUTS
#  * vfs -- name of target vfs dir
#  * list -- list of files to copy to vfs
# SOURCE
proc _vfscopy {vfs list} {
  foreach src $list {
    if {[string range $src 0 2] == "../"} {
      set dest [string range $src 3 end]
    } else {
      set dest $src
    }
    set d $vfs/[file dirname $dest]
    if {![file isdir $d]} {
      file mkdir $d
    }
    set dest $vfs/$dest
    if {[file exists $dest]} {
      puts "ignore existing: '$dest'"
      continue
    }
    switch -- [file extension $src] {
      .tcl - .txt - .msg - .test {
        # get line-endings right for text files - this is crucial for boot.tcl
        # and several scripts in lib/vlerq4/ which are loaded before vfs works
        set fin [open $src r]
        set fout [open $dest w]
        fconfigure $fout -translation lf
        fcopy $fin $fout
        close $fin
        close $fout
      } .static {;# patch pkgIndex.tcl file
        set src [string range $src 0 end-7]
        set dest [string range $dest 0 end-7]
        set fin [open $src r]
        set fout [open $dest w]
        fconfigure $fout -translation lf
        puts $fout [read $fin][_libdir $src];# hack to get 'package ifneeded..'
        close $fin
        close $fout
      } default {
        file copy $src $dest
      }
    }
    file mtime $dest [file mtime $src]
  }
}
#===============================================================================

#***f* ::/_package()
# FUNCTION
#  Add name and version to internal package list.
# INPUTS
#  * type -- type of package, one of none,static,shared
#  * name -- internal package name
#  * version -- package version number (major.minor..)
#  * pkgname -- if given replace name for 'package ifneeded' statement
#  * patchlevel -- if given replaces the version argument in 'package ifneeded'
#  * libdir -- if given replace default '../lib/$name$version'
# SOURCE
proc _package {type name {version {}} {pkgname {}} {patchlevel {}} {libdir {}}} {
  if {$libdir eq {}} {
    set libdir ../lib/$name$version
  }
  if {![file isdirectory $libdir]} {
    puts stderr "\n$name$version missing '$libdir'"
    exit 1
  }
  set ::_libdir($name) $libdir
  if {$type eq {static}} {;# hack to save 'package ifneeded..' statement
    if {$pkgname eq {}} {set pkgname $name}
    if {$patchlevel eq {}} {set patchlevel $version}
    set ::_files [concat $::_files [_filelist $libdir {.a$|.so$|.dll$}]]
    lappend ::_files $libdir/pkgIndex.tcl.static
    set ::_libdir($libdir/pkgIndex.tcl) "package ifneeded $pkgname $patchlevel {load {} $pkgname}"
  } else {
    set ::_files [concat $::_files [_filelist $libdir {.a$}]]
  }
  puts -nonewline "$name$version "
}
#===============================================================================
#
# common startup
#
puts "[info nameofexe]: $argv"
set _lite [expr {![catch {load {} vlerq}]}]
load {} vfs ;# vlerq or mk4tcl is already loaded by now

set ::tcl_major [lindex [split $::tcl_version .] 0];# ready for tcl9
_package none tcl $::tcl_version
catch {;# tcl with dde and registry under windows
_package shared dde {} {} {} [glob ../lib/dde*]
_package shared registry {} {} {} [glob ../lib/reg*]
}
lappend ::_files {*}[_filelist ../lib/tcl$::tcl_major];# tcl modules
_package static vfs [package require vfs];# vfs
if {$_lite} {;# vlerq with ro tclkits
  _package static vqtcl [package require vlerq] vlerq
} else {;# metakit with rw tclkits but need of C++ compiler and libs
  puts -nonewline "Mk4tcl[package require Mk4tcl] ";# no files
}
#
# option parsing
# '-init- setupvfs.tcl vfs cli|dyn|gui ...'
#
set _vfs [lindex $argv 2]
switch [lindex $argv 3] {
  cli {;# shell application
  } gui {;# Tk statically linked
    _package static tk $::tcl_version Tk $::tcl_patchLevel
    lappend _files tclkit.ico
  } dyn {;# Tk dynamic loadable
    _package shared tk $::tcl_version Tk $::tcl_patchLevel
    if {$::tcl_platform(platform) == "windows"} {
      set _tklib [glob ../bin/tk$::tcl_major*.dll]
    } else {
      set _tklib [_libdir tk]/../libtk$::tcl_version[info sharedlibext]
      # to be sure
      catch {file rename [glob [_libdir tk]/../libtk$::tcl_major*.so*] $_tklib}
    }
    lappend _files tclkit.ico $_tklib
  } default {
    puts stderr "Unknown type, must be one of: cli, dyn, gui"
    exit 1
  }
}
foreach my [lrange $argv 4 end] {;# additional packages
  _package shared {*}[split $my :]
}
puts "with [llength $_files] files"
#
# get necessary parts
#
set tcl_library ../tcl/library
source [_libdir tcl]/init.tcl
source [_libdir vfs]/vfsUtils.tcl
source [_libdir vfs]/vfslib.tcl ;# override vfs::memchan/vfsUtils.tcl
# mount vfs
if {$_lite} {
  source [_libdir vqtcl]/m2mvfs.tcl
  vfs::m2m::Mount $_vfs $_vfs
} else {
  source [_libdir vfs]/mk4vfs.tcl
  vfs::mk4::Mount $_vfs $_vfs
}
# copy and adjust all files
_vfscopy $_vfs $_files
# ready
vfs::unmount $_vfs
