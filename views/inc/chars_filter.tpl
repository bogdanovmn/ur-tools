<form method=post>
	<fieldset>
		<legend>Clans</legend>
		<TMPL_LOOP NAME="filter_clans">
			<div class=clan_checkbox>
			<input type=checkbox <TMPL_IF NAME='checked'>checked</TMPL_IF> name=clan value="<TMPL_VAR NAME='clan_id'>">
			<img class=for_checkbox src="<TMPL_VAR NAME='clan_pic_url'>">
			</div>
		</TMPL_LOOP>
	</fieldset>
	
	<fieldset>
		<legend>Formats</legend>
		<input type=checkbox <TMPL_IF NAME='elo'>checked</TMPL_IF> name=elo>
		<img class=for_checkbox src="http://static.beta.urban-rivals.com/img/pillz.png">
		<input type=checkbox <TMPL_IF NAME='standard'>checked</TMPL_IF> name=standard>
		<img class=for_checkbox src="http://static.beta.urban-rivals.com/img/v2/icons/format_standard.png">
	</fieldset>

	<fieldset>
		<legend>Character params</legend>
		<table>
		<tr>
		<td>Min power: 
		<td>
			<select name='power'>
				<TMPL_LOOP NAME='filter_power_values'>
					<option <TMPL_IF NAME='selected'>selected</TMPL_IF> value='<TMPL_VAR NAME="power">'><TMPL_VAR NAME='power'></option>
				</TMPL_LOOP>
			</select>
		<tr>
		<td>Min damage: 
		<td>
			<select name='damage'>
				<TMPL_LOOP NAME='filter_damage_values'>
					<option <TMPL_IF NAME='selected'>selected</TMPL_IF> value='<TMPL_VAR NAME="damage">'><TMPL_VAR NAME='damage'></option>
				</TMPL_LOOP>
			</select>
		<tr>
		<td>Level: 
		<td>
			<TMPL_LOOP NAME='filter_level_values'>
				<input type=checkbox <TMPL_IF NAME='checked'>checked</TMPL_IF> name=level value="<TMPL_VAR NAME='level'>">
				<TMPL_VAR NAME=level>
			</TMPL_LOOP>
		</table>	
	</fieldset>

	<fieldset>
	<legend>Exclude ability prefix</legend>
	<TMPL_LOOP NAME=filter_ability_prefix>
		<input type=checkbox <TMPL_IF NAME=checked>checked</TMPL_IF> name=ability_prefix value="<TMPL_VAR NAME=prefix_id>">
		<TMPL_VAR NAME=prefix>
		<br>
	</TMPL_LOOP>
	</fieldset>

	<fieldset>
	<legend>Ability</legend>
	<TMPL_LOOP NAME='filter_ability'>
		<option <TMPL_IF NAME='selected'>selected</TMPL_IF> value='<TMPL_VAR NAME="rule_id">'>
			<TMPL_VAR NAME='rule'>
		</option>
		<input type=checkbox <TMPL_IF NAME=checked>checked</TMPL_IF> name=ability value="<TMPL_VAR NAME=rule_id>">
		<TMPL_VAR NAME=rule>
		<br>
	</TMPL_LOOP>
	</fieldset>

		<input type=submit name=filter value='Filter'>
</form>
