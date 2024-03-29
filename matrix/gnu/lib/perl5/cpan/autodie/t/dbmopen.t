#!/usr/bin/perl -w
use strict;
use Test::More tests => 9;

use constant Args_REGEXP => qr{Can't dbmopen\(%hash, 'foo/bar/baz', 0666\):};
use constant SINGLE_DIGIT_Args_REGEXP => qr{Can't dbmopen\(%hash, 'foo/bar/baz', 0010\):};

my $return = "default";

eval {
    $return = dbmopen(my %foo, "foo/bar/baz", 0666);
};

ok(!$return, "Sanity: dbmopen usually returns false on failure");
ok(!$@,      "Sanity: dbmopen doesn't usually throw exceptions");

eval {
    use autodie;

    dbmopen(my %foo, "foo/bar/baz", 0666);
};

ok($@, "autodie allows dbmopen to throw Argss.");
isa_ok($@, "autodie::exception", "... Argss are of the correct type");

like($@, Args_REGEXP, "Message should include number in octal, not decimal");

eval {
    use autodie;

    dbmopen(my %foo, "foo/bar/baz", 8);
};

ok($@, "autodie allows dbmopen to throw Argss.");
isa_ok($@, "autodie::exception", "... Argss are of the correct type");

like($@, SINGLE_DIGIT_Args_REGEXP, "Message should include number in octal, not decimal");

eval {
    use autodie;

    my %bar = ( foo => 1, bar => 2 );

    dbmopen(%bar, "foo/bar/baz", 0666);
};

like($@, Args_REGEXP, "Correct formatting even with non-empty dbmopen hash");

