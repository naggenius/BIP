<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="affectationForm" scope="request" class="com.socgen.bip.form.AffectationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/affectation.do"/>  
<%  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_restache",affectationForm.getHParams());
    pageContext.setAttribute("choixStache", list1);
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="affectationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="affectationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

}

function getSelectValue()
{
	
	var elmt = document.getElementById("sous_tacheMulti");

	//elmt.type != 'select-multiple'
	if(elmt.multiple == false)
	{
		return elmt.options[elmt.selectedIndex].value;
	}
	var values = "";
	for(var i=0; i< elmt.options.length; i++)
	{
		if(elmt.options[i].selected == true)
		{
						
			values = values.concat(elmt.options[i].value+"/");
			
		}
	}	
	values = values.substring(0,values.length-1);
	
	document.getElementById("SelectConcat").value = values;
		
}

function Verifier(form, action, mode, flag)
{
   getSelectValue();
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form)
{
	if (blnVerification)
	{
		if (form.sous_tache.selectedIndex==-1)
		{
			alert('Choisissez une sous-tâche');
			return (false);
		}
		<!--if (!confirm("Attention : la suppression d'une sous-tâche affectée à une ressource entraîne la suppression\ndes consommés qui lui sont associés !\nVoulez-vous vraiment supprimer cette sous-tâche ?")) return false;-->
	}
   return true;
}


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
		  <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Les sous-t&acirc;ches d'une ressource<!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/affectation"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div id="content">
			<table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
                    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    
                  	<html:hidden property="action"/>
		            <html:hidden property="mode"/>
				    <html:hidden property="SelectConcat" id="SelectConcat" value =""/>
					<html:hidden property="arborescence" value="<%= arborescence %>"/>
		            <html:hidden property="keyList0"/> <!--ident-->
		            <html:hidden property="choix_filtre"/>
		            <html:hidden property="ident"/>
		            
                    <table border="0" cellpadding="2" cellspacing="2" class="TableBleu" >
                       <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
                        <td align=center colspan="4" class='texte'><b>Ressource : <bean:write name="affectationForm"  property="ressource" /><html:hidden property="ressource"/></b> 

                        </td>
                      </tr>
                      <tr> 
                        <td >&nbsp;</td>
                      </tr>
                      <tr> 
						  <td colspan="4">
							<table border="0" cellpadding="2" cellspacing="0" class="TableBleu" width="700"> 
								<tr> 
									<td align=center colspan="6" class='texte'> <b>Liste des sous-tâches : </b></td>
								</tr>
								<tr> 
									<td class="texteGras" width="7">Ligne BIP
									</td>
									<td class="texteGras" width="192">Etape
									</td>
									<td class="texteGras" >Type
									</td>
									<td class="texteGras" width="203">Tâche
									</td>
									<td class="texteGras" width="205">Sous-tâche
									</td>
									<td class="texteGras" width="70">Type
									</td>
								</tr>
								<tr> 
									<td align=center colspan="6" width="700">
										<html:select property="sous_tacheMulti" multiple="true" size="10" styleClass="Multicol">
											<bip:options collection="choixStache"/>
										</html:select>
									</td>
								</tr>
								<tr>
									<td >&nbsp;</td>
								</tr>
								<tr>
									<td >&nbsp;</td>
								</tr>
							</table>
						  </td>
                      </tr>
					  <tr colspan="4"> 
					  	<td width="25%">&nbsp;</td>
						<td width="25%" align="center"> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'valider', 'delete',true);"/> 
						</td>
						<td width="25%" align="center"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'retour', 'delete', false);"/>
						</td>
						<td width="25%">&nbsp;</td>
					  </tr>
					</table>
				<!-- #EndEditable --></div>
                </td>
              </tr>
            </table>
            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
          </div>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("6005"); 
com.socgen.bip.commun.form.AutomateForm formWebo = affectationForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
