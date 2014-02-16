select d.*
from deck_char dc1 
join deck_char dc2 on dc1.deck_id = dc2.deck_id 
join gen_deck d on d.id = dc1.deck_id 
where dc1.char_id = 854 
and dc2.char_id = 645 
and d.elo 
and d.stars <= 17
order by d.stars
limit 20
