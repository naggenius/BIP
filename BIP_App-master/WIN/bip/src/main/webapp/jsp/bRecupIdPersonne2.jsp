<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>

<!-- #BeginEditable "imports" -->
<%@ page language="java"
	import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"
	errorPage="../jsp/erreur.jsp"%>
<jsp:useBean id="RecupIdPersonneSaisieForm" scope="request"
	class="com.socgen.bip.form.RecupIdPersonneSaisieForm" />
<jsp:useBean id="listeRechercheId" scope="session"
	class="com.socgen.ich.ihm.menu.PaginationVector" />
	

<html:html locale="true">
<!-- #EndEditable -->
<!-- #BeginTemplate "/Templates/Page_bip.dwt" -->
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip"%>


<!-- #BeginEditable "doctitle" -->
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->


<!-- Page autoris�e � tous les utilisateurs -->
<bip:VerifUser page="jsp/eMonProfilAd.jsp" />

<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<!-- <link rel="stylesheet" href="../css/style_bip.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%String arborescence = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("arborescence")));
				String sPageAide = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("pageAide")));
				String sRtype = ESAPI.encoder().encodeForJavaScript(
						ESAPI.encoder().canonicalize(
								request.getParameter("rtype")));%>
var pageAide = "<%=sPageAide%>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="RecupIdPersonneSaisieForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupIdPersonneSaisieForm"  property="focus" />";
   
   // Placer le focus la zone de recherche
  document.forms[0].nomRecherche.focus();
  
  if(document.forms[0].nomRecherche.value !='')
  {
  
   document.forms[0].nomRecherche.focus();
  }

  
   
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].bpmontme_1){
	  document.forms[0].bpmontme_1.focus();
   }
}


