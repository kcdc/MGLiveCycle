import org.apache.xerces.dom.DocumentImpl;

import org.w3c.dom.Document.*;

import org.w3c.dom.*;
import javax.xml.*;
import javax.xml.xpath.*;
/*
This code takes in an XPath expression, a name of a Node, a Value and an XML variable.
The XML variable is iterated and searched for the XPath expression, if a result is found it is checked whether the Nodename exist as a part of the children of this XPath expression (e.g.: //DocumentHeader). If the NodeName is found - the value will be set in this node and the search for the XPath expression continues (there might be more than one). If the NodeName is not found as a child of the XPath Value it will be created and the value will be set.
*/

Document document = patExecContext.getProcessDataValue("/process_data/xmlVar");
String strValue = patExecContext.getProcessDataStringValue("/process_data/@strValue");
String strNodeName = patExecContext.getProcessDataStringValue("/process_data/@strNodeName");
String strXPathNode = patExecContext.getProcessDataStringValue("/process_data/@strXPathNode");

//if we have an XPathNode and a Nodename
if(strXPathNode.length() > 0 && strNodeName.length() >0)
{
//Evaluate XPath against Document itself
XPath xPath = XPathFactory.newInstance().newXPath();
//get the children of the XPathNode
NodeList childNodes = (NodeList)xPath.evaluate(strXPathNode, document.getDocumentElement(), XPathConstants.NODESET);


int numChildren = childNodes.getLength();

//for each children of the XPathNode
for (int i = 0; i < numChildren; i++)
{
	Node currentNode = childNodes.item(i);
	
	XPath xPath = XPathFactory.newInstance().newXPath();
	//is the NodeName a child of this XPath Node
    XPathExpression expr = xPath.compile("./"+strNodeName);
    Object result = expr.evaluate(currentNode, XPathConstants.NODESET);

    NodeList nodes = (NodeList) result;
	//if child exist
    if(nodes.getLength() > 0)
	{
		//set the value on the first child (several repeating children not handled)
		nodes.item(0).setTextContent(strValue);
		
	}
	//if not found as child
	else
	{
		//create node and set the value
		Element newResource = document.createElement(strNodeName);
		newResource.setTextContent(strValue);
		currentNode.appendChild(newResource);
	}
	}
	
}
//return the changed xml variable back to the calling process
patExecContext.setProcessDataValue("/process_data/inXmlDoc", document);