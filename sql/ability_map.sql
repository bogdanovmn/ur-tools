create table ability_map (
	char_id int unsigned not null primary key,
	prefix_id int unsigned default null,
	rule_id int unsigned not null,
	prefix varchar(20) default null,
	rule varchar(40) not null,
	x int default null,
	y int default null
) ENGINE=InnoDB DEFAULT CHARSET=utf8
