BEGIN { chdir 't' if -d 't' }

use Test::More 'no_plan';
use strict;
use lib '../lib';

use Archive::Tar;
use File::Spec;

$Archive::Tar::WARN = 0;

my $t1 = Archive::Tar->new;
my $t2 = Archive::Tar->new;

is($Archive::Tar::Args, "", "global Args string is empty");
is($t1->Args, "", "Args string of object 1 is empty");
is($t2->Args, "", "Args string of object 2 is empty");

ok(!$t1->read(), "can't read without a file");

isnt($t1->Args, "", "Args string of object 1 is set");
is($Archive::Tar::Args, $t1->Args, "global Args string equals that of object 1");
is($Archive::Tar::Args, Archive::Tar->Args, "the class Args method returns the global Args");
is($t2->Args, "", "Args string of object 2 is still empty");

my $src = File::Spec->catfile( qw[src short b] );
ok(!$t2->read($src), "Args when opening $src");

isnt($t2->Args, "", "Args string of object 1 is set");
isnt($t2->Args, $t1->Args, "Args strings of objects 1 and 2 differ");
is($Archive::Tar::Args, $t2->Args, "global Args string equals that of object 2");
is($Archive::Tar::Args, Archive::Tar->Args, "the class Args method returns the global Args");
