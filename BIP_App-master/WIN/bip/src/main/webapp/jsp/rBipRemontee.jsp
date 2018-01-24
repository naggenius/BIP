<%@ page language="java"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<bip:VerifUser page="frameAccueil.jsp"/>
<html:html>

<!--cap:authchk redir="jsp/login.jsp"/-->
<head>
	<title>Application BIP</title>
</head>
<frameset rows="35,*" border="0" framespacing="0" frameborder="YES" >
	<frame name="upload" src="rBipUpload.jsp" scrolling=auto noresize marginwidth=0 marginheight=2>
	<frame name="display" src="rBipDisplay.jsp" scrolling=auto noresize marginwidth=3 marginheight=0>
</frameset>
</html:html>