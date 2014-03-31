package it.senato.teseo.tordf;

import java.io.File;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class AppTest 
    extends TestCase
{
    /**
     * Create the test case
     *
     * @param testName name of the test case
     */
    public AppTest( String testName )
    {
        super( testName );
    }

    /**
     * @return the suite of tests being tested
     */
    public static Test suite()
    {
        return new TestSuite( AppTest.class );
    }
    
    void testMain(String outputFile, String xl)
    {
        File out = new File(outputFile);
        if (out.exists()) out.delete();
        String args[] = {"input/export.dat",outputFile,"xsl/teseo.xsl",xl};
        TeseoRdf.main(args);
        System.out.println("\n*** output file " + outputFile + " has " + (new File(outputFile)).length() + " bytes length ***\n");
    }
    /**
     * Rigourous Test :-)
     */
    public void testApp()
    {
        testMain("output/teseo.rdf", "xl:no");
        testMain("output/teseo-xl.rdf", "xl:yes");
        testMain("output/teseo-both.rdf", "xl:both");
    }
}
