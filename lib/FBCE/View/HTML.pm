use utf8;
package FBCE::View::HTML;
use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    ENCODING => 'utf-8',
    render_die => 1,
);

=head1 NAME

FBCE::View::HTML - TT View for FBCE

=head1 DESCRIPTION

TT View for FBCE.

=head1 SEE ALSO

L<FBCE>

=head1 AUTHOR

Dag-Erling Smørgrav <des@freebsd.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

# $FreeBSD$
