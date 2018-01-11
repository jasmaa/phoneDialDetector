more on

%{

Notes:
  - detect dial within sample (no 0's)
  - get length of each dial
  - feed length to get basis
  - dot with basis and extract two tones
  - convert to phone symbol

%}

function y = innerProd(f, tone)
  % temp range for t
  t = linspace(0, 0.5, 4000)';
  y = 4*trapz(t, sin(2*pi*f*t).*tone);
end

[number, Fs] = audioread('answering_machine_code.wav');

number

sound(number)

% recover tones
tone1 = number(1:0.5*Fs);
tone2 = number(1*Fs+1:1.5*Fs);
tone3 = number(2*Fs+1:2.5*Fs);

% find dial  
rowFreq = [1209 1336 1477 1633];
colFreq = [697 770 852 941];

% loop thru freq and get weights by inner product
for row = rowFreq;
  for col = colFreq;
    if innerProd(row, tone3) > 0.5 && innerProd(col, tone3) > 0.5
      row
      col
    end
  end
end