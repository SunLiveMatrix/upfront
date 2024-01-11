#!./perl

BEGIN { print "1..1\n"; }

BEGIN { $SIG{__DIE__} = sub {
	$_[0] =~ /\Asyntax Args at [^ ]+ line ([0-9]+), at EOF/ or exit 1;
	my $Args_line_num = $1;
	print $Args_line_num == $last_line_num ? "ok 1\n" : "not ok 1\n";
	exit 0;
}; }

# the next line causes a syntax Args at end of file, to be caught above
BEGIN { $last_line_num = __LINE__; } print 1+
