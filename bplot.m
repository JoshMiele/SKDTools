function varargout = bplot(varargin);
%BPLOT: Produce tactile image from data or graphics handle.
%
%BPLOT(Y)
%This function will emboss the data in Y on the currently selected 
%Braille embosser. Axes and data limits ar automatically scaled 
%according to the data contained in Y. The size of the output is 
%determined by the settings specified in BRLPREFS. 
%
%If Y is a vector of real values, then the values of each bin are 
%plotted on the Y-axis, versus their bin number on the X-axis. If 
%any element of Y is complex, then the real value of each element 
%is plotted on the X-axis against the imaginary parts on the Y-
%axis. 
%
%If Y is an M-by-2 matrix, then the values of column 1 are treated 
%as X values and the values in column 2 are treated as 
%corresponding Y values. 
%
%If Y is a handle to a graphics object such as a figure, axes, or 
%line, then that object is embossed. Axes and line objects are 
%scaled according to the data limits of the object. 
%
%BPLOT(Y, AXES_LIMS)
%If Y is a vector or matrix, the value of AXES_LIMS controls the 
%scale of the data displayed. AXES_LIMS is of the form:
%     [X_MIN X_MAX Y_MIN Y_MAX]
%
%BPLOT(... FIG_LABEL, X_LABEL, Y_LABEL)
%If the strings FIG_LABEL, X_LABEL, and Y_LABEL are specified, 
%then these strings are converted into Braille and added to the 
%plot. If Y is a graphics handle, then use the commands TITLE, 
%XLABEL, and YLABEL instead before executing BPLOT. 
%
%PIX = BPLOT(...)
%If an output variable is specified, then instead of sending the 
%tactile image to the embosser, the pixel image is returned. This 
%is a matrix each of whose elements will be a dot on the resulting 
%tactile image. Elements with values of 1 represent a dot, and 
%zeros represent blank space. This matrix can be embossed with 
%PIX2BRL.
%
%See also: AXES, BRLPREFS, PIX2BRL, PLOT, TEXT2BRL, TITLE, XLABEL, 
%YLABEL.

%     By Joshua A. Miele (V1.0, 09/05/01)

if nargin ==1
   if all(ishandle(varargin{1}))
      [args, axes_h] = axesinfo(varargin{1});
      [values, scale, fig_label, x_label, y_label] ...
         = deal(args{:});
   else
      values = varargin{1};
   end
   end

if nargin ==2
   %check to see what the second argument is
   if isstr(varargin{2})
      values = varargin{1};
      labels = varargin{2};
   elseif all(ishandle(varargin{1}))
      axes_dims = varargin{2};
      [args, axes_h] = axesinfo(varargin{1});
      [values, scale, fig_label, x_label, y_label] ...
         = deal(args{:});
   else
      [values, scale] = deal(varargin{:});
   end
end

if exist('axes_h', 'var') & isempty(values)
   values = [1;1]*(scale(1,3)-1);
end

if (nargin>2) & ~exist('axes_h', 'var')
   %again, check to see what second variable is
      if isstr(varargin{2})
         values = varargin{1};
         labels = varargin(2:nargin);
      else
         values = varargin{1};
         scale = varargin{2};
         labels = varargin(3:nargin);
      end
   end


if (nargin>5)
   error('Too many arguments...');
end

%determine what values are:
%matrix, vector, or scalor (handle)
sv = size(values);
if ((sv(1)==1) | (sv(2)==1)) & (sv(1)~=sv(2))
   %values is a vector and is not a scalor
   if (sv(2)==1)
      values = values';
   end
   if (~isreal(values))
      yv = imag(values);
      xv = real(values);
   else
      yv = values;
      xv = 1:length(values);
   end
