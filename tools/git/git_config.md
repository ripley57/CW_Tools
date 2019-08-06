# git config  

"git config" lets you get and set configuration variables that control how Git operates. 

These variables can be stored in three different places:

1)  /etc/gitconfig (On Windows: C:\Program Files\Git\mingw64\etc\gitconfig)  
Use "git config --system" to target this file.  
Applies to every user on the system and all their repositories.  

2) ~/.gitconfig (On Windows: C:\Users\jcdc\.gitconfig)  
Use "git config --global" to target this file.  
Applies to your specific user.  

3) .git/config (in each repository)  
Values in this file trump those in /etc/gitconfig.

Example: Change the email address, but just for the current repository:
git config --local user.email bob@smith.com 
("--local" is actually the default, so it's not really needed here)
To confirm the change:
git config --local user.email
bob@smith.com


To see the current settings:  
`git config [--system|--global] --list`

__NOTE__: Running "git config --list" will usually show the same values multiple times (from each different location). The last value displayed is the one that will be used. 

You can also query an individual value, e.g.:  
`git config user.name`


user.name & user.email
======================
Every Git commit 'bakes' this information into your commits, e.g.:  
`git config --global user.name "John Doe"`  
`git config --global user.email "johndoe@example.com"`  
Note (from above): Remove the "--global" if you want to override these values for a specific repository.

core.editor
===========
git config --global core.editor emacs
NOTE: "git commit -v" will pre-populate your editor with the code change to be committed,
       but it will be below a special marker line, so it won't be included in the message.
       This is useful if you need to see the changes in order to write your commit comment.

core.autocrlf
=============
Windows uses both a carriage-return character and a linefeed character for newlines, whereas Mac and Linux 
use only the linefeed character. The reason for the "git config" option "core.autocrlf" is that many editors 
on Windows silently replace existing LF-style line endings with CRLF.

__NOTE__: 
Before worrying about what to set here, see https://help.github.com/articles/dealing-with-line-endings/ and
https://git-scm.com/docs/gitattributes, which describe how you can add a __.gitattributes__ file in the root of 
the repository to override any local git config settings. For my own projects, I plan to add a .gitattributes 
file, so I don't need to worry about correctly setting the line-endings behaviour using "git config".

Here is an example .gitattributes file I plan to use:
See https://raw.githubusercontent.com/ripley57/DocSearcher/master/.gitattributes

However, if you ever do need to play with "git config core.autocrlf" 
(see https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration) ...
 
git config --global core.autocrlf true
This auto-converts CRLF line endings to LF when you checkin a file to the index, and vice versa 
when you checkout the file. If you are on a Windows machine, you would usually set this.
*** NOTE: *** This will also convert files that have only LF endings to CRLF, which is no good for 
Linux or Cygwin!

## git config --global core.autocrlf input  
This is suitable for working on Linux, because it prevents any conversion to CRLF on checkout, 
and it will also "fix" any files that have CRLF endings by converting them to LF on checkin. 
But this is obviously not suitable for working with Windows files that do have CRLF line endings!
From https://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/:  
"This setting is generally used on Unix/Linux/OS X to prevent CRLFs from getting written into the repository. 
The idea being that if you pasted code from a web browser and accidentally got CRLFs into one of your files,
Git would make sure they were replaced with LFs when you wrote to the object database."  
From https://git-scm.com/book/en/v2/Customizing-Git-Git-Configuration:  
"This setup should leave you with CRLF endings in Windows checkouts, but LF endings on Mac and Linux systems 
and in the repository."  
__TBC__: Since it sounds like everything on checkin will be converted to LF, I can only assume that this comment
means that the Windows git client, recognising it is on Windows, will convert everything back to CRLF,
including on Cywin, which will be not use to me for .sh files!

## git config --global core.autocrlf false  
You can turn off all this conversion behaviour using the following:
`git config --global core.autocrlf false`  
From https://adaptivepatchwork.com/2012/03/01/mind-the-end-of-your-line/:  
Most people working in a Unix/Linux world use this value because they don’t have CRLF problems and they
don’t need Git to be doing extra work whenever files are written to the object database or written out 
into the working directory.


JeremyC 13-07-2018
