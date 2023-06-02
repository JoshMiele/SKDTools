function c = brltrans(s, grade);
%BRLTRANS wrapper function for Braille translator
%out = brltrans(in, grade)
%OUT is a cell array containing the translated strings contained in IN.
%IN can be either a cell array or a character array.
%GRADE is an integer from 1 to 3 indicating the level of Braille 
%translation desired. If GRADE is omitteed, GRADE defaults to a value 
%of 2.



if nargin ==1 
	grade = 2;
end

if (nargin == 2) & isstr(grade)
	grade = str2num(grade);
end
	
if ~any(grade == 1:3)
	error('GRADE can only have values of 1, 2, or 3.');
end

gradestring = {'~o'; ['~u ~-pw=80 ~', int2str(grade)]};
nl = ['~_']; 
if ~iscell(s), s = cellstr(s); end
siz = size(s);
s = reshape(s, prod(siz), 1);
s = [gradestring; s];
fs = filesep;
exe = fullfile(setdirs('bin'), ['nfbtrans', fs, 'nfbtrans']);

tn = tempname;
perm = 'w';
if ispc, perm = [perm, 't']; end
fid = fopen([tn,'.txt'], perm);
fprintf(fid, ['%s\n'], s{:});
fclose(fid);
eval(['!', exe, ' <', tn, '.txt' ' >', tn, '.brl']);
c = {};
perm = 'r';
if ispc, perm = [perm, 't']; end
fid = fopen([tn, '.brl'], perm);
while ~feof(fid)
	l = fliplr(deblank(fliplr(fgetl(fid))));
	if ~isempty(l), c{end+1} = l; end;
end
fclose(fid);
%if isempty(c(end)), c = c(1:(end-1)); end
c = reshape(c, siz);