use utf8;
package Template::Plugin::Boolean;

=head1 NAME

Template::Plugin::Boolean

=cut

use strict;
use warnings;
use base 'Template::Plugin::Filter';

=head1 DESCRIPTION

L<Template::Toolkit> filter plugin that formats a value as a boolean

=head1 METHODS

=head2 init

The initialization function.

=cut

sub init {
    my ($self) = @_;

    my $name = $self->{_CONFIG}->{name} || 'boolean';
    $self->{_DYNAMIC} = 1;
    $self->install_filter($name);
    return $self;
}

=head2 filter

The filter function.

=cut

sub filter {
    my ($self, $raw) = @_;

    return $raw ? "true" : "false";
}

=head1 AUTHOR

Dag-Erling Smørgrav <des@FreeBSD.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
