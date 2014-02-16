create table player_access_keys (
	player_id int unsigned not null primary key,
	token varchar(255) not null,
	token_secret varchar(255) not null,
	update_time timestamp not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8
