<%@ page language="java" import="java.util.*" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<bip:VerifUser page=""/>
<html:html>

<head>
	<title>Menu</title>
	<link rel="stylesheet" href="css/menu.css" type="text/css">
	<link rel="stylesheet" href="css/style_bip.css" type="text/css">
	<!-- link rel="stylesheet" href="css/base_style.css" type="text/css"-->
	<link rel="stylesheet" href="css/style_data.css" type="text/css">
	<script language="JavaScript" src="js/menu.js"></script>
	<script language="JavaScript">
		var couleur = null ;
		var titreMenu = null;
		var titreMenuInfo = null;
		var libMenu = null;
		<bip:menu/>

		function initMenu()
		{
			if (couleur != null)
			{
				document.bgColor = couleur ;
			}
			//libMenu = '<table width="100%"  border="1" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">';
			//libMenu += '<tr >';
  			//libMenu += '<td  class="TitreMenu" align="center">'+titreMenu+'</td>';
  			//libMenu += '</tr>';		
			//if (titreMenuInfo != null) {
			//     libMenu += '<tr><td class="TitreMenuInfo">'+titreMenuInfo+'</td></tr>';  	
			//}
		    //libMenu += '</table>';
		    document.all.divTitreMenu.innerHTML = libMenu  ;
			document.all.divMenu.innerHTML = menuAfficher();
		}
		
		if (code_page != null)
		{
			parent.main.location.href=code_page;
		}
	</script>

 
</head>
<body marginheight="0" marginwidth="0" leftmargin="0" topmargin="0" onLoad="initMenu()">
  <table width="100%" height="25" border="0" cellpadding="2" cellspacing="0" >
  <tr><td align="center">  <html:link page="/chgmenu.do?action=creer" target="_top"><img src="images/bip_logo.jpg" border="0"></html:link>
  </td></tr>
  </table>
  <div id="divTitreMenu"></div>
   
    
<br>
<div id="divMenu"></div>
<span class="CanalSG"> 
    <table width="90%" border="0" cellspacing="0" cellpadding="0">
      <tr> 
        <td nowrap  align="center">
        <a href="#" target="_top" class="OptionMenuOpen1" onClick="top.close()" ><img src="/images/exit.gif" border="0" align="middle" alt="Quitter l'application"></a>&nbsp;&nbsp;&nbsp;&nbsp;
        <A HREF="http://monportail.socgen/web/guest/home" target="_top"><IMG SRC="images/logoLePortail.gif" BORDER="0" ALIGN="MIDDLE" ALT="Retour vers Le Portail"></A></td>
      </tr>
    </table>
</span>

<% 
String libEnv = null;
try {
	libEnv = com.socgen.bip.commun.Tools.getSysProperties().getProperty(com.socgen.bip.commun.BipConstantes.MENU_LIB_ENV); 
} catch (java.lang.Exception excep) {
}
if (libEnv != null) {
%>

<br /><br /><br />
<span> 
    <table width="90%" border="1" cellspacing="1" cellpadding="1">
      <tr> 
        <td align="center"><b><%=libEnv%></b></td>
      </tr>
      <tr> 
        <td align="center"><b>Version 8.4</b></td>
      </tr>
    </table>
</span>

<%	} %>

</body>
</html:html>