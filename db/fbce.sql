--
-- Database schema for FreeBSD Core Elections
--

drop table if exists persons cascade;
create table persons (
        id serial primary key,
        login varchar not null,
        realname varchar null,
        password varchar not null default '*',
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

--
-- Elections
--

drop table if exists statements cascade;
create table statements (
        id serial primary key,
        person integer not null,
        short varchar(64) not null,
        long text not null,
        unique(person),
        foreign key(person) references persons(id) on delete cascade on update cascade
);

drop table if exists core_votes cascade;
create table core_votes (
        id serial primary key,
        voter integer not null,
        candidate integer not null,
        unique(voter, candidate),
        foreign key(voter) references persons(id) on delete cascade on update cascade,
        foreign key(candidate) references persons(id) on delete cascade on update cascade
);

drop view if exists results;
create view results as
    select persons.id, persons.login as login, persons.realname as realname, persons.incumbent, count(core_votes.*) as votes
    from persons join core_votes on persons.id = core_votes.candidate
    where votes > 0
    group by persons.id, persons.login, persons.realname, persons.incumbent;

--
-- Polls
--

drop table if exists polls cascade;
create table polls (
        id serial primary key,
        owner integer not null,
        title varchar(64) not null,
        starts timestamp not null,
        ends timestamp not null,
        synopsis varchar(256) not null,
        long text not null,
        unique(title),
        foreign key(owner) references persons(id) on delete cascade on update cascade
);

drop table if exists questions cascade;
create table questions (
        id serial primary key,
        poll integer not null,
        rank integer not null,
        short varchar(256) not null,
        long text not null,
        min_options integer not null default 1,
        max_options integer not null default 1,
        unique (poll, rank),
        foreign key(poll) references polls(id) on delete cascade on update cascade
);

drop table if exists options cascade;
create table options (
        id serial primary key,
        question integer not null,
        label varchar(256) not null,
        foreign key(question) references questions(id) on delete cascade on update cascade
);

drop table if exists poll_votes cascade;
create table poll_votes (
        id serial primary key,
        voter integer not null,
        question integer not null,
        option integer not null,
        unique(voter, option),
        foreign key(voter) references persons(id) on delete cascade on update cascade,
        foreign key(question) references questions(id) on delete cascade on update cascade,
        foreign key(option) references options(id) on delete cascade on update cascade
);
