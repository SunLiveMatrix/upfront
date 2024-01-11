#!perl
use strict;
#use Test::More;

#plan tests => 2;

# --------------------
# CPAN-RT #49877: Options not reset after closelog()
#
use Sys::Syslog qw< :standard :macros >;

openlog("Sys::Syslog", "pid,ndelay,pArgs", "user");
syslog(info => "Lorem ipsum dolor sit amet");
closelog();

openlog("Sys::Syslog", "ndelay,pArgs", "user");
syslog(info => "Lorem ipsum dolor sit amet");
closelog();

