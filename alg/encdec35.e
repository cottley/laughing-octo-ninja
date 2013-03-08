
include std/search.e

function process_encode_35_chunk(sequence chunk)
  sequence result = {}
  log_debug("Chunk length is " & int_to_string(length(chunk)))
  -- 11 bits for max length of any byte occurance
  log_debug("Counting number of zero bytes " & int_to_string(length(find_all(0, chunk))))
  log_debug_pretty("Zero byte locations ", find_all(0, chunk), {})

  for i = 1 to length(chunk) do
    log_trace_pretty("Getting bits for element " & int_to_string(i) & " of chunk", int_to_bits(chunk[i],8), {})
    log_trace_pretty("Negating bits for element " & int_to_string(i) & " of chunk", int_to_bits(not_bits(chunk[i]),8), {})
    result &= bits_to_int(int_to_bits(not_bits(chunk[i]),8))    
  end for

  log_trace_pretty("Result is", result, {})

  return result
end function


global procedure process_encode_35(sequence infilename, sequence outfilename, integer buffsize)
  printf(1, " Algorithm: 35 - Assumption Average Encoding\n")
  integer ifn, ofn
  ifn = open(infilename, "rb")
  ofn = open(outfilename, "wb")
  if (ifn = -1) then
    printf(1, " Error: Unable to open input file for reading\n")
  else
    if (ofn = -1) then
      printf(1, " Error: Unable to open output file for writing\n")
    else
      sequence chunk
      while 1 do
        chunk = get_bytes ( ifn , buffsize) -- read buffsize bytes at a time
        puts(ofn, process_encode_35_chunk(chunk))
        -- chunk might be empty, that's ok
        if length(chunk) < buffsize then
          exit
        end if
      end while

      printf(1, " Status: Completed write to: " & outfilename & "\n\n")
      close(ofn)
    end if
    close(ifn)
  end if
end procedure

function process_decode_35_chunk(sequence chunk)
  sequence result = {}
  log_debug("Chunk length is " & int_to_string(length(chunk)))
  for i = 1 to length(chunk) do
    log_trace_pretty("Getting bits for element " & int_to_string(i) & " of chunk", int_to_bits(chunk[i],8), {})
    log_trace_pretty("Negating bits for element " & int_to_string(i) & " of chunk", int_to_bits(not_bits(chunk[i]),8), {})
    result &= bits_to_int(int_to_bits(not_bits(chunk[i]),8)) 
  end for
  log_trace_pretty("Result is", result, {})
  return result
end function


global procedure process_decode_35(sequence infilename, sequence outfilename)
  integer buffsize = 1024
  
  printf(1, " Algorithm: 35 - Assumption Average Encoding\n")
  integer ifn, ofn
  ifn = open(infilename, "rb")
  ofn = open(outfilename, "wb")
  if (ifn = -1) then
    printf(1, " Error: Unable to open input file for reading\n")
  else
    if (ofn = -1) then
      printf(1, " Error: Unable to open output file for writing\n")
    else
      sequence chunk
      while 1 do
        chunk = get_bytes ( ifn , buffsize) -- read buffsize bytes at a time
        puts(ofn, process_decode_35_chunk(chunk))
        -- chunk might be empty, that's ok
        if length(chunk) < buffsize then
          exit
        end if
      end while

      printf(1, " Status: Completed write to: " & outfilename & "\n\n")
      close(ofn)
    end if
    close(ifn)
  end if
end procedure
