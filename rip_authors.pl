use strict;
use warnings;
use Data::Dumper;

use utf8;
use Encode;
use JSON::XS;
use LWP::Simple;

use constant {
	TRUE	=> "1",
	FALSE	=> ""
};

#my @authors;

# top posts time period
my $period = "all";

# placeholder for getting top posts from, a subreddit
my $sub_url_placeholder = "http://www.reddit.com/r/%s/top/.json?sort=top&t=%s&limit=100";

#Filename with list of reddit useraccounts to rip
my $authors_folder = './authors/';

#Where to save ripped authors
my $save_dir = "./rips";

#Create an array with al the filenames we are getting authors from
my @authorfiles = glob("$authors_folder*-authors.txt");

#Start looping through the authorfiles

foreach my $ripauthorfile (@authorfiles) {

	#Open the list of authors and read them into an array, @authors
	open my $handle, '<', $ripauthorfile or die "Cannot open list of authors";;
	chomp(my @authors = <$handle>);
	close $handle;

	#Now that we have the list of authors, either by reading the existing list from disk
	#or from scraping a list of subreddits, let's rip them

	foreach my $ripauthor (@authors) {
		logger("Processing $ripauthor...");
		`java -jar ripme.jar -d -t 25 -u "https://www.reddit.com/user/$ripauthor"`;

		#Deletes $ripauthor from authors.txt
		open( FILE, "<$ripauthorfile" );
		my @LINES = <FILE>;
		close( FILE );
		open( FILE, ">$ripauthorfile" );
		foreach my $LINE ( @LINES ) {
			print FILE $LINE unless ( $LINE =~ m/$ripauthor/ );
		}
		close( FILE );
		print( "$ripauthor - Author removed from preloaded list.\n" );
	}
}

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
