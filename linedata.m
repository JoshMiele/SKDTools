function alldata = linedata(lines_h)
%%LINEDATA -- gets data from a line object for passing to brlprep
%% Not intended for casual use.
%%See instead: BPLOT, SKDMENU.

%     By Joshua A. Miele (V1.0 09/01/01)
alldata = [];
for i = 1:length(lines_h)
   xdata = get(lines_h(i), 'xdata');
   ydata = get(lines_h(i), 'ydata');
   linestyle = get(lines_h(i), 'linestyle');
   if ~isempty(findstr(linestyle, '-'))
      if (length(xdata)>5) & (length(xdata)<100)
         interp_factor = ceil(length(xdata)/100);
         data = [interp(xdata', interp_factor, 2), ...
               interp(ydata', interp_factor, 2)];
      elseif (length(xdata)<=5)
         data = [];
         for j = 1:(length(xdata)-1)
            increments = [xdata(j+1)-xdata(j), ydata(j+1)-ydata(j)]/120;
            data = [data; [[xdata(j):increments(1):xdata(j+1)]', ...
                     [ydata(j):increments(2):ydata(j+1)]']];
         end
      else
         data = [xdata', ydata'];
      end
         else
      data = [xdata', ydata'];
   end
   alldata = [alldata; data];
end
