#!/usr/bin/eui
include lib/logging.e
include lib/util.e
include alg/encdec01.e

constant ENC_BUFF_SIZE = 1024

sequence cl_mode = "ENCODE"
sequence cl_input = ""
sequence cl_output = ""

atom process_io = 0

procedure process_command_line() 
  log_debug("Processing command line")
end procedure

procedure show_help()
  printf(1, "\n\tCottley encoder/decoder version 1.0 - Algorithm 35\n")
  printf(1, "\tPlease specify command line arguments to indicate encoding or decoding\n")
  printf(1, "\tTo encode a file, use the -e flag as below:\n\n")
  printf(1, "\t\t  [program] -e inputfile outputfile\n\n")
  printf(1, "\tTo decode a file, use the -d flag as below:\n\n")
  printf(1, "\t\t  [program] -d inputfile outputfile\n\n")
end procedure

procedure main()
   init_logging()
   setLogLevel(LOG_LEVEL_DEBUG)
   log_debug("In main")

   process_command_line()

   if (process_io = 1) then

     if (cl_mode = "ENCODE") then
       log_debug("Encoding")
     else
       log_debug("Decoding")
     end if

   else
     show_help()
   end if

   finish_logging()
end procedure

-- Call main
main()
