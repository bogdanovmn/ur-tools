<h2>Hello! You must <a href='/auth'>login</a> UR before begin work with our Service!</h2>

<TMPL_IF NAME='vars.error_msg'>
	<h2>Error</h2>
	<p><TMPL_VAR NAME='vars.error_msg'>
</TMPL_IF>
