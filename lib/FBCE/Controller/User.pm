use utf8;
package FBCE::Controller::User;
use Moose;
use MooseX::MethodAttributes;
use MooseX::Types::Moose qw(Str);
use namespace::autoclean -except => 'Str';

BEGIN { extends 'FBCE::Controller' }

=head1 NAME

FBCE::Controller::User - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 user

Start of user-related chain

=cut

sub user :Chained('/') :Path :CaptureArgs(Str) {
    my ($self, $c, $login) = @_;

    # Must be logged in
    my $user = $self->require_user($c);
    # Admin can view anyone, others can only view themselves
    if (!$user->admin && $login ne $user->login) {
	$c->detach('/default');
    }
    my $person = $c->model('FBCE::Person')->find({ login => $login });
    $c->detach('/default')
	unless $person;
    $c->stash(person => $person);
}

=head2 see

View a specific person

=cut

sub see :Chained('user') :PathPart('') :Args(0) {
    my ($self, $c) = @_;

    # Nothing to add
}

=head2 default

Default page.

=cut

sub default :Path {
    my ($self, $c) = @_;

    $c->detach('/default');
}

=encoding utf8

=head1 AUTHOR

Dag-Erling Smørgrav <des@FreeBSD.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
