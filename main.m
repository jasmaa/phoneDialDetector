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
function y = innerProd(f, tone, valRange)
  % temp range for t
  t = linspace(0, 0.5, valRange)';
  y = 4*trapz(t, sin(2*pi*f*t).*tone);
end

[number, Fs] = audioread('sample01.wav');

% Set vals  
rowFreq = [1209 1336 1477 1633];
colFreq = [697 770 852 941];
thresh = 0.2

% Main loop
head = 1;
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
    
    disp("---")
    tone = number(head:tail-1);

    % analyze tone
    % loop thru freq and get weights by inner product
    innerProd(row, tone, tail-head)
    for row = rowFreq;
      for col = colFreq;
        if innerProd(row, tone, tail-head) > thresh && innerProd(col, tone, tail-head) > thresh
          row
          col
        end
      end
    end
    
    head = tail;
  end
  head++;
end
