create table player (
	id int unsigned not null primary key,
	name varchar(100) not null,
	grade varchar(20) not null,
	locale char(2) not null,
	flag_url varchar(200) not null,
	url varchar(100) not null,
	clintz int unsigned not null,
	level int unsigned not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8
