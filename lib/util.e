
include std/sequence.e
include std/text.e

global function open_binary_read(sequence filepath) 
  integer fn = open(filepath, "rb")
  return fn
end function


global procedure close_binary_read(integer fn)
  if (fn != -1) then 
    close(fn)
  end if
end procedure

global function i2s(integer i) 
  return sprintf("%d", i)
end function

global function int_to_string(integer i) 
  return sprintf("%d", i)
end function

global function get_permuted_chunk(sequence factoradic, sequence startseq)
  sequence temp = startseq
  sequence result = {}
  
  for i = 1 to length(factoradic) do
    integer location = factoradic[i]+1
    result &= temp[location]
    temp = remove(temp, location)
  end for
  
  return result
end function

global function get_factoradic_chunk(sequence startseq, sequence permutation)
  sequence temp = startseq
  sequence result = repeat(0, length(permutation))

  for i = 1 to length(permutation) do
    integer location = find(permutation[i], temp)
    --//log_debug_pretty("Calculated Factoradic temp " & int_to_string(i) & " with location " & int_to_string(location), temp, {})
    result[i] = location - 1
    temp = remove(temp, location)
  end for
  
  return result
end function

global function factoradic_to_string(sequence factoradic)
  sequence result = {}
  sequence factoradic_lsf = reverse(factoradic)
  
  for i = 1 to length(factoradic_lsf) do
    result &= pad_tail(i2s(factoradic_lsf[i]), length(i2s(i-1)), "0")
  end for
  
  return reverse(flatten(result))
end function

global function digit_iseven(atom in)
  atom result = 0
  in = in - 48
  if ((in = 0) or (in = 2) or (in = 4) or (in = 6) or (in = 8)) then
    result = 1
  end if
  return result
end function

--// http://en.wikipedia.org/wiki/Division_by_two
global function divide_by_2(sequence in)
  sequence result = {} --// Stores quotient and remainder 
  sequence quotient = {}
  sequence remainder = {}
  sequence n = "0" & in
  
  for i = 1 to length(n) - 1 do
    if digit_iseven(n[i]) then
      if (n[i+1] = '0') or (n[i+1] = '1') then
        quotient &= '0'
      end if      
      if (n[i+1] = '2') or (n[i+1] = '3') then
        quotient &= '1'
      end if      
      if (n[i+1] = '4') or (n[i+1] = '5') then
        quotient &= '2'
      end if      
      if (n[i+1] = '6') or (n[i+1] = '7') then
        quotient &= '3'
      end if      
      if (n[i+1] = '8') or (n[i+1] = '9') then
        quotient &= '4'
      end if      
      
    else
      if (n[i+1] = '0') or (n[i+1] = '1') then
        quotient &= '5'
      end if          
      if (n[i+1] = '2') or (n[i+1] = '3') then
        quotient &= '6'
      end if      
      if (n[i+1] = '4') or (n[i+1] = '5') then
        quotient &= '7'
      end if      
      if (n[i+1] = '6') or (n[i+1] = '7') then
        quotient &= '8'
      end if      
      if (n[i+1] = '8') or (n[i+1] = '9') then
        quotient &= '9'
      end if      
    end if
  end for
  
  if (digit_iseven(n[length(n)])) then
    remainder = "0"
  else
    remainder = "1"  
  end if
  
  quotient = trim_head(quotient, "0")
  
  result = { quotient, remainder }
  
  return result
end function

global function decimal_string_to_bitstring(sequence decimalstr)
  sequence result = {}
  sequence decdiv2 = { decimalstr, "0" }
  
  while not(equal(decdiv2[1], "")) do
    decdiv2 = divide_by_2(decdiv2[1])
    --//log_debug("Divided by 2 quotient is " & decdiv2[1])
    if equal(decdiv2[2], "0") then
      result &= 0
    else
      result &= 1
    end if
  end while
  
  return result
end function

global function bitstringtobytes(sequence bitstring)
  sequence result = {}
  sequence remainingbitstring = bitstring
  
  if (length(remainingbitstring) < 8) then
    remainingbitstring = pad_tail(remainingbitstring, 8, 0)
  end if
  
  while (length(remainingbitstring) >= 8) do
    
    result &= bits_to_int(remainingbitstring[1..8])
    
    remainingbitstring = remainingbitstring[9..length(remainingbitstring)]
   
  end while

  if (length(remainingbitstring) > 0) then
    remainingbitstring = pad_tail(remainingbitstring, 8, 0)
    result &= bits_to_int(remainingbitstring[1..8])
  end if
  
  return result
end function