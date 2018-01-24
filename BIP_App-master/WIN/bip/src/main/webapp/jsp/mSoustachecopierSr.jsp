<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="copierCollerSousTacheForm" scope="request" class="com.socgen.bip.form.CopierCollerSousTacheForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fSoustachecopierSr.jsp"/> 
<%  
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_sstachelb_copier",copierCollerSousTacheForm.getHParams());
    pageContext.setAttribute("choixSousTache", list1);
    java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_sstachelb_coller",copierCollerSousTacheForm.getHParams());
    pageContext.setAttribute("choixTache", list2);
%> 

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="copierCollerSousTacheForm"  property="msgErreur" />";
   var Focus = "<bean:write name="copierCollerSousTacheForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;

} 
function ValiderEcran(form)
{  if (blnVerification) {

		if (form.sous_tache.selectedIndex==-1 )  {
			alert('Choisissez une sous-tâche');
			return (false);
		}
		
		if (form.tache.selectedIndex==-1 )  {
			alert('Choisissez une tâche');
			return (false);
		}
		else {
			index = form.tache.selectedIndex;
		   	libelle = form.tache.options[index].text;
			return true;	
		}

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
						<%=tb.printHtml()%>	<!-- #EndEditable -->
					</div>
				  </td>
				</tr>
				<tr> 
				  <td>&nbsp;</td>
				</tr>
				<tr> 
				  <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Copier-Coller de sous-t&acirc;che<!-- #EndEditable --></div></td>
				</tr>
				<tr> 
					<td> 
					<div id="content">
					<!-- #BeginEditable "debut_form" --> <html:form action="/copiercoller"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
					<div align="center"><!-- #BeginEditable "contenu" -->
					<html:hidden property="action"/>
					<html:hidden property="mode"/>
					<html:hidden property="arborescence" value="<%= arborescence %>"/>
					<html:hidden property="affecter"/>
					<html:hidden property="mois"/>
					<html:hidden property="keyList0"/> <!--pid_src-->
					<html:hidden property="keyList1"/> <!--pid_dest-->             
			
					<table width="60%" border="0" cellpadding="2" cellspacing="0" class="TableBleu" > 
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
							<td colspan="3" class="texte"	>
								<b>Choisir la sous-tâche &agrave; copier : 
								(ligne <bean:write name="copierCollerSousTacheForm"  property="pid_src" />)</b>
								<html:hidden property="pid_src"/>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
							<td align="center" colspan="3"> 
								<table width="100%" border="0">
									<tr> 
										<td class="texteGras" width="33%">Etape</td>
										<td class="texteGras" width="32%">Tâche</td>
										<td class="texteGras" width="35%">Sous-tâche</td>                    
									</tr>
									<tr>
										<td colspan="3">
											<html:select property="sous_tache" styleClass="Multicol" size="5">
											  <bip:options collection="choixSousTache"/>
											</html:select>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>		
												<tr> 
							<td colspan="3" class="texte">
								<b>Choisir la t&acirc;che o&ugrave; sera copi&eacute;e la sous-t&acirc;che : 
								(ligne <bean:write name="copierCollerSousTacheForm"  property="pid_dest" />)</b>
							
								<html:hidden property="pid_dest"/> 
							</td>
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
							<td align="center" colspan="3"	> 
								<table width="100%" border="0">
									<tr> 
										<td class="texteGras" width="33%">Etape</td>
										<td class="texteGras" width="32%">Tâche</td>
										<td width="35%">&nbsp;</td>		
									</tr>
									<tr>
										<td colspan="2">
											<html:select property="tache" styleClass="Multicol" size="5">
											  <bip:options collection="choixTache"/>
											</html:select>
										</td>
										<td>&nbsp;</td>
									</tr>
								</table>
							</td>
							
						</tr>
						<tr>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr> 
							<td align="center"> 
								<table width="100%" border="0">
									<tr> 
										<td width="25%">&nbsp;</td>
										<td width="25%"> 
										  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
										  </div>
										</td>
										<td width="25%"> 
										  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
										  </div>
										</td>
										<td width="25%">&nbsp;</td>
									</tr>
								</table>
								<!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
							</td>
						</tr>
					</table>
					<!-- #EndEditable --></div></div>
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
</body></html:html>
<!-- #EndTemplate -->
