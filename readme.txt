Smith-Kettlewell Display Tools (SKDtools)
Version 1.0
An Auditory/Tactile Data Representation Toolbox
For Matlab r


*Contents
About SKDtools
Disclaimers
System Requirements
Downloading and Installing SKDtools
Contacting Us 


*About SKDtools

Matlab is a powerful number-crunching environment from The 
Mathworks, Inc. It has become one of the most popular and 
ubiquitous software tools for scientists and engineers to do 
such tasks as numerical modeling, signal processing, image 
processing, and data analysis. Smith-Kettlewell Display Tools 
(SKDtools) provides blind engineers and scientists with a set 
of Matlab scripts for auditory and tactile data 
representation. For information on Matlab, please visit 
http://www.mathworks.com

SKDtools uses a standard sound card and/or a Braille embosser 
capable of producing tactile graphics. The auditory plotter 
uses spatial location and frequency as parameters in 
representing single-valued, two-dimensional plots with a wide 
variety of user-definable parameters. The extraordinarily 
flexible tactile graphics functions can be used to emboss any 
combination of charts, graphs, images or text. 

SKDtools was written by Joshua A. Miele at the Smith-
Kettlewell Institute's Rehabilitation Engineering Research 
Center (SKI RERC) with support from the National Institute for 
Disability and Rehabilitation Research (NIDRR).


*Disclaimers

SKDtools is a work in progress. We anticipate users will find 
some quirks and bugs. We have tried to make the scripts as 
stable and robust as possible, but you may find situations 
where they do not function as expected. Please contact us and 
tell us about any problems you encounter so that we can fix them 
for other users. If you are able to fix the problem yourself, 
please send us the modified code so we can include it in 
future releases. 

This toolbox does not include any Matlab tutorial information. 
We assume that the user already has a working knowledge of the 
Matlab environment. Thus, the beginning user may wish to begin 
by learning some Matlab basics before installing and using 
SKDtools. 

SKDtools is NOT a screen reader. We assume that you already 
have a means of accessing the text of your computer screen. 

*System Requirements

Before downloading and installing SKDtools, please be sure 
that your system satisfies the following requirements
-Sound Blaster-Compatible sound card and/or Graphics-capable 
Braille embosser
-Matlab 6.0 (R12) or later version of Matlab (Note: Some 
student versions of Matlab may not be compatible with 
SKDtools)
-Matlab Signal-Processing Toolbox
-Matlab Image-Processing Toolbox

*Downloading and Installing SKDtools

1. Install Matlab 6.0 or later and verify that it works 
properly.
TIP: Most people using MS Windows with screen readers or 
magnification software may find it helpful to add the command 
line argument -nodesktop to the Matlab command line. Without 
this modification you may experience caret-tracking problems 
in the Matlab Command Window. To do this:
a. After installing Matlab 6.0, find the shortcut that 
launches the Matlab application and select it.
b. Press Alt-Plus-Enter to open the properties dialog, then 
select the "Shortcut" tab.
c. Press `TAB' until the "Target:" field is selected and 
press the "END" key.
Type a space, followed by a dash (-), followed by the word 
nodesktop so that the entire target line looks something 
like this:
C:\matlabR12\bin\win32\matlab.exe -nodesktop
1. Download and save the SKDtools.zip archive.
2. Copy the entire contents of this archive to a directory 
under your Matlab root. For example:
C:\matlab\skdtools
3. Add the SKDtools directory name to your Matlab path. This 
can be done in a number of ways. Perhaps the easiest way 
is to add the command 
addpath c:\matlabr12\skdtools
to your startup.m file. For more information on this 
command, type 
help addpath
at the prompt in the Matlab command window. You may want 
to restart Matlab after doing this just to be safe.
4. If you plan to use SKDtools with a Braille embosser to 
produce tactile graphics, edit the brlprefs.m file found 
in your SKDtools directory to reflect the realities of 
your embosser. You may use any standard text editor to do 
this.
5. To get started learning about the various scripts in the 
SKDtools package, type the command 
help SKDtools
at the prompt in the Matlab Command Window. A text file 
called DOCUMENTS.TXT IS ALSO INCLUDED FOR YOUR CONVENIENCE. 
This file simply contains the text of the help information 
found in each of the SKDtools scripts compiled into a single 
file.

*Contacting Us

If you have questions or comments about SKDtools, please 
contact the author, Joshua A. Miele, at 
jam@socrates.berkeley.edu
