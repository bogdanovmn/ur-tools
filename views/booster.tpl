<h2>New blood</h2>

<table class=chars id=chars>
<thead>
<tr>
	<th>id
	<th>Release
	<th>Clan
	<th>Name
	<th><img src='http://static.beta.urban-rivals.com/img/v2/icons/cardstats/10x10/power.gif'>
	<th><img src='http://static.beta.urban-rivals.com/img/v2/icons/cardstats/10x10/damage.gif'>
	<th>Ability
	<th><img src='http://static.beta.urban-rivals.com/img/v2/card/small/star_on.png'>
	<th>Format
	<th>Min price
	<th>Avg price
	<th>Max price
	<th>Count
</thead>
<tbody>
<TMPL_LOOP NAME=new_blood>
	<tr> 
		<td class='bg_rarity_<TMPL_VAR NAME=char_rarity>'><TMPL_VAR NAME=char_id>
		<td><TMPL_VAR NAME=char_release_date>
		<td>
			<span class=hidden><TMPL_VAR NAME=char_clan_mnemonic></span>
			<img title='<TMPL_VAR NAME=char_bonus>' src='<TMPL_VAR NAME=char_clan_pic_url>'>
		<td><a target=_blank href='<TMPL_VAR NAME=ur_domain><TMPL_VAR NAME=char_url>'><TMPL_VAR NAME=char_name></a>
		<td><TMPL_VAR NAME=char_power>
		<td><TMPL_VAR NAME=char_damage>
		<td><TMPL_VAR NAME=char_ability>
		<td><TMPL_VAR NAME=char_level>
		<td>
			<TMPL_UNLESS NAME=char_is_valid_elo>
				<span class=hidden>elo</span>
				<img src="http://static.beta.urban-rivals.com/img/v2/icons/noelo.png">
			</TMPL_UNLESS>
			<TMPL_IF NAME=char_is_standard>
				<span class=hidden>std</span>
				<img src="http://static.beta.urban-rivals.com/img/v2/icons/format_standard.png">
			</TMPL_IF>
		<td class=price><TMPL_VAR NAME=char_min_price>
		<td class=price><TMPL_VAR NAME=char_avg_price>
		<td class=price><TMPL_VAR NAME=char_max_price>
		<td class=rate><TMPL_VAR NAME=char_count>
</TMPL_LOOP>
</tbody>
</table>

<script type="text/javascript">
$(document).ready(
	function() {
		$("#chars").tablesorter({
			textExtraction: 'complex'
		});
	}
);
</script>
