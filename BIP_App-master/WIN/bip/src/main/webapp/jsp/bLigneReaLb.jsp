
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" -->
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.util.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*, java.util.Hashtable"    errorPage="../jsp/erreur.jsp"  %>

<jsp:useBean id="ligneRealisationForm" scope="request" class="com.socgen.bip.form.LigneRealisationForm" />
<jsp:useBean id="listeCA" scope="request" class="com.socgen.bip.commun.liste.ListeCentreActivite" />
<jsp:useBean id="centreActivite" scope="request" class="com.socgen.bip.metier.CentreActivite" />

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

	Hashtable hKeyList= new Hashtable();
	hKeyList.put("annee", ""+ligneRealisationForm.getAnnee());
	hKeyList.put("codcamo", ""+ligneRealisationForm.getCodcamo());

	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());

	liste = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ligne_inv", hKeyList);
	if ((ligneRealisationForm.getCodcamo() != null) && (liste.isEmpty()))
	{
		com.socgen.bip.commun.liste.ListeOption lO = new com.socgen.bip.commun.liste.ListeOption("", "Aucunes Lignes pour ce CA");
		liste.add(lO);
	}
 
	pageContext.setAttribute("choixCodeInv",liste);
	

  	String action = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("action")));
  	String localTitrePage = "Gestion des lignes Budgétaires";
  	if("consulter".equals(action) ||"check".equals(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("mode"))))){
  	  localTitrePage = "Consulter une ligne Budgétaire";
  	}

  	localTitrePage = "Saisie des réalisés";


	// On récupère le menu courant

	//com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = userbip.getCurrentMenu();
	String menuId = menu.getId();
	String sousMenus = userbip.getSousMenus(); 

%>

<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" -->
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" -->
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
<bip:VerifUser page="jsp/bLigneReaLb.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<script language="JavaScript">

	var blnVerification = true;
	var blnModifAnnee = false ;

	<%
		String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	%>
	var pageAide = "<%= sPageAide %>";

	var anneeCourante = '<bip:value champ="to_char(datdebex, 'YYYY')" table="datdebex" clause1="1" clause2="1" />';

	var anneeInterdite = parseInt(anneeCourante) - 1;

	function MessageInitial()
	{
	   var Message="<bean:write filter="false"  name="ligneRealisationForm"  property="msgErreur" />";
	   var Focus = "<bean:write name="ligneRealisationForm"  property="focus" />";

	   if (Message != "") {
	      alert(Message);
	   }
	   if (Focus != "") {
	   	(eval( "document.forms[0]."+Focus )).focus();
	   }
	   	

	   if (document.forms[0].annee.value.length==0) {
		document.forms[0].annee.value = anneeCourante;
	   }		

	   //au chargement de la page, pour avoir la liste des codinv du CA selectionne par defaut
	   if ((document.forms[0].codcamo.options.length != 0 || document.forms[0].codcamo.value != "")&& document.forms[0].codinv.options.length == 0)
	   	UpdateCA(document.forms[0]);

	   	document.forms[0].codrea.focus();
	}

	function Verifier(form, action, mode,flag)
	{
	  blnVerification = flag;
	  form.mode.value = mode;
	  form.action.value = action;
	}

	function ValiderEcran(form)
	{

	   if (blnVerification == true) {
		if (form.annee && !ChampObligatoire(form.annee, "l\'année d'exercice")) return false;
                
		
		if (form.codinv && !ChampObligatoire(form.codinv, "le numéro de ligne d'investissement")) return false;
		
			if (form.mode.value!="insert") {
			if (form.codrea && !ChampObligatoire(form.codrea, "le numéro de la ligne de réalisation"))
	             		return false;
	        }

	   }

	    return true;
	}

	function UpdateCA(form)
	{
		if (	blnModifAnnee == true ){
			blnModifAnnee = false ;
			return false ;
		}	 
		form.action.value = 'suite';
		form.submit();
	}

	function UpdateAnnee(form)
	{
		if (form.annee && !VerifierDate(form.annee, 'aaaa')) return false;
		blnModifAnnee = true ;
		form.action.value = 'suite';
		form.submit();
	}

</script>

<!-- #EndEditable -->
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="ChargeCa('<%=userbip.getCodcamoCourant()%>','codcamo',document.forms[0]);MessageInitial();">
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
          <td height="20" class="TitrePage">
          <!-- #BeginEditable "titre_page" --><%= localTitrePage %><!-- #EndEditable --></td>
        </tr>
        <tr>
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr>
          <td> </td>
        </tr>
        <tr>
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/lignerea"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
            <table width="100%" border="0">
              <tr>
                <td>
                  <div align="center"><!-- #BeginEditable "contenu" -->
                    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                    <html:hidden property="action"/>
                    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="flaglock"/>

                    <!-- menu courant -->
                    <input type="hidden" name="menu" value="<%= menuId %>">
                    <table cellspacing="2" cellpadding="2" class="tableBleu" width="80%" >
                      <tr>
                        <td colspan=2>&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="lib" ><b>Ann&eacute;e d'exercice :</b></td>
                         <!-- Si on est superviseur des investissements , on peut modifier l'année -->
                        <td><% 	if (sousMenus.indexOf("ginv") < 0 ) { %>
                        	<bean:write name="ligneRealisationForm"  property="annee" />
                    	<html:hidden property="annee"/>
			    <%} else { %>
                        	<html:text property="annee" styleClass="input" size="4" maxlength="4" onchange="return UpdateAnnee(this.form);"/>
			<% } %>
                        </td>
                      </tr>
                      <tr>
                        <td class="lib" width="40%"><b>Centre d'activit&eacute; :</b></td>
                        <td > <html:select property="codcamo" styleClass="input" onchange="return UpdateCA(this.form);">
                        	<html:options collection="choixCA" property="cle" labelProperty="libelle" />
                                </html:select>
                        </td>
                      </tr>
                      <tr>
                        <td class="lib" ><b>Ligne investissement num&eacute;ro :</b></td>
                        <td>
                            <!--<html:text property="codinv" styleClass="input" size="3" maxlength="3" onchange="return VerifierNum(this,3,0);"/>-->
							<html:select property="codinv" styleClass="input">
                        		<html:options collection="choixCodeInv" property="cle" labelProperty="libelle" />
							</html:select>

                        </td>
                      </tr>
                      <tr>
                        <td class="lib" ><b>Ligne de réalisation num&eacute;ro :</b></td>
                        <td>
                            <html:text property="codrea" styleClass="input" size="2" maxlength="2" onchange="return VerifierNum(this,3,0);"/>
                        </td>
                      </tr>
                      <tr>
                        <td  colspan="2" align="center" >&nbsp;</td>
                      </tr>
                    </table>
                    <table  align=center" border="0" width=100%>
                      <tr>
    			<td align="right"> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert' ,true);"/>
                        </td>
                        <td align="center"> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/>
                        </td>
                        <td> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer','delete', true);"/>
                        </td>

                      </tr>

                    </table>
                    <!-- #EndEditable --></div>
                </td>
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

<%
  	pageContext.removeAttribute("choixCentreActivite");
	pageContext.removeAttribute("choixCodeInv");  	
%>

	<!-- #EndTemplate -->

