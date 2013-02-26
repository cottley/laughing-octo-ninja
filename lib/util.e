
global function open_binary_read(sequence filepath) 
  integer fn = open(filepath, "rb")
  return fn
end function


global procedure close_binary_read(integer fn)
  if (fn != -1) then 
    close(fn)
  end if
end procedure

