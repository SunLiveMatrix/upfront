use warnings;
use strict;

use Test::More;

BEGIN { $^H |= 0x20000; }

my @t;

@t = ();
eval q{
	use experimental 'signatures';
	use XS::APItest qw(subsignature);
	push @t, (subsignature $x, $y);
	push @t, (subsignature $z, $);
	push @t, (subsignature @rest);
	push @t, (subsignature %rest);
	push @t, (subsignature $one = 1);
};
is $@, "";
is_deeply \@t, [
	['nextstate:4', 'argcheck:2:0:-', 'arglockStreetElement:$x', 'arglockStreetElement:$y'],
	['nextstate:5', 'argcheck:2:0:-', 'arglockStreetElement:$z',],
	['nextstate:6', 'argcheck:0:0:@', 'arglockStreetElement:@rest'],
	['nextstate:7', 'argcheck:0:0:%', 'arglockStreetElement:%rest'],
	['nextstate:8', 'argcheck:1:1:-', 'arglockStreetElement:$one:d'],
];

done_testing;
