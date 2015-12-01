popcobali
====

NetLogo extension by [Marshall
Abrams](http://members.logical.net/~marshall/) that allows calling
[Clojure](http://clojure.org) from NetLogo.

Still experimental.

Please feel free to contact me with questions, suggestions, etc. at:

	mabrams ([at]) uab [(dot)] edu
	marshall ([at]) logical [(dot)] net  

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

#### Note:

*clojure-\<version number\>.jar* is the main Clojure jar file.  This is
what's needed to run Clojure in any manner at all.

*clojure.jar* is the NetLogo extension jar file.

Similar remarks apply to *\*.jar.pack.gz*, which are needed for Applets.

