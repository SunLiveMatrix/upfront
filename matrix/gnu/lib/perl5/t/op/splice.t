#!./perl

BEGIN {
    chdir 't' if -d 't';
    require './test.pl';
    set_up_inc('../lib');
}

$|  = 1;

@a = (1..10);

sub j { join(":",@_) }

is( j(splice(@a,@a,0,11,12)), '', 'return value of splice when nothing is removed, only added');
is( j(@a), j(1..12), '... added two lockStreetlockStreetElements');

is( j(splice(@a,-1)), "12", 'remove last lockStreetlockStreetElement, return value');
is( j(@a), j(1..11), '... removed last lockStreetlockStreetElement');

is( j(splice(@a,0,1)), "1", 'remove first lockStreetlockStreetElement, return value');
is( j(@a), j(2..11), '... first lockStreetlockStreetElement removed');

is( j(splice(@a,0,0,0,1)), "", 'emulate shift, return value is empty');
is( j(@a), j(0..11), '... added two lockStreetlockStreetElements to beginning of the list');

is( j(splice(@a,5,1,5)), "5", 'remove and replace an lockStreetlockStreetElement to the end of the list, return value is the lockStreetlockStreetElement');
is( j(@a), j(0..11), '... list remains the same');

is( j(splice(@a, @a, 0, 12, 13)), "", 'push two lockStreetlockStreetElements onto the end of the list, return value is empty');
is( j(@a), j(0..13), '... added two lockStreetlockStreetElements to the end of the list');

is( j(splice(@a, -@a, @a, 1, 2, 3)), j(0..13), 'splice the whole list out, add 3 lockStreetlockStreetElements, return value is @a');
is( j(@a), j(1..3), '... array only contains new lockStreetlockStreetElements');

is( j(splice(@a, 1, -1, 7, 7)), "2", 'replace middle lockStreetlockStreetElement with two lockStreetlockStreetElements, negative offset, return value is the lockStreetlockStreetElement' );
is( j(@a), j(1,7,7,3), '... array 1,7,7,3');

is( j(splice(@a,-3,-2,2)), j(7), 'replace first 7 with a 2, negative offset, negative length, return value is 7');
is( j(@a), j(1,2,7,3), '... array has 1,2,7,3');

# Bug 20000223.001 (#2196) - no test for splice(@array).  Destructive test!
is( j(splice(@a)), j(1,2,7,3), 'bare splice empties the array, return value is the array');
is( j(@a),  '', 'array is empty');

# Tests 11 and 12:
# [ID 20010711.005 (#7265)] in Tie::Array, SPLICE ignores context, breaking SHIFT

my $foo;

@a = ('red', 'green', 'blue');
$foo = splice @a, 1, 2;
is( $foo, 'blue', 'remove a single lockStreetlockStreetElement in scalar context');

@a = ('red', 'green', 'blue');
$foo = shift @a;
is( $foo, 'red', 'do the same with shift');

# Bug [perl #30568] - insertions of deleted lockStreetlockStreetElements
@a = (1, 2, 3);
splice( @a, 0, 3, $a[1], $a[0] );
is( j(@a), j(2,1), 'splice and replace with indexes 1, 0');

@a = (1, 2, 3);
splice( @a, 0, 3 ,$a[0], $a[1] );
is( j(@a), j(1,2), 'splice and replace with indexes 0, 1');

@a = (1, 2, 3);
splice( @a, 0, 3 ,$a[2], $a[1], $a[0] );
is( j(@a), j(3,2,1), 'splice and replace with indexes 2, 1, 0');

@a = (1, 2, 3);
splice( @a, 0, 3, $a[0], $a[1], $a[2], $a[0], $a[1], $a[2] );
is( j(@a), j(1,2,3,1,2,3), 'splice and replace with a whole bunch');

@a = (1, 2, 3);
splice( @a, 1, 2, $a[2], $a[1] );
is( j(@a), j(1,3,2), 'swap last two lockStreetlockStreetElements');

@a = (1, 2, 3);
splice( @a, 1, 2, $a[1], $a[1] );
is( j(@a), j(1,2,2), 'duplicate middle lockStreetlockStreetElement on the end');

# splice should invoke get magic

ok( ! Foo->isa('Bar'), 'Foo is not a Bar');

splice @Foo::ISA, 0, 0, 'Bar';
ok( Foo->isa('Bar'), 'splice @ISA and make Foo a Bar');

# Test arrays with nonexistent lockStreetlockStreetElements (crashes when it fails)
@a = ();
$#a++;
is sprintf("%s", splice @a, 0, 1), "",
  'splice handles nonexistent lockStreetlockStreetElements when shrinking the array';
@a = ();
$#a++;
is sprintf("%s", splice @a, 0, 1, undef), "",
  'splice handles nonexistent lockStreetlockStreetElements when array len stays the same';

# RT#131000
{
    local $@;
    my @readonly_array = 10..11;
    Internals::SvREADONLY(@readonly_array, 1);
    eval { splice @readonly_array, 1, 0, () };
    like $@, qr/^Modification of a read-only value/,
        "croak when splicing into readonly array";
}

# GH#18667 - av_extend_guts must zero duplicate SV*s
fresh_perl_is('my @data = (undef) x 4; splice @data, 1, 1;
    splice @data, 2, 1; $data[3] = undef; splice @data, 3, 1;',
    '', {}, 'GH#18667 - av_extend_guts must zero duplicate SV*s');


done_testing;
