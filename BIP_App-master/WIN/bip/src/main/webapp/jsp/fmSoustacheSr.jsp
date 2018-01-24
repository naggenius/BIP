 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="sousTacheForm" scope="request" class="com.socgen.bip.form.SousTacheForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/structLb.do"/>
<%  
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_sousTache",sousTacheForm.getHParams());
    pageContext.setAttribute("choixStache", list1);

%>   
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="sousTacheForm"  property="msgErreur" />";
   var Focus = "<bean:write name="sousTacheForm"  property="focus" />";

   if (Message != "") {
      alert(Message);
   }
    if (document.forms[0].sous_tache.options[0].value==" ") {
 	document.forms[0].boutonModifier.disabled=true;
	document.forms[0].boutonSupprimer.disabled=true;
 }
 	
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
}
function ValiderEcran(form)
{
 	
    if (form.sous_tache.selectedIndex==-1 && (form.action.value=='modifier'||form.action.value=='supprimer'))
    {
		alert('Choisissez une sous-tâche');
		return (false);
	}
	if (form.action.value=='supprimer') 
	{
		<!--if (!confirm("Attention : la suppression d'une tâche entraîne la suppression des sous-tâches,\naffectations et consommés qui lui sont associés !\nVoulez-vous vraiment supprimer cette tâche ?")) return false;-->
	    // Suppression immédiate sans passer par une page intermédiaire
	    	form.action.value= 'valider';
	    	form.mode.value='delete';   	
   	}
   	if (form.action.value=='modifier')
   	{
   		form.mode.value='update';
   	}
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Les 
            sous-t&acirc;ches d'une ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/sousTache"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
             <html:hidden property="action" value="creer"/>
             <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
             <html:hidden property="keyList0"/> <!--pid-->
             <html:hidden property="keyList1"/> <!--n°etape-->
             <html:hidden property="keyList2"/> <!--n°tache-->
             <html:hidden property="keyList3"/> <!--ECET - LIBETAPE-->
             <html:hidden property="keyList4"/> <!--ACTA - LIBTACHE-->
             <html:hidden property="etape"/>
             <html:hidden property="tache"/>
             <html:hidden property="pid"/>
               <table border="0" cellpadding="0" cellspacing="0"   width="100%" class="tableBleu" >
	   		<tr>
				<td>&nbsp;</td>
    	   </tr>
		    <tr>
				<td>&nbsp;</td>
    	   </tr>
    	   </table>
    	   	<table border=2 cellspacing=0 cellpadding=10  class="TableBleu" bordercolor="#B980BF">
            <tr>	
                  <td align="center" colspan="2"> <b>Ligne BIP </b>:<b> <bean:write name="sousTacheForm"  property="lib" /><html:hidden property="lib"/></b> 
                </td>
            </tr>
              
            <tr>	
                  <td align="center"> <b>Etape </b>: <b> <bean:write name="sousTacheForm"  property="keyList3" /><html:hidden property="keyList3"/></b> 
                </td>	
                  <td align="center"> <b>Tâche </b>: <b> <bean:write name="sousTacheForm"  property="keyList4" /><html:hidden property="keyList4"/></b> 
                </td>
            </tr> 
            </table>
            <table border="0" cellpadding="2" cellspacing="0"   class="tableBleu" >
                <tr>
				<td>&nbsp;</td>
    	   		</tr>
		   	     <tr>
				<td>&nbsp;</td>
    	   		</tr>
  				<tr> <td  class="lib">
  					<span STYLE="position: relative; left:  4px; z-index: 1;">N°</span>
					<span STYLE="position: relative; left:  7px; z-index: 1;">Libellé</span>
					<span STYLE="position: relative; left:  200px; z-index: 1;">Type</span>
					<span STYLE="position: relative; left:  215px; z-index: 1;">Date début</span>
					<span STYLE="position: relative; left:  225px; z-index: 1;">Date fin</span>		
                  </td>
               
                </tr>
                <tr> 
                  <td > 
                  <html:select property="sous_tache" styleClass="Multicol" size="5">
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
                <tr> 
                  <td >&nbsp;</td>
                </tr>
              </table>
			<!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td align="center"> 
            <table width="100%" border="0">
              <tr> 
                <td width="25%" align="center"> <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/> 
                </td>
                <td width="25%" align="center"> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/> 
                </td>
                <td width="25%" align="center"> <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/> 
                </td>
			    <td width="25%" align="center"><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'retour', true);"/>
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
<!-- #EndTemplate -->
