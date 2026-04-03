use utf8;
package FBCE::Controller::Result;
use Moose;
use namespace::autoclean;

BEGIN { extends 'FBCE::Controller' }

=head1 NAME

FBCE::Controller::Result - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;

    $c->stash(voters => $c->model('FBCE::Person')->
	      search_rs({ active => 1 }, { order_by => 'login' }));
    $c->stash(candidates => $c->model('FBCE::Statement')->
	      search_related_rs('person', {}, { order_by => 'login' }));
    if ($c->stash->{'announced'}) {
	$c->stash(voted => $c->model('FBCE::CoreVote')->
		  search_related_rs('voter', {}, { distinct => 1 })->count);
	$c->stash(votes => $c->model('FBCE::CoreVote')->count);
	$c->stash(results => $c->model('FBCE::Result')->
		  search_rs(undef, { order_by => [ { -desc => 'votes' }, { -asc => 'login' } ] }));
    } else {
	$c->stash(voted => 0, votes => 0, results => undef);
    }
}


=head1 AUTHOR

Dag-Erling Smørgrav <des@FreeBSD.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
