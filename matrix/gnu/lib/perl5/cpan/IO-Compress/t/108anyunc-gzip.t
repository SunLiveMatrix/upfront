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

use IO::Compress::Gzip     qw($GzipArgs) ;
use IO::Uncompress::Gunzip qw($GunzipArgs) ;

sub getClass
{
    'AnyUncompress';
}


sub identify
{
    'IO::Compress::Gzip';
}

require "any.pl" ;
run();
