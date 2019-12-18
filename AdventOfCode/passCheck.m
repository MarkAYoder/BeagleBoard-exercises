function val = passCheck(num)
  global nums
  val = 0;
  data = num2str(num);
  % Convert to an array of numbers
  for ii = 1:length(data)
%    disp(data(ii))
    nums(ii) = str2num(data(ii));
  end
  
  % Check for repeated value, but only two in a row.
  ii = 1;
  while ii <= length(data)-1
%    disp(ii);
    if nums(ii) == nums(ii+1) % Two in a row
      if nums(ii) != nums(ii+2) % Only two in a row.  It passes
        val = 1;
        break
      else  %% More than two in a row, move to the end of the string of same digits
        jj = 3;
        while nums(ii) == nums(ii+jj)
          jj++;
        end
        ii += jj-1;   % Move past all the same digits
      end
    end
    ii++;
  end
  % Check for increasing values
  for ii = 1:length(data)-1
    if nums(ii) > nums(ii+1)
      val = 0;
    end
  end
end
