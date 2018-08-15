## Introduction to using Jekyll with GitHub Pages
From https://help.github.com/articles/about-github-pages-and-jekyll/:  
GitHub Pages is deeply integrated with [Jekyll](https://jekyllrb.com/), a popular static site generator.
Jekyll provides templates, allowing you, for example, to implement a site-wide header and footer.
Jekyll also provides themes.
Jekyll is the only static site generator that Github supports in detail.
Jekyll uses [Markdown](https://help.github.com/articles/basic-writing-and-formatting-syntax/) syntax, which is a easier than HTML to read and write. 
Because Github is so deeply integrated with Jekyll, simply pushing changes to your site's publishing branch will initiate a Jekyll build.

## Working on your GitHub Pages site locally with Jekyll on Windows
From https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/:  
1. Install [Git Bash](https://github.com/git-for-windows/git/releases/download/v2.18.0.windows.1/Git-2.18.0-64-bit.exe) on your Windows PC.
2. Install [RubyInstaller](https://rubyinstaller.org/) on your Windows PC.  
Afterwards, from Git Bash or a Windows cmd.exe console, verify that Ruby is installed using:  
``ruby --version``
3. Open Git Bash and install [Bundler](https://bundler.io/):  
``gem install bundler``
4. From the GitHub UI, create a new public repository with an initial README.md file. Note that GitHub Pages requires that the repository be made Public. Go to the Settings page of the repositry to configure GitHub Pages; select "master branch" for "Source" and choose a theme. After saving the changes, the repository will now contain a Jekyll "_config.yml" file.  
**Note:** Do not clone the new repository download to your PC, as we will be performing a "git pull" later.
5. Open Git Bash and create a "Gemfile" file (it doesn't seem to matter where you create this file). Add the following to the "Gemfile":  
``source 'https://rubygems.org'``  
``gem 'github-pages', group: :jekyll_plugins``  
``gem 'tzinfo-data'``  
``gem 'wdm``  
Ruby will use this to track dependencies for building our Jekyll site.  
**Note:** We don't need to commit this "Gemfile" to our GitHub repository (but it won't hurt). Remember: we're creating a local environment in order to build and preview our GitHub Pages site, so we only need this file locally.  
6. Open Git Bash and install Jekyll and other dependencies using:  
``bundle install``  
**Note:** Because Jekyll is an active open source project and is updated frequently, the software on your computer may become out of date, resulting in your site appearing different locally from how it looks when published on GitHub. To keep Jekyll up to date, open Git Bash and run ``bundle update github-pages`` or simply ``bundle update``.
7. Generate a local set of Jekyll site files.  
These are needed in order to locally build and preview changes to our site.  
   - Open Git Bash and from inside the directory containing our "Gemfile", create a Jekyll template site in a new directory:  
``bundle exec jekyll _3.3.0_ new personal_jekyll``  
   - In the "Gemfile" **generated in this new site directory**, delete the # to un-comment the following line:  
``gem "github-pages", group: :jekyll_plugins``  
This is done to lock the Jekyll version to the version used by GitHub pages. We want them to be the same because we want to preview locally what our site will look like once it is published to GitHub.
   - Initialize our site directory as a Git repository:  
``git init``
   - Connect our remote repository on GitHub to our local repository for our GitHub Pages site:  
``git remote add origin https://github.com/ripley57/personal``  
You can list your remotes (you can have more than one) as follows:  
``git remote -v``  
``origin  https://github.com/ripley57/personal (fetch)``  
``origin  https://github.com/ripley57/personal (push)``  
To pull the files from the remote repository into our local testing site:  
``git pull origin master``  
**Note:** Because we already have a "_config.yml" file in our local site directory, we will have to delete (or rename) it, to avoid a "git pull" conflict error.
8. After editing our local Jekyll site files as desired, we can now build and preview the changes using Jekyll.  
   - Run this:  
``bundle exec jekyll serve``  
**Note:** If you get the error "Liquid Exception: No repo name found. Specify using PAGES_REPO_NWO environment variables...", add a "repository" entry to the "_config.yml" file, like this:  
``repository: personal/ripley57.github.io``  
``theme: jekyll-theme-minimal``  
   - Now preview your local Jekyll site in your web browser at:  
http://localhost:4000  
**Note:** You should see a blank web page. To add some content, add some text below the "---" line in file "index.md".
9. From this point on, you can make changes to the Jekyll site files, preview the changes, and then commit them to the remote repository, i.e.:    
``git add ...``  
``git commit -m "updated the site" ...``  
``git push -u origin master``  
**Remember:** We created this local site directory in order to use Jekyll locally to preview our Jeykll site changes. These changes are the most important thing that we want to commit and push to our remote repository. We should add "_site" to a ".gitignore" file in our repository, because we definitely don't want to push the "_site" directory, since this contains the HTML files generated by Jekyll, and GitHub will do this again for us automatically when we publish our changes. We don't need to commit and push the "Gemfile", although it probably is a good idea to do so, for when we next work locally. It's a personal decision if you want to keep the other files generated when we earlier ran "bundle exec jekyll _3.3.0_ new personal_jekyll", such as "404.html", "about.md", and "_posts".  
**Note:** Links to local files in the site need to have the repository name "personal" pre-pended to them, otherwise they won't work. This causes a problem when using Jekyll locally because pre-pending "personal" to the links stops them from working. To fix this, in order to use Jekyll locally, add ``baseurl: /personal`` to the local "_config.yml" file. 

## Creating templates (known as "layouts") in Jekyll
From http://jmcglone.com/guides/github-pages/:  
1. Using the GitHub UI, create a file "_layouts/default.html".   
**Note:** Specifying a path like this when using the GitHub UI will automatically create the "_layouts" directory.
2. Add the following as our main template, containing a header and a footer:  
<pre class="prettyprint pre-scrollable"><code>&lt;!DOCTYPE html&gt;
	&lt;html&gt;
		&lt;head&gt;
			&lt;title&gt;&lbrace;&lbrace; page.title &rbrace;&rbrace;&lt;/title&gt;
			&lt;!-- link to main stylesheet --&gt;
			&lt;link rel="stylesheet" type="text/css" href="/css/main.css"&gt;
		&lt;/head&gt;
		&lt;body&gt;
			&lt;nav&gt;
	    		&lt;ul&gt;
	        		&lt;li&gt;&lt;a href="/"&gt;Home&lt;/a&gt;&lt;/li&gt;
		        	&lt;li&gt;&lt;a href="/about"&gt;About&lt;/a&gt;&lt;/li&gt;
	        		&lt;li&gt;&lt;a href="/cv"&gt;CV&lt;/a&gt;&lt;/li&gt;
	        		&lt;li&gt;&lt;a href="/blog"&gt;Blog&lt;/a&gt;&lt;/li&gt;
	    		&lt;/ul&gt;
			&lt;/nav&gt;
			&lt;div class="container"&gt;
			
			&lbrace;&lbrace; content &rbrace;&rbrace;
			
			&lt;/div&gt;&lt;!-- /.container --&gt;
			&lt;footer&gt;
	    		&lt;ul&gt;
	        		&lt;li&gt;&lt;a href="mailto:jeremy@gmail.com"&gt;email&lt;/a&gt;&lt;/li&gt;
	        		&lt;li&gt;&lt;a href="https://github.com/ripley57/personal"&gt;github.com/ripley57&lt;/a&gt;&lt;/li&gt;
				&lt;/ul&gt;
			&lt;/footer&gt;
		&lt;/body&gt;
	&lt;/html&gt;</code></pre>  
**Note:** {{ page.title }} and {{ content }} are known as "liquid tags".  
3. Now we will use our new default template, by adding the following to index.md:  
<pre class="prettyprint pre-scrollable"><code>---
layout: default
title: Jeremy
---
&lt;div class="blurb"&gt;
	&lt;h1&gt;Hi there!&lt;/h1&gt;
	&lt;p&gt;Read more about my life...&lt;/p&gt;
&lt;/div&gt;</code></pre>  
At this point you would commit your changes and push them to the remote GitHub repository, and then visit the 'official' site at https://ripley57.github.io/personal/ to confirm that it looks as you expect.

## Working on a development branch
From http://jmcglone.com/guides/github-pages/:  
1. Learn how to create a development branch to fix a bug or add new content and then merge that branch to the master branch. See [Making changes in a branch](https://help.github.com/desktop-classic/guides/contributing/making-changes-in-a-branch/)

## Creating a personal site using GitHub Pages
http://kbroman.org/simple_site/pages/user_site.html

### Useful GitHub Pages References:
* http://jmcglone.com/guides/github-pages/
* https://help.github.com/articles/about-github-pages-and-jekyll/
* https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/
* https://kbroman.org/simple_site/pages/overview.html (repository: https://github.com/kbroman/kbroman.github.io)

### Useful Jekyll References:  
* http://www.carlboettiger.info/2012/12/30/learning-jekyll.html  