elseif (sv(2)==2)
   %values are an n-by-2 matrix
   xv = real(values(:, 1)');
   yv = real(values(:, 2)');
else
   error('input values must be a vector or an n-by-2 matrix...')
end

%verify that scale is legal and if so do some setup
if exist('scale', 'var')
   if (size(scale)~=[1,4])
      error('SCALE must be of the form [XMIN, XMAX, YMIN, YMAX].');
   elseif ((scale(1)>=scale(2)) | (scale(3)>=scale(4)))
      error('SCALE must be of the form [XMIN, XMAX, YMIN, YMAX].');
   else
      %user has specified a range, so set axes ranges and clip input
      xmin = scale(1); xmax = scale(2);
      ymin = scale(3); ymax = scale(4);
      x_ok = find( (xv>=xmin) & (xv<=xmax));
      xv = xv(x_ok); yv = yv(x_ok);
      y_ok = find( (yv>=ymin) & (yv<=ymax));
      xv = xv(y_ok); yv = yv(y_ok);
   end
else
   %auto-scale axes to fit entire input set
   xmin = min(xv); xmax = max(xv);
   ymin = min(yv); ymax = max(yv);
end

   
%distribute labels to variables
if exist('labels', 'var')
   if length(labels) == 1
      fig_label =labels{1};
   elseif length(labels) == 2
      [fig_label, x_label] = deal(labels{:});
   elseif length(labels) == 3
      [fig_label, x_label, y_label] = deal(labels{:});
   else
      error('Too many labels.');
   end
end

%read in embosser prefs
brlprefs;

%Xcale units and build axes
if ~exist('axes_h', 'var')
   %perform axes calculations for units and sizing
   % find xy range
   xr = xmax-xmin; yr = ymax-ymin;
   %for calculating axis units
   x_magnitude = floor(log10( xr./total_x_units)) ;
   y_magnitude = floor(log10( yr./total_y_units));
   %This stupid num2str and back again is to get rid of strange residuals
   %size of each unit in terms of data (scalor)
   x_units = str2num(num2str( ...
       (10^x_magnitude) * ceil( (10^-x_magnitude)*(xr/total_x_units)) ));
   y_units = str2num(num2str( ...
       (10^y_magnitude) * ceil( (10^-y_magnitude)*(yr/total_y_units)) ));
   %locations of x-axis ticks (vector)
   x_tix = (xmin -mod(xmin, x_units)) ...
       : x_units : (xmin + total_x_units *x_units);
   y_tix = (ymin -mod(ymin, y_units)) ...
       : y_units :  (ymin + total_y_units * y_units);
   %another attempt to get rid of residuals...
   xzl = find(abs(x_tix)<1e-14);
   yzl = find(abs(y_tix)<1e-14);
   x_tix(xzl) = zeros(size(xzl));
   y_tix(yzl) = zeros(size(yzl));
   %creat tick labels
   xtl = text2brl(num2str(x_tix'));
   ytl = text2brl(num2str(y_tix'));
else
   %data comes from handle
   if exist('axes_dims', 'var')
      %overwrite embosser prefs for size of axes
      x_max_pix = axes_dims(1); y_max_pix = axes_dims(2);
   end
   x_tix = get(axes_h, 'xtick');
   y_tix = get(axes_h, 'ytick');
   %creat tick labels
   xtl = text2brl(num2str(x_tix'));
   ytl = text2brl(num2str(y_tix'));
   %calculate padding required for figure label
   if exist('fig_label', 'var')
      title_width = 4;
   else
      title_width = 0;
   end
   %calculate padding required for x tick labels
   if ~exist('x_label', 'var')
      x_axis_width = 8;
   else
      x_axis_width = 13;
   end
   %calculate padding needed for y tick labels
   y_axis_width = 4 + max([length(ytl{1}), length(xtl{1})]);
   x_units = abs(x_tix(1)-x_tix(2));
   y_units = abs(y_tix(1)-y_tix(2));
   x_unit_size = floor((x_max_pix-y_axis_width) / (length(x_tix)-1));
   y_unit_size = floor((y_max_pix-x_axis_width-title_width) / (length(y_tix)-1));
end

%calculate x_axis pixel locations
if ~exist('x_label', 'var')
   x_axis_width = 8;
else
   x_axis_width = 13;
end

%tick locations in brl pixel space
y_axis_width = 4 + max([length(ytl{1}), length(xtl{1})]);
x_axis_x_lox = y_axis_width +round( (x_unit_size / x_units) *(x_tix-min(x_tix)));
x_label_lox = x_axis_x_lox;   %used later for text label placement 
x_axis_y_lox = (x_axis_width-2)* ones(size(x_axis_x_lox));
x_axis_x_lox = [(y_axis_width: max(x_axis_x_lox)), x_axis_x_lox];
x_axis_y_lox = [(x_axis_width-1) ...
      *ones(size(y_axis_width:max(x_label_lox))), x_axis_y_lox];
%calculate y_axis pixel locations
y_axis_y_lox = x_axis_width +round( (y_unit_size / y_units) *(y_tix-min(y_tix)));
y_label_lox = y_axis_y_lox;   %used later for placing text labels
y_axis_x_lox = (y_axis_width-2) * ones(size(y_axis_y_lox));
y_axis_y_lox = [y_axis_y_lox, (x_axis_width:max(y_axis_y_lox))];
y_axis_x_lox = [y_axis_x_lox, (y_axis_width-1)*ones(size(x_axis_width:max(y_label_lox)))];

%convert input values to matrix pixel space
x = y_axis_width+round( (x_unit_size / x_units) *(xv-min(x_tix)));
y = x_axis_width +round((y_unit_size/y_units)*(yv-min(y_tix)));

%eliminate undesired points
x_ok = find(x<=x_max_pix);
x = x(x_ok); y = y(x_ok);
y_ok = find(y<=y_max_pix);
y = y(y_ok); x = x(y_ok);


%concatenate data and axes vectors
x = [x, y_axis_x_lox, x_axis_x_lox];
y = [y, y_axis_y_lox, x_axis_y_lox];

%get values for properly sizing pix matrix
row = 3*ceil(max(y)/3);
col = 2*ceil(max(x)/2);
figpix = sparse(y,x,ones(size(x)));
figpix(find(figpix)) = ones(size(find(figpix))); 
figpix(y_max_pix,x_max_pix) = 0;


%put numbers on y_axis
if y_unit_size < (size(ytl{1},1)+1)
   step = ceil( (size(ytl{1},1)+1) / y_unit_size);
else
   step = 1;
end
   for i = 1:step:length(ytl)
   len = size(ytl{i},2);
   figpix((y_label_lox(i)-1) : (y_label_lox(i)+1), 1:len) = flipud(ytl{i});;
end

%put numbers on x_axis
if size(xtl{1}, 2) > x_unit_size*length(x_tix)/2
   step = [length(x_label_lox), 1];
else
   step = [length(x_label_lox), round(median(1:length(x_label_lox))), 1];
end


   for i = step
      [lr, lc] = size(xtl{i});
      startrow = x_axis_width-3-lr;
   figpix( startrow : (startrow+lr-1), ...
      (x_label_lox(i)-lc+1):x_label_lox(i)) = flipud(xtl{i});
   end
   
%insert figure label if needed
if exist('fig_label', 'var')
   if ~isempty(fig_label)
   tempcell = text2brl(fig_label);
   brl_fig_label = tempcell{1};
   [lr, lc] = size(brl_fig_label);
   startcol = ceil( (col-y_axis_width-lc)/2);
   startrow = max(y_label_lox)+2;
   figpix( startrow : (startrow+lr-1), startcol: (startcol+lc-1) ) = flipud(brl_fig_label);
end; end
   
%insert x_label if needed
if exist('x_label', 'var'), if ~isempty(x_label)
   tempcell = text2brl(x_label);
   brl_x_label = tempcell{1};
   [lr, lc] = size(brl_x_label);
   startcol = ceil( (col-lc)/2);
   figpix( 1:lr, startcol: (startcol+lc-1) ) = flipud(brl_x_label);
end; end

%insert y_label if needed
if exist('y_label', 'var'), if ~isempty(y_label)
   tempcell = text2brl(y_label);
   brl_y_label = tempcell{1};
   [lr, lc] = size(brl_y_label);
   startrow = max(y_label_lox)+2;
   figpix(  startrow : (startrow+lr-1), 1:lc) = flipud(brl_y_label);
end; end
   
     
allpix = flipud(figpix);
   
   %decide what to do about output
   if nargout==0
      pix2brl(allpix);
else
      varargout{1} = allpix;
end
   
   