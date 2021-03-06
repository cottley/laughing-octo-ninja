include std/math.e
include std/stats.e

/*
procedure ithPermutation(integer n, integer i)

   integer j, k = 1
   sequence fact = repeat(0, n)
   sequence perm = repeat(0, n)

   -- compute factorial numbers
   fact[k] = 1
   k+=1
   while (k < n) do
      fact[k] = fact[k - 1] * k
      k+=1
   end while

   -- compute factorial code
   for k1 = 1 to n+1 do   
      perm[k1] = i / fact[n - k1]
      i = mod(i, fact[n - k1])
   end for

   -- readjust values to obtain the permutation
   -- start from the end and check if preceding values are lower
   for k2 = n to 1 by -1 do
      for j1 = k2 to 1 by -1 do
         if (perm[j1] <= perm[k2]) then
            perm[k2]+=1
         end if
      end for
   end for

   -- print permutation
   for k3 = 1 to n+1 do
      printf("%d ", perm[k3])
   end for


end procedure
*/
/*
The Countdown QuickPerm Algorithm:

   let a[] represent an arbitrary list of objects to permute
   let N equal the length of a[]
   create an integer array p[] of size N+1 to control the iteration     
   initialize p[0] to 0, p[1] to 1, p[2] to 2, ..., p[N] to N
   initialize index variable i to 1
   while (i < N) do {
      decrement p[i] by 1
      if i is odd, then let j = p[i] otherwise let j = 0
      swap(a[j], a[i])
      let i = 1
      while (p[i] is equal to 0) do {
         let p[i] = i
         increment i by 1
      } // end while (p[i] is equal to 0)
   } // end while (i < N)

*/

sequence perm_chunk = {}

procedure swap(integer i, integer j)
  integer bit = perm_chunk[i]
  perm_chunk[i] = perm_chunk[j]
  perm_chunk[j] = bit
  log_debug_pretty("perm_chunk", perm_chunk, {})
end procedure

procedure testperm(integer sizeofchunk, integer noofsetbits)
  sequence startseq = repeat(1, noofsetbits) & repeat(0, sizeofchunk-noofsetbits)
  sequence endseq = repeat(0, sizeofchunk-noofsetbits) & repeat(1, noofsetbits)
  sequence perm1 = startseq 

  integer counter = 0

  atom t = time ()


  while (not(equal(endseq, perm1))) do
    perm1 = bitlib_permuteone(perm1)
    counter += 1
    -- log_debug_pretty("[testPerm] Permuted Bit chunk " & int_to_string(counter) & " ", perm1, {})
  end while
  log_debug("Time to run testperm: " & int_to_string(ceil(time () - t)))

end procedure

/*
function getMatchingPermNumber(sequence chunk, integer chunksum, integer noofsetbits)
  integer result = 0

  perm_chunk = repeat(1, noofsetbits) & repeat(0, length(chunk)-noofsetbits) 
  
  
  log_debug_pretty("Initial Bit chunk ", perm_chunk, {})
  --log_debug("No of bits is: " & int_to_string(bitlib_no_of_bits(perm_chunk)))
  --log_debug_pretty("Added one and now chunk is ", bitlib_add_one(perm_chunk), {})
  --log_debug("No of bits is: " & int_to_string(bitlib_no_of_bits(bitlib_add_one(perm_chunk))))
  --log_debug_pretty("Permuted Bit chunk ", bitlib_permuteone(perm_chunk), {})
  
  sequence perm1 = bitlib_permuteone(perm_chunk)
  result += 1
  -- log_debug_pretty("Permuted Bit chunk " & int_to_string(result) & " ", perm1, {})
  
  while (not(equal(chunk, perm1))) do
    perm1 = bitlib_permuteone(perm1)
    -- log_debug_pretty("Permuted Bit chunk " & int_to_string(result) & " ", perm1, {})
    result += 1
  end while

  return result
end function
*/

function getMatchingPermNumber(sequence chunk, integer noofsetbits, integer noofbitgroups)
  integer result = 0

  sequence perm_chunk_bits = repeat(1, noofsetbits) & repeat(0, length(chunk)-noofsetbits) 
  
  sequence perm1 = bitlib_permuteone(perm_chunk_bits)

  if (bitlib_no_of_bit_groups(perm1) = noofbitgroups) then
    result += 1
  end if
  
  while (not(equal(chunk, perm1))) do
    perm1 = bitlib_permuteone(perm1)
    if (bitlib_no_of_bit_groups(perm1) = noofbitgroups) then
      result += 1
    end if
  end while

  return result
end function

function process_encode_03_chunk(sequence chunk)
  sequence result = {}
