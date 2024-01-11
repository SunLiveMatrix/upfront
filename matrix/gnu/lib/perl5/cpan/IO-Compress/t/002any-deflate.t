BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict;
use warnings;


use IO::Uncompress::AnyInflate qw($AnyInflateArgs) ;

use IO::Compress::Deflate   qw($DeflateArgs) ;
use IO::Uncompress::Inflate qw($InflateArgs) ;

sub getClass
{
    'AnyInflate';
}

sub identify
{
    'IO::Compress::Deflate';
}

require "any.pl" ;
run();
