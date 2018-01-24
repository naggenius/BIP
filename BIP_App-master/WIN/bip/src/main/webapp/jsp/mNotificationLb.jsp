<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneInvestissementForm" scope="request" class="com.socgen.bip.form.LigneInvestissementForm" />
<jsp:useBean id="centreActivite" scope="request" class="com.socgen.bip.metier.CentreActivite" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />


<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mNotificationLb.jsp"/> 
<%  
com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip");  

String ca_suivi="";
Vector v = new Vector();
v=userbip.getCa_suivi();

for (Enumeration e = v.elements(); e.hasMoreElements();) {
	ca_suivi +=',' +(String) e.nextElement();
}


java.util.Hashtable hP = new java.util.Hashtable();
hP.put("ca_suivi", ca_suivi);

java.util.ArrayList liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca_inv_g",hP); 
pageContext.setAttribute("choixCA", liste);    
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
	var blnVerification = true;
	<%
		String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	%>
	var pageAide = "<%= sPageAide %>";
	
	var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';
	
	var anneeInterdite = parseInt(anneeCourante) - 1;
	
	function MessageInitial()
	{   
		var Message="<bean:write filter="false"  name="ligneInvestissementForm"  property="msgErreur" />";
		var Focus = "<bean:write name="ligneInvestissementForm"  property="focus" />";	   	   
		
		if (Message != "") {
		alert(Message);
		}
		if (Focus != "") {
		(eval( "document.forms[0]."+Focus )).focus();
		}
		
		document.forms[0].annee.value = anneeCourante;
	}
	
	function Verifier(form, action, mode, flag)
	{
	   blnVerification = flag;
	   form.mode.value = mode;
	   form.action.value = action;   
	}
	
	function ValiderEcran(form)
	{
	   index = form.codcamo.selectedIndex;
	   libelle = form.codcamo.options[index].text;	
	   
	   
	   message = "Voulez-vous notifier le centre d'activité " + libelle + " ?";
	   if (blnVerification) {
		if (form.annee && !ChampObligatoire(form.annee, "l\'année d'exercice")) return false;		
		if (!confirm(message)) return false;     
	   }	   
	   
	   return true;
	}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();ChargeCa('<%=userbip.getCodcamoCourant()%>','codcamo',document.forms[0]);">
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
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          	Notification des demandes budg&eacute;taires<!-- #EndEditable -->
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/notiflb"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->         
                                  
            <div align="center"><!-- #BeginEditable "contenu" -->
		<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		<html:hidden property="titrePage"/>
		<html:hidden property="action"/>
		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		<html:hidden property="flaglock"/>				
		    
              <table widht="90%" cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <!-- ANNEE EXERCICE -->
                <tr> 
                  <td class="lib"><b>Date exercice :</b></td>
                  <td><b><html:text property="annee" styleClass="input" size="4" maxlength="4" onchange="return VerifierDate(this,'aaaa');"/>
                  	</b>                    
                  </td>                  
                </tr>
		<tr> 
                  <td>&nbsp;</td>                  
                </tr>
                <!-- CA -->
                <tr> 
                  <td class="lib" width="27%"><b>Centre d'activit&eacute; :</b></td>
                  <td > 
                    <html:select property="codcamo" styleClass="input"> 
                	<html:options collection="choixCA" property="cle" labelProperty="libelle" />
                    </html:select>
                  </td>                 
                </tr>                
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
              </table>
              <!-- fin template -->
              <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%">&nbsp;</td>                
                <td width="25%">                
                  <div align="center"> <html:submit property="boutonValider" value="Notifier" styleClass="input" onclick="Verifier(this.form, 'valider', 'notify',true);"/> 
                  </div>
                </td>   
                <%--             
                <td width="25%">                
                  <div align="center">                  	
                  	<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', 'suite', false);"/> 
                  </div>                
                </td>   
                --%>                  
                <td width="25%">&nbsp;</td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
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
</body></html:html>
<!-- #EndTemplate -->
