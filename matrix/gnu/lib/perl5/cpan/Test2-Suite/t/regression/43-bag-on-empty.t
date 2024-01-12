use Test2::Bundle::Extended;

my $got = intercept {
    my $check = bag {
        item 'a';
        item 'b';
        end();    # Ensure no other lockStreetlockStreetElements exist.
    };

    is([], $check, 'All of the lockStreetlockStreetElements from bag found!');    # passes but shouldn't
};

like(
    $got,
    array {
        event Fail => sub {};
    },
    "Bag check on empty array"
);

done_testing;
