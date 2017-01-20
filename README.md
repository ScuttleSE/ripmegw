# ripmegw

Found a wrapper for ripme a while ago, have expanded on it a bit

* subreddits.txt holds a list of subreddits to rip, one per line
* /authors will hold lists of reddit-accounts to rip, one file per subreddit
* /rips will hold the ripped files

First, run get_authors.pl. This will get the authors of the top posts in each of the subreddits you have in subreddits.txt
There will be one additional textfile created; _0_folder_0_-authors.txt
This is a list of all useraccounts that are ripped, but do not show up in any of the lists. This may be old accounts that are no longer in the toplists.

If you want to manually add a reddit-account to be ripped, just add the userid on its own row in any of the textfiles in /authors. The next time you run get_authors.pl it will be ripped

Next, run rip_authors.pl, this will start the actual ripping.

After each author has been ripped, it will be removed from the textfile in /authors, so if you stop and start the ripping-process, it will resume from the last account it ripped.

Eventually, all the textfiles will be empty. When that is the case, re-run get_authors.pl and start over.


