#  Troubleshooting #

1. rails console
2. debug(params) in views
3. logger.info in the controller
4. puts or p in the model
5. Using tail to view development log file.
Open a new tab in the terminal (On Mac Command+T opens a new tab on an existing open terminal), go the rails project blog directory and type the following command:
   	$ tail -f log/development.log

6. View source in the browser. For example: Checking if path to images are correct. 
7. dbconsole
8. Firebug or something equivalent
9. Debugger in Rubymine




# FAQ #

1. Adding a new source to gem.

$ gem sources -a http://gems.github.com

2. Suppress installing rdoc for gems. For example to install passenger gem without any rdoc or ri type:
		$ gem install passenger -d --no-rdoc --no-ri

3. How to upgrade gems on my system?

$ gem update —system