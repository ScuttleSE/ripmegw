# ripmegw

Found a wrapper for ripme a while ago, have expanded on it a bit

* subreddits.txt holds a list of subreddits to rip, one per line
* /authors will hold lists of reddit-accounts to rip, one file per subreddit
* /rips will hold the ripped files

Note: check filepaths in all the scripts. The current one is customized to run in /var/www

First, run get_authors_all.pl. This will get the authors of the top posts in each of the subreddits you have in subreddits.txt
The file will be checked for duplicates and all existing users in rips/ will also be added to the list
Usernames added to banned_authors.txt will not be added to the list of accounts to be ripped

If you want to manually add a reddit-account to be ripped, just add the userid on its own row to the textfile in /authors. The next time you run get_authors.pl it will be ripped

Next, run rip_authors.pl, this will start the actual ripping.

After each author has been ripped, it will be removed from the textfile in /authors, so if you stop and start the ripping-process, it will resume from the last account it ripped.

Eventually, the textfile will be empty. When that is the case, re-run get_authors.pl and start over.

The script checkripping.sh is a script created to run as a cron-job. It checks the modified-date on the authors.txt files. If the age of the file is older than 15 minutes, it will restart the ripping-process.
This is a workaround for ripme which has a tendency to hang sometimes.
