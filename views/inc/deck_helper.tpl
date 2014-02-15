<div id=deck_helper>
	<div id=dh_title>
		Deck Helper
	</div>

	<div id=dh_menu>
		<select name='foramt'>
			<option value='elo'>ELO</option>
		</select>
	<div>

	<div id=dh_chars>
		<TMPL_LOOP NAME="selected_cahrs">
			<div id="sc_<TMPL_VAR NAME='sc_char_id'>">
				<TMPL_VAR NAME="sc_name">
			</div>
		</TMPL_LOOP>
	</div>

	<div id=dh_info>
		...info...
	</div>
</div>
