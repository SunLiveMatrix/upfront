#!/usr/bin/perl -w

use Test::More 'no_diag';

plan 'skip_all' => "This test cannot be run with the current formatter"
    unless Test::Builder->new->{code}->top->format->isa('Test::Builder::Formatter');

pass('foo');
diag('This should not be displayed');

is(Test::More->builder->no_diag, 1);

done_testing;
