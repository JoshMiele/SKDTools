function varargout = axesinfo(obj_h)
%% AXESINFO obtains specific info from axes objects for passing to FIG2BRL.
%% Not intended for casual use.
%% See instead: BPLOT.

%     By Joshua A. Miele (V1.0 09/01/01)
if ~all(ishandle(obj_h))
   error('One or more elements of input is not a valid handle.');
end

if iscell(obj_h)
   error('AXESINFO is not defined for class CELL');
end

axes_flag = 0;
parents = [];
lines_h = [];
for i = 1:length(obj_h)
   cobj= obj_h(i);
   obj_type = get(cobj, 'type');
   switch obj_type
   case 'axes'
            axes_flag = axes_flag+1;
      axes_h = cobj;
   case 'line'
      parents = [parents, get(cobj, 'parent')];
      lines_h = [lines_h, cobj];
   otherwise
      error(['AXESINFO unable to handle objects of type ', obj_type]);
   end
end

if axes_flag==0
   if isempty(parents), 
      error('No valid axes found.');
   end
   if all(parents==parents(1))
      axes_h = parents(1);
   else
      error('All objects must be children of the same axes.');
   end
elseif axes_flag==1 & ~isempty(parents), 
   if ~all(parents==axes_h)
      error('All objects must be children of the same axes.');
   end
elseif (axes_flag==1) & isempty(parents)
   lines_h = findobj(axes_h, 'type', 'line');
else
   error('Found multiple axes handles in input vector.');
end

alldata = linedata(lines_h);

%find data limits
scale = [get(axes_h, 'xlim'), ...
      get(axes_h, 'ylim')];

text_h = get(axes_h, {'title', 'xlabel', 'ylabel'});
for i = 1:length(text_h)
   labels{i} = get(text_h{i}, 'string');
end

if nargout>=0
   varargout{1} = {alldata, scale, labels{:}};
end

if nargout>=2
   varargout{2} = axes_h;
end
