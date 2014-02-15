<TMPL_INCLUDE NAME='inc/top.tpl'>

<div id=filter_menu>
	<TMPL_INCLUDE NAME='inc/chars_filter.tpl'>
</div>

<div id=chars_list>
	<table class=chars id=chars>
	<thead>
	<tr>
		<th>Clan
		<th>Name
		<th><img src='http://static.beta.urban-rivals.com/img/v2/icons/cardstats/10x10/power.gif'>
		<th><img src='http://static.beta.urban-rivals.com/img/v2/icons/cardstats/10x10/damage.gif'>
		<th>Ability
		<th><img src='http://static.beta.urban-rivals.com/img/v2/card/small/star_on.png'>
		<th>Format
		<th>Price
		<th>Rate
	</thead>
	<tbody>
	<TMPL_LOOP NAME='chars'>
		<tr>
			<td>
				<span class=hidden><TMPL_VAR NAME='char_clan_mnemonic'></span>
				<img title='<TMPL_VAR NAME="char_bonus">' src='<TMPL_VAR NAME="char_clan_pic_url">'>
			<td><a target=_blank href='<TMPL_VAR NAME="ur_domain"><TMPL_VAR NAME="char_url">'><TMPL_VAR NAME="char_name"></a>
			<td><TMPL_VAR NAME="char_power">
			<td><TMPL_VAR NAME="char_damage">
			<td><TMPL_VAR NAME="char_ability">
			<td><TMPL_VAR NAME="char_level">
			<td>
				<TMPL_UNLESS NAME="char_is_valid_elo">
					<span class=hidden>elo</span>
					<img src="http://static.beta.urban-rivals.com/img/v2/icons/noelo.png">
				</TMPL_UNLESS>
				<TMPL_IF NAME="char_is_standard">
					<span class=hidden>std</span>
					<img src="http://static.beta.urban-rivals.com/img/v2/icons/format_standard.png">
				</TMPL_IF>
			<td class=price><TMPL_VAR NAME="char_price">
			<td class=rate><TMPL_VAR NAME="char_rate">
	</TMPL_LOOP>
	</tbody>
	</table>
</div>

<TMPL_INCLUDE NAME='inc/deck_helper.tpl'>

<script type="text/javascript">
	$(document).ready(
		function() {
			$("#chars").tablesorter({
				textExtraction: 'complex'
			});
		}
	);

</script>

<TMPL_INCLUDE NAME='inc/foot.tpl'>
