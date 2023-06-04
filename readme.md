# Smith-Kettlewell Display Tools (SKDTools)

Version 1.0
An Auditory/Tactile Data Representation Toolbox
For Matlab r

Originally published in 2001 by Josh Miele

## Contents
* About SKDTools
* Disclaimers
* System Requirements
* Downloading and Installing SKDTools
* Contacting Us 


### About SKDtools

MATLAB is a powerful number-crunching environment from The 
Mathworks, Inc. It has become one of the most popular and 
ubiquitous software tools for scientists and engineers to do 
such tasks as numerical modeling, signal processing, image 
processing, and data analysis. Smith-Kettlewell Display Tools 
(SKDTools) provides blind engineers and scientists with a set 
of Matlab scripts for auditory and tactile data 
representation. For information on Matlab, please visit 
http://www.mathworks.com

SKDTools uses  standard sound hardware and/or a Braille embosser 
capable of producing tactile graphics. The auditory plotter 
uses spatial location and frequency as parameters in 
representing single-valued, two-dimensional plots with a wide 
variety of user-definable parameters. The  
flexible tactile graphics functions can be used to emboss any 
combination of charts, graphs, images or text. 

SKDtools was written by Joshua A. Miele at The Smith-
Kettlewell Eye Research Institute's Rehabilitation Engineering Research 
Center on Low-Vision and Blindness (SKERI RERC) with support from the National Institute for 
Disability and Rehabilitation Research (NIDRR), and was first released in 2001.


### Disclaimers

SKDtools is old code, and even in 2001 it was  a work in progress. We anticipate users will find 
plenty of quirks and bugs. We have tried to make the scripts as 
stable and robust as possible, but you may find situations 
where they do not function as expected. Please submit issues  about any problems you encounter.  
 If you are able to fix the problem yourself, 
please submit a pull request. 

This toolbox does not include any MATLAB tutorial information. 
We assume that the user already has a working knowledge of the 
MATLAB environment. Thus, the beginning user may wish to begin 
by learning some Matlab basics before installing and using 
SKDTools. 

SKDTools is NOT a screen reader. We assume that you already 
have a means of accessing the text of your computer screen. 

### System Requirements

Before downloading and installing SKDTools, please be sure 
that your system satisfies the following requirements
* Sound Blaster-Compatible sound hardware and/or Graphics-capable 
Braille embosser
* MATLAB 6.0 (R12) or later version of MATLAB (Note: Some 
student versions of MATLAB may not be compatible with 
SKDTools)
* MATLAB Signal-Processing Toolbox
* Matlab Image-Processing Toolbox

### Downloading and Installing SKDtools

1. Install MATLAB 6.0 or later and verify that it works 
properly.
TIP: Most people using MS Windows with screen readers or 
magnification software may find it helpful to add the command 
line argument -nodesktop to the MATLAB command line. Without 
this modification you may experience caret-tracking problems 
in the MATLAB Command Window. To do this:
a. After installing MATLAB 6.0, find the shortcut that 
launches the MATLAB application and select it.
b. Press Alt-Plus-Enter to open the properties dialog, then 
select the "Shortcut" tab.
c. Press `TAB' until the "Target:" field is selected and 
press the "END" key.
Type a space, followed by a dash (-), followed by the word 
nodesktop so that the entire target line looks something 
like this:
C:\matlabR12\bin\win32\matlab.exe -nodesktop
1. Download and save the SKDTools.zip archive.
2. Copy the entire contents of this archive to a directory 
under your MATLAB root. For example:
C:\matlab\skdtools
3. Add the SKDTools directory name to your Matlab path. This 
can be done in a number of ways. Perhaps the easiest way 
is to add the command 
addpath c:\matlabr12\skdtools
(or something like it) to your startup.m file. For more information on this 
command, type 
help addpath
at the prompt in the MATLAB command window. You may want 
to restart MATLAB after doing this just to be safe.
4. If you plan to use SKDTools with a Braille embosser to 
produce tactile graphics, edit the brlprefs.m file found 
in your SKDTools directory to reflect the realities of 
your embosser. You may use any standard text editor to do 
this.
5. To get started learning about the various scripts in the 
SKDTools package, type the command 
help SKDtools
at the prompt in the Matlab Command Window. A text file 
called DOCUMENTS.TXT IS ALSO INCLUDED FOR YOUR CONVENIENCE. 
This file simply contains the text of the help information 
found in each of the SKDtools scripts compiled into a single 
file.

### Contacting Us

If you have questions or comments about SKDTools, please reach out to the author, Josh Miele, on Twitter @BerkeleyBlink
