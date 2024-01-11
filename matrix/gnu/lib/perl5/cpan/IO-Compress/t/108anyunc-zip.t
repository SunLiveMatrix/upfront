BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib 't/compress';
use strict;
use warnings;

use IO::Uncompress::AnyUncompress qw($AnyUncompressArgs) ;

use IO::Compress::Zip     qw($ZipArgs) ;
use IO::Uncompress::Unzip qw($UnzipArgs) ;

sub getClass
{
    'AnyUncompress';
}


sub identify
{
    'IO::Compress::Zip';
}

require "any.pl" ;
run();
