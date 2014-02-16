explain select count(*) 
from (
	select distinct dc1.deck_id, d.stars
	from deck_char dc1 
	join deck_char dc2 on dc1.deck_id = dc2.deck_id 
	join gen_deck d on d.id = dc1.deck_id 
	where dc1.char_id = 854 
	and dc2.char_id = 645 
	and d.clan_id = 44
	and d.elo 
	and d.stars <= 17
) d1
cross join (
	select distinct dc1.deck_id, d.stars 
	from deck_char dc1 
	join deck_char dc2 on dc1.deck_id = dc2.deck_id 
	join gen_deck d on d.id = dc1.deck_id 
	where dc1.char_id = 597 
	and dc2.char_id = 600 
	-- and d.clan_id = 44
	and d.elo 
	and d.stars <= 17
) d2
-- join gen_deck gd1 on d1.deck_id = gd1.id
-- join gen_deck gd2 on d2.deck_id = gd2.id
where (d1.stars + d2.stars) = 25
