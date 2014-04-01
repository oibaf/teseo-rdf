package it.senato.teseo.tordf;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;

import java.util.zip.ZipOutputStream;
import java.util.zip.ZipEntry;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestResult;
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
    
    long testMain(String outputFile, String xsl, String xl) throws Exception
    {
        File out = new File(outputFile);
        if (out.exists()) out.delete();
        String args[] = {"input/export-test.dat",outputFile,xsl,xl};
        TeseoRdf.main(args);
        long length = (new File(outputFile)).length();
        System.out.println("\n*** output file " + outputFile + " has " + length + " bytes length ***\n");
        
        FileInputStream fis = new FileInputStream(outputFile);
        ZipOutputStream zos = new ZipOutputStream(new FileOutputStream(outputFile + ".zip"));
        zos.setMethod(ZipOutputStream.DEFLATED);
        zos.setLevel(9);
        zos.putNextEntry(new ZipEntry(out.getName())); 
        int count; byte[] b = new byte[1024*1024];
        while ((count = fis.read(b)) > 0) zos.write(b, 0, count);
        zos.close();
        fis.close();  
        
        return length;
    }
    /**
     * Rigourous Test :-)
     */
    public void testApp()
    {
        try 
        {
            long result;
            //testMain("output/teseo.rdf", "xsl/teseo.xsl", "xl:no");
            //testMain("output/teseo-both.rdf", "xsl/teseo.xsl", "xl:both");
            result = testMain("output/teseo-plain.rdf", "xsl/teseo-plain.xsl", "xl:yes");
            assertEquals(result, 10198482);
            result = testMain("output/teseo.rdf", "xsl/teseo.xsl", "xl:yes");
            assertEquals(result, 11856344);
        }
        catch (Exception e) {
            assert(false);
        }    
        
    }
}
