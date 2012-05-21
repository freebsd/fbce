--
-- $FreeBSD$
--

drop table if exists persons cascade;
create table persons (
        id serial primary key,
        login varchar not null,
        realname varchar null,
        password varchar not null,
        admin boolean not null default false,
	active boolean not null default false,
        incumbent boolean not null default false,
	voted boolean not null default false,
        votes integer not null default 0,
        unique(login)
);
insert into persons(login, realname, password, active, admin)
    values('des', 'Dag-Erling Smørgrav', '*', true, true);
insert into persons(login, realname, password, active, admin)
    values('kenneth36', 'Kenneth (36)', '*', true, false);

drop table if exists statements cascade;
create table statements (
        id serial primary key,
        person integer not null,
        short varchar(64) not null,
        long text not null,
        unique(person),
        foreign key(person) references persons(id) on delete cascade on update cascade
);

drop table if exists votes cascade;
create table votes (
        id serial primary key,
        voter integer not null,
        candidate integer not null,
        unique(voter, candidate),
        foreign key(voter) references persons(id) on delete cascade on update cascade,
        foreign key(candidate) references persons(id) on delete cascade on update cascade
);

drop view if exists results;
create view results as
    select persons.id, persons.login as login, persons.realname as realname, persons.incumbent, count(votes.*) as votes
    from persons join votes on persons.id = votes.candidate
    group by persons.id, persons.login, persons.realname, persons.incumbent;
