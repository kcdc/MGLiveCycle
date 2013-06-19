import org.apache.xerces.dom.DocumentImpl;

import org.w3c.dom.Document.*;

import org.w3c.dom.*;
import javax.xml.*;
import javax.xml.xpath.*;

Document document = patExecContext.getProcessDataValue("/process_data/MessageException");
Document document = patExecContext.getProcessDataValue("/process_data/exceptionHandling");
//String strValue = patExecContext.getProcessDataStringValue("/process_data/@strValue");
String strNodeName = patExecContext.getProcessDataStringValue("/process_data/@strNodeName");
String strXPathNode = patExecContext.getProcessDataStringValue("/process_data/@strXPathNode");

if(strXPathNode.length() > 0 && strNodeName.length() >0)
{
//Evaluate XPath against Document itself
XPath xPath = XPathFactory.newInstance().newXPath();
NodeList childNodes = (NodeList)xPath.evaluate(strXPathNode, document.getDocumentElement(), XPathConstants.NODESET);


int numChildren = childNodes.getLength();

//System.out.println("First XPATH: "+childNodes.getLength());
//Loop through the numbere of children of the node
for (int i = 0; i < numChildren; i++)
{
	Node currentNode = childNodes.item(i);
	
	XPath xPath = XPathFactory.newInstance().newXPath();
    XPathExpression expr = xPath.compile("./"+strNodeName);
    Object result = expr.evaluate(currentNode, XPathConstants.NODESET);

    NodeList nodes = (NodeList) result;
//if we find a child with the name we are looking for set the value in this child
    if(nodes.getLength() > 0)
	{
		nodes.item(0).setTextContent(strValue);
		
	}
	//else create the node and add the value
	else
	{
		Element newResource = document.createElement(strNodeName);
		newResource.setTextContent(strValue);
		currentNode.appendChild(newResource);
	}
	}
	
}

patExecContext.setProcessDataStringValue("/process_data/outStringVar", concatednatedString);