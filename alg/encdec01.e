

function process_encode_01_chunk(sequence chunk)
  return chunk
end function


global procedure process_encode_01(sequence infilename, sequence outfilename, integer buffsize)
  printf(1, " Algorithm: 01 - Passthough - Copy input to output\n")
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
        puts(ofn, process_encode_01_chunk(chunk))
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

function process_decode_01_chunk(sequence chunk)
  return chunk
end function


global procedure process_decode_01(sequence infilename, sequence outfilename)
  integer buffsize = 1024
  
  printf(1, " Algorithm: 01 - Passthough - Copy input to output\n")
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
        puts(ofn, process_decode_01_chunk(chunk))
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
