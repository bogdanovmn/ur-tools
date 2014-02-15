<div class="cardNewDiv" style="opacity: 1; left: 0px;">
	<div class="sprite-cards bg_<TMPL_VAR NAME='char_rarity'> iepng">
		<div class="cardNewName"><TMPL_VAR NAME='char_name'></div>
		<a href="<TMPL_VAR NAME='char_pic_url'>" class="lightbox remooz-element">
			<img class="cardNewPict" src="<TMPL_VAR NAME='char_pic_url'>">
		</a>
		<div class="cardNewClanMask sprite-cards clanmask iepng"></div>
		<a href="<TMPL_VAR NAME='ur_domain'>/characters/list.php?show=27">
			<span class="sprite-clans <TMPL_VAR NAME='char_clan_mnemonic'>_160 iepng cardNewClanPict"></span>
		</a>
		<div class="cardNewFirstStar sprite-cards lvl<TMPL_VAR NAME='char_level'> iepng"></div>
		<div class="cardNewPH"><TMPL_VAR NAME='char_power'></div>
		<div class="cardNewPDD"><TMPL_VAR NAME='char_damage'></div>
		<div class="cardNewPower">
			<div class="vcenterAround">
				<div class="vcenterInside">
					<div class="vcenterContent"><TMPL_VAR NAME='char_ability'></div>
				</div>
			</div>
		</div>
	<div class="cardNewBonus">
		<div class="vcenterAround">
			<div class="vcenterInside">
				<div class="vcenterContent"><TMPL_VAR NAME='char_bonus'></div>
			</div>
		</div>
	</div>
<div class="cardMinPrice iepng">
	<div class="sprite-cards clintz_left"></div>
	<div class="sprite-cards clintz_middle"><TMPL_VAR NAME='char_price'> Clintz</div>
	<div class="sprite-cards clintz_right"></div>
</div></div></div>
