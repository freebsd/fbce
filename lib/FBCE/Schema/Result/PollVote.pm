use utf8;
package FBCE::Schema::Result::PollVote;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FBCE::Schema::Result::PollVote

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

=head1 TABLE: C<poll_votes>

=cut

__PACKAGE__->table("poll_votes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'poll_votes_id_seq'

=head2 voter

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 question

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 option

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "poll_votes_id_seq",
  },
  "voter",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "question",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "option",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<poll_votes_voter_option_key>

=over 4

=item * L</voter>

=item * L</option>

=back

=cut

__PACKAGE__->add_unique_constraint("poll_votes_voter_option_key", ["voter", "option"]);

=head1 RELATIONS

=head2 option

Type: belongs_to

Related object: L<FBCE::Schema::Result::Option>

=cut

__PACKAGE__->belongs_to(
  "option",
  "FBCE::Schema::Result::Option",
  { id => "option" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
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

=head2 voter

Type: belongs_to

Related object: L<FBCE::Schema::Result::Person>

=cut

__PACKAGE__->belongs_to(
  "voter",
  "FBCE::Schema::Result::Person",
  { id => "voter" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2026-04-01 13:37:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:H146MwQhvYNBn2yLrq/OOw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
