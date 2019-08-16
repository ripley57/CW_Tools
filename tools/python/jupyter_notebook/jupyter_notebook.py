""" Jupyter notebook.

	Jupyter notebook is a web application that allows you to create and share documents
	that contain live code, equations, visualizations, and explanatory text.

	NOTE: 	You Jupyter notebooks can be save to a ".ipynb" file, so you can keep 
		these as your own record, or share them with others.

	Several languages are now supported, but it orginated in connection to IPython,
	an alternative Python shell developed for the scientific community.

	It lets you combine text and code, and modify and execute your code interactively.
	You can also save and share notebooks with others.

	"Project Jupyter", the community behind it, hosts free online notebooks here:
		https://jupyter.org/try

	One way to run a Jupyter process locally on your machine, is to use docker:
		docker run -it --rm -p 8888:8888 jupyter/datascience-notebook

	Or you can run it locally inside a Python virtual env, like this:
		python3 -m venv jupyter
		cd jupyter
		source bin/activate
		pip install wheel		(for bdist_wheel)
		pip install jupyter
		jupyter-notebook


	STARTING A KERNEL	

	With Jupyter running and open in your web browser, you need to start a Python kernel.
	Jupyter lets you run multiple kernels at the same time, e.g. for different versions
	of Python, and for other languages including Ruby.

	To start a new kernel, click the new button and select "Python3" (see screenshot_start-kernel.png).	


	EXECUTING SOME PYTHON CODE

	Enter some code and then click the "Cell" button to run it, or alternatively click "Alt-Enter".
	See screenshot_run-cell.png.
"""
