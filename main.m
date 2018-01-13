more on

%{

Notes:
  - detect dial within sample (no 0's)
  - get length of each dial
  - feed length to get basis
  - dot with basis and extract two tones
  - convert to phone symbol

%}

% funcs
function y = innerProd(f, inp, valRange)
  % temp range for t
  t = linspace(0, 0.5, valRange)';
  y = 4*trapz(t, sin(2*pi*f*t).*inp);
end

% Sample dial
[number, Fs] = audioread("dtmf_112163.wav");

% Set vals  
rowList = [1209 1336 1477 1633];
colList = [697 770 852 941];

dialArray = ["1" "2" "3" "A"; "4" "5" "6" "B"; "7" "8" "9" "C"; "*" "0" "#" "D"];

thresh = 0.01;

% Main loop
head = 1;
counter = 0;
while head < length(number);
  s = number(head);
  if abs(s) > 0;
    tail = head;
    while abs(s) > 0;
      s = number(tail);
      tail++;
      
      % Rudimentary check 1 value over
      if tail < length(number) && abs(number(tail)) > 0;
        s = number(tail);
        tail++;
      end
    end
    
    counter++;
    
    % display stuff
    %disp("---")
    %counter

    % determine if long enough
    if ((tail-head) / Fs) < thresh;
      head = tail;
      continue
    end
    
    tone = number(head:tail-1);
    
    % analyze tone
    % loop thru freq and get weights by inner product
    currentMax = 0;
    currentRow = -1;
    for i = 1:length(rowList);
      % calculate inner product
      f = rowList(i);
      t = linspace(0, (tail-head) / Fs, tail-head)';
      y = 4*trapz(t, sin(2*pi*f*t).*tone);
      
      if abs(y) > currentMax;
        currentRow = i;
        currentMax = abs(y);
      end
    end
    
    currentMax = 0;
    currentCol = -1;
    for j = 1:length(colList);
      % calculate inner product
      f = colList(j);
      t = linspace(0, (tail-head) / Fs, tail-head)';
      y = 4*trapz(t, sin(2*pi*f*t).*tone);
      
      if abs(y) > currentMax;
        currentCol = j;
        currentMax = abs(y);
      end
    end
    
    % print correct symbol
    dialArray(currentCol, currentRow)
    
    head = tail;
  end
  head++;
end
