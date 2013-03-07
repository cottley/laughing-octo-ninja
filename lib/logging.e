
global enum LOG_LEVEL_TRACE, LOG_LEVEL_DEBUG, LOG_LEVEL_INFO, LOG_LEVEL_ERROR, LOG_LEVEL_FATAL

global atom LOG_LEVEL = LOG_LEVEL_FATAL

global sequence logFileName = "log/application.log"

integer file_num

global procedure setLogLevel(atom newLogLevel)
  if (newLogLevel = LOG_LEVEL_TRACE) then LOG_LEVEL = LOG_LEVEL_TRACE end if
  if (newLogLevel = LOG_LEVEL_DEBUG) then LOG_LEVEL = LOG_LEVEL_DEBUG end if
  if (newLogLevel = LOG_LEVEL_INFO) then LOG_LEVEL = LOG_LEVEL_INFO end if
  if (newLogLevel = LOG_LEVEL_ERROR) then LOG_LEVEL = LOG_LEVEL_ERROR end if
  if (newLogLevel = LOG_LEVEL_FATAL) then LOG_LEVEL = LOG_LEVEL_FATAL end if
end procedure

global procedure init_logging() 
  file_num = open(logFileName, "w")
end procedure

global procedure finish_logging()
  if (file_num != -1) then
    close(file_num)
  end if
end procedure

global procedure log_trace(sequence message)
   if (LOG_LEVEL <= LOG_LEVEL_TRACE) and (file_num != -1) then
     printf(file_num, "[TRACE] " & message & '\n')
   end if
end procedure

global procedure log_trace_pretty(sequence message, object x, sequence options)
   if (LOG_LEVEL <= LOG_LEVEL_TRACE) and (file_num != -1) then
     printf(file_num, "[TRACE] " & message & " ")
     pretty_print(file_num, x, options)
     printf(file_num, "\n")
   end if
end procedure

global procedure log_debug(sequence message)
   if (LOG_LEVEL <= LOG_LEVEL_DEBUG) and (file_num != -1) then
     printf(file_num, "[DEBUG] " & message & '\n')
   end if
end procedure

global procedure log_debug_pretty(sequence message, object x, sequence options)
   if (LOG_LEVEL <= LOG_LEVEL_DEBUG) and (file_num != -1) then
     printf(file_num, "[DEBUG] " & message & " ")
     pretty_print(file_num, x, options)
     printf(file_num, "\n")
   end if
end procedure

global procedure log_info(sequence message)
   if (LOG_LEVEL <= LOG_LEVEL_INFO) and (file_num != -1) then
     printf(file_num, "[INFO] " & message & '\n')
   end if
end procedure

global procedure log_error(sequence message)
   if (LOG_LEVEL <= LOG_LEVEL_ERROR) and (file_num != -1) then
     printf(file_num, "[ERROR] " & message & '\n')
   end if
end procedure

global procedure log_fatal(sequence message)
   if (LOG_LEVEL <= LOG_LEVEL_ERROR) and (file_num != -1) then
     printf(file_num, "[FATAL] " & message & '\n')
   end if
end procedure

