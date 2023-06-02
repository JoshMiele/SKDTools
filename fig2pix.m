function img = fig2pix(fig_h)
%FIG2PIX produces a pixel representation of a Matlab figure.
%PIX = FIG2PIX(H)
%This function produces a pixel representation of a Matlab 
%figure whose handle is contained in H. The size of the 
%representation is determined by the Braille page dims specified 
%in BRLPREFS.M. 
%
%The output variable PIX is suitable for passing to PIX2BRL for embossing.
%
%See also: BRLPREFS, IMBRL, PIX2BRL, SKDMENU, TEXT2BRL.


%     By Joshua A. Miele (V01, 09/05/01)

all_h = [fig_h; findobj(fig_h, 'type', 'uicontrol'); ...
      findobj(fig_h, 'type', 'axes')];
old_units = get(all_h, 'units');
units_cell = cell(size(old_units));
[units_cell{:}] = deal('units');
set(all_h, 'units', 'pixels');

brlprefs;

fig_pos = get(fig_h, 'position');
fig_width = fig_pos(3); fig_height = fig_pos(4);
factor = min(x_max_pix/fig_width, y_max_pix/fig_height);

pix = rect(floor(factor*fig_width), floor(factor*fig_height));
[pix_rows, pix_cols] = size(pix);

for i = 2:length(all_h)
   brl_pos = floor(factor*get(all_h(i), 'position'));
   
   %check for clipped regions and calculate rect extents
%is it clipped on the bottom?
   [pix_row_start, clp_flg] = max([(brl_pos(2)+1), 1]);
   if clp_flg-1
      rect_row_start = abs(brl_pos(2)); 
   else 
      rect_row_start = 1;
   end
%Is it clipped on the top?
   [pix_row_end, clp_flg] = min([sum(brl_pos([2 4])), pix_rows]);
   if clp_flg-1
      rect_row_end = ...
         brl_pos(4)-abs(sum(brl_pos([2 4])) - pix_rows);
   else
      rect_row_end = brl_pos(4);
   end
%is it clipped on the left?
   [pix_col_start, clp_flg] = max([(brl_pos(1)+1), 1]);
   if clp_flg-1
      rect_col_start = abs(brl_pos(1)); 
   else
      rect_col_start = 1;
   end
%is it clipped on the right?
   [pix_col_end, clp_flg] = min([sum(brl_pos([1 3])), pix_cols]);
   if clp_flg-1
      rect_col_end = brl_pos(3)-abs(sum(brl_pos([1 3])) - pix_cols);
   else
      rect_col_end = brl_pos(3);
   end
   rect_width = rect_col_end-rect_col_start+1;
   rect_height = rect_row_end-rect_row_start+1;
   if strcmpi(get(all_h(i), 'type'), 'axes')
      rect_clp = flipud(bplot(all_h(i), [brl_pos(3), brl_pos(4)]));
      rect_clp = rect_clp( rect_row_start:rect_row_end, ...
         rect_col_start:rect_col_end );      
      pix( pix_row_start:pix_row_end, ...
      pix_col_start:pix_col_end ) ...
         = rect_clp;
else
      pix( pix_row_start:pix_row_end, ...
      pix_col_start:pix_col_end ) ...
         = rect(rect_width, rect_height);
end

end
img = flipud(pix);

%restore units
set(all_h, units_cell', old_units');
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function border = rect(x, y);
border = ones(y, x);
border(2:(y-1), 2:(x-1)) = zeros(y-2, x-2);
return