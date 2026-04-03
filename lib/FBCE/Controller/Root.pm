use utf8;
package FBCE::Controller::Root;
use Moose;
use namespace::autoclean;

BEGIN { extends 'FBCE::Controller' }

#
# Sets the actions in this controller to be registered with no prefix
# so they function identically to actions created in MyApp.pm
#
__PACKAGE__->config(namespace => '');

=head1 NAME

FBCE::Controller::Root - Root Controller for FBCE

=head1 DESCRIPTION

[enter your description here]

=head1 METHODS

=head2 auto

Common code for all pages.

=cut

sub auto :Private {
    my ($self, $c) = @_;

    # Stash schedule information etc.
    $c->stash(title => $c->config->{'title'});
    $c->stash(descr => $c->config->{'descr'});
    my $schedule = $c->model('Schedule');
    foreach my $phase ("nominating", "voting") {
	foreach my $endpoint ("${phase}_starts", "${phase}_ends") {
	    $c->stash($endpoint => $schedule->{$endpoint});
	}
    }
    $c->stash(thisyear => $schedule->thisyear($c->now));
    $c->stash(announcement => $schedule->{'announcement'});
    $c->stash(investiture => $schedule->{'investiture'});
    $c->stash(nominating => $schedule->nominating($c->now));
    $c->stash(voting => $schedule->voting($c->now));
    $c->stash(announced => $schedule->announced($c->now));

    my $rules = $c->model('Rules');
    $c->stash(max_votes => $rules->{'max_votes'});

    # Active polls
    my $dtf = $c->model('FBCE::Poll')->result_source->schema->storage->datetime_parser;
    my $nowf = $dtf->format_datetime($c->now);
    if ($c->user_exists) {
	my $polls = $c->model('FBCE::Poll')->
	    search({ starts => { '<=', $nowf }, ends => { '>=', $nowf } });
	$c->stash(polls => $polls);
    }

    # Authentication
    if ($c->request->path !~ m/^(login|logout|bylaws|help|static\/.*)?$/) {
	if (!$c->user_exists) {
	    $c->stash(action => $c->uri_for());
	    $c->stash(template => 'login.tt');
	    return 0;
	}
    }

    return 1;
}

=head2 login

Display the login page and process login information

=cut

sub login :Local :Args(0) {
    my ($self, $c) = @_;

    my ($login, $password, $action) =
	@{$c->request->params}{'login', 'password', 'action'};
    if ($login && $password) {
	$c->authenticate({
	    login => $c->request->params->{'login'},
	    password => $c->request->params->{'password'}
	});
    }
    if ($c->user_exists) {
	$c->change_session_id();
	if ($action) {
	    $c->response->redirect($action);
	} else {
	    $c->response->redirect($c->uri_for('/'));
	}
	return;
    }
    $c->stash(action => $action);
}

=head2 logout

Log the user out and return to the front page

=cut

sub logout :Local :Args(0) {
    my ($self, $c) = @_;

    $c->logout();
    $c->response->redirect($c->uri_for('/'));
}

=head2 polls

List of active polls.

=cut

sub polls :Local :Args(0) {
    my ($self, $c) = @_;

    $c->stash(title => 'Active polls');
}

=head2 index

The root page (/)

=cut

sub index :Path :Args(0) {
    my ($self, $c) = @_;
}

=head2 index

Display the Project bylaws.

=cut

sub bylaws :Local :Args(0) {
    my ($self, $c) = @_;
}

=head2 help

Display help text.

=cut

sub help :Local :Args(0) {
    my ($self, $c) = @_;
}

=head2 wiki

Describe the WikiFormat syntax.

=cut

sub wiki :Local :Args(0) {
    my ($self, $c) = @_;
}

=head2 default

Standard 404 error page

=cut

sub default :Path {
    my ($self, $c) = @_;

    $c->response->body('Page not found');
    $c->response->status(404);
}

=head2 end

Attempt to render a view, if needed.

=cut

sub end : ActionClass('RenderView') {}

=head1 AUTHOR

Dag-Erling Smørgrav <des@FreeBSD.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
