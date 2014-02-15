<TMPL_INCLUDE NAME='inc/top.tpl'>

<div id=deck_list>
	<TMPL_LOOP NAME='deck_list'>
		<TMPL_LOOP NAME='deck_cahrs'>
			<TMPL_VAR NAME='name'>
		</TMPL_LOOP>
	</TMPL_LOOP>
</div>

<TMPL_INCLUDE NAME='inc/deck_helper.tpl'>

<script type="text/javascript">
	$(document).ready(
		function() {
		}
	);

</script>

<TMPL_INCLUDE NAME='inc/foot.tpl'>
