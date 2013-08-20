import org.apache.xerces.dom.DocumentImpl;

import java.io.IOException;
import java.io.StringReader;

import org.w3c.dom.Document.*;

import org.w3c.dom.*;
import javax.xml.*;
import javax.xml.xpath.*;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;


import org.xml.sax.InputSource;

import org.xml.sax.SAXException;

public String validateXML(String docString, String accExceptionDescription, int exceptionFound)
{


try
{
// the "parse" method also validates XML, will throw an exception if misformatted
Document doc = builder.parse(new InputSource(new StringReader(docString)));
if(exceptionFound == 0)
{
	exceptionFound = 0;
}
patExecContext.setProcessDataIntValue("/process_data/exceptionFound", exceptionFound);
patExecContext.setProcessDataValue("/process_data/inData", docString);
return accExceptionDescription;
}

catch(e)
{
String[] lines = docString.split("\\n");
int arrayLine = (e.getLineNumber())-1;
//System.out.println("Newest DocString: "+docString);
//System.out.println("Found exception in line: "+e.getLineNumber());
String nodeLine = lines[arrayLine];
String nodeName = nodeLine.substring(lines[arrayLine].indexOf('<')+1, lines[arrayLine].indexOf('>'));

if(exceptionFound == 1)
{
	accExceptionDescription += "\n";
}

exceptionFound = 1;
//if(e.getMessage().contains("Character reference"))
//{
//String illegalValue = e.getMessage().substring(e.getMessage().indexOf('"')+1, e.getMessage().lastIndexOf('"'));
//System.out.println("Removing: "+illegalValue);
String cleanedXML = docString.replaceFirst(nodeLine, "");

accExceptionDescription += e.getMessage()+" Error found in node "+nodeName+" at line "+e.getLineNumber()+", column "+e.getColumnNumber();
//System.out.println("Error: " +accExceptionDescription);
//System.out.println("Newest cleanedXML: "+cleanedXML);

accExceptionDescription = validateXML(cleanedXML, accExceptionDescription, exceptionFound);
//}
//else
//{
//	accExceptionDescription = e.getMessage()+" Error found in node "+nodeName+" at line "+e.getLineNumber()+", column "+e.getColumnNumber();
//}

return accExceptionDescription;

}

}

public String getStringFromDocument(com.adobe.idp.Document doc) 
{ 
                try { 
                        String s = ""; 

                        doc.passivate(); 

                        byte[] b = new byte[(int) doc.length()]; 

                        InputStream is = doc.getInputStream(); 
                        InputStreamReader isr; 

                        isr = new InputStreamReader( is ); 

                        char[] cbuf = new char[ b.length ]; 
                        isr.read( cbuf, 0, b.length ); 

                        s = new String( cbuf ); 

                        return s; 
                } catch (Exception e) { 
                        return null; 
                } 
}

com.adobe.idp.Document document = patExecContext.getProcessDataValue("/process_data/inData");


String exception = "";
int exceptionFound = 0;

String docString = getStringFromDocument(document);
//System.out.println("docString: "+docString);
String trimmedString = docString.substring(0, docString.lastIndexOf('>')+1);
docString = trimmedString;


DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
factory.setValidating(false);
factory.setNamespaceAware(true);

DocumentBuilder builder = factory.newDocumentBuilder();

builder.setErrorHandler(null);

String exceptionDescription = validateXML(docString, "", 0);

//patExecContext.setProcessDataValue("/process_data/inData", myNewString);
//patExecContext.setProcessDataIntValue("/process_data/exceptionFound", exceptionFound);
patExecContext.setProcessDataStringValue("/process_data/exception", exceptionDescription);