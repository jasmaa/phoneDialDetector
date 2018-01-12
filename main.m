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

%dtmf_112163
[number, Fs] = audioread('dtmf_112163.wav');
[divider, Fs1] = audioread('ding.wav');

% Set vals  
freqList = [1209 1336 1477 1633 697 770 852 941];
thresh = 0.001

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
    disp("---")
    counter
    
    tone = number(head:tail-1);
    
    % analyze tone
    % loop thru freq and get weights by inner product
    for f = freqList;
      % calculate inner product
      t = linspace(0, (tail-head) / Fs, tail-head)';
      y = 4*trapz(t, sin(2*pi*f*t).*tone);
      
      if y > thresh;
        f
      end
    end
    
    head = tail;
  end
  head++;
end
