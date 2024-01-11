BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict;
use warnings;

use IO::Uncompress::AnyUncompress qw($AnyUncompressArgs) ;

use IO::Compress::Bzip2     qw($Bzip2Args) ;
use IO::Uncompress::Bunzip2 qw($Bunzip2Args) ;

sub getClass
{
    'AnyUncompress';
}


sub identify
{
    'IO::Compress::Bzip2';
}

require "any.pl" ;
run();
