<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>

<bip:VerifUser page=""/>
<html:html locale="true"> 
<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript">
<% 
String id="";
session = request.getSession(false);

	if (session == null || session.getAttribute("UserBip") == null) {
		response.sendRedirect("/frameAccueil.jsp?redirect=O");
	}
 	else {
		com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
    	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
    	
    	if (menu==null) {
    		response.sendRedirect("/frameAccueil.jsp?redirect=O");
    	
    		}
    	else {
    		id =menu.getId();	
    		
    	}	
	}
%>

function ouvrirAide()
{
	var pageAide; 
	var param;
	
	param = "<%=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")))%>";
	if ((param=="null")||(param==""))
	{
		pageAide = "<%= com.socgen.bip.menu.BipMenuManager.getInstance().getMenuPageAide(id)%>";
    }
    else
    	pageAide = param;

	if (pageAide.substr(0,1) != "/")
    {
    	//alert("vide "+pageAide);
    	pageAide = "/"+pageAide;
	    
   	}
	//alert("vide>"+pageAide);
	window.open(pageAide, 'Aide', 'toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=500, height=400') ;
	
	return ;
}
</script>
<head>
	<title>Page vide !</title>
</head>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<body>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
 
        </table>
        </td>
        </tr>
   </table>
</body>
</html:html>