<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="domaineForm" scope="request" class="com.socgen.bip.form.DomaineForm" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/fmDomaineAd.jsp"/> 
<%
  java.util.ArrayList topActif = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
  pageContext.setAttribute("choixTopActif", topActif);
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("sous_systeme_sans",domaineForm.getHParams()); 
  list1.add(0,new ListeOption("---", "      " ));
  pageContext.setAttribute("choixSousSystemeActif", list1);
 %>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	int nbBloc = domaineForm.getNbbloc();
	int nbProjet = domaineForm.getNbProjet();
	int nbDPCOPI = domaineForm.getNbDPCOPI();
	String top_actif = domaineForm.getTop_actif();
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="domaineForm"  property="msgErreur" />";
   var Focus = "<bean:write name="domaineForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  
 
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
    if ((blnVerification == true) && (form.action.value != 'annuler')) {
     if (form.mode.value != 'delete') {	   
     	if (!ChampObligatoire(form.code, "le code du domaine")) return false;  
		if (!ChampObligatoire(form.libelle, "le libellé du domaine")) return false;
		
		if (form.code_ss.value == "---")
		{
			alert("Entrez le code sous-système"); 
		 return false;
		}
		
		
     }
     
    

     if (form.mode.value == 'update') {
     
     	var nbBloc = "<%= nbBloc %>";
     	var nbProjet = "<%= nbProjet %>";
     	var nbDPCOPI = "<%= nbDPCOPI %>";
      	var top_actif = "<%= top_actif %>";
     var LesRadios = document.getElementsByName("top_actif");
		for (i=0; i<LesRadios.length; i++)
		if (LesRadios[i].checked)
		valeur = LesRadios[i].value;
		
		if ((valeur == "N") && (top_actif == "O") && ((nbBloc != 0) || (nbProjet != 0) || (nbDPCOPI != 0) ))
     	{
     			if (nbBloc != 0)
     				alert("Modification impossible un bloc est rattaché à ce domaine");	
     			else
     				if (nbProjet != 0)
     					alert("Modification impossible un projet est rattaché à ce domaine");
     				else
     					 if (nbDPCOPI != 0)
     					 		alert("Modification impossible un dossier projet COPI est rattaché à ce domaine");
			 return false;
			 }
			 
		
		
        if (!confirm("Voulez-vous modifier ce domaine?")) return false;
     }
     if (form.mode.value == 'delete') {
        if (!confirm("Voulez-vous supprimer ce domaine?")) return false;
     }
  }
   return true;
}
</script>
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
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
          	<bean:write name="domaineForm" property="titrePage"/> un domaine
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/domaine"  onsubmit="return ValiderEcran(this);">
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		  	<html:hidden property="titrePage"/>
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		<table cellspacing="2" cellpadding="2" class="tableBleu">
		<tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code du domaine :</b></td>
                  <td> 
                   <logic:equal parameter="action" value="creer"> 
                    	<html:text property="code" styleClass="input" size="5" maxlength="5" onchange="return VerifierAlphanum( this, 4, 0 );"/>
                    </logic:equal> 
                    <logic:notEqual parameter="action" value="creer"> 
                    	<bean:write name="domaineForm" property="code"/> 
                    	<html:hidden property="code"/>                    
                    </logic:notEqual>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libellé du domaine :</b></td>
                  <td> 
                  	<logic:notEqual parameter="action" value="supprimer"> 
                    	<html:text property="libelle" styleClass="input" size="60" maxlength="100" onchange="return VerifierAlphanumExclusion(this);"/>
                    </logic:notEqual> 
                    <logic:equal parameter="action" value="supprimer"> 
                    	<bean:write name="domaineForm" property="libelle"/> 
                    	<html:hidden property="libelle"/>                    
                    </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code du sous-système :</b></td>
                  <td> 
                  	<logic:notEqual parameter="action" value="supprimer"> 
                    	<html:select property="code_ss" styleClass="input"> 
   							<html:options collection="choixSousSystemeActif" property="cle" labelProperty="libelle" />
						</html:select>	</logic:notEqual> 
                    <logic:equal parameter="action" value="supprimer"> 
                    	<bean:write name="domaineForm" property="libelle_code_ss"/> 
                    	<html:hidden property="libelle"/>                    
                    </logic:equal>
                  </td>
                </tr>
                
                      
                
                
                
                
                
                
                <tr> 
                  <td class="lib"><b>Top Actif :</b> 
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixTopActif">
							<bean:define id="choix" name="element" property="cle"/>
								<html:radio property="top_actif" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  					<% if (domaineForm.getTop_actif().equals("N"))
  							domaineForm.setTop_actif("Non");
  						else
  							domaineForm.setTop_actif("Oui");
  						%>
  						<bean:write name="domaineForm" property="top_actif"/>
  					</logic:equal>
                    </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
              </table>
			  </div>
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
            </html:form> 
          </td>
        </tr>
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
Integer id_webo_page = new Integer("1022"); 
com.socgen.bip.commun.form.AutomateForm formWebo = domaineForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
