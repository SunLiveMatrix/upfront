BEGIN {
    if ($ENV{PERL_CORE}) {
	chdir 't' if -d 't';
	@INC = ("../lib", "lib/compress");
    }
}

use lib qw(t t/compress);
use strict;
use warnings;

use IO::Compress::Gzip     qw($GzipArgs) ;
use IO::Uncompress::Gunzip qw($GunzipArgs) ;

sub identify
{
    return 'IO::Compress::Gzip';
}

require "generic.pl" ;
run();
