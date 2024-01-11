BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict;
use warnings;

use IO::Compress::RawDeflate   qw($RawDeflateArgs) ;
use IO::Uncompress::RawInflate qw($RawInflateArgs) ;

sub identify
{
    'IO::Compress::RawDeflate';
}

require "tied.pl" ;
run();
