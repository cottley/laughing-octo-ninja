include std/stats.e
include std/search.e


constant FALSE = 0
constant TRUE = 1

global function bitlib_add_one(sequence in)
  sequence result = in
  atom done = FALSE
  integer index = 1
  integer maxlen = length(in)
  result[index] += 1
  while (not(done)) do
    if (result[index] > 1) then
      result[index] = 0
      index += 1
      if (index <= maxlen) then
        result[index] += 1
      else
        done = TRUE
      end if
    else
      done = TRUE
    end if
  end while
  return result
end function

global function bitlib_no_of_bits(sequence in)
  integer result = 0
  for i = 1 to length(in) do
    if (in[i] = 1) then result += 1 end if
  end for
  return result
end function

global function bitlib_permuteone_count(sequence in)
  integer noofbits = bitlib_no_of_bits(in)
  sequence result = bitlib_add_one(in)
  
  while (noofbits != bitlib_no_of_bits(result)) do
    result = bitlib_add_one(result)
  end while
  
  return result
end function

/*
 Name: bitlib_permuteone
 Note: This function generates the next bit-wise permutation of the sequence.
*/
global function bitlib_permuteone(sequence in)
  --log_debug_pretty("bitlib_permuteone in ", in, {})

  -- Find last set bit
  integer lastSetBitLoc = rfind(1, in) 
  --log_debug("lastSetBitLoc is: " & int_to_string(lastSetBitLoc))
  integer sequenceSize = length(in)
  --log_debug("sequenceSize is: " & int_to_string(sequenceSize))
  sequence result = in 
  if ((lastSetBitLoc != sequenceSize) and (lastSetBitLoc != 0)) then
    result[lastSetBitLoc+1] = 1
    result[lastSetBitLoc] = 0
    --log_debug("swapped location " & int_to_string(lastSetBitLoc) & " and " & int_to_string(lastSetBitLoc+1))

  else 
    -- Find the last 0
    integer lastZeroBitLoc = rfind(0, in)
    --log_debug("lastZeroBitLoc is: " & int_to_string(lastZeroBitLoc))

    -- Find the next 1
    integer nextOneLoc = rfind(1, in, lastZeroBitLoc)
    --log_debug("nextOneLoc is: " & int_to_string(nextOneLoc))

    if (nextOneLoc != 0) then
      -- We can continue to permute
      --log_debug("We can continue to permute")
      result[nextOneLoc+1] = 1
      result[nextOneLoc] = 0
      --log_debug("swapped location " & int_to_string(nextOneLoc) & " and " & int_to_string(nextOneLoc+1))
  

      integer index = nextOneLoc + 2
      --log_debug("index is: " & int_to_string(index))

      integer endindexoffset = 0
      --log_debug("endindexoffset is: " & int_to_string(endindexoffset))

      --log_debug("upper limit is: " & int_to_string(sequenceSize-endindexoffset))

      while (index < (sequenceSize-endindexoffset)) do
        --log_debug("can swap")
        integer savedbit = result[index]
        result[index] = result[(sequenceSize-endindexoffset)]
        result[sequenceSize-endindexoffset] = savedbit

        --log_debug("swapped locations " & int_to_string(index) & " and " & int_to_string(sequenceSize-endindexoffset))


        index += 1
        endindexoffset += 1
      end while

    else
      -- No 1s left, can't permute anymore
     --log_debug("No 1s left, can't permute anymore")
    end if

  end if
  --log_debug_pretty("bitlib_permuteone result ", result, {})
  return result
end function



