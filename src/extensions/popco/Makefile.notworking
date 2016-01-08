POPCO=./resources/popco2-1.0.0-standalone.jar
MANIFEST=resources/manifest.txt
ESCNETLOGO=$(subst ' ','\\\\ ',$(NETLOGO))
OTHERS="$(ESCNETLOGO)/extensions/table/table.jar"
EXTENSION="$(ESCNETLOGO)/extensions/popco"
SRCS=$(wildcard src/*.java)
JAVAC=javac

ifeq ($(OS),Windows_NT)
	SEP=\;
else
	SEP=:
endif

OLDJARLOC=$(ESCNETLOGO)NetLogo.jar
NEWJARLOC=$(ESCNETLOGO)Java/NetLogo.jar
#NEWJARLOC="/Applications/NetLogo\ 5.3/Java/NetLogo.jar"
WILDJAR="$(wildcard $(ESCNETLOGO)/Java/NetLogo.jar)"

YO=wha?
ifneq ($(wildcard $(OLDJARLOC)),)
	YO=5.2
else ifneq ($(wildcard $(NEWJARLOC)),)
	YO=5.3
else
	YO=huh?
endif


popco.jar popco.jar.pack.gz: $(SRCS) $(MANIFEST) Makefile
	echo "$(ESCNETLOGO)"
	echo $(YO)
	echo $(WILDJAR)
	ls -l $(NEWJARLOC)
	ls -l $(OLDJARLOC)
	mkdir -p target/classes
	$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -classpath "$(ESCNETLOGO)"/Java/NetLogo.jar$(SEP)$(POPCO)$(SEP)$(OTHERS) -d target/classes $(SRCS)
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


#$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -classpath "$(ESCNETLOGO)"/NetLogo.jar$(SEP)$(POPCO)$(SEP)$(OTHERS) -d target/classes $(SRCS)
#$(JAVAC) -g -deprecation -Xlint:all -Xlint:-serial -Xlint:-path -encoding us-ascii -source 1.6 -target 1.6 -classpath "$(ESCNETLOGO)"/NetLogo.jar$(SEP)$(POPCO)$(SEP)$(OTHERS) -d target/classes $(SRCS)