function ValiderEcran(form)
{
    return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

function Verifier(form){
    form.action.value="modifier";
    if(form.nomRecherche.value != "" || form.codeRecherche.value != "")
    {       
       form.nomRecherche.value = form.nomRecherche.value.toUpperCase()
       
       form.submit();
       return true; 
       
    }else {
 			 alert("Veuillez saisir sur l'un des deux champs !"); 
       return false;	
    }      
}

function fill(num) {

	var action = "<%=RecupIdPersonneSaisieForm.rafraichir%>";
	  
	window.opener.document.forms[0].ident.value = num;
	
	if( action == 'OUI' ) {
		   	rafraichir(window.opener.document.forms[0]);
	}
	
	  window.close();
}
	
function fill2(txt) {
	   
	}
	
function fill3(txt) {
	 
	}
	
function Quitter()
{
	window.close();
}

function viderNom()
{
	document.forms[0].nomRecherche.value="";
}

function viderCode()
{
	document.forms[0].codeRecherche.value="";
}

function VerifEntree(form) {

	if (window.event.type == "keypress" & window.event.keyCode == 13) {
		Verifier(form);
		
	}
	
}
</script>
<!-- #EndEditable -->
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0"
	onLoad="MessageInitial();" background="../images/bg_page_popup.jpg">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td>&nbsp;</td>
					</tr>
					<!--         <tr >  -->
					<!--           <td>  -->
					<!--             <div align="center">#BeginEditable "barre_haut"  -->
					<%--               <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%> --%>
					<%--               <%=tb.printHtml()%><!-- #EndEditable --></div> --%>
					<!--           </td> -->
					<!--         </tr> -->
					<tr>
						<td>&nbsp;</td>
					</tr>
					<!--         <tr>  -->
					<!--           <td background="../images/ligne.gif"></td> -->
					<!--         </tr> -->
					<tr>
						<td height="20" class="TitrePage">Recherche Ressource</td>
					</tr>
					<!--         <tr>  -->
					<!--           <td background="../images/ligne.gif"></td> -->
					<!--         </tr> -->
					<tr>
						<td></td>
					</tr>
					<BR>
					<tr>
						<td><html:form action="/recupIdPersonneSaisie.do">
								<table width="100%" border="0">
									<tr>
										<td>
											<div align="center">
												<!-- #BeginEditable "contenu" -->
												<input type="hidden" name="pageAide"
													value="<%=sPageAide%>">


												<html:hidden property="arborescence"
													value="<%= arborescence %>" />
												<html:hidden property="action" value="modifier" />
												<html:hidden property="page" value="modifier" />
												<input type="hidden" name="rtype" value="<%=sRtype%>">
												<html:hidden name="RecupIdPersonneSaisieForm"
													property="nomChampDestinataire" />
												<html:hidden name="RecupIdPersonneSaisieForm"
													property="nomChampDestinataire2" />
												<html:hidden name="RecupIdPersonneSaisieForm"
													property="nomChampDestinataire3" />
												<html:hidden name="RecupIdPersonneSaisieForm"
													property="windowTitle" />
												<html:hidden name="RecupIdPersonneSaisieForm"
													property="habilitationPage" />
												<html:hidden name="RecupIdPersonneSaisieForm"
													property="rafraichir" />

												<input type="hidden" name="index" value="modifier">
												<table align="center">
													<tr>

														<td align="left" class="texte">Code ressource</td>

														<td><html:text property="codeRecherche" size="20" onkeypress="VerifEntree(this.form)" onkeydown="viderNom();"
																maxlength="20" /></td>
													</tr>
													<tr>

														<td align="left" style="font-size:15px;font-width:bold"><b>OU</b></td>
													</tr>
													<tr>
														<td align="left" class="texte">Nom de la ressource
															:&nbsp;<BR><i>Veuillez saisir un ou plusieurs car.
															<BR>recherche de type "contient"</i></td>

														<td><html:text property="nomRecherche" size="20" onkeypress="VerifEntree(this.form)"  onkeydown="viderCode();"
																maxlength="20" /></td>
													</tr>
													<%
														int i = 0;
																String[] strTabCols = new String[] { "fond1", "fond2" };
													%>
												</table>
												<table>

													<%
														if (listeRechercheId.size() == 99) {
													%>
													<tr>
														<td align="left" colspan="3" class="contenu">Le
																nombre de <B>ressources</B> trouv�es est sup�rieur � 100<BR>
																Veuillez saisir un nom plus long afin de mieux limiter
																la recherche
														</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
													</tr>
													<%
														}
													%>



													<logic:present name="listeRechercheId">
														<%
															if (listeRechercheId.size() > 1) {
														%>

														<tr>
															<td align="left" colspan="3" class="contenu">Cliquez
																sur un code d'une personne pour la s�lectionner</td>
														</tr>
														<BR>
														<tr>
															<td align="left" class="lib" width="30%">Code</td>
															<td align="left" class="lib" width="30%">Nom</td>
															<td align="left" class="lib" width="30%">Pr�nom</td>
														</tr>
														<logic:iterate id="element" name="listeRechercheId"
															length="<%=listeRechercheId.getCountInBlock()%>"
															offset="<%=listeRechercheId.getOffset(0)%>"
															type="com.socgen.bip.metier.InfosPersonne"
															indexId="index">
															<%
																if (i == 0)
																						i = 1;
																					else
																						i = 0;
															%>
															<tr align="left" class="<%=strTabCols[i]%>">
																<td class="contenu"><b> <bean:write
																			name="element" property="lienHref" filter="false" />
																		<bean:write name="element" property="id" /> </b>
																</td>
																<td class="contenu"><bean:write name="element"
																		property="name" />
																</td>
																<td class="contenu"><bean:write name="element"
																		property="pname" />
																</td>
															</tr>

														</logic:iterate>

														<tr>
															<td align="center" colspan="3" class="contenu"><bip:pagination
																	beanName="listeRechercheId" /></td>
														</tr>

														<%
															}else{
																if(listeRechercheId.size() == 1)
																{
																	%>
																	<script language="JavaScript">
																	fill(<%=((com.socgen.bip.metier.InfosPersonne)listeRechercheId.firstElement()).getId() %>);
																	</script>
																	<%			
																}
																if(listeRechercheId.size() == 0)
																{
																	%>
																	<script language="JavaScript">
																	if(document.forms[0].codeRecherche.value !='')
																		{
																	alert('Ce code ne correspond pas � une ressource existante ou alors cette ressource ne peut pas �tre s�lectionn�e');
																	window.close();
																		}
																	
																	if(document.forms[0].nomRecherche.value != '')
																	{
																		alert('Aucune ressource s�lectionnable ne correspond � votre demande');
																		window.close();																		
																	}
																	
																	 
																	</script>
																	<%			
																}
															}
														%>
													</logic:present>
												</table>


												<table width="100%" border="0" cellspacing="0"
													cellpadding="0">
													<tr>
														<td align="center" colspan="4" class="contenu"></td>
													</tr>
													<tr>
														<td align="center" colspan="4" class="contenu"></td>
													</tr>
													<tr>
														<td colspan="4">&nbsp;
													</tr>
													<tr>
														<td width="25%">&nbsp;</td>
														<td width="25%">
															<div align="center">
																<html:button property="boutonValider" value="Valider"
																	styleClass="input" onclick="Verifier(this.form);" />
															</div></td>
														<td width="25%">
															<div align="center">
																<html:button property="boutonAnnuler" value="Annuler"
																	styleClass="input" onclick="Quitter();" />
															</div></td>
														<td width="25%">&nbsp;</td>
													</tr>

												</table>
												<!-- #EndEditable -->
											</div></td>
									</tr>
								</table>
								<!-- #BeginEditable "fin_form" -->
							</html:form>
							<!-- #EndEditable --></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							<div align="center">
								<html:errors />
								<!-- #BeginEditable "barre_bas" -->
								<!-- #EndEditable -->
							</div></td>
					</tr>
					<tr>
						<td>&nbsp;</td>
					</tr>
				</table></td>
		</tr>
	</table>
</body>
</html:html>
<!-- #EndTemplate -->
