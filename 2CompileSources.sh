#!/bin/bash

SCRIPTSDIRECTORY=$(pwd)
JAVALOCATION=$(which java)
JAVACLOCATION=$(which javac)

#uname -v | grep -qi Darwin && JAVA_PATH=`/usr/libexec/java_home -v 1.7`/bin
#uname -v | grep -qi Ubuntu && JAVA_PATH="/usr/lib/jvm/java-7-oracle/bin"

#compile files in QACrashFix
cd qacrashfix/QACrashFix/test/Test/
rm -fr bin/
mkdir bin/
$JAVACLOCATION -cp ../../target/exception-fix-0.0.1-SNAPSHOT.jar:log4j-api-2.5.jar:org.eclipse.core.resources_3.10.1.v20150725-1910.jar:org.eclipse.jdt.core_3.11.1.v20150902-1521.jar:log4j-core-2.5.jar:org.eclipse.core.runtime_3.11.1.v20150903-1804.jar:org.eclipse.osgi_3.10.102.v20160118-1700.jar:org.eclipse.core.contenttype_3.5.0.v20150421-2214.jar:org.eclipse.equinox.common_3.7.0.v20150402-1709.jar:org.eclipse.core.jobs_3.7.0.v20150330-2103.jar:org.eclipse.equinox.preferences_3.5.300.v20150408-1437.jar -d bin/ src/CountNumberOfGenProgMutations.java
cd ../../../..

cd ScalaGumTree/bugfixes/historicalfixv2/

scalac -cp ".:allLibs/*" -d bin/ src/gumdiff/handlejdt/*.scala src/gumdiff/jdtgum/*.java src/gumdiff/difftemplates/*.scala src/gumdiff/customLib/*.scala src/gumdiff/handlecommits/*.scala
javac -cp ".:allLibs/*" -d bin/ src/gumdiff/jdtgum/*.java 




#compile files in Gumtree
#cd gumtreeBin/

#Change to 10 when finished
#for (( i=1; i<=1; i++ )) 
#do

#$JAVACLOCATION -cp .:/$SCRIPTSDIRECTORY/gumtreeBin/lib/dist-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/core-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/client-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/client.diff-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-antlr-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-css-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-json-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-php-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-r-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.antlr-xml-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.c-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.jdt-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.js-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gen.ruby-2.1.0-SNAPSHOT.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/simmetrics-core-3.2.3.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/trove4j-3.0.3.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/gson-2.4.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/reflections-0.9.10.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/nanohttpd-webserver-2.1.1.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/rendersnake-1.9.0.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/antlr-3.5.2.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/org.eclipse.jdt.core-3.11.0.v20150602-1242.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/runtime-3.10.0-v20140318-2214.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/org.eclipse.core.resources-3.10.0.v20150423-0755.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/rhino-1.7.7.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/jrubyparser-0.5.3.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/guava-18.0.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/commons-codec-1.10.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/javassist-3.18.2-GA.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/annotations-2.0.1.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/nanohttpd-2.1.1.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/junit-4.8.2.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/servlet-api-2.4.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/commons-lang3-3.1.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/commons-io-2.0.1.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-webmvc-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/jtidy-r938.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/guice-3.0.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/javax.inject-1.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/antlr-runtime-3.5.2.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/ST4-4.0.8.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/osgi-3.10.0-v20140606-1445.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/common-3.6.200-v20130402-1505.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/jobs-3.6.0-v20140424-0053.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/registry-3.5.400-v20140428-1507.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/preferences-3.5.200-v20140224-1527.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/contenttype-3.4.200-v20140207-1251.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/app-1.3.200-v20130910-1609.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-beans-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-context-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-core-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-expression-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-web-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/aopalliance-1.0.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/cglib-2.2.1-v20090111.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/spring-aop-4.1.6.RELEASE.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/commons-logging-1.2.jar:/$SCRIPTSDIRECTORY/gumtreeBin/lib/asm-3.1.jar CountInstancesOfTemplate$i.java

#done

#cd ..

