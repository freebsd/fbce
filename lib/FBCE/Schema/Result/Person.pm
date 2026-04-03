use utf8;
package FBCE::Schema::Result::Person;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

FBCE::Schema::Result::Person

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

=head1 TABLE: C<persons>

=cut

__PACKAGE__->table("persons");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'persons_id_seq'

=head2 login

  data_type: 'text'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 realname

  data_type: 'text'
  is_nullable: 1
  original: {data_type => "varchar"}

=head2 password

  data_type: 'text'
  default_value: '*'
  is_nullable: 0
  original: {data_type => "varchar"}

=head2 admin

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 active

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 incumbent

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 voted

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=head2 votes

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "persons_id_seq",
  },
  "login",
  {
    data_type   => "text",
    is_nullable => 0,
    original    => { data_type => "varchar" },
  },
  "realname",
  {
    data_type   => "text",
    is_nullable => 1,
    original    => { data_type => "varchar" },
  },
  "password",
  {
    data_type     => "text",
    default_value => "*",
    is_nullable   => 0,
    original      => { data_type => "varchar" },
  },
  "admin",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "active",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "incumbent",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "voted",
  { data_type => "boolean", default_value => \"false", is_nullable => 0 },
  "votes",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<persons_login_key>

=over 4

=item * L</login>

=back

=cut

__PACKAGE__->add_unique_constraint("persons_login_key", ["login"]);

=head1 RELATIONS

=head2 core_votes_candidates

Type: has_many

Related object: L<FBCE::Schema::Result::CoreVote>

=cut

__PACKAGE__->has_many(
  "core_votes_candidates",
  "FBCE::Schema::Result::CoreVote",
  { "foreign.candidate" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 core_votes_voters

Type: has_many

Related object: L<FBCE::Schema::Result::CoreVote>

=cut

__PACKAGE__->has_many(
  "core_votes_voters",
  "FBCE::Schema::Result::CoreVote",
  { "foreign.voter" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 poll_votes

Type: has_many

Related object: L<FBCE::Schema::Result::PollVote>

=cut

__PACKAGE__->has_many(
  "poll_votes",
  "FBCE::Schema::Result::PollVote",
  { "foreign.voter" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 polls

Type: has_many

Related object: L<FBCE::Schema::Result::Poll>

=cut

__PACKAGE__->has_many(
  "polls",
  "FBCE::Schema::Result::Poll",
  { "foreign.owner" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 statement

Type: might_have

Related object: L<FBCE::Schema::Result::Statement>

=cut

__PACKAGE__->might_have(
  "statement",
  "FBCE::Schema::Result::Statement",
  { "foreign.person" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2026-04-01 13:37:09
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mCP8lTGvbveQ/M0ddcWixA

use Crypt::SaltedHash;
use Digest::MD5 qw(md5_hex);

#
# Change the password.
#
sub set_password {
    my ($self, $password) = @_;

    if ($password !~ m/^[[:print:]]{8,}$/a || $password !~ m/[0-9]/a ||
	$password !~ m/[A-Z]/a || $password !~ m/[a-z]/a) {
	die("Your password must be at least 8 characters long and contain" .
	    " at least one upper-case letter, one lower-case letter and" .
	    " one digit.\n");
    }
    my $csh = new Crypt::SaltedHash(algorithm => 'SHA-256');
    $csh->add($password);
    $self->set_column(password => $csh->generate());
    $self->update()
	if $self->in_storage();
}

#
# Check the password.
#
sub check_password {
    my ($self, $password) = @_;

    return Crypt::SaltedHash->validate($self->password, $password);
}

#
# Reset the password.
#
sub reset_password {
    my ($self) = @_;

    $self->set_column(password => '*');
    $self->update()
	if $self->in_storage();
}

#
# Pretty name
#
sub name {
    my ($self) = @_;

    return $self->realname || ($self->login . '@freebsd.org');
}

#
# Commit votes
#
sub commit {
    my ($self) = @_;

    my $schema = $self->result_source->schema;
    $schema->txn_do(sub {
	my $votes = $self->votes_voters;
	while (my $vote = $votes->next) {
	    $vote->candidate->votes++;
	    $vote->delete;
	}
    });
}

#
# Email address
#
sub email {
    my ($self) = @_;

    return $self->login . "\@freebsd.org";
}

#
# Gravatar URL
#
sub gravatar {
    my ($self, $scheme) = @_;

    my $md5 = md5_hex($self->email);
    if ($scheme eq 'https') {
	return "https://secure.gravatar.com/avatar/$md5";
    } else {
	return "http://www.gravatar.com/avatar/$md5";
    }
}

1;


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
