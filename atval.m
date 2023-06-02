function sig = atval(x, lengthout, marks, ticktype);
%ATVAL indicate when a curve attains or crosses a specified value.
%ATVAL(X, LENGTHOUT, MARKS, TICKTYPE)
%X is the original input vector passed to APLOT. lengthout is the length of 
%the signal (in bins) that APLOT produced in its representation of X.
%MARKS is the value or vector of values where auditory indicators are
%desired. TICKTYPE can have values of 0, 1, or FILENAME. if (TICKTYPE == 0) 
%then markers are 0.1 second noise bursts. If (TICKTYPE == 1), then 
%markers are 0.1 sec, 1 KHz unramped tones. If (TICKTYPE == FILENAME) then
%ATVAL uses the wav file at the specified location. 
%
%See also: APLOT, SOUND.

%     By Joshua A. Miele (V1.0 09/05/01)

fs = 16384;
duration = 0.01;
bins = round(fs*duration);

if (nargin<4)
   ticktype = 1; end
if (nargin <3)
   marks = 0; end


if (length(marks)>1)
   xmat = ones(length(marks), 1)*x;
   pad = zeros(length(marks),1);
   marksmat = marks'*ones(1,length(x));
   else
   xmat = x;
   pad = 0;
   marksmat = marks;
end;

l = xmat<marksmat;
l1 = [l(:, 2:length(l)), pad];
g = xmat>marksmat;
g1 = [g(:, 2:length(g)), pad];
e = xmat==marksmat;
e1 = [e(:, 2:length(e)), pad];

splaces = (l&g1) | (g&l1) | (e1&~e);
if (length(marks)>1)
   splaces = sum(splaces);
end;

if (ischar(ticktype))
   marker = wavread(ticktype);
   [row, col] = size(marker);
   if (col==2)
      marker = sum(marker')/2;
   end;
%   marker = resample(marker, fs, sfs);
elseif (ticktype==0)
   %noiseburst
   marker =  (1-cos(2*pi*(0:(bins-1))/bins-1)).*(.5-rand(1, bins));
elseif (ticktype==1)
   marker = sin(2*pi*1000*(1:bins)/fs);
end;
binlocs = find(splaces~=0);
places = zeros(1, lengthout);
places(round(binlocs*lengthout/length(x))) = ones(size(binlocs));

unscaled = conv(marker, places);
sig = unscaled(1:lengthout);