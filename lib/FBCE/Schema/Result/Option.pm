use utf8;
package FBCE::Schema::Result::Option;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FBCE::Schema::Result::Option

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<options>

=cut

__PACKAGE__->table("options");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'options_id_seq'

=head2 question

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 label

  data_type: 'varchar'
  is_nullable: 0
  size: 256

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "options_id_seq",
  },
  "question",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "label",
  { data_type => "varchar", is_nullable => 0, size => 256 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 poll_votes

Type: has_many

Related object: L<FBCE::Schema::Result::PollVote>

=cut

__PACKAGE__->has_many(
  "poll_votes",
  "FBCE::Schema::Result::PollVote",
  { "foreign.option" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 question

Type: belongs_to

Related object: L<FBCE::Schema::Result::Question>

=cut

__PACKAGE__->belongs_to(
  "question",
  "FBCE::Schema::Result::Question",
  { id => "question" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2026-04-01 13:37:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6T+VKMX16+IMHOQ8nXHmng

=head2 votes

Return votes cast for this option.  In list context, returns a list of
votes.  In scalar context, returns a resultset.

=cut

sub votes {
    my ($self) = @_;

    return wantarray() ? $self->votes_rs->all : $self->votes_rs;
}

=head2 votes_rs

Return votes cast for this option as a resultset.

=cut

sub votes_rs {
    my ($self) = @_;

    return $self->poll_votes_rs;
}

=head2 voters

Return persons who have voted for this option.  In list context,
returns a list of voters.  In scalar context, returns a resultset.

=cut

sub voters {
    my ($self) = @_;

    return wantarray() ? $self->voters_rs->all : $self->voters_rs;
}

=head2 voters_rs

Return persons who have voted for this option as a resultset.

=cut

sub voters_rs {
    my ($self) = @_;

    return $self->poll_votes->search_related_rs('voter', undef, { distinct => 1 });
}

__PACKAGE__->meta->make_immutable;
1;