/*
  log_debug("Chunk length is " & int_to_string(length(chunk)))

  sequence first16bytechunk = chunk[1..3]
  log_debug_pretty("First 3 byte chunk is ", first16bytechunk, {})

  integer first16bytechunksum = math:sum(first16bytechunk)
  log_debug(" Sum is: " & int_to_string(first16bytechunksum))

  sequence first16bytechunk_asbits = {}

  for i = 1 to length(first16bytechunk) do
    first16bytechunk_asbits &= int_to_bits(first16bytechunk[i],8)
  end for

  log_debug_pretty("Bit chunk ", first16bytechunk_asbits, {})

  integer bitfrequency =  bitlib_no_of_bits(first16bytechunk_asbits)

  
  -- integer matchingpermnumber = getMatchingPermNumber(first16bytechunk_asbits, first16bytechunksum, bitfrequency[1][1])
  integer bitfrequency_sm =  bitlib_no_of_bits(first16bytechunk_asbits)
  -- integer matchingpermnumber = getMatchingPermNumber(first16bytechunk_asbits, first16bytechunksum, bitfrequency_sm)

  -- log_debug("Matching perm number " & int_to_string(matchingpermnumber))  
*/

  integer maxcontiguousbits = 0
/*
  integer startchunkloc = 1
  for i = 1 to length(chunk)/3 do
    sequence chunkofinterest = chunk[startchunkloc..(startchunkloc+2)]
    -- // log_debug_pretty("3 byte chunk is ", chunkofinterest, {})

    sequence chunkofinterest_asbits = {}
    for j = 1 to length(chunkofinterest) do
      chunkofinterest_asbits &= int_to_bits(chunkofinterest[j],8)
    end for

    integer maxnoofcontbitsforchunk = bitlib_max_no_of_contiguous_bits(chunkofinterest_asbits)
    if (maxnoofcontbitsforchunk > maxcontiguousbits) then
      maxcontiguousbits = maxnoofcontbitsforchunk
    end if

    startchunkloc += 3
  end for
*/

  integer startchunkloc = 1
  for i = 1 to length(chunk)/3 do
    sequence chunkofinterest = chunk[startchunkloc..(startchunkloc+2)]
    -- // log_debug_pretty("3 byte chunk is ", chunkofinterest, {})

    sequence chunkofinterest_asbits = {}
    for j = 1 to length(chunkofinterest) do
      chunkofinterest_asbits &= int_to_bits(chunkofinterest[j],8)
    end for
    log_debug_pretty("Chunk bitstream is ", chunkofinterest_asbits, {})

    integer bitfrequency_sm =  bitlib_no_of_bits(chunkofinterest_asbits)
    integer bitgrouping_sm = bitlib_no_of_bit_groups(chunkofinterest_asbits)
    integer matchingpermnumber = getMatchingPermNumber(chunkofinterest_asbits, bitfrequency_sm, bitgrouping_sm)
    log_debug("Matching perm number " & int_to_string(matchingpermnumber) & " bit frequency " & int_to_string(bitfrequency_sm) & " bit grouping " & int_to_string(bitgrouping_sm))

    startchunkloc += 3
  end for

  log_debug("Max number of contiguous bits for chunk is " & int_to_string(maxcontiguousbits))


  for i = 1 to length(chunk) do
    log_trace_pretty("Getting bits for element " & int_to_string(i) & " of chunk", int_to_bits(chunk[i],8), {})
    log_trace_pretty("Negating bits for element " & int_to_string(i) & " of chunk", int_to_bits(not_bits(chunk[i]),8), {})
    result &= bits_to_int(int_to_bits(not_bits(chunk[i]),8))    
  end for

  --log_debug_pretty("Result is", result, {})

  return result
end function


global procedure process_encode_03(sequence infilename, sequence outfilename, integer inbuffsize)
  printf(1, " Algorithm: 03 - Predictive Permutation\n")
  integer buffsize = 1026
  integer ifn, ofn
  ifn = open(infilename, "rb")
  ofn = open(outfilename, "wb")
  if (ifn = -1) then
    printf(1, " Error: Unable to open input file for reading\n")
  else
    if (ofn = -1) then
      printf(1, " Error: Unable to open output file for writing\n")
    else
      --//integer testsize = 32
      --//testperm(testsize, testsize/2)
      --//7 minutes for 32 bits

      sequence chunk
      while 1 do
        chunk = get_bytes ( ifn , buffsize) -- read buffsize bytes at a time
        puts(ofn, process_encode_03_chunk(chunk))
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

function process_decode_03_chunk(sequence chunk)
  sequence result = {}
  log_debug("Chunk length is " & int_to_string(length(chunk)))
  for i = 1 to length(chunk) do
    log_trace_pretty("Getting bits for element " & int_to_string(i) & " of chunk", int_to_bits(chunk[i],8), {})
    log_trace_pretty("Negating bits for element " & int_to_string(i) & " of chunk", int_to_bits(not_bits(chunk[i]),8), {})
    result &= bits_to_int(int_to_bits(not_bits(chunk[i]),8)) 
  end for
  log_debug_pretty("Result is", result, {})
  return result
end function


global procedure process_decode_03(sequence infilename, sequence outfilename)
  integer buffsize = 1024
  
  printf(1, " Algorithm: 03 - Predictive Permutation\n")
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
        puts(ofn, process_decode_03_chunk(chunk))
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
