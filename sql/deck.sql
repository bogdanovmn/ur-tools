create table gen_deck (
	id bigint unsigned not null primary key,
	clan_id int unsigned not null,
	stars int unsigned not null,
	common_count int unsigned not null,
	uncommon_count int unsigned not null,
	rare_count int unsigned not null,
	legend_count int unsigned not null,
	cr_count int unsigned not null,
	rate int not null,
	elo tinyint not null,
	standard tinyint not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table deck_char (
	deck_id bigint unsigned not null,
	char_id int unsigned not null,
	unique (deck_id, char_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8
