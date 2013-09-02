import org.apache.log4j.*;

// get to the logger which is specific for that process 
String loggerName = patExecContext .getProcessDataStringValue("/process_data/@loggerName");
String returnText = patExecContext .getProcessDataStringValue("/process_data/@exceptionDescription");
String returnStatus = patExecContext .getProcessDataStringValue("/process_data/@returnStatus");
String exceptionLevel = patExecContext .getProcessDataStringValue("/process_data/@exceptionLevel");
String filename = patExecContext .getProcessDataStringValue("/process_data/@fileName");
Logger logger = Logger.getLogger(loggerName);


if(exceptionLevel.toLowerCase().contains("warning"))
{
	logger.warn(exceptionLevel+": "+returnStatus+" - "+returnText+" --> processing of "+filename+" will continue");
}
else if(exceptionLevel.toLowerCase().contains("error"))
{
		logger.error(exceptionLevel+": "+returnStatus+" - "+returnText+" --> processing of "+filename+" was stopped");
}
else if(exceptionLevel.toLowerCase().contains("info"))
{
		logger.info(exceptionLevel+": "+returnStatus+" - "+returnText+" --> processing of "+filename+" was logged");
}