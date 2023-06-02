function pixout = text2brl(ts, s)
%TEXT2BRL Converts ASCII to a pixel representation of Braille.
%PIX = TEXT2BRL(STRING, SPACING)
%Produces a cell array containing pixel representations of the ASCII 
%strings contained in the input variable STRING. The number of elements 
%in the output cell array corresponds to the number of rows in the input 
%STRING matrix. 
%
%The SPACING argument specifies the distance between dots and characters.
%If omitted, SPACING defaults to a value of 1. (no blank pixels between
%intra-character dots). This results in a 3x3 pixel character. 
%A SPACING value of 2 results in a 5x5 character, etc.
%
%The output variable PIX contains a pixel representation of Braille
%characters suitable for use with images produced with BRLPREP, FIG2PIX, 
%and IMBRL. It is ideal for adding Braille labels to tactile graphics.
%
%Example:
% p = ones(40); p(2:39, 2:39) = zeros(38);
%     %make a square border
%brl_label = text2brl(',box #a4');
%     %convert ASCII to Braille pixels
%[r, c] = size(brl_label{1});   %how big is the Braille label?
%p( round( (40-r)/2 )+(1:r), round( (40-c)/2 )+(1:c) ) = brl_label{1};
%     %add label to center of box
%pix2brl(p)     %emboss the resulting image
%
%See also: BRLPREP, FIG2PIX, IMBRL, NUM2STR, and PIX2BRL.

%     By Joshua A. Miele -- (V1.5, 11/07/03)
if nargin ==1
   s = 1;
end

fixchars = {'|', '\'};
for i = 1:size(fixchars, 1)
	ts(fixchars{i,1}==ts) = fixchars{i,2};
end

dotmap = [1:s:((2*s)+1), (s*((2*s)+1)+1):s:(2*(s^2)+3*s+1)];
cellsize = (2*s)+1;

chars = brlchars;
pixout = cell(0);
for y = 1:size(ts,1)
   pix = [];
   for x = double(upper(ts(y,:)))-31
   chardots = zeros(cellsize);
   dotnums = chars{2,x};
   chardots( dotmap(dotnums) ) = ones(1, length(dotnums));
   pix = [pix,  chardots];
end
pixout{y} = pix;
end