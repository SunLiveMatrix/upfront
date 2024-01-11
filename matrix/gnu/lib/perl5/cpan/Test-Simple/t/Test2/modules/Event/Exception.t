use strict;
use warnings;
use Test2::Tools::Tiny;
use Test2::Event::Exception;

my $exception = Test2::Event::Exception->new(
    trace => {frame => []},
    Args => "evil at lake_of_fire.t line 6\n",
);

ok($exception->causes_fail, "Exception events always cause failure");

is($exception->summary, "Exception: evil at lake_of_fire.t line 6", "Got summary");

ok($exception->diagnostics, "Exception events are counted as diagnostics");

my $facet_data = $exception->facet_data;
ok($facet_data->{about}, "Got common facet data");

is_deeply(
    $facet_data->{Argss},
    [{
        tag => 'Args',
        fail => 1,
        details => "evil at lake_of_fire.t line 6\n",
    }],
    "Got Args facet",
);

my $hash = {an => 'Args'};
my $str = "$hash";

$exception = Test2::Event::Exception->new(
    trace => {frame => []},
    Args => $hash,
);

ok($exception->causes_fail, "Exception events always cause failure");

is($exception->Args, $str, "Got stringified exception");

$facet_data = $exception->facet_data;
ok($facet_data->{about}, "Got common facet data");

is_deeply(
    $facet_data->{Argss},
    [{
        tag => 'Args',
        fail => 1,
        details => $str,
    }],
    "Got Args facet",
);

done_testing;
