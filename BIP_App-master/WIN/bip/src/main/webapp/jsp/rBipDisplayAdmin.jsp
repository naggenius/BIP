 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*, com.socgen.bip.rbip.intra.*"   errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 

<jsp:useBean id="rBipDisplayAdminForm" scope="request" class="com.socgen.bip.form.RBipDisplayForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Upload Files</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/rBipDisplayAdmin.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip userBip = (com.socgen.bip.user.UserBip) session.getAttribute("UserBip");	
	
	if (rBipDisplayAdminForm.getIDRemonteur() == null)
		rBipDisplayAdminForm.setIDRemonteur(userBip.getIdUser());
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
   
   document.forms[0].action.value = 'suite';
}

function supprimer(form, pid)
{
	var msg;
	msg = 'Êtes vous certain de vouloir supprimer le fichier de remonntée pour le PID : \'' + pid + '\' du remonteur \''+form.IDRemonteur.value+'\' ?';
	if (confirm(msg))
	{
		form.PID.value = pid;
		form.action.value = 'supprimer';
	}
	else
	{
		refresh(form);
	}
}

function refresh(form)
{
	form.action.value = 'suite';
}


</script>
<!-- #EndEditable --> 
</head>


<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">

<html:form action="/rBipDisplayAdmin">
<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="PID"/>
<!--<html:hidden property="IDRemonteur"/>-->
<table align="center">
	<tr>
		<td align="center">
			<table>
			<tr>
				<td>
					Identifiant du remonteur : 
				</td>
				<td>
					<html:text property="IDRemonteur" styleClass="input" size="10" maxlength="20" onchange="return VerifierAlphaMax(this);"/>
				</td>
				<td>
					<html:submit property="toto" value="Rafraîchir" styleClass="input" onclick="refresh(this.form);"/>
				</td>
			</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<b> Fichiers du Remonteur <bean:write name="rBipDisplayAdminForm"  property="IDRemonteur" /></b>
		</td>
	</tr>
	<tr>
		<td>
		<table class="tableBleu" cellspacing="0" border="0" align="center">
			<tr>
				<td class="lib" width="45"><b>PID</b></td>
				<td class="lib" width="120"><b>Fichier</b></td>
				<td class="lib" width="185"><b>Statut</b></td>
				<td class="lib" width="120"><b>Date statut</b></td>
				<td class="lib" width="90"><b>Supprimer</b></td>
			</tr>
			<%
			java.util.Vector vFichiers = RBipFichier.getFichiersUser(rBipDisplayAdminForm.getIDRemonteur());
			
			//pour la recapitualation a la fin
			int iCharges = 0;
			int iOK = 0;
			int iKO = 0;
			int iSupprimes = 0;
			int iAutres = 0;
			
			//position dans le vecteur
			int posPID = 0;
			int posIDRemonteur = 1;
			int posFichier = 2;
			int posStatut = 3;
			int posStatutInfo = 4;
			int posStatutDate = 5;
			
			
			//pour afficher l'icone des statuts
			String imageERREUR = "<img src=\"/images/imageKO.bmp\" border=0>";
			String imageOK = "<img src=\"/images/imageOK.bmp\" border=0>";
			String imageMSP_OK = "<img src=\"/images/imageMSP_OK.bmp\" border=0>";
			String imageKO = "<img src=\"/images/imageKO.bmp\" border=0>";
			String imageENCOURS = "<img src=\"/images/imageENCOURS.bmp\" border=0>";
			String imageREMPLACE = "<img src=\"/images/imageREMPLACE.bmp\" border=0>";
			String imageCHARGE = "<img src=\"/images/imageCHARGE.bmp\" border=0>";
			String imageSUPPRIME = "<img src=\"/images/imageSUPPRIME2.bmp\" border=0>";
			
			//le libelle dans le statut
			String LIBELLE_OK = "Fichier Valide";
			String LIBELLE_MSP_OK = "Fichier MSP Valide";
			String LIBELLE_KO = "Fichier invalide";
			String LIBELLE_ENCOURS = "Traitement En cours";
			String LIBELLE_ERREUR = "Problème bloquant";
			String LIBELLE_CHARGE = "Fichier pris en compte";
			String LIBELLE_REMPLACE = "Remplacé par ";
			String LIBELLE_SUPPRIME = "Fichier Supprimé";
			
			for (int i=0; i< vFichiers.size(); i++)
			{ 
				java.util.Vector vTmp = (java.util.Vector)vFichiers.elementAt(i);
				//les valeurs
				
				String sPID = (String)vTmp.elementAt(posPID);
				String sFichier = (String)vTmp.elementAt(posFichier);				
				String sStatutInfo = (String)vTmp.elementAt(posStatutInfo);
				String sDate = (String)vTmp.elementAt(posStatutDate);
				int iStatut = new Integer((String)vTmp.elementAt(posStatut)).intValue();
				
				String sStatut="";
				String sSupprime;
				
				String sFichierVal = "<a href=../rBipDisplayAdmin.do?action=valider&fichier="+sFichier+
												"&mode=fichier"+
												"&IDRemonteur="+rBipDisplayAdminForm.getIDRemonteur()+
												"&PID="+sPID+
												">"+sFichier+"</a>";
				
				switch(iStatut)
				{
					case RBipFichier.STATUT_ERREUR :
					{
						iAutres++;
						sFichierVal=sFichier;
						sStatut = imageERREUR + " " + LIBELLE_ERREUR;// + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_CONTROLE_KO :
					{
						iKO++;
						sStatut = imageKO + " " + "<a href=../rBipDisplayAdmin.do?action=valider&fichier="+sFichier+
															"&IDRemonteur="+rBipDisplayAdminForm.getIDRemonteur()+
															"&mode=erreurs&PID="+sPID+
															">"+LIBELLE_KO+"</a>";
						break;
					}
					case RBipFichier.STATUT_CONTROLE_OK :
					{
						iOK++;
						sStatut = imageOK + " " + LIBELLE_OK + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_PBIP_OK :
					{
						iAutres++;
						sStatut = imageMSP_OK + " " + LIBELLE_MSP_OK + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_NON_CONTROLE :
					{
						iAutres++;
						sStatut = imageENCOURS + " " + LIBELLE_ENCOURS + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_NO_DATA:
					{
						iAutres++;
						sFichierVal=sFichier;
						sStatut = imageENCOURS + " " + LIBELLE_ENCOURS + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_REMPLACE:
					{
						iAutres++;
						sStatut = imageREMPLACE + " " + LIBELLE_REMPLACE + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_CHARGE:
					{
						iCharges++;
						sStatut = imageCHARGE + " " + LIBELLE_CHARGE + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_SUPPRIME:
					{
						iSupprimes++;
						sStatut = imageSUPPRIME + " " + LIBELLE_SUPPRIME + sStatutInfo;
					}
				}
				if ((iStatut == RBipFichier.STATUT_NO_DATA) ||
					(iStatut == RBipFichier.STATUT_NON_CONTROLE) ||
					(iStatut == RBipFichier.STATUT_SUPPRIME) )
				{
					sSupprime = ""; 
				}
				else
				{
					sSupprime = "<input type=submit value=\"Supprimer\" class=\"input\" onclick=\"supprimer(this.form, '"+sPID+"');\">";
				}
				%>
				<tr>
					<td> <%= sPID %> </td>
					<td> <%= sFichierVal %> </td>
					<td> <%= sStatut %> </td>
					<td> <%= sDate %> </td>
					<td> <%= sSupprime %> </td>
				</tr>
			<%
			} %>
		</table>
		</td>
	</tr>
	<tr>
		<td align="center">
			<html:submit value="Rafraîchir" styleClass="input" onclick="refresh(this.form);"/>	
		</td>
	</tr>
	<tr>
		<td>
		<table class="tableBleu" cellspacing="0" border="0" align="center">
			<tr>
				<td class="lib" width="45"><b>Statut</b></td>
				<td class="lib" width="120" align="right"><b>Nombre</b></td>
			</tr>
			<tr>
				<td> <%= imageCHARGE + " " + LIBELLE_CHARGE %> </td>
				<td align="right"> <%= iCharges%> </td>
			</tr>
			<tr>
				<td> <%= imageOK + " " + LIBELLE_OK %> </td>
				<td align="right"> <%= iOK%> </td>
			</tr>
			<tr>
				<td> <%= imageKO + " " + LIBELLE_KO %> </td>
				<td align="right"> <%= iKO%> </td>
			</tr>
			<tr>
				<td> <%= imageSUPPRIME + " " + LIBELLE_SUPPRIME %> </td>
				<td align="right"> <%= iSupprimes%> </td>
			</tr>
			<tr>
				<td>     Autres ... </td>
				<td align="right"> <%= iAutres%> </td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</html:form>

</body></html:html>
<!-- #EndTemplate -->
