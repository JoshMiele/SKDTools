%Edit this file to reflect the reality of your embosser and your desires 
%regarding axes and text labels. 

%number of dots per unit
%this effects the physical size of units on each axis

x_unit_size = 9;
y_unit_size = 9;
%number of units on an axis
%Each axis will always have the specified number of units
total_x_units = 10;
total_y_units = 10;
%size of paper in pixels
x_max_pix = 120;
y_max_pix = 120;

%text size
%options are  'normal' and 'large'
brl_size = 'normal';

%special characters for your particular embosser to enter and exit graphics mode
%begingraphics =[char(27) '1'];       %Enabling Tech low-res graphics
%begingraphics = [char(27) '6']; %Enabling Tech high-res 
%endgraphics = [char(27), ']'];  %Enabling Tech. 
%endgraphics = [char(27), '0'];     %Index end graphics
%endgraphics = char(12);     %just a formfeed