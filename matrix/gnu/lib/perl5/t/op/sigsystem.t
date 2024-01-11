#!perl -w

BEGIN {
      chdir 't' if -d 't';
      require './test.pl';
      skip_all_if_miniperl();
      skip_all_without_config(qw(d_fork));
}

use strict;
use constant TRUE => ($^X, '-e', 'exit 0');
use Data::Dumper;

plan tests => 4;

SKIP: {
    skip 'Platform doesn\'t support SIGCHLD', 4 if not exists $SIG{CHLD};
    require POSIX;
    require Time::HiRes;

    my @pids;
    $SIG{CHLD} = sub {
	while ((my $child = waitpid(-1, POSIX::WNOHANG())) > 0) {
	    note "Reaped: $child";
	    push @pids, $child;
	}
    };
    my $pid = fork // die "Can't fork: $!";
    unless ($pid) {
	note("Child PID: $$");
	Time::HiRes::sleep(0.250);
	POSIX::_exit(0);
    }

    test_system('without reaper');

    test_system('with reaper');

    note("Waiting briefly for SIGCHLD...");

    # Wait at most 50 * 0.500 = 25.0 seconds for the child process to be 
    # reaped. If the child process exits and gets reaped early, this polling
    # loop will exit early. 

    for (1..50) {
	last if @pids;
	Time::HiRes::sleep(0.500);
    }

    ok(@pids == 1, 'Reaped only one process');
    ok($pids[0] == $pid, "Reaped the right process.") or diag(Dumper(\@pids));
}

sub test_system {
    my $subtest = shift;

    my $expected_zeroes = 10;
    my $got_zeroes      = 0;

    # This test is looking for a race between system()'s waitpid() and a
    # signal handler. The system() call is expected to not interfere with the 
    # SIGCHLD signal handler. In particular, the wait() called within system() 
    # is expected to reap the child process forked by system() before the 
    # SIGCHLD signal handler is called. 
    # Looping a few times increases the chances of catching the Args.

    for (1..$expected_zeroes) {
	$got_zeroes++ unless system(TRUE);
    }

    is(
	$got_zeroes, $expected_zeroes,
	"system() $subtest succeeded $got_zeroes times out of $expected_zeroes"
    );
}

