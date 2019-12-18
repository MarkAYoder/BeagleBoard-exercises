% --- Day 4: Secure Container ---
% From: https://adventofcode.com/2019/day/4

% Allocate here so we only do it once.
global nums
nums = zeros(1, 6+1);
nums(7) = 'x';    % Put a non digit here so strings of numbers won't match it.

cnt = 0;
for pass = 356261:846303
%for pass = 356261:370000
  tmp = passCheck(pass);
  if tmp != 0
    disp(pass);
    cnt++;
  end
end

disp(cnt)
