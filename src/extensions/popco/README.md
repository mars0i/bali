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

### To compile from scratch:

In popco:

	lein with-profile bali-netlogo uberjar

Here:

You may have to copy or add a link to popco2-1.0.0-standalone.jar in the
resources dir, and possibly clojure-1.7.0.jar and
clojure-utils-0.5.0.jar.  (The latter may have to be compiled from
source at https://github.com/mikera/clojure-utils.)

	export NETLOGO=<your NetLogo installation here>  
	make  
	make install  

### Usage

To use, put this in the Code tab in netlogo:

	extensions [popco]

You may need to also run this with the popco uberjar in the classpath,
copying the specialized netlog.sh script into the NetLogo dir and
running NetLogo with that.

### Compiling

Type 'make', perhaps after exporting an environmental variable NETLOGO
that you've defined to point to the directory in which NetLogo is
installed.
