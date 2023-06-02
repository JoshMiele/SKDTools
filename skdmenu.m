function skdmenu()
%SKDMENU uimenu function for SKDtools.
%skdmenu
%Running this function when no figure windows are open adds a menu to the 
%default figure window's menu bar that allows easy embossing and 
%sonification of figure window elements such as lines and axes. 
%
%Typing this command when a figure window is open adds the SKD menu to 
%the current figure's menu bar if it is not already present.
%
%See also: APLOT, BPLOT, FIG2PIX, IMBRL, PIX2BRL.

%     By Joshua A. Miele (V1.0, 09/05/01)

%Add SKD menu to menu bars of new figures
if isempty(get(0, 'children'))     %no figure windows open
   if isempty(findstr(get(0, 'defaultfigurecreatefcn'), 'skdmenu'))
      %add SKD menu to all new figures
      set(0, 'defaultfigurecreatefcn', ...
         [get(0, 'defaultfigurecreatefcn'), ' skdmenu;']);
   end
   return;
end


%A figure window is open
%expose all handles so I can do my evil
def_handle_visibility = get(0, 'showhiddenhandles');
set(0, 'showhiddenhandles', 'on');

if ~isempty(findobj(gcf, 'tag', 'skdmenu'))
   %there is already an SKDmenu, so restore defaults & return
   set(0, 'showhiddenhandles', def_handle_visibility);
   return;
end

   
%create SKD menu
skd_menu_h = uimenu('label', 'S&KDtools', ...
   'tag', 'skdmenu', ...
   'handlevisibility', 'off');
%find out position of Window menu and put SKD menu before it.
window_menu_pos = get(findobj(gcf, 'label', '&Window'), 'position');
%if no Window menu, just put it at the end of the menu bar
if ~isempty(window_menu_pos)
   set(skd_menu_h, 'position', window_menu_pos);
end

%create children of SKD menu
bplot_fig_h = uimenu(skd_menu_h, ...
   'label', 'Emboss &Figure', ...
   'accelerator', 'e', ...
   'position', [1], ...
   'callback', 'pix2brl(fig2pix(gcf));');
bplot_axes_h = uimenu(skd_menu_h, ...
   'label', 'Emboss Current &Axes', ...
   'position', [2], ...
   'callback', 'bplot(gca);');
bplot_obj_h = uimenu(skd_menu_h, ...
   'label', 'Emboss Current Object',  ...
   'position', [3], ...
   'callback', 'bplot(gco);');
aplot_h = uimenu(skd_menu_h, ...
   'label', '&Sonify Current Object', ...
   'accelerator', 'y', ...
   'position', [4], ...
   'callback', 'aplot(gco);');

%restore defaults
set(0, 'showhiddenhandles', def_handle_visibility);