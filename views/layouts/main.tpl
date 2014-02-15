<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
        "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-type" content="text/html; charset=<TMPL_VAR NAME='settings.charset'>" />
<title>URHelper</title>
<link rel="stylesheet" href="<TMPL_VAR NAME='request.uri_base'>/css/style.css" />

<script type="text/javascript">/* <![CDATA[ */
    !window.jQuery && document.write('<script type="text/javascript" src="<TMPL_VAR NAME="request.uri_base">/javascripts/jquery.js"><\/script>')
/* ]]> */</script>

</head>
<body>
<TMPL_VAR NAME=content>
<div id="footer">
Powered by <a href="http://perldancer.org/">Dancer</a> <TMPL_VAR NAME=dancer_version>
</div>
</body>
</html>
