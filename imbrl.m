function varargout = imbrl(filename, threshold, figlabel, crop, dims);
%IMBRL: Emboss image.
%
%IMBRL(IMG, THRESHOLD)
%Converts the image in the variable IMG to a Braille 
%representation and embosses it on the default printer. If  IMG is 
%a file name, then the image in the file specified will be 
%embossed. If the image is a truecolor (RGB) image, then it is 
%converted to gray scale using RGB2GRAY before embossing.
%
%The argument THRESHOLD assigns the gray scale cut-off between 
%black and white (dots and no dots). THRESHOLD can take on values 
%from 1 to 99. If THRESHOLD is omitted, IMBRL uses a default value 
%of 50.
%
%Before embossing or returning, IMBRL analizes the resulting 
%tactile representation to see if dot density is too high. If 
%there are more dots than white space the image is inverted before 
%embossing or returning.
%
%A = imbrl(…)
%If an output argument is specified, the tactile representation is 
%not embossed, but is returned as an m-by-n matrix with ones and 
%zeros representing dots and blank space respectively. This matrix 
%can then be passed as an argument to PIX2BRL for embossing.
%
%IMBRL(IMG, THRESHOLD, TITLE, CROP, DIMS)
%TITLE can be specified as a string. It is converted to Braille 
%using text2brl and is centered at the top of the resulting image. 
%
%CROP is a 2x2 matrix specifying the portion of the image to be 
%embossed or converted. It is of the form 
%     [FROM%DOWN TO%DOWN;
%      FROM%ACRS TO%ACRS]
%
%DIMS is an optional 2-element vector that specifies the size of 
%the output representation. It is of the form [MAX_WIDTH 
%MAX_HEIGHT]Original image proportions are preserved, and the 
%resulting representation is sized to maximize the image 
%dimentions within the specified values of DIMS. If DIMS is 
%unspecified then IMBRL uses values of X_MAX_PIX and Y_MAX_PIX as 
%obtained from BRLPREFS.
%
%Examples:
%
%IMG = imread(‘foo.bmp’);     %read RGB image from disk
%A = IMBRL(IMG)     %represent full image with default threshold 
%and dimentions with no title.
%
%IMBRL(‘foo.bmp’)     %same as above.
%
%IMBRL(‘foo.bmp’, 70, ‘image of foo’, [5 95;5 95], [100 100])
%     %emboss the image contained in file foo.bmp using a 
%     %threshold of 70% with a proper title. Cut off the 5% of the image 
%     %around the edged, and use a maximum pixel dimention of 100 pixels 
%     %in both the x and y dimentions.
%
%See also: BRLPREFS, IMREAD, PIX2BRL, TEXT2BRL.


%     By Joshua A. Miele (V1.0, 09/05/01)

brlprefs;
if exist('dims', 'var')
   x_max_pix = dims(1);
   y_max_pix = dims(2);
end

if ~exist('threshold', 'var')
   threshole = 50;
end

if isstr(filename)
   pict = double(imread(filename));
else
   pict = double(filename);
end

if length(size(pict))==3
   pict = rgb2gray(pict);
end

if exist('figlabel', 'var')
   brllabel = [];
   if ~isempty(figlabel)
      brltext = text2brl(figlabel);
      [bl_row, bl_col] = size(brltext{1});
      y_max_piix = y_max_pix-(bl_row+3);
      brllabel = zeros(bl_row+3, x_max_pix);
      brllabel(1:bl_row, round(x_max_pix/2)+(1:bl_col)) = brltext{1};
   end
else
   brllabel = [];
end
   
[row, col] = size(pict);
if exist('crop', 'var')
   if ~isempty(crop)
      cropind = round( diag([col, row]) * crop/100 );
      pict = pict(cropind(2,1) : cropind(2,2), cropind(1,1) : cropind(1,2) );
      [row, col] = size(pict);
   end
end


if row > col 
    resize = resample(resample( double(pict), y_max_pix, row)', ...
       y_max_pix, row)'; 
else
    resize = resample(resample( double(pict), x_max_pix, col)', ...
       x_max_pix, col)'; 
end

normal = 100 * (resize-min(min(resize))) / (max(max(resize)) - min(min(resize)));

gt = normal>threshold;
lt = normal<threshold;

if sum(sum(gt)) > sum(sum(lt))
   pix = lt;
else
   pix = gt;
end

pix = [brllabel; pix];
   
   
   if nargout == 0
      pix2brl(pix);
   else
      varargout = {pix};
   end
   