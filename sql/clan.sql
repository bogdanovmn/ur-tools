create table clan (
	id int unsigned not null primary key,
	name varchar(100) not null,
	description varchar(255) not null,
	bonus_long_desc varchar(255) not null,
	bonus_desc varchar(255) not null,
	pic_url varchar(255) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8
