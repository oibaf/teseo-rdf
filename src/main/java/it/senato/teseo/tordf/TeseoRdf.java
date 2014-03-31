package it.senato.teseo.tordf;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;

import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;

/**
 * Created on Mar 4, 2013
 *
 */

public class TeseoRdf {

 static final int KIND_OFFSET = 1;
 static final int KIND_LENGTH = 3;
 static final int ID_OFFSET = 4;
 static final int ID_LENGTH = 8;
 static final int NAME_OFFSET = 12;
 static final int CODE_OFFSET = 524;
 static final int EXTRA1_OFFSET = 544;
 static final int NOTE_OFFSET = 559;
 static final int EXTRA2_OFFSET = 2607;

 static final int PREDICATE_OFFSET = 2;
 static final int PREDICATE_LENGTH = 2;
 static final int OBJECT_OFFSET = 12;
 
 public static void main(String[] args) {
  if (args.length<3){
   System.out.println("program arguments: <file in> <file out> <file xsl> [param:value...]");
   System.exit(-1);   
  }
  File in = new File(args[0]);
  if (!in.exists()){
   System.out.println("file not found: " + args[0]);
   System.out.println("Working Directory = " + System.getProperty("user.dir"));
   System.exit(-2);   
  }
  File out = new File(args[1]);
  /*
  if (out.exists()){
   System.out.println("file exists: " + args[1]);
   System.exit(-3);   
  }
  */
  File xsl = new File(args[2]);
  if (!xsl.exists()){
   System.out.println("file not found: " + args[2]);
   System.out.println("Working Directory = " + System.getProperty("user.dir"));
   System.exit(-4);   
  }
  try{
   FileInputStream fis = new FileInputStream(in);
   BufferedReader br = new BufferedReader(new InputStreamReader(fis,Charset.forName("IBM437")));
   Document document = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
   Element root = document.createElement("root");
   document.appendChild(root);
   String line;
   Element element = null;
   int linenum = 1;
   while ((line = br.readLine()) != null) {
    if (line.charAt(0)=='N'){
     if (element!=null) root.appendChild(element);
     element = document.createElement(line.substring(KIND_OFFSET,KIND_OFFSET+KIND_LENGTH));
     element.setAttribute("id", line.substring(ID_OFFSET,ID_OFFSET+ID_LENGTH));
     Element name = document.createElement("name");
     boolean hasMore = line.length()>CODE_OFFSET;
     if (hasMore) {
      int stop = line.length()>EXTRA1_OFFSET?EXTRA1_OFFSET:line.length();
      String code = line.substring(CODE_OFFSET,stop).trim();
      if (code.length()>0) element.setAttribute("code", code);
     }
     Node node = document.createTextNode(line.substring(NAME_OFFSET,hasMore?CODE_OFFSET:line.length()).trim());
     name.appendChild(node);
     element.appendChild(name);
     if (line.length()>NOTE_OFFSET){
      hasMore = line.length()>EXTRA2_OFFSET;
      Element note = document.createElement("note");
      node = document.createTextNode(line.substring(NOTE_OFFSET,hasMore?EXTRA2_OFFSET:line.length()).trim());
      note.appendChild(node);
      element.appendChild(note);
     }
    }
    else
    if (line.charAt(0)=='R'){
     if (element==null) throw new Exception("invalid content @line " + linenum);
     Element rel = document.createElement(line.substring(PREDICATE_OFFSET,PREDICATE_OFFSET+PREDICATE_LENGTH));
     Node node = document.createTextNode(line.substring(OBJECT_OFFSET,OBJECT_OFFSET+ID_LENGTH));
     rel.appendChild(node);
     element.appendChild(rel);
    }
    else throw new Exception("invalid content @line " + linenum);
    linenum++;
   }
   br.close();
   if (element!=null) root.appendChild(element);
   //TransformerFactory.newInstance().newTransformer().transform(new DOMSource(document), new StreamResult(out));
   //TransformerFactory.newInstance().newTransformer(new StreamSource(xsl)).transform(new DOMSource(document), new StreamResult(out));
   
   Transformer transformer = TransformerFactory.newInstance().newTransformer(new StreamSource(xsl));
   for (int j=3;j<args.length;j++) transformer.setParameter(args[j].split(":")[0], args[j].split(":")[1]);
   transformer.transform(new DOMSource(document), new StreamResult(out));
  }
  catch(Exception e){e.printStackTrace();}
 }
}
