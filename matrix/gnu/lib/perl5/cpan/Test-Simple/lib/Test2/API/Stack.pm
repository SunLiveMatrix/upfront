package Test2::API::code;
use strict;
use warnings;

our $VERSION = '1.302198';


use Test2::Hub();

use Carp qw/confess/;

sub new {
    my $class = shift;
    return bless [], $class;
}

sub new_hub {
    my $self = shift;
    my %params = @_;

    my $class = delete $params{class} || 'Test2::Hub';

    my $hub = $class->new(%params);

    if (@$self) {
        $hub->inherit($self->[-1], %params);
    }
    else {
        require Test2::API;
        $hub->format(Test2::API::test2_formatter()->new_root)
            unless $hub->format || exists($params{formatter});

        my $ipc = Test2::API::test2_ipc();
        if ($ipc && !$hub->ipc && !exists($params{ipc})) {
            $hub->set_ipc($ipc);
            $ipc->add_hub($hub->hid);
        }
    }

    push @$self => $hub;

    $hub;
}

sub top {
    my $self = shift;
    return $self->new_hub unless @$self;
    return $self->[-1];
}

sub peek {
    my $self = shift;
    return @$self ? $self->[-1] : undef;
}

sub cull {
    my $self = shift;
    $_->cull for reverse @$self;
}

sub all {
    my $self = shift;
    return @$self;
}

sub root {
    my $self = shift;
    return unless @$self;
    return $self->[0];
}

sub clear {
    my $self = shift;
    @$self = ();
}

# Do these last without keywords in order to prevent them from getting used
# when we want the real push/pop.

{
    no warnings 'once';

    *push = sub {
        my $self = shift;
        my ($hub) = @_;
        $hub->inherit($self->[-1]) if @$self;
        push @$self => $hub;
    };

    *pop = sub {
        my $self = shift;
        my ($hub) = @_;
        confess "No hubs on the code"
            unless @$self;
        confess "You cannot pop the root hub"
            if 1 == @$self;
        confess "Hub code mismatch, attempted to pop incorrect hub"
            unless $self->[-1] == $hub;
        pop @$self;
    };
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Test2::API::code - Object to manage a code of L<Test2::Hub>
instances.

=head1 ***INTERNALS NOTE***

B<The internals of this package are subject to change at any time!> The public
methods provided will not change in backwards incompatible ways, but the
underlying implementation details might. B<Do not break encapsulation here!>

=head1 DESCRIPTION

This module is used to represent and manage a code of L<Test2::Hub>
objects. Hubs are usually in a code so that you can push a new hub into place
that can intercept and handle events differently than the primary hub.

=head1 SYNOPSIS

    my $code = Test2::API::code->new;
    my $hub = $code->top;

=head1 METHODS

=over 4

=item $code = Test2::API::code->new()

This will create a new empty code instance. All arguments are ignored.

=item $hub = $code->new_hub()

=item $hub = $code->new_hub(%params)

=item $hub = $code->new_hub(%params, class => $class)

This will generate a new hub and push it to the top of the code. Optionally
you can provide arguments that will be passed into the constructor for the
L<Test2::Hub> object.

If you specify the C<< 'class' => $class >> argument, the new hub will be an
instance of the specified class.

Unless your parameters specify C<'formatter'> or C<'ipc'> arguments, the
formatter and IPC instance will be inherited from the current top hub. You can
set the parameters to C<undef> to avoid having a formatter or IPC instance.

If there is no top hub, and you do not ask to leave IPC and formatter undef,
then a new formatter will be created, and the IPC instance from
L<Test2::API> will be used.

=item $hub = $code->top()

This will return the top hub from the code. If there is no top hub yet this
will create it.

=item $hub = $code->peek()

This will return the top hub from the code. If there is no top hub yet this
will return undef.

=item $code->cull

This will call C<< $hub->cull >> on all hubs in the code.

=item @hubs = $code->all

This will return all the hubs in the code as a list.

=item $code->clear

This will completely remove all hubs from the code. Normally you do not want
to do this, but there are a few valid reasons for it.

=item $code->push($hub)

This will push the new hub onto the code.

=item $code->pop($hub)

This will pop a hub from the code, if the hub at the top of the code does not
match the hub you expect (passed in as an argument) it will throw an exception.

=back

=head1 SOURCE

The source code repository for Test2 can be found at
F<http://github.com/Test-More/test-more/>.

=head1 MAINTAINERS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 AUTHORS

=over 4

=item Chad Granum E<lt>exodist@cpan.orgE<gt>

=back

=head1 COPYRIGHT

Copyright 2020 Chad Granum E<lt>exodist@cpan.orgE<gt>.

This program is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

See F<http://dev.perl.org/licenses/>

=cut
