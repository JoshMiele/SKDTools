function out = pix2brl(pix, filename);
%PIX2BRL emboss or return a properly prepared pixel image.
%PIX2BRL(PIX, FILENAME)
%This function turns a properly prepared Braille pixel image into a 
%Braille graphics file and sends it to the currently selected printer. 
%The input argument PIX should contain a matrix whose elements are ones 
%and zeros only. Wherever a matrix element is 1, there will be a dot in 
%the resulting tactile image, and wherever there is a zero, there will be 
%no dot. 
%
%The FILENAME argument allows the user to specify the name of the Braille
%graphics file to which the output should be saved. If no FILENAME 
%argument is specified, the Braille graphics file is not saved.
%
%BRG = PIX2BRL(...) returns a character array that contains the Braille 
%characters that make up the tactile image. If an output argument is 
%specified, the image will not be embossed.
%
%If your Braille embosser is not your default printer, you should select
%your embosser in the Print Setup dialog before embossing with PIX2BRL.
%
%See also: BPLOT, IMBRL, TEXT2BRL.

%     By Joshua A. Miele (V1.5, 11/07/03)

ip_num = '10.10.105.8';
if nargin==1
   filename = tempname;
end

brlprefs;

chrs = brlchars;
binval = [];
for i = 1:size(chrs,2)
	binval(i) = sum(2.^(chrs{2,i}-1));
end
[foo1, order] = sort(binval);
chrs = chrs(:,order);
[r0,c0] = size(pix);
r = ceil(r0/3)*3; c = ceil(c0/2)*2;
img = double(pix);
if (r>r0) | (c>c0), img(r,c) = 0; end
img = reshape(permute(reshape(img, [3, r/3, c]), [1 3 2]), [6, (r*c)/6]);
colnums = mod(find(img), 6);
colnums(colnums==0) = 6;
img(find(img)) = colnums;
img(find(img==0)) = nan;
inds = nansum(2.^(img-1))+1;
inds(isnan(inds)) = 1;
brlprep = reshape(cat(1, chrs{1, inds}), c/2, r/3)';

%manipulate files
if exist(filename)==2
   delete(filename);
end

fid = fopen(filename, 'wt');
fprintf(fid, '%.2s\n', begingraphics);

for i = 1:size(brlprep, 1)
   fprintf(fid, ['%.', num2str(size(brlprep,2)),  's\n'], brlprep(i,:));
end
fprintf(fid, '%.2s\n', endgraphics);
fclose(fid);


if nargout>0
	out = brlprep;
else
%	eval(['!', strrep(printopt, '%s', filename)]);
	eval(['!lpr -S ' ip_num, ' -P auto ', filename]);
end

if nargin > 2
	delete(filename);
end
