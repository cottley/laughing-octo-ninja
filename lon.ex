#!/usr/bin/eui
include file.e
include get.e
include machine.e
include lib/logging.e
include lib/util.e
include alg/encdec01.e
include alg/encdec02.e
include alg/encdec03.e
include alg/encdec35.e


constant ENC_BUFF_SIZE = 1024

sequence cl_mode = ""
sequence cl_input = ""
sequence cl_output = ""
sequence cl_algorithm = ""

atom process_io = 0

procedure process_command_line() 
  log_debug("Processing command line")
  sequence cmds = command_line()
  for i = 1 to length (cmds) do
    switch cmds[i] do
      case "-e" then
        cl_mode = "ENCODE"  
      case "-d" then
        cl_mode = "DECODE"         
      case "-i" then
        cl_input = cmds[i+1]
      case "-o" then
        cl_output = cmds[i+1]
      case "-a" then
        cl_algorithm = cmds[i+1]        
    end switch
  end for

  if ((not equal(cl_mode, "")) and (not equal(cl_input, "")) and (not equal(cl_output, "")) and (not equal(cl_algorithm,  ""))) then
    process_io = 1
  end if
end procedure

procedure show_header()
  printf(1, "\n\tLaughing-octo-ninja encoder/decoder version 0.1\n")
end procedure

procedure show_help()
  show_header()
  printf(1, "\tPlease specify command line arguments to indicate encoding or decoding\n")
  printf(1, "\tTo encode a file, use the -e flag as below:\n\n")
  printf(1, "\t\t  [program] -a algorithm -e -i inputfile -o outputfile\n\n")
  printf(1, "\tTo decode a file, use the -d flag as below:\n\n")
  printf(1, "\t\t  [program] -a algorithm -d -i inputfile -o outputfile\n\n")
  printf(1, "\t Available Algorithm Identifiers: 01,02,03,35\n\n")
end procedure

procedure main()
   init_logging()
   setLogLevel(LOG_LEVEL_DEBUG)
   log_debug("In main")

   process_command_line()

   if (process_io = 1) then

     if (equal(cl_mode, "ENCODE")) then
       log_debug("Encoding")
       show_header()
       printf(1, "\n Encoding: " & cl_input & "\n")
       switch cl_algorithm with fallthru do
         case "01" then process_encode_01(cl_input, cl_output, ENC_BUFF_SIZE) break
         case "02" then process_encode_02(cl_input, cl_output, ENC_BUFF_SIZE) break
         case "03" then process_encode_03(cl_input, cl_output, ENC_BUFF_SIZE) break
         case "35" then process_encode_35(cl_input, cl_output, ENC_BUFF_SIZE) break
         case else
           printf(1, "\tError, algorithm id: " & cl_algorithm & " is not recognized.\n")
       end switch
     else if equal(cl_mode, "DECODE") then
         log_debug("Decoding")
         show_header()
         printf(1, "\n Decoding: " & cl_input & "\n")
         switch cl_algorithm with fallthru do
           case "01" then process_decode_01(cl_input, cl_output) break
           case "02" then process_decode_02(cl_input, cl_output) break
           case "03" then process_decode_03(cl_input, cl_output) break
           case "35" then process_decode_35(cl_input, cl_output) break
           case else
             printf(1, "\tError, algorithm id: " & cl_algorithm & " is not recognized.\n")
         end switch 
       else
         log_fatal("Unable to determine mode from command line parameter")
         printf(1, "\tError, unable to determine mode from command line parameter\n")
       end if       
     end if

   else
     show_help()
   end if

   finish_logging()
end procedure

-- Call main
main()
