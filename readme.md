# Phone Dial Detector

A simple project that attempts to decode button presses
from frequencies in a DTMF phone dial.

### Method

  - DTMF tones inputted as wav file
  - Locations containing tones are found
  - DTMF tone is known to be two sine waves of different frequencies added together
    - Inner product between a candidate function and the tone is found taking the largest magnitude
  - Symbols are matched

### Acknowledgements

Test tones generated from [here](http://www.audiocheck.net/audiocheck_dtmf.php)