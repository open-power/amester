#
# Entries is from vfs-1.4/library/pkgIndex.tcl
#
package ifneeded vfs        1.4   [list load {} vfs]

package ifneeded starkit    1.3.3 [list source [file join $dir starkit.tcl]]
package ifneeded vfslib     1.4   [list source [file join $dir vfslib.tcl]]

# New, for the old, keep version numbers synchronized.
package ifneeded vfs::mk4     1.10.1 [list source [file join $dir mk4vfs.tcl]]
package ifneeded vfs::zip     1.0.2  [list source [file join $dir zipvfs.tcl]]

# New
package ifneeded vfs::ftp     1.0 [list source [file join $dir ftpvfs.tcl]]
package ifneeded vfs::http    0.6 [list source [file join $dir httpvfs.tcl]]
package ifneeded vfs::ns      0.5.1 [list source [file join $dir tclprocvfs.tcl]]
package ifneeded vfs::tar     0.91 [list source [file join $dir tarvfs.tcl]]
package ifneeded vfs::test    1.0 [list source [file join $dir testvfs.tcl]]
package ifneeded vfs::urltype 1.0 [list source [file join $dir vfsUrl.tcl]]
package ifneeded vfs::webdav  0.1 [list source [file join $dir webdavvfs.tcl]]
package ifneeded vfs::tk      0.5 [list source [file join $dir tkvfs.tcl]]
#
# Virtual filesystems based on the template vfs:
#
package ifneeded vfs::template::chroot 1.5.2 \
    [list source [file join $dir template chrootvfs.tcl]]
package ifneeded vfs::template::collate 1.5.2 \
    [list source [file join $dir template collatevfs.tcl]]
package ifneeded vfs::template::version 1.5.2 \
    [list source [file join $dir template versionvfs.tcl]]
package ifneeded vfs::template::version::delta 1.5.2 \
    [list source [file join $dir template deltavfs.tcl]]
package ifneeded vfs::template::fish 1.5.2 \
    [list source [file join $dir template fishvfs.tcl]]
package ifneeded vfs::template::quota 1.5.2 \
    [list source [file join $dir template quotavfs.tcl]]
package ifneeded vfs::template 1.5.2 \
    [list source [file join $dir template templatevfs.tcl]]
#
# Helpers
#
package ifneeded fileutil::globfind 1.5 \
    [list source [file join $dir template globfind.tcl]]
package ifneeded trsync 1.0 [list source [file join $dir template tdelta.tcl]]
