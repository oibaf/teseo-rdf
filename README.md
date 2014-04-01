teseo-rdf
=========

tool to convert the legacy data format to skos rdf

* requires:

  * jvm 1.7+
  * maven

* build instructions:

  * download and install maven
  * download teseo-rdf
  * start a shell in the project main directory and run
    > mvn package
  * the output files are in the output folder
  * the input file is input/export-test.dat (the latest available)
  
* usage instructions:

  java -cp target/teseo-rdf-1.0-SNAPSHOT.jar it.senato.teseo.tordf.TeseoRdf  <file in> <file out> xsl/teseo.xsl
  
* note: the java code is tailored on the input source
