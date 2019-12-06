function val = passCheck(num)
  global nums
  val = 0;
  data = num2str(num);
  % Convert to an array of numbers
  for ii = 1:length(data)
%    disp(data(ii))
    nums(ii) = str2num(data(ii));
  end
  
  % Check for repeated value
  for ii = 1:length(data)-1
    if nums(ii) == nums(ii+1)
      val = 1;
      break
    end
  end
  % Check for increasing values
  for ii = 1:length(data)-1
    if nums(ii) > nums(ii+1)
      val = 0;
    end
  end
end
