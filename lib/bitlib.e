include std/stats.e

integer FALSE = 0
integer TRUE = 1

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

global function bitlib_permuteone(sequence in)
  integer noofbits = bitlib_no_of_bits(in)
  sequence result = bitlib_add_one(in)
  
  while (noofbits != bitlib_no_of_bits(result)) do
    result = bitlib_add_one(result)
  end while
  
  return result
end function