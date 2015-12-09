POPCO=./resources/popco2-1.0.0-standalone.jar
MANIFEST=resources/manifest.txt

# Probably better to define the env var NETLOGO to point to your
# Netlogo installation:
ifeq ($(origin NETLOGO), undefined)
  NETLOGO=../..
endif

OTHERS=$(NETLOGO)/extensions/table/table.jar

EXTENSION=$(NETLOGO)/extensions/popco

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

#JAVAC=$(JAVA_HOME)/bin/javac
JAVAC=javac
SRCS=$(wildcard src/*.java)


popco.jar popco.jar.pack.gz: $(SRCS) $(MANIFEST) Makefile
	mkdir -p target/classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.6 -target 1.6 -classpath "$(NETLOGO)"/NetLogo.jar$(COLON)$(POPCO)$(COLON)$(OTHERS) -d target/classes $(SRCS)
	jar cmf $(MANIFEST) target/popco.jar -C target/classes .
	pack200 --modification-time=latest --effort=9 --strip-debug --no-keep-file-order --unknown-attribute=strip target/popco.jar.pack.gz target/popco.jar

popco.zip: popco.jar
	rm -rf popco
	mkdir popco
	cp -rp target/popco.jar target/popco.jar.pack.gz README.md src $(MANIFEST) $(POPCO) $(POPCO).pack.gz popco  # Makefile 
	zip -rv popco.zip popco
	rm -rf popco

install:
	if [ ! -d "$(EXTENSION)" ]; then mkdir -v "$(EXTENSION)"; fi
	cp -v target/*.jar* resources/*.jar* README.md LICENSE "$(EXTENSION)"
