
include std/search.e
include std/stats.e
include std/sequence.e

-- Determine the maximum frequency a byte occurs
function e35_calc_maxfreq(sequence chunk)
  integer result = -1
  integer findallfori
  integer mostfrequentbyte = 0
  for i = 0 to 255 do
    findallfori = length(find_all(i, chunk))
    if findallfori > result then
      result = findallfori
      mostfrequentbyte = i
    end if
  end for
  return { int_to_string(mostfrequentbyte), int_to_string(result), mostfrequentbyte}
end function

-- Determine the delta locations for a sequence
function e35_calc_deltalocation(sequence chunk)
  sequence result = {}
  if (length(chunk) > 0) then
    result &= chunk[1]
  end if
  for i = 2 to length(chunk) do
    result &= chunk[i] - chunk[i-1]
  end for
  return result
end function

-- Create a sequence that has all delta locations together
function e35_calc_alldeltalocations(sequence chunk)
  sequence result = {}
  for i = 0 to 255 do
    result &= e35_calc_deltalocation(find_all(i, chunk))
  end for
  return result
end function

function process_encode_35_chunk(sequence chunk)
  sequence result = {}
  log_debug("Chunk length is " & int_to_string(length(chunk)))
  -- 11 bits for max length of any byte occurance
  --log_debug("Counting number of zero bytes " & int_to_string(length(find_all(0, chunk))))
  --log_debug_pretty("Zero byte locations ", find_all(0, chunk), {})
  while length(chunk) > 0 do
    sequence bytefreqstats = e35_calc_maxfreq(chunk)
    log_debug("Most frequent byte is " & bytefreqstats[1] & " with a count of " & bytefreqstats[2])
    log_debug_pretty(bytefreqstats[1] & " byte locations ", find_all(bytefreqstats[3], chunk), {})
    log_debug_pretty(bytefreqstats[1] & " byte location deltas ", e35_calc_deltalocation(find_all(bytefreqstats[3], chunk)), {})
    chunk = remove_all(bytefreqstats[3], chunk)
  end while
  
  --for i = 0 to 255 do
  --  log_debug_pretty(int_to_string(i) & " byte locations ", find_all(i, chunk), {})
  --  log_debug_pretty(int_to_string(i) & " byte location deltas ", e35_calc_deltalocation(find_all(i, chunk)), {})
  --end for
  
  -- log_debug("Average location for zero byte location " & int_to_string(floor(average(e35_calc_deltalocation(find_all(0, chunk))))))
  --log_debug_pretty("Raw frequency of zero byte deltas ", raw_frequency(e35_calc_deltalocation(find_all(0, chunk))), {})
  --log_debug_pretty("Raw frequency of all deltas ", raw_frequency(e35_calc_alldeltalocations(chunk)), {})
  --log_debug("Average location for all location deltas " & int_to_string(floor(average(remove_dups(e35_calc_alldeltalocations(chunk))))))
  
  
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
