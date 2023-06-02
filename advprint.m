function img = advprint(x, sp)
%ADVPRINT: formats text to be embossed by Tiger Advantage
%pix = advprint(x)
%X can be a file name, a cell array of strings or a character array.
%input is converted into a pixel representation of Braille appropriately 
%spaced for a Tiger Advantage.
%Use pix2tgr to emboss eht output.

if nargin <2
	%default spacing is for tiger.
	sp = 2;
end

if iscell(x)
	s = x;
elseif (isstr(x) & (size(x,1)==1) )
	fid = fopen(x,'r');
	if fid<0
		error(['Cannot find file ', x]); 
	end
	s = {};
	while ~feof(fid)
		s{end+1} = fgetl(fid);
	end
	fclose(fid);
elseif (isstr(x) & size(x,1)>1)
	s = cellstr(x);
end

b = text2brl(strvcat(s), sp);
c = cell(2*length(b)-1,1);
[c{2:2:end}] = deal(zeros( ceil(size(b{1}).*[.5,1]) ));
[c{1:2:end}] = deal(b{:});
img = 8*cat(1, c{:});
