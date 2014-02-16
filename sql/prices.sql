create table prices (
	char_id int unsigned not null primary key,
	min int unsigned default null,
	max int unsigned default null,
	avg int unsigned default null,
	update_time timestamp not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8
