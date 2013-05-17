import java.math.BigInteger;
import java.io.*;
import java.io.File;
import org.w3c.dom.Document;
import org.w3c.dom.*;
import org.xml.sax.*;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.DocumentBuilder;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException; 

import org.apache.xerces.dom.DocumentImpl;

import org.w3c.dom.Document.*;

import org.w3c.dom.*;
import javax.xml.*;
import javax.xml.xpath.*;

String addBackSlash(String pathPart)
{
	
if(pathPart.length() > 0)
{
	pathPart = "\\"+pathPart;
}
return pathPart;
}
Document document = patExecContext.getProcessDataValue("/process_data/xmlVar");

String fileName = patExecContext.getProcessDataValue("/process_data/fileName");

String charSet = patExecContext.getProcessDataValue("/process_data/charSet");

String archiveStorePath = patExecContext.getProcessDataValue("/process_data/archiveStorePath");

//try
//{
  String strXPathNode = "";
  DocumentBuilderFactory docFactory = DocumentBuilderFactory.newInstance();
  DocumentBuilder docBuilder = docFactory.newDocumentBuilder();

  //root elements
  Document doc = docBuilder.newDocument();

  Element rootElement = doc.createElement("adiarchive");
  doc.appendChild(rootElement);

  //invoice element
  Element invoice = doc.createElement("invoice");
  rootElement.appendChild(invoice);

  //set attribute to invoice element
  Attr attr = doc.createAttribute("accountno");
  strXPathNode = "//RESKONTRONR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

  //set attribute to invoice element
  attr = doc.createAttribute("amount");
  strXPathNode = "//BELOP";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

  //set attribute to invoice element
  attr = doc.createAttribute("vehicleregno");
  strXPathNode = "//BILNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr); 

//set attribute to invoice element
  attr = doc.createAttribute("depnojur");
  strXPathNode = "//JFNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr); 

//set attribute to invoice element
  attr = doc.createAttribute("depno");
  strXPathNode = "//FNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr); 

//set attribute to invoice element
  attr = doc.createAttribute("pdfname");
   attr.setValue(fileName+".pdf");
  invoice.setAttributeNode(attr); 

//concat("pdf\",/process_data/xmlVar//Country,"\",/process_data/xmlVar//JFNR, "\",/process_data/xmlVar//DocType,"\",/process_data/xmlVar//FNR, "\", /process_data/xmlVar//FAKTAR,"\", /process_data/xmlVar//FAKTMND)

//set attribute to invoice element
  attr = doc.createAttribute("pdfpath");
  
strXPathNode = "//Country";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String country = addBackSlash(xp.evaluate(document));

strXPathNode = "//JFNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String jfnr = addBackSlash(xp.evaluate(document));

strXPathNode = "//DocType";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String docType = addBackSlash(xp.evaluate(document));

strXPathNode = "//FNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String fnr = addBackSlash(xp.evaluate(document));

strXPathNode = "//FAKTAR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String faktAar = addBackSlash(xp.evaluate(document));


strXPathNode = "//FAKTMND";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String faktMnd = addBackSlash(xp.evaluate(document));

attr.setValue("\\pdf"+country+jfnr+docType+fnr+faktAar+faktMnd+"\\");
invoice.setAttributeNode(attr); 

//set attribute to invoice element
  attr = doc.createAttribute("depname");
  strXPathNode = "//FORHANDLERNAVN";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr); 

//set attribute to invoice element
  attr = doc.createAttribute("ordernumber");
  strXPathNode = "//GJENNOMGNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr); 
//concat(substring(/process_data/xmlVar//FAKTDATO, 7,4),'-', substring(/process_data/xmlVar//FAKTDATO, 4,2), '-', substring(/process_data/xmlVar//FAKTDATO, 1,2))
//set attribute to invoice element
  attr = doc.createAttribute("invoicedate");
  
  
strXPathNode = "//FAKTDATO";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String invoiceDate = xp.evaluate(document);
String formattedInvoiceDate = invoiceDate.substring(6,10)+"-"+invoiceDate.substring(3,5)+"-"+invoiceDate.substring(0,2);
attr.setValue(formattedInvoiceDate);
invoice.setAttributeNode(attr); 


//set attribute to invoice element
  attr = doc.createAttribute("custname");
  strXPathNode = "//NAVN";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

//set attribute to invoice element
  attr = doc.createAttribute("custno");
  strXPathNode = "//KUNDENR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

//set attribute to invoice element
  attr = doc.createAttribute("invoiceno");
  strXPathNode = "//FAKTURANR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

//set attribute to invoice element
  attr = doc.createAttribute("doctype");
  strXPathNode = "//RAPPORTID";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);


//set attribute to invoice element
  attr = doc.createAttribute("archivedyear");
  strXPathNode = "//ARKIVAAR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

//set attribute to invoice element
  attr = doc.createAttribute("archiveid");
  strXPathNode = "//ARKIVNR";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);

//set attribute to invoice element
  attr = doc.createAttribute("countrycode");
  strXPathNode = "//LANDKODE";
XPathExpression xp = XPathFactory.newInstance().newXPath().compile(strXPathNode);
String value = xp.evaluate(document);
  attr.setValue(value);
  invoice.setAttributeNode(attr);


  //write the content into xml file
  TransformerFactory transformerFactory = TransformerFactory.newInstance();
  Transformer transformer = transformerFactory.newTransformer();
transformer.setOutputProperty(OutputKeys.ENCODING,charSet);
  DOMSource source = new DOMSource(doc);

  StreamResult result =  new StreamResult(new File(archiveStorePath+"\\"+fileName+".xml"));
  transformer.transform(source, result);

  System.out.println("Done");

/*}catch(ParserConfigurationException pce){
  pce.printStackTrace();
}catch(TransformerException tfe){
  tfe.printStackTrace();
}*/
