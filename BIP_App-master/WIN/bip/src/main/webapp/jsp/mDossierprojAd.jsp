<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.text.SimpleDateFormat,java.util.Locale"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dossierprojForm" scope="request" class="com.socgen.bip.form.DossierprojForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDossierprojAd.jsp"/> 
<%
	// On récupère la date du jour
	long dateJour = System.currentTimeMillis();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.FRANCE);
	String aujourdhui= (sdf.format(new java.util.Date(dateJour))).toString();
	// On récupère l'année en cours
	String anneeCourante = aujourdhui.substring(6);
	// On récupère l'année d'immobilisation
	String dateImmo = dossierprojForm.getDateimmo();
	String anneeImmo = anneeCourante;
	if ((dateImmo != null) && (dateImmo.length()==10) && (!(dossierprojForm.getAction()).equals("valider"))){
		anneeImmo = dateImmo.substring(6);
	}
	// On récupère la liste des top actif
    java.util.ArrayList choixTopFer = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topFer"); 
    pageContext.setAttribute("choixTopFer", choixTopFer);
    
    // On récupère la liste des types de dossier projet
    java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
    java.util.ArrayList typeDossProj = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("type_doss_proj",hP); 
	pageContext.setAttribute("typeDossProj", typeDossProj);
	//PPM 59288 debut 
	//On recupère la liste des branches:directions
	com.socgen.bip.commun.liste.ListeDynamique listeDynamique = new com.socgen.bip.commun.liste.ListeDynamique();
	try
	{
		java.util.ArrayList listDirPrin = listeDynamique.getListeDynamique("dir_prin",dossierprojForm.getHParams()); 
		  pageContext.setAttribute("listDirPrin",listDirPrin);

	}
	catch (Exception e) 
	{ 
		%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
	}
	//Fin PPM 59288
%>

<script language="JavaScript" src="../js/function.cjs"></script>
<script language="JavaScript" src="../js/jquery.js"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="dossierprojForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dossierprojForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "")
   {
   		(eval( "document.forms[0]."+Focus )).focus();
   }
   else if (document.forms[0].mode.value!="delete")
   {
	 document.forms[0].dplib.focus();
   }
   if (document.forms[0].mode.value=="insert"){
    	document.forms[0].typdp[0].checked = true;
	}
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
  if (blnVerification == true) {
      if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  		
     if (form.dplib && !ChampObligatoire(form.dplib, "le libellé")) return false;     
 	//PPM 59288
     if (form.dir_prin.selectedIndex == -1 || form.dir_prin.value == "") {
 		alert("Choisissez une direction BIP principale");
 		return false;
 	}
   //Fin PPM 59288
     if (form.mode.value== 'update') {
        if (!confirm("Voulez-vous modifier ce dossier projet  ?") ) return false;
      //PPM 59288 : appel de la fonction de controle de cohérence
		var ress = controleDirPrin(form.dpcode.value,form.dir_prin.value);
        if(  ress.trim() == "1"){
			alert("Impossible de choisir cette Direction car à ce DP est attaché au moins 1 ligne Bip active et non GT1");
			return false;//on reste dans la même page
		}
        //Fin PPM 59288
     }
     if (form.mode.value== 'delete') {
        if (!confirm("Voulez-vous supprimer ce dossier projet ?")) return false;
     }
     if (form.typdp.selectedIndex == -1) {
		alert("Choisissez un type de dossier");
		return false;
	}
  }
   
   return true;
}
//PPM 59288 : fonction de controle de cohérence dirprin/dpcode
function controleDirPrin(dpcode,dirprin)
{
	//appel de la fonction ajax de controle de cohérence de direction parincipale à un Dossier Projet
	ajaxCallRemotePage('/dossierproj.do?action=controleDirPrin&dpcode=' + dpcode + '&dirprin=' + dirprin);
	//récupération de la valeur retournée par la procédure CONTROLE_DIRPRIN()
	var ajaxres = document.getElementById("ajaxResponse").innerHTML;
	return ajaxres;
}
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div style="display:none;" id="ajaxResponse"></div>
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
           <bean:write name="dossierprojForm" property="titrePage"/> un dossier projet<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/dossierproj"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="titrePage"/>
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code dossier projet :</b></td>
                  <td>
                   <b> <bean:write name="dossierprojForm"  property="dpcode" /></b> 
                    <html:hidden property="dpcode"/>
                 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Libellé :</b></td>
          
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="dplib" styleClass="input" size="50" maxlength="50" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="dossierprojForm"  property="dplib" />
                    </logic:equal> 
                 
                  </td>
                </tr>
                
                <tr>
				  <!--  PPM 59288 : ajout liste déroulante Dir Prin-->
				  <td class="lib"><b>Direction Bip principalement concernée : </b></td>				  
                  <td colspan="4" > 
                  <logic:notEqual parameter="action" value="supprimer">
					  	<html:select property="dir_prin" styleClass="inputlist">
						<!--QC 1657-->					  						
							<bip:options collection="listDirPrin" />                    
						</html:select>					
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="dossierprojForm"  property="libelleDirPrin" />
                   </logic:equal> 
				  </td>
				  <!-- Fin PPM 59288 -->
				</tr>
				
                    <tr> 
                  <td class="lib" ><b>Directeur de projet 1 :</b></td>
          
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="dp1" styleClass="input" size="50" maxlength="50" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="dossierprojForm"  property="dp1" />
                    </logic:equal> 
                 
                  </td>
                </tr>
                   <tr> 
                  <td class="lib" ><b>Directeur de projet 2 :</b></td>
          
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="dp2" styleClass="input" size="50" maxlength="50" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="dossierprojForm"  property="dp2" />
                    </logic:equal> 
                 
                  </td>
                </tr>
                 
                <tr> 
                  <td class="lib"><b>Top actif :</b></td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixTopFer">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="topActif" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dossierprojForm" property="topActif"/>
  					</logic:equal>
                  </td>
                </tr>

                <tr>
                  <td class="lib">Date d'immobilisation :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                    	<% if ((new Integer(anneeImmo)).intValue() >= (new Integer(anneeCourante)).intValue()){ %>
                    	   <html:text property="dateimmo" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this, 'jj/mm/aaaa');"/>
                    	<% }
                    	   else { %>
                    	   <bean:write name="dossierprojForm"  property="dateimmo" />
                    	   <html:hidden property="dateimmo"/>
                    	<% } %>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="dossierprojForm"  property="dateimmo" />
                    </logic:equal> 
                  </td>
                </tr>
                <tr>
					<td class="lib"><b>Catégorie du DP :</b></td>
                    <td>
                    	<logic:iterate id="element" name="typeDossProj">
			   				<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="typdp" value="<%=choix.toString()%>"/>
							<bean:write name="element" property="libelle"/>
	  						<br>
  						</logic:iterate>
					</td>
				</tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                </tr>
              </table>
              <!-- #EndEditable --></div>
          </td>
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
</body>
<% 
Integer id_webo_page = new Integer("1026"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dossierprojForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
