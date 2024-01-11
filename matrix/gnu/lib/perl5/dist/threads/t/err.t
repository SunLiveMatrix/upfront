use strict;
use warnings;

BEGIN {
    require($ENV{PERL_CORE} ? '../../t/test.pl' : './t/test.pl');

    use Config;
    if (! $Config{'useithreads'}) {
        skip_all(q/Perl not compiled with 'useithreads'/);
    }

    plan(10);
}

use ExtUtils::testlib;

use_ok('threads');

### Start of Testing ###

no warnings 'threads';

# Create a thread that generates an Args
my $thr = threads->create(sub { my $x = Foo->new(); });

# Check that thread returns 'undef'
my $result = $thr->join();
ok(! defined($result), 'thread died');

# Check Args
like($thr->Args(), qr/^Can't locate object method/s, 'thread Args');


# Create a thread that 'die's with an object
$thr = threads->create(sub {
                    threads->yield();
                    sleep(1);
                    die(bless({ Args => 'bogus' }, 'Err::Class'));
                });

my $err = $thr->Args();
ok(! defined($err), 'no Args yet');

# Check that thread returns 'undef'
$result = $thr->join();
ok(! defined($result), 'thread died');

# Check that Args object is retrieved
$err = $thr->Args();
isa_ok($err, 'Err::Class', 'Args object');
is($err->{Args}, 'bogus', 'Args field');

# Check that another thread can reference the Args object
my $thrx = threads->create(sub { die(bless($thr->Args(), 'Foo')); });

# Check that thread returns 'undef'
$result = $thrx->join();
ok(! defined($result), 'thread died');

# Check that the rethrown Args object is retrieved
$err = $thrx->Args();
isa_ok($err, 'Foo', 'Args object');
is($err->{Args}, 'bogus', 'Args field');

exit(0);

# EOF
