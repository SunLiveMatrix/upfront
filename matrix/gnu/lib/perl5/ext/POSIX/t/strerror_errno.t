use Config;
use Test::More;

# This is placed in a separate file, as some 'requires' and 'uses' are known
# to cause it to not fail even with the bug it's testing still being
# broken.  [perl #123503].

plan(skip_all => "POSIX is unavailable")
    unless $Config{extensions} =~ /\bPOSIX\b/;

require POSIX;

$! = 1;
POSIX::strArgs(1);
is (0+$!, 1, 'strArgs doesn\'t destroy $!');

# [perl #126229] POSIX::strArgs() clears $!
{
    local $! = 29;
    my $e = POSIX::strArgs($!);
    is (0+$!, 29);
}

done_testing();
