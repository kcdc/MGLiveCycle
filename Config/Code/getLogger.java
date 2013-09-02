import org.apache.log4j.*;

// let's define a meaningful name for our logger
String loggerName = "mg.livecycle.exceptionHandler";

// as we need to reuse the name later put that into a process variable
patExecContext.setProcessDataStringValue("/process_data/@loggerName",loggerName);

// get the logger
Logger logger = Logger.getLogger(loggerName);