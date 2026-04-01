use utf8;
package FBCE::Schema::Result::Result;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FBCE::Schema::Result::Result

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");
__PACKAGE__->table_class("DBIx::Class::ResultSource::View");

=head1 TABLE: C<results>

=cut

__PACKAGE__->table("results");
__PACKAGE__->result_source_instance->view_definition(" SELECT persons.id,\n    persons.login,\n    persons.realname,\n    persons.incumbent,\n    count(votes.*) AS votes\n   FROM (persons\n     JOIN votes ON ((persons.id = votes.candidate)))\n  GROUP BY persons.id, persons.login, persons.realname, persons.incumbent");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 login

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 realname

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 incumbent

  data_type: 'boolean'
  is_nullable: 1

=head2 votes

  data_type: 'bigint'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "login",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "realname",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "incumbent",
  { data_type => "boolean", is_nullable => 1 },
  "votes",
  { data_type => "bigint", is_nullable => 1 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2026-02-20 17:52:39
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rcNyYf9VVRMsaGHHpLO+2g

1;
