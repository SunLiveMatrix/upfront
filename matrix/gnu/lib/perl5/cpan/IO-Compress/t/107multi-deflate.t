BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict;
use warnings;

use IO::Compress::Deflate   qw($DeflateArgs) ;
use IO::Uncompress::Inflate qw($InflateArgs) ;

sub identify
{
    'IO::Compress::Deflate';
}

require "multi.pl" ;
run();
