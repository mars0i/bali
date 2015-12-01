popco
====

NetLogo extension by [Marshall
Abrams](http://members.logical.net/~marshall/) that allows calling
popco (written in [Clojure](http://clojure.org)) from NetLogo.

Please feel free to contact me with questions, suggestions, etc. at:

	mabrams ([at]) uab [(dot)] edu
	marshall ([at]) logical [(dot)] net  

This software is copyright 2015 by [Marshall
Abrams](http://members.logical.net/~marshall/), and is distributed
under the [Gnu General Public License version
3.0](http://www.gnu.org/copyleft/gpl.html) as specified in the file
LICENSE, except where noted.  (For example, there is source code in
src/java that was written by other authors, which is released under
different licenses.)

### Installation

(These instructions are designed for unix-family systems such as OS X
and Linux.  You'll probably have to make minor changes for for NetLogo
on Windows.)

To install, copy target/\*.jar\*, resources/\* and (optionally)
src/netlogo/example.nlogo to a directory that you name 'clojure' in
the 'extensions' subdirectory of your NetLogo installation directory.

Or set the environment variable NETLOGO to your NetLogo application
directory and use `make install`.

Or change to the extensions subdirectory of the NetLogo application
directory and unzip clojure.zip.  (This file includes Java source files
for the extension for reference purposes, but if you want to build the
extension from scratch, you probably want to get the original version using
`git` from https://github.com/mars0i/netlogo-clojure, because the
Makefile is there and is set up for the directory structure there.)

### Usage

To use, put this in the Code tab in netlogo:

	extensions [popcobali]

For now, that's it.

### Compiling

Type 'make', perhaps after exporting an environmental variable NETLOGO
that you've defined to point to the directory in which NetLogo is
installed.
