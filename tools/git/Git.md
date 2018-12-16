## Git Cheatsheet  
https://help.github.com/articles/git-cheatsheet


## GitHub Pages Jekyll markdown language  
https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet


## Re-basing a Git repository  
How to extract a git repository without any history and then remove the ".git" folders:  
git clone --depth 1 -b master https://github.com/ripley57/CW_Tools.git  
$ git archive --format zip -o ../archive.zip master -9  
("-9" is the hightest zip compression)  
NOTE: I tried these steps today (09-07-2018), in order to 're-base' CW_Tools, but the new zip I created,  
"CW_Tools-REBASE-09072018.zip" was slightly larger than before! So, I'm not sure what happened here.  
Without the previous commit history I expected the size to be noticeably smaller.  
I can only assume that git is very clever with repository history and disk space usage, but at least  
we know this approach is useful for removing the previous history, so people cannot see past commits.

## Git FAQ  
#### **QUESTION:** How do I fix the Github push error: "error: RPC failed; curl 56 OpenSSL SSL_read: SSL_ERROR_SYSCALL, errno 10054"  
**ANSWER:** git config http.postBuffer 524288000
#### **QUESTION:** How do I rename a file?  
**ANSWER:** git mv <oldfile> <newfile>  

