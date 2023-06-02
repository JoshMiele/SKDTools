function pix2tgr(img, outfile, opt)
%PIX2TGR produce file printable by Tiger from pixel representation.
%PIX2TGR(IMG, FILESTEM, OPTION)
%IMG is a bitmap containing integers from 0 to 8 indicating various 
%dot heights. 0 is whitespace and 8 is Braille height.
%
%FILESTEM is a base name for the .asc and .prn files that will be 
%created as the output files for embossing. The .asc file has numbers 
%from 0 to 8 in human readable form; the .prn file is readable by the 
%tiger embosser. If FILESTEM is omitted, temp files are used and 
%destroyed after embossing.
%
%OPTION is a string that can be set to "noprint' in which case only 
%files will be produced, but no hardcopy will be embossed.

bin_dir = 'c:\utils\';   %directory where binaries are kept
%ip_num = '192.207.85.31';     %IP address of printer device
ip_num = '10.10.105.8';
ver_num = '2';   %tgradv = 2; cub, pro, etc. = 3
tmpnam1 = tempname;
tmpnam2 = tempname;
if nargin < 3
	opt = 'print';
end

if any(any( (round(img)-img)~=0 ))
	error('Array elements must have integer values.');
elseif any(any( (img>8) | (img<0) ))
	error('Array elements must have values between 0 and 8 (inclusive).');
end

if nargin >= 2
	if ~isstr(outfile)
		error('FILENAME must be a string.');
	else
		tmpnam1 = [outfile '.asc'];
		tmpnam2 = [outfile '.prn'];
	end
end

%write file that ASCII2PRN can understand
%no spaces, int values between 0 and 8, with char(10) as EOL
dlmwrite(tmpnam1, img, '');
	
%hand it off to ViewPlus code
eval(['!', bin_dir, 'ascii2prn -i ', tmpnam1, ' -o ', tmpnam2, ' -v ', ver_num]);
%copy output of ViewPlus code to printer.
if ~strcmpi(opt, 'noprint')
	eval(['!lpr -S ' ip_num, ' -P auto ', tmpnam2]);
end
if nargin<2
	%clean up temp files
	eval(['!del ', tmpnam1, ' ', tmpnam2]);
end