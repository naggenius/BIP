<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="loadTablerepartForm" scope="request" class="com.socgen.bip.form.LoadTableRepartForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/loadTabRepartJH.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	com.socgen.bip.commun.liste.ListeDynamique listeDynamique = new com.socgen.bip.commun.liste.ListeDynamique();
	Hashtable hKeyList= new Hashtable();
	
 	try {
 		hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
 		hKeyList.put("codsg", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getDpg_Defaut());
 		
  		java.util.ArrayList listR = listeDynamique.getListeDynamique("table_repart",hKeyList); 
  		pageContext.setAttribute("choixCodrep", listR);
 	} catch (Exception e) { 
    	%>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
 	}
 	
  java.util.ArrayList listFlag = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typTab"); 
  pageContext.setAttribute("choixTypTab", listFlag); 	
%>
var pageAide = "<%= sPageAide %>";
var exercice = "<bean:write name="loadTablerepartForm"  property="datdebex" />";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="loadTablerepartForm"  property="msgErreur" />";
   var Focus = "<bean:write name="loadTablerepartForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].codrep.focus();
   }
   document.forms[0].moisrep.value="";
   document.forms[0].moisfin.value="";
}

function Verifier(form, action, flag)
{
   blnVerification = flag;
   form.action.value = action;
   
} 

function ValiderEcran(form)
{
   if (blnVerification==true) 
   {
	   if (form.codrep && !ChampObligatoire(form.codrep,"le code table de répartition")) return false;
	   
	   // On ne peut pas dupliquer les tables de répartition des arbitrés sur un autre mois.
  	   if (form.action.value=='dupliquer' && form.typtab[0].checked)
   	   {
   		alert('On ne peut pas dupliquer les tables des arbitrés.');
   		return false;
   	   }
   	   
	   if (form.moisrep && (form.moisrep.value!="" || form.moisrep.value==null ) && form.typtab[0].checked && (form.action.value=='creer' || form.action.value=='supprimer_detail') )
	   {
	   	alert("Vous ne devez pas saisir de Mois de répartition pour les Arbitrés.");
	    return false;
	   }
	   
	   // Si table de répartition des Arbitrés on force la date de la table à janvier 2000.
	   if (form.typtab[0].checked)
	   {
	   		form.moisrep.value='01/2000';
	   		form.moisfin.value='01/2000';
	   }
	   // Si table de répartition des Proposés.
	   if (form.typtab[1].checked)
	   {
	   		if (form.moisrep && !ChampObligatoire(form.moisrep,"le mois de la table")) return false;
	   		else
	   		{
	   	   		if (!VerifierDate2(form.moisrep, 'mmaaaa')) return false;
	   	   		else
	   	   		{
	   	   	   		var anneeSaisie = form.moisrep.value.substring(3,7);
	   	   	   		if (anneeSaisie<exercice)
	   	   	   		{
	   	   	       		alert("Le mois de la répartition ne doit pas être inférieur à l'exercice courant.");
	   	   	       		form.moisrep.focus();
		   	   	   		return false;
	   	   	   		}
	   	   		}
	    	}
	   }
	   // Si la date de fin de répartition est renseignée son format doit être valide, 
	   // sinon elle prend la valeur de la date de début.
	   if (document.forms[0].moisfin.value!=""){
	   		if (!VerifierDate2(form.moisfin, 'mmaaaa')) return false;
	   }else{
	   		document.forms[0].moisfin.value = document.forms[0].moisrep.value;
	   }
	      
	   if (form.action.value == "creer" ) {
	       if (form.nomfichier.value == "") {
	           alert("Vous devez sélectionner un fichier");
	   	       return false;
	       }
	   }
	   if (!form.typtab[0].checked && !form.typtab[1].checked)
	   {
        	alert("Choisissez un type de table de répartition");
        	return false;
       }
	   if (form.action.value == 'supprimer_detail') {
		   if (!confirm("Voulez-vous supprimer cette table de répartition pour le mois sélectionné ?")) return false;
	   }
   }

   document.getElementById( "msgEnCours" ).style.visibility ="visible";

   return true;
}

</script>
<!-- #EndEditable -->  


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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Chargement des tables de répartition JH<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/loadTabRepartJH" enctype="multipart/form-data" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action" value="creer"/>
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
                
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code Table de r&eacute;partition : &nbsp; </b></td>
                  <td> 
                  	  <html:select property="codrep" styleClass="input" size="1" onchange=""> 
                    	<html:options collection="choixCodrep" property="cle" labelProperty="libelle" /> 
                      </html:select> 
				  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <!-- TD531: SUPPRESSION DU TYPTAB PAR DEFAUT  = p -->
                <input type="hidden" name="typtab" value="P">
              <!--   <tr> 
                  <td class="lib"><b>Type de table de r&eacute;partition : &nbsp </b></td>
                  <td>     

				 		 <logic:iterate id="element" name="choixTypTab">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="typtab" value=""/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 

  				  </td>
                </tr>-->
                
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr>
                  <td class="lib"><b>Mois de la r&eacute;partition (d&eacute;but) : &nbsp; </b></td>
                  <td> 
					  <html:text property="moisrep" styleClass="input" size="9" maxlength="7" onblur="VerifierDateT9(this,'mm/aaaa');"/>
				  </td>
  				</tr>
                <tr>
                  <td class="lib"><b>Mois de la r&eacute;partition (fin) : &nbsp; </b></td>
                  <td> 
					  <html:text property="moisfin" styleClass="input" size="9" maxlength="7" onblur="VerifierDateT9(this,'mm/aaaa');"/>
				  </td>
  				</tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib"><b>Fichier &agrave; charger : &nbsp; </b></td>
                  <td> 
					  <html:file property="nomfichier" accept="csv,zip" size="47"/>
				  </td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2" align="center">
				    <div id="msgEnCours" class="msgInfo msgErreur" style="visibility: hidden;">
						Chargement en cours, veuillez patienter s'il vous pla&icirc;t...
					</div>
				  </td>
				</tr>
<%	if ( (loadTablerepartForm.getLienRapport()!=null) && (loadTablerepartForm.getLienRapport().length()>0) ) { %>
                <tr> 
                  <td colspan="2" align="center">
                  	Cliquer <a href="/rapportTabRepartJH.do?<%=loadTablerepartForm.getLienRapport()%>" onmouseover="window.status='';return true">ici</a> pour visualiser le rapport.
				  </td>
				</tr>
<% } %>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
              </table>
			  <!-- #EndEditable --></div>
            
			</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
                <tr> 
                  <td width="33%" align="right">  
                	 <html:submit property="boutonCreer" value="Charger" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                  </td>
				   <td width="33%" align="center">  
     				 <html:submit property="boutonModifier" value="Dupliquer" styleClass="input" onclick="Verifier(this.form, 'dupliquer', true);"/>
                  </td>
				   <td width="33%" align="left">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer_detail', true);"/>
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
</body>
<% 
Integer id_webo_page = new Integer("1048"); 
com.socgen.bip.commun.form.AutomateForm formWebo = loadTablerepartForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 
