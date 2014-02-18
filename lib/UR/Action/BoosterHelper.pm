package UR::Action::BoosterHelper;

use strict;
use warnings;
use utf8;

use UR::Store;
use Utils;


sub main {
	my ($class, $params) = @_;
	
	my $player_id = $params->{player_id};
	
	return {
		new_blood => $class->_new_blood($params)
	};
}

sub _new_blood {
	my ($class, $params) = @_;
	
	return UR::Store->connect->query(qq|
		SELECT 
			CH.id char_id,
			CH.name char_name,
			DATE_FORMAT(CH.release_date, '%Y-%m-%d') char_release_date,
			CH.power char_power,
			CH.damage char_damage,
			CH.ability char_ability,
			CL.bonus_desc char_bonus,
			CH.pic_url char_pic_url,
			CH.url char_url,
			CH.rarity char_rarity,
			CH.level char_level,
			CH.is_valid_elo char_is_valid_elo,
			CH.is_standard char_is_standard,
			P.min char_min_price,
			P.avg char_avg_price,
			P.max char_max_price,
			IFNULL(C.count, 0) char_count,
			CL.pic_url char_clan_pic_url,
			SUBSTRING_INDEX(
				SUBSTRING_INDEX(CL.pic_url, '/', -1),
				'_',
				1
			) char_clan_mnemonic

		FROM chars CH
		JOIN clan CL ON CL.id = CH.clan_id
		LEFT JOIN collection C ON C.char_id = CH.id AND C.player_id = ?
		LEFT JOIN prices P ON P.char_id = CH.id
		WHERE CH.distrib
		ORDER BY CH.id DESC
		LIMIT 50
		|,
		[ $params->{player_id} ],
	);
}

1;
