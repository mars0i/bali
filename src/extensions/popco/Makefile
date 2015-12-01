CLOJURE=./resources/clojure-1.6.0.jar
#CLOJURE=$(HOME)/.m2/repository/org/clojure/clojure/1.6.0/clojure-1.6.0.jar 
MANIFEST=resources/manifest.txt

ifeq ($(origin NETLOGO), undefined)
  NETLOGO=../..
endif

EXTENSION=$(NETLOGO)/extensions/clojure

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

#JAVAC=$(JAVA_HOME)/bin/javac
JAVAC=javac
SRCS=$(wildcard src/java/*.java)


clojure.jar clojure.jar.pack.gz: $(SRCS) $(MANIFEST) Makefile
	mkdir -p target/classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.5 -target 1.5 -classpath "$(NETLOGO)"/NetLogo.jar$(COLON)$(CLOJURE) -d target/classes $(SRCS)
	jar cmf $(MANIFEST) target/clojure.jar -C target/classes .
	pack200 --modification-time=latest --effort=9 --strip-debug --no-keep-file-order --unknown-attribute=strip target/clojure.jar.pack.gz target/clojure.jar

clojure.zip: clojure.jar
	rm -rf clojure
	mkdir clojure
	cp -rp target/clojure.jar target/clojure.jar.pack.gz README.md src $(MANIFEST) $(CLOJURE) $(CLOJURE).pack.gz clojure  # Makefile 
	zip -rv clojure.zip clojure
	rm -rf clojure

install:
	if [ ! -d "$(EXTENSION)" ]; then mkdir -v "$(EXTENSION)"; fi
	cp -v target/*.jar* resources/*.jar* src/netlogo/* README.md LICENSE "$(EXTENSION)"
