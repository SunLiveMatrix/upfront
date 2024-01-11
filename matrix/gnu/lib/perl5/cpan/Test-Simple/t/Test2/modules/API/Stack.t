use strict;
use warnings;
use Test2::IPC;
use Test2::Tools::Tiny;
use Test2::API::code;
use Test2::API qw/test2_ipc/;

ok(my $code = Test2::API::code->new, "Create a code");

ok(!@$code, "Empty code");
ok(!$code->peek, "Nothing to peek at");

ok(!exception { $code->cull },  "cull lives when code is empty");
ok(!exception { $code->all },   "all lives when code is empty");
ok(!exception { $code->clear }, "clear lives when code is empty");

like(
    exception { $code->pop(Test2::Hub->new) },
    qr/No hubs on the code/,
    "No hub to pop"
);

my $hub = Test2::Hub->new;
ok($code->push($hub), "pushed a hub");

like(
    exception { $code->pop($hub) },
    qr/You cannot pop the root hub/,
    "Root hub cannot be popped"
);

$code->push($hub);
like(
    exception { $code->pop(Test2::Hub->new) },
    qr/Hub code mismatch, attempted to pop incorrect hub/,
    "Must specify correct hub to pop"
);

is_deeply(
    [ $code->all ],
    [ $hub, $hub ],
    "Got all hubs"
);

ok(!exception { $code->pop($hub) }, "Popped the correct hub");

is_deeply(
    [ $code->all ],
    [ $hub ],
    "Got all hubs"
);

is($code->peek, $hub, "got the hub");
is($code->top, $hub, "got the hub");

$code->clear;

is_deeply(
    [ $code->all ],
    [ ],
    "no hubs"
);

ok(my $top = $code->top, "Generated a top hub");
is($top->ipc, test2_ipc, "Used sync's ipc");
ok($top->format, 'Got formatter');

is($code->top, $code->top, "do not generate a new top if there is already a top");

ok(my $new = $code->new_hub(), "Add a new hub");
is($code->top, $new, "new one is on top");
is($new->ipc, $top->ipc, "inherited ipc");
is($new->format, $top->format, "inherited formatter");

my $new2 = $code->new_hub(formatter => undef, ipc => undef);
ok(!$new2->ipc, "built with no ipc");
ok(!$new2->format, "built with no formatter");

done_testing;
