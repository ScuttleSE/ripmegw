use strict;
use warnings;
use Data::Dumper;
use List::MoreUtils qw(uniq);

use utf8;
use Encode;
use JSON::XS;
use LWP::Simple;

use constant {
	TRUE	=> "1",
	FALSE	=> ""
};

my @authors;

my @folderauthors;

my @allauthors;

# top posts time period
my $period = "all";

my $save_dir = "./rips";

# placeholder for getting top posts from, a subreddit
my $sub_url_placeholder = "http://www.reddit.com/r/%s/top/.json?sort=top&t=%s&limit=100";

#Filename with list of subreddits to monitor for top posters
my $subredditfile = "subreddits.txt";

#Folder where author-lists are stored
my $authorfolder = "./authors";

#Filename with list of reddit useraccounts to rip
my $authorsfile = "authors.txt";

#Open the list of subreddits and read them into an array, @subs
open my $handle, '<', $subredditfile or die "Cannot open list of subreddits";;
chomp(my @subs = <$handle>);
close $handle;

for my $sub (@subs) {
	my $after;
	do {
		logger("LOADING PAGE: $after", "PAGE") if $after;
		my $sub_url;
		$sub_url	.= sprintf $sub_url_placeholder, $sub, $period;
		$sub_url	.= sprintf "&after=%s", $after if $after;
		my $json	= get_json($sub_url);

		# update the after value
		$after = $json->{'data'}->{'after'};

		# for every post, grab the author and store it in the unique @authors array
		my $posts = $json->{'data'}->{'children'};
		for my $post (@$posts) {
			my $data	= $post->{'data'};
			my $author      = $data->{'author'};

			unless(grep /$author/i, @authors) {
				push @authors, $author;
			}
		}
	} while ($after);

	##Print all authors to authors.txt, one for each subreddit
	#open my $fh, '>', "$authorfolder/$sub-authors.txt" or die "Cannot open output.txt: $!";
	#foreach (@authors)
	#{
	#    print $fh "$_\n";
	#}
	#close $fh;
	##Clear the authors-array for next subreddit
	#push(@allauthors, @authors);
	#undef(@authors);
}

#List of existing users in ripme-folder
my @existing_users = `ls -1 $save_dir | grep reddit_user`;
        foreach my $folderpath (@existing_users) {
            chomp $folderpath;
            my $user = $folderpath;
            $user =~ s/reddit_user_//;
            next if $user =~ m/^rips$/;
            unless(grep /$user/i, @allauthors) {
                push @authors, $user;
            }
        }

##Print all authors to authors.txt, one for each subreddit
#open my $fh2, '>', "$authorfolder/_0_folder_0_-authors.txt" or die "Cannot open output.txt: $!";
#foreach (@folderauthors)
#{
#    print $fh2 "$_\n";
#}
#close $fh2;

my @unique_authors = uniq @authors;

open my $fh, '>', "$authorfolder/all-authors.txt" or die "Cannot open output.txt: $!";
foreach (@authors)
{
    print $fh "$_\n";
}
close $fh;




sub get_json {
	my $url	 = shift;
	my $response    = get $url;
	my $json	= decode_json(encode('UTF-8', $response));
	return $json;
}

sub logger {
	my $mesg	= shift;
	my $severity    = shift // "INFO";
	print Dumper(sprintf "[%s]: %s", $severity, $mesg);
}
