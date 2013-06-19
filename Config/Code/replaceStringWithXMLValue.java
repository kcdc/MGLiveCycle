import org.apache.xerces.dom.DocumentImpl;

import org.w3c.dom.Document.*;

import org.w3c.dom.*;
import javax.xml.*;
import javax.xml.xpath.*;

Document messageException = patExecContext.getProcessDataValue("/process_data/MessageException");
Document variablesFound = patExecContext.getProcessDataValue("/process_data/variablesFound");
String strValue = patExecContext.getProcessDataStringValue("/process_data/@replacementString");
//String strNodeName = patExecContext.getProcessDataStringValue("/process_data/@strNodeName");
String variableValueXPathNode = patExecContext.getProcessDataStringValue("/process_data/@variableValueXPathNode");

String concatenatedString = "";

XPath xPath = XPathFactory.newInstance().newXPath();
NodeList childNodes = (NodeList)xPath.evaluate(variableValueXPathNode, variablesFound.getDocumentElement(), XPathConstants.NODESET);

XPath xPath = XPathFactory.newInstance().newXPath();
NodeList messageExceptionNodeList = (NodeList)xPath.evaluate(".",messageException.getDocumentElement(), XPathConstants.NODESET);

Node parent = messageExceptionNodeList.item(0);

int numChildren = childNodes.getLength();


for (int i = 0; i < numChildren; i++)
{
	Node currentNode = childNodes.item(i);
	
	XPathExpression expr = xPath.compile(".//"+currentNode.getTextContent());
	Object result = expr.evaluate(parent, XPathConstants.NODESET);

	NodeList nodes = (NodeList) result;
	//System.out.println("Test: "+nodes.item(0).getTextContent());
	strValue = strValue.replaceFirst("\\$", nodes.item(0).getTextContent());
   
	
}

patExecContext.setProcessDataStringValue("/process_data/outStringVar", strValue);