create table collection (
	player_id int unsigned not null,
	char_id int unsigned not null,
	count int unsigned not null,
	PRIMARY KEY (player_id, char_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
