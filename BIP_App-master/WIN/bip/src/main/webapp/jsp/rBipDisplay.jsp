 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*, com.socgen.bip.rbip.intra.*"   errorPage="../jsp/erreur.jsp"  %><html:html locale="true"> 

<jsp:useBean id="rBipDisplayForm" scope="request" class="com.socgen.bip.form.RBipDisplayForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Upload Files</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/rBipRemontee.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip userBip = (com.socgen.bip.user.UserBip) session.getAttribute("UserBip");	
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function supprimer(form, pid, fichier)
{
	var msg;
	var msg_bips;
	msg = 'Êtes vous certain de vouloir supprimer le fichier de remontée pour le PID : \'' + pid + '\' ?';
	msg_bips = 'Êtes vous certain de vouloir supprimer le fichier de remontée : \'' + fichier + '\' ?';
	
	if(pid == 'BIPS' || pid == 'bips' )
		{
		msg=msg_bips;
		}
	
	if (confirm(msg))
	{
		//alert('On supprime '+ pid + ' / ' + '<%=userBip.getIdUser()%>');
		form.PID.value = pid;
		form.action.value = 'supprimer';
		form.fichier.value = fichier;
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


<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">

<html:form action="/rBipDisplay">
<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="PID"/>
<html:hidden property="fichier"/>
<table align="center">
	<tr>
		<td align="center">		
			<html:submit value="Rafraîchir" styleClass="input" onclick="refresh(this.form);"/>
		</td>
	</tr>
	<tr>
		<td>
		<table class="tableBleu" cellspacing="0" border="0" align="center">
			<tr>
				<td class="lib" width="45"><b>Ligne</b></td>
				<td class="lib" width="120"><b>Fichier</b></td>
				<td class="lib" width="250"><b>Statut</b></td>
				<td class="lib" width="120"><b>Date statut</b></td>
				<td class="lib" width="90"><b>Supprimer</b></td>
			</tr>
			<%
			java.util.Vector vFichiers = RBipFichier.getFichiersUser(userBip.getIdUser());
			
			//pour la recapitualation a la fin
			int iCharges = 0;
			int iOK = 0;
			int iKO = 0;
			int iAutres = 0;
			int iENT_VAL = 0;
			int iPAR_VAL = 0;
			int iENT_VAL_ENT_TRT = 0;
			int iPAR_VAL_ENT_TRT = 0;
			int iENT_VAL_PAR_TRT = 0;
			int iPAR_VAL_PAR_TRT = 0;
			int iKO_BIPS = 0;
			
			
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
			String imageWARNING = "<img src=\"/images/warning.png\" border=0>";
			
			//le libelle dans le statut
			String LIBELLE_OK = "Fichier .BIP entièrement valide";
			String LIBELLE_OK_BAS = "Fichiers .BIP entièrement valides";
			String LIBELLE_MSP_OK = "Fichier MSP Valide";
			String LIBELLE_KO = "Fichier .BIP invalide";
			String LIBELLE_KO_BAS = "Fichiers .BIP invalides";
			String LIBELLE_ENCOURS = "Traitement En cours";
			String LIBELLE_ERREUR = "Problème bloquant";
			String LIBELLE_CHARGE = "Fichier pris en compte";
			String LIBELLE_CHARGE_BAS = "Fichiers .BIP traités par une mensuelle";
			String LIBELLE_REMPLACE = "Remplacé par ";
			
			//SEL PPM 60612 : Libelles des statuts BIPS
			String BIPS_LIBELLE_OK = "Fichier .BIPS entièrement valide";
			String BIPS_LIBELLE_OK_WARNINGS = "Fichier .BIPS avec avertissements";
			String BIPS_LIBELLE_REJETS = "Fichier .BIPS avec rejets";
			String BIPS_LIBELLE_ENT_VAL = "Fichiers .BIPS entièrement valides";
			String BIPS_LIBELLE_PAR_VAL = "Fichiers .BIPS partiellement valides";
			String BIPS_LIBELLE_ENT_VAL_ENT_TRT = "Fichiers .BIPS entièrement valides et entièrement traités";
			String BIPS_LIBELLE_PAR_VAL_ENT_TRT = "Fichiers .BIPS partiellement valides et entièrement traités";
			String BIPS_LIBELLE_ENT_VAL_PAR_TRT = "Fichiers .BIPS entièrement valides et partiellement traités";
			String BIPS_LIBELLE_PAR_VAL_PAR_TRT = "Fichiers .BIPS partiellement valides et partiellement traités";
			String BIPS_LIBELLE_KO = "Fichier .BIPS invalide";
			String BIPS_LIBELLE_KO_BAS = "Fichiers .BIPS invalides";
			
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
				String actionBips=sStatutInfo;
				
				String sFichierVal = "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=fichier&PID="+sPID+">"+sFichier+"</a>";
				
				//SEL PPM 60612
				if("controler".equals(sStatutInfo) || "creer".equals(sStatutInfo))
				{
					sStatutInfo="";
				}
				
				switch(iStatut)
				{
					case RBipFichier.STATUT_ERREUR :
					{
						iAutres++;
						sFichierVal=sFichier;
						sStatut = imageERREUR + " " + LIBELLE_ERREUR + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_CONTROLE_KO :
					{
						iKO++;
						sStatut = imageKO + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+LIBELLE_KO+"</a>";
						break;
					}
					case RBipFichier.STATUT_CONTROLE_OK :
					{
						iOK++;
						sStatut = imageOK + " " + LIBELLE_OK + sStatutInfo;
						break;
					}
					case RBipFichier.STATUT_CONTROLE_OK_WARNING : //SEL 60709 5.4
					{
						iKO++;
						sStatut = imageKO + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+LIBELLE_KO+"</a>";
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
						// PPR : cas particulier du fichier PBIP pour éviter qu'il mette remplacé par
						if (sPID.equals("_MSP")) {
							sStatut = imageMSP_OK + " " + LIBELLE_MSP_OK ;
						}
						else {	
							sStatut = imageREMPLACE + " " + LIBELLE_REMPLACE + sStatutInfo;
						}
						break;
					}
					case RBipFichier.STATUT_CHARGE:
					{
						iCharges++;
						sStatut = imageCHARGE + " " + LIBELLE_CHARGE + sStatutInfo;
						break;
					}
					//////////////////////////////////////////////BIPS
					case RBipFichier.BIPS_STATUT_ENT_VAL_OK:
					{ 
						iENT_VAL++;
						sStatut = imageOK + " " + BIPS_LIBELLE_OK ;
						break;
					}
					case RBipFichier.BIPS_STATUT_ENT_VAL_WARNINGS:
					{
						iENT_VAL++;
						sStatut = imageWARNING + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_OK_WARNINGS+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_PAR_VAL:
					{
						iPAR_VAL++;
						sStatut = imageWARNING + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_REJETS+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_ENT_VAL_ENT_TRT_OK:
					{
						iENT_VAL_ENT_TRT++;
						sStatut = imageOK + " " + BIPS_LIBELLE_OK;
						break;
					}
					case RBipFichier.BIPS_STATUT_ENT_VAL_ENT_TRT_WARNINGS:
					{
						iENT_VAL_ENT_TRT++;
						sStatut = imageWARNING + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_OK_WARNINGS+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_PAR_VAL_ENT_TRT:
					{
						iPAR_VAL_ENT_TRT++;
						sStatut = imageWARNING + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_REJETS+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_ENT_VAL_PAR_TRT_WARNINGS:
					{
						iENT_VAL_PAR_TRT++;
						sStatut = imageWARNING + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_OK_WARNINGS+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_ENT_VAL_PAR_TRT:
					{
						iENT_VAL_PAR_TRT++;
						sStatut = imageWARNING + " " +BIPS_LIBELLE_OK+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_PAR_VAL_PAR_TRT:
					{
						iPAR_VAL_PAR_TRT++;
						sStatut = imageWARNING + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_REJETS+"</a>";
						break;
					}
					case RBipFichier.BIPS_STATUT_REJET:
					{
						iKO_BIPS++;
						sStatut = imageKO + " " + "<a href=../rBipDisplay.do?action=valider&fichier="+sFichier+"&mode=erreurs&PID="+sPID+">"+BIPS_LIBELLE_KO+"</a>";
						break;
					}
					
					//BIPS
					default:
					{
						continue;
					}
				}
				if ((iStatut == RBipFichier.STATUT_NO_DATA) ||
					(iStatut == RBipFichier.STATUT_NON_CONTROLE) )
				{
					sSupprime = ""; 
				}
				else
				{
					sSupprime = "<input type=submit value=\"Supprimer\" class=\"input\" onclick=\"supprimer(this.form, '"+sPID+"', '"+sFichier+"');\">";
				}
				%>
				<tr>
					<td valign="baseline"> <%= "BIPS".equals(sPID)? "":sPID %> </td>
					<td valign="baseline"> <%= sFichierVal %> </td>
					<td valign="baseline"> <%= sStatut %> </td>
					<td valign="baseline"> <%= sDate %> </td>
					<td valign="baseline"> <%= sSupprime %> </td>
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
				<td valign="baseline" class="lib" width="45"><b>Statut</b></td>
				<td valign="baseline" class="lib" width="120" align="right"><b>Nombre</b></td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageCHARGE + " " + LIBELLE_CHARGE_BAS %> </td>
				<td valign="baseline" align="right"> <%= iCharges%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageOK + " " + LIBELLE_OK_BAS %> </td>
				<td valign="baseline" align="right"> <%= iOK%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageKO + " " + LIBELLE_KO_BAS %> </td>
				<td valign="baseline" align="right"> <%= iKO%> </td>
			</tr>
			
			<tr>
				<td valign="baseline"> <%= imageOK + " " + BIPS_LIBELLE_ENT_VAL %> </td>
				<td valign="baseline" align="right"> <%= iENT_VAL%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageWARNING + " " + BIPS_LIBELLE_PAR_VAL %> </td>
				<td valign="baseline" align="right"> <%= iPAR_VAL%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageOK + " " + BIPS_LIBELLE_ENT_VAL_ENT_TRT %> </td>
				<td valign="baseline" align="right"> <%= iENT_VAL_ENT_TRT%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageWARNING + " " + BIPS_LIBELLE_PAR_VAL_ENT_TRT %> </td>
				<td valign="baseline" align="right"> <%= iPAR_VAL_ENT_TRT%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageWARNING + " " + BIPS_LIBELLE_ENT_VAL_PAR_TRT %> </td>
				<td valign="baseline" align="right"> <%= iENT_VAL_PAR_TRT%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageWARNING + " " + BIPS_LIBELLE_PAR_VAL_PAR_TRT %> </td>
				<td valign="baseline" align="right"> <%= iPAR_VAL_PAR_TRT%> </td>
			</tr>
			<tr>
				<td valign="baseline"> <%= imageKO + " " + BIPS_LIBELLE_KO_BAS %> </td>
				<td valign="baseline" align="right"> <%= iKO_BIPS%> </td>
			</tr>
			
			
			<tr>
				<td valign="baseline">     Autres ... </td>
				<td valign="baseline" align="right"> <%= iAutres%> </td>
			</tr>
		</table>
		</td>
	</tr>
</table>
</html:form>

</body></html:html>
<!-- #EndTemplate -->
