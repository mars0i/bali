CLOJURE=./resources/popco2-1.0.0-standalone.jar
MANIFEST=resources/manifest.txt

ifeq ($(origin NETLOGO), undefined)
  NETLOGO=../..
endif

EXTENSION=$(NETLOGO)/extensions/popcobali

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

#JAVAC=$(JAVA_HOME)/bin/javac
JAVAC=javac
SRCS=$(wildcard src/*.java)


popcobali.jar popcobali.jar.pack.gz: $(SRCS) $(MANIFEST) Makefile
	mkdir -p target/classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.6 -target 1.6 -classpath "$(NETLOGO)"/NetLogo.jar$(COLON)$(CLOJURE) -d target/classes $(SRCS)
	jar cmf $(MANIFEST) target/popcobali.jar -C target/classes .
	pack200 --modification-time=latest --effort=9 --strip-debug --no-keep-file-order --unknown-attribute=strip target/popcobali.jar.pack.gz target/popcobali.jar

popcobali.zip: popcobali.jar
	rm -rf popcobali
	mkdir popcobali
	cp -rp target/popcobali.jar target/popcobali.jar.pack.gz README.md src $(MANIFEST) $(CLOJURE) $(CLOJURE).pack.gz popcobali  # Makefile 
	zip -rv popcobali.zip popcobali
	rm -rf popcobali

install:
	if [ ! -d "$(EXTENSION)" ]; then mkdir -v "$(EXTENSION)"; fi
	cp -v target/*.jar* resources/*.jar* src/netlogo/* README.md LICENSE "$(EXTENSION)"
