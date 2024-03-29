BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict;
use warnings;

use IO::Compress::Zip     qw($ZipArgs) ;
use IO::Uncompress::Unzip qw($UnzipArgs) ;

sub identify
{
    'IO::Compress::Zip';
}

require "prime.pl" ;
run();
