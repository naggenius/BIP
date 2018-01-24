<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="editionForm" scope="request" class="com.socgen.bip.commun.form.EditionForm" />
<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eMonProfilAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();

<%
	String sTitre;
	String sInitial;
	String sJobId="eMonProfilAd";
	
	String sNom;								// P_PARAM6
	String sPrenom;								// p_PARAM7
	String sMenus;								// P_PARAM8
	String sSSMenus="ssmenu1;ssmenu2;ssmenu3";	// P_PARAM9
	String sCA=null;							// P_PARAM10
	String sliste_centre_frais = null;			// P_PARAM11
	
	
	com.socgen.bip.user.UserBip uBip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");
	java.util.Vector vMenus = uBip.getListeMenuConfig();	
	//java.util.Vector vSSMenus = uBip.getListeBipItem();
	java.util.Vector vSSMenus = com.socgen.bip.menu.BipMenuManager.getInstance().getListeBipItemConfig(uBip.getSousMenus());
	com.socgen.bip.menu.item.BipItem bI;
	com.socgen.bip.menu.item.BipItemMenu bIM;

	
	sNom = uBip.getNom();
	sPrenom = uBip.getPrenom();	
	sliste_centre_frais = uBip.getListe_Centres_Frais();
	
	
	/*
	 * Construction de la liste des CA du suivi des investissements
	 */
	java.util.Vector vCA = uBip.getCa_suivi();

	sCA = "";
	if (vCA != null && vCA.size() > 0)
	{
		for (int i=0; i< vCA.size(); i++)
		{
			if (i == (vCA.size()-1))
				sCA += (String)vCA.get(i);
			else
				sCA += (String)vCA.get(i) + ",";
		}
	}
	
	/*
	 * Construction de la liste des libellés des menus
	 * La liste est deja triée !! :)
	 */
	sMenus = "";	
	if (vMenus != null)
	for (int i=0; i < vMenus.size(); i++)
	{
		if (i == (vMenus.size()-1))
			sMenus += vMenus.get(i);
		else
			sMenus += vMenus.get(i) + ";";
	}
    
    sMenus = com.socgen.bip.commun.Tools.remplaceQuoteEspace(sMenus);
	
	/*
	 * Construction de la liste des libellés des sous-menus
	 * La liste est deja triée !! :)
	 */
	sSSMenus = "";
	if (vSSMenus != null)
	for (int i=0; i < vSSMenus.size(); i++)
	{
		if (i == (vSSMenus.size()-1))
			sSSMenus += vSSMenus.get(i);
		else
			sSSMenus += vSSMenus.get(i) + ";";
	}
    sSSMenus = com.socgen.bip.commun.Tools.remplaceQuoteEspace(sSSMenus);

%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	var Message="<bean:write filter="false"  name="editionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="editionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  //form.BOUTON.value = bouton;
}

function ValiderEcran(form)
{
	document.editionForm.submit.disabled = true;
	return true;
}

</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
           &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/edition"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
			<!-- #BeginEditable "debut_hidden" -->
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<input type="hidden" name="jobId" value="<%=sJobId%>">				
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="p_param6" value="<%= sNom %>">
            <input type="hidden" name="p_param7" value="<%= sPrenom %>">
            <input type="hidden" name="p_param8" value="<%= sMenus %>">
            <input type="hidden" name="p_param9" value="<%= sSSMenus %>">
            <input type="hidden" name="p_param10" value="<%= sCA %>">
            <input type="hidden" name="p_param11" value="<%= sliste_centre_frais %>">
			<!-- #EndEditable -->
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center" height="20">&nbsp;</td>
                      </tr>
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					<!-- #EndEditable -->
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
                </tr>
            
            </table>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html>

<!-- #EndTemplate -->