function [varargout] = aplot(varargin);
%APLOT Auditory Display Function
%APLOT(X, Y, DUR [SEC], UNITS, INTERVAL, F0, TP)
%
%The X-axis is represented by the spatial location of the output 
%signal in left-right space, and the Y-axis is represented by 
%pitch, either as discrete tones or as a continuous tone that 
%changes smoothly. If no output variables are specified, APLOT 
%plays its output through the speakers attached to the workstation 
%via SOUND. For example, APLOT(SIN(0:.01:6*PI)) results in three 
%periods	 of a sine wave being represented. If an input value 
%corresponds to a frequency that is too high or low for APLOT to 
%represent, an off-scale indicator is heard. High- and low-pass 
%filtered noise indicate input values that are too large or too 
%small respectively. All values can be represented by properly 
%adjusting UNITS and/or INTERVAL (see below). Whenever the input 
%values crosses zero (an X-intercept) a brief noise burst is heard. 
%This serves as an anchor so that the user knows when the display 
%has changed sign. 
%
%APLOT(Y)
%If Y is a row vector the values of Y are plotted as Y values and 
%bin indices are interpreted as X values. If Y is an N-by-2 matrix, 
%bins in column 1 are treated as X values and bins in column 2 are 
%treated as corresponding Y values. If Y is a row vector of complex 
%values, the real parts are treated as X values and the imaginary 
%parts are treated as corresponding Y values. In the latter two 
%cases, a sepparate X argument is not permitted.
%
%APLOT(X, Y)
%If X and Y are row vectors of the same length  then each bin of 
%vector X is interpreted as an X value for the corresponding bin in 
%vector Y. If a sepparate Y argument is specified, then X must be a 
%row vector. If X and Y are both specified then any imaginary 
%componants are discarded.
%
%APLOT(X, y, DUR)
%DUR specifies how long the display should last IN SECONDS. Thus, 
%APLOT(Y, 8) will play a representation of the data in vector Y, as 
%a function of index, that lasts for approximately 8 seconds. If 
%DUR is omitted, (e.g. APLOT(Y)), DUR defaults to a value of 5 
%seconds. 
%
%APLOT(X, y, DUR, UNITS)
% UNITS allows the Y-axis (pitch) to be scaled to the desired 
%number of units per interval. THIS is analogous to grid lines on 
%graph paper. Thus, if APLOT receives a UNITS value of 0.2, each 
%unit of input data will consist of 5 intervals; if UNITS is set to 
%1, each unit of input corresponds to a single interval step.
%
%EXAMPLE: 
%APLOT(SIN(0:.01:6*PI), 5, 0.5) 
%includes tones at -1, -0.5, 0, 0.5, and 1. When input values are 
%between unit tones, a linearly weighted sum of the two adjacent 
%tones is used. If UNITS is set to 0, the display self-scales, such 
%that the input data utilizes the entire display space. When self-
%scaling the minimum and maximum input values are automatically 
%mapped to the minimum  and  maximum output frequencies 
%respectively. Self-scaling is most useful for getting a 
%qualitative sense of the shape of an unfamiliar dataset. 
%
%APLOT(X, Y, DUR, UNITS, INTERVAL)
%INTERVAL determines the distance between consecutive tones in the 
%discrete display by specifying the number of intervals per octave. 
%Thus, as the value of INTERVAL increases, the pitch difference 
%between consecutive tones decreases. For example, an INTERVAL 
%value of 2 corresponds to half-octave steps, a value of 3 
%corresponds to one third octave steps, a value of 4 corresponds to 
%one fourth octave steps, etc. If INTERVAL is omitted, it defaults 
%to a value of 4 (musical types will recognize this as a minor 
%third). If INTERVAL is set to 1 negative number, then the display becomes
%continuous rather than discrete. Instead of individual tones that fade 
%from one to the next, the continuous display uses a single tone that 
%changes smoothly without steps. In this mode, each unit on the display 
%corresponds to intervals of (a/abs(INTERVAL)) of an octave. 
%
%EXAMPLE:
% APLOT(SIN(0:.01:6*PI), 5, 1, -4) produces a continuous 
%representation of a three period sine wave whose amplitude is 1/2 
%octave peak-to-peak. 
%APLOT(SIN(0:.01:6*PI), 5, 0.5, -4)
%Produces the same figure, but the amplitude is reduced to one 
%quarter octave peak-to-peak.
%
%APLOT(X, y, DUR, UNITS, INTERVAL, F0)
%F0 specifies the frequency that corresponds to a value of zero in 
%the input. If omitted, F0 defaults to 500 Hz. 
%
%APLOT(X, y, DUR, UNITS, INTERVAL, F0, TP)
%TP specifies the tick placement for X-axis indicators. You must 
%specify each value at which a tick is to be located. For example, 
%if Y is a row vector, and is therefore plotted with respect to bin 
%number, TP specifies a set of bin numbers at which ticks will be 
%placed. If both X and Y values are specifieds, then values in 
%vector TP specify values of X for which ticks will be heard in the 
%output. If omitted, TP defaults to an inactive state.  
%
%EXAMPLE:
%Z = 0:.01:10;
%APLOT(Z, 5, 1, 4, 500, [100:100:LENGTH(Z)])
%Produces an auditory plot of the linear values in Z with ticks 
%every 100 bins.
%APLOT(COS(Z), SIN(Z), 5, .2, 4, 500, [-1:.5:1])
%Produces a circular plot with ticks at -1, -.5, 0, .5, and 1.
%
% SIG = APLOT(...);
%sets SIG to an N-by-2 matrix containing the output of APLOT that 
%is normally be played by calling APLOT. SIG contains values 
%between -1 and 1 and can be played with SOUND at a sampling rate 
%of 16384 bins/sec. For example, 
%
%SIG = APLOT(SIN(0:.01:6*PI));
%SOUND(SIG, 16384)
%
%Is equivalent to: 
%APLOT((SIN(0:.01:6*PI))
%
%This is useful when APLOT takes a long time to generate a sound 
%that you wish to play repeatedly.
%
%[SIG, X_CROSSINGS, TICKS, LOCATIONS] = APLOT(X, Y, DUR, UNITS, 
%INTERVAL, F0, TP);
%
%This allows X_CROSSINGS and TICKS to be manipulated independently 
%from the display trace itself. When multiple output arguments are 
%specified, SIG is a vector contains only the tones of the display 
%without the noise bursts indicating zero crossings, or the ticks 
%produced when TP is specified. Similarly, X_CROSSINGS is a vector 
%containing only the noise bursts of the X-intercepts, and TICKS is 
%a vector containing only the clicks produced when TP is specified. 
%X_CROSSINGS and TICKS are contain values between -1 and 1, and can 
%be played with SOUND at a sampling rate of 16384 bins/sec. 
%LOCATIONS is an N-by-2 matrix that contains the stereo amplitude 
%envelope used to "move" the display horizontally.  Thus,
%
%[SIG, X_CROSSINGS, TICKS, LOCATIONS] = APLOT(SIN(0:.01,6*PI), 10, 
%.2, 4, -1:.5:1);
%SOUND( ([1;1]*(SIG + X_CROSSINGS + TICKS))' .* LOCATIONS, 16384)
%
%Is equivalent to:
%APLOT(SIN(0:.01:6*PI), 10, .2, 4, -1:.5:1)
%
%See also ATVAL, SOUND.

%     By Joshua A. Miele (V1.0 07/18/01)

%set default values
fs = 16384;
def_dur = 5;
def_n = 1;
def_interval = 4;
def_tonic = 500;


%organize input arguments
l = length(varargin);
if ( (l>=2) & (length(varargin{2})>1) )   
   %y exists and there are multiple input arguments
   
   if (l==7)
      [x, y, dur, n, interval, tonic, tp] = deal(varargin{:});
   elseif (l == 6)
      [x, y, dur, n, interval, tonic] = deal(varargin{:});
   elseif (l == 5)
      [x, y, dur, n, interval] = deal(varargin{:});
      tonic = def_tonic;
   elseif (l == 4)
      [x, y, dur, n] = deal(varargin{:});
      tonic = def_tonic;
      interval = def_interval;
   elseif (l == 3)
      [x, y, dur] = deal(varargin{:});
      tonic = def_tonic;
      interval = def_interval;
      n = def_n;
   else 
      [x, y] = deal(varargin{:});
      tonic = def_tonic;
      interval = def_interval;
      n = def_n;
      dur = def_dur;
   end
   
   %verify proper size of x and y
   if ((size(x) ~= size(y)) | (size(x, 1)~=1))
      error('X and Y must be row vectors of the same length.');
   end
   
else
   %y does not exist     
   if (l>=6)
      [x, dur, n, interval, tonic, tp] = deal(varargin{:});
   elseif (l == 5)
      [x, dur, n, interval, tonic] = deal(varargin{:});
   elseif (l == 4)
      [x, dur, n, interval] = deal(varargin{:});
      tonic = def_tonic;
   elseif (l == 3)
      [x, dur, n] = deal(varargin{:});
      tonic = def_tonic;
      interval = def_interval;
   elseif (l == 2)
      [x, dur] = deal(varargin{:});
      tonic = def_tonic;
      interval = def_interval;
      n = def_n;
   else 
      [x] = deal(varargin{:});
      tonic = def_tonic;
      interval = def_interval;
      n = def_n;
      dur = def_dur;
   end
   
   %check if x is array or vector
   [r, c] = size(x);
     %check on size of input vectors...
  if (r>1000000)|(c>1000000)
     error('Input vector is too large.');
  end

if (length(size(x))>2) | ((r>=2)&(c>2)) | ((c==1) & (r>1))
   error('X must be a 1-by-N or N-by-2 array.')
    elseif (c == 2) & (r>1)
      y = x(:, 2)';
      x = x(:, 1)';
   elseif (r*c==1)&ishandle(x)
      if ~strcmpi(get(x, 'type'), 'line')
         error('APLOT can only represent objects of type LINE.');
      else
         %is a line object so setup for that
         line_h = x;
         axes_h = get(line_h, 'parent');
         x = get(line_h, 'xdata');
         y = get(line_h, 'ydata');
         n = min(diff(get(axes_h, 'ytick')));
      end
   elseif (r == 1) 
      if  (isreal(x))         
         y = x;
         x = 1:length(x);
   elseif (~isreal(x))
      y = imag(x);
      x = real(x);
   end
   else
      error('Unhandled case of X...');
   end
  end
  
  
  %remove infinite datapoints
x = x(find(~isinf(y)));
y = y(find(~isinf(y)));

%Adjust vertical scale to fit display range if n is 0;
if (n == 0)
   if (interval<0)
      int = abs(interval);
   else
      int = interval;
   end
   vscale = ((y-min(y)) / max(y-min(y))) ...
      *floor( log( ((fs/2)-400)/tonic)*int/log(2));
   zmark = (-min(y)/max(y-min(y))) ...
      * floor( log( ((fs/2)-400)/tonic)*int/log(2))
else
	%set vertical scale to n units/tones witn zero at tonic;
	vscale = y/n;
   zmark = 0;
end

%Adjust length of x and y to proper duration
p = round(fs*dur);
q = length(vscale);
if p>q
   %interpolate
   rc = 10^floor(log10(q)-1);
else
   rc = 10^floor(log10(p)-1);
end;

if rc<1
   rc=1;
end


resamp = resample([x', vscale'], round(p/rc), round(q/rc), 0);

%remove tails resulting from resampling
firstbin = min(find(resamp(:,2)==vscale(1)));
lastbin = max(find(resamp(:,2)==vscale(end)));

tvscale = resamp(:, 2)';
thscale = resamp(:,1)';


%distinguish between discrete and continuous;
if (interval>0)
   %make display discrete
   %round tvscale to even and odd integers;
   harms = [(round( (tvscale-1)/2)*2)+1; round(tvscale/2)*2];
   frqs =  tonic * exp( (log(2)/interval)* harms);
   %make amplitude 0 when frq changes to next odd or even val
   amp = (1 - abs([tvscale; tvscale] - harms));
else
   %make display continuous
   frqs =  tonic * exp( (log(2)/abs(interval))* [tvscale; tvscale] );
   amp = ones(size(frqs));   
end

%Mark out-of-bounds.
maxfrq = (fs/2)-200;
minfrq = 200;
toohigh = find(frqs>maxfrq);
toolow = find(frqs<minfrq);
frqs(toohigh) = .32*fs*rand(1, length(toohigh));
frqs(toolow) =  .08*fs*rand(1, length(toolow));

tones = sum( (amp) .* sin(2*pi*cumsum(frqs')'/fs));

%generate markers if desired
x_crossings = atval(vscale, length(tvscale), zmark, 0);
if (exist('tp')==1)
   tix = atval(x, length(thscale), tp, 1);
else
  	tix = zeros(size(thscale));
end

%scale x values to center display
thscale = (-1 + 2*(thscale-min(thscale))/max(thscale-min(thscale)));

%generate placement look-up table
linatten = (1 ./ (2.^(.01:.01:6)) );  %linear attenuation in dB
env = [zeros(size(linatten)), sin( (pi/2)*(0:.005:1) ).^2, linatten]; 
plut = [env; fliplr(env)];
locations = plut(:, round((length(plut)/2) +100 * thscale ));

%do some clipping to avoid interpolation errors ad beginning and end
bins = firstbin:lastbin;
locations = locations(:,bins);
tones = tones(bins);
x_crossings = x_crossings(bins);
tix = tix(bins);

%evaluate output situation
  total = tones + x_crossings + tix;
   sig = (locations.* ([1;1]*total)/max(abs(total)))';
if (nargout==0)
     sound(fliplr(sig), fs);
  elseif (nargout==1)
    		varargout(1) = {sig};
  elseif (nargout==2)
     varargout(1) = {(locations .* ([1;1]*tones))'/abs(max(tones))};
     varargout(2) = {x_crossings'};
  elseif (nargout==3)
     varargout(1) = {(locations .* ([1;1]*tones))'/abs(max(tones))};
     varargout(2) = {x_crossings};
     varargout(3) = {tix};
  elseif (nargout==4)
     varargout(1) = {tones};
     varargout(2) = {x_crossings};
     varargout(3) = {tix};
     varargout(4) = {locations'};
end
                         