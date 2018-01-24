<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.util.Hashtable"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="activiteLigneForm" scope="request" class="com.socgen.bip.form.ActiviteLigneForm" />
<jsp:useBean id="listeActivitesLignes" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 
<title>Outil de r&eacute;estim&eacute;</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bActiviteLigneRe.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
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
   var Message="<bean:write filter="false"  name="activiteLigneForm"  property="msgErreur" />";
   var Focus = "<bean:write name="activiteLigneForm"  property="focus" />";
   var pos_menu ="<%=session.getAttribute("POS_MENUACT")%>";
   
      
   if (Message != "") 
   {
      alert(Message);
   }	
   
  if (document.forms[0].pid.length-1>=parseInt(pos_menu))
		document.forms[0].pid.selectedIndex=parseInt(pos_menu);
   
}

function Verifier(form, action)
{
	form.action.value = action;
}

function VerifierSupprimer(form, action, valeur)
{
if (confirm("Voulez-vous supprimer cette ligne ?"))
{
	form.action.value = action;
   	form.pid_choisi.value = valeur;
   	return true;
}
else
{
	return false;
}
}

function ValiderEcran(form)
{ 
 
   form.pos_menu.value = form.pid.selectedIndex; 
   
   return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

</script>
 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<%
	Hashtable hKeyList= new Hashtable();
	hKeyList.put("codsg", ""+activiteLigneForm.getCodsg());
	hKeyList.put("code_activite", ""+activiteLigneForm.getCode_activite());
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList listeLigne = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("activiteLigne", hKeyList);
	// On enleve les lignes deja choisie
	for(java.util.Iterator iter = listeActivitesLignes.iterator(); iter.hasNext();)
	{
		com.socgen.bip.metier.ActiviteLigne activiteLigne = (com.socgen.bip.metier.ActiviteLigne) iter.next();
		com.socgen.bip.commun.liste.ListeOption listeOption = new com.socgen.bip.commun.liste.ListeOption(activiteLigne.getPid(), activiteLigne.getPid() + " - " + activiteLigne.getLib_ligne());
		for (int i = 0 ; i < listeLigne.size() ; i++)
		{
			if (listeOption.equals((com.socgen.bip.commun.liste.ListeOption)listeLigne.get(i)))
			{
				listeLigne.remove(i);
			}
		}
	}	
	pageContext.setAttribute("listeLigne", listeLigne);
%>
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
          <td height="20" class="TitrePage">Affectation Activit&eacute;s - Lignes BIP</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
          	<html:form action="/activiteLigne"  onsubmit="return ValiderEcran(this);"> 
            <div align="center">
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="page" value="creer"/>
		    <input type="hidden" name="index" value="creer">
		    <html:hidden property="pos_menu"/> 
		    	
			<table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      	<tr>
                        <td align="left" class="lib"><b>Code D&eacute;partement/P&ocirc;le/Groupe : </b></td>
                        <td colspan=3 >
                        	<b><bean:write name="activiteLigneForm" property="codsg"/></b>
                        	<html:hidden property="codsg"/>
                        </td>
                      </tr>
                      <tr>
                        <td align="left" class="lib"><b>Activit&eacute; : </b></td>
                        <td colspan=4>
                        	<b><bean:write name="activiteLigneForm" property="code_activite"/> - <bean:write name="activiteLigneForm" property="lib_activite"/></b>
                        	<html:hidden property="code_activite"/>
                        	<html:hidden property="lib_activite"/>
                        </td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                    </table>
                    <table border=0 cellspacing=0 cellpadding=2 class="TableBleu">
                    	<tr>
                      	<td>Ajout Ligne BIP : </td>
                        <td colspan=3>
							<html:select property="pid" styleClass="input" size="1"> 
                    			<html:options collection="listeLigne" property="cle" labelProperty="libelle"/>
                      		</html:select>
						</td>
						<td>
							<html:submit property="boutonCreer" value="Affecter" styleClass="input" onclick="Verifier(this.form, 'creer');"/>
						</td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      <tr>
                        <td colspan=6>&nbsp;</td>
                      </tr>
                      <tr class="titreTableau">
                      	<td class="lib"><B>Ligne BIP</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Libell&eacute;</B></td>
                        <td class="lib">&nbsp;</td>
                        <td class="lib"><B>Option</B></td>
                        <td class="lib">&nbsp;</td>
                      </tr>
             <% int i = 0;
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeActivitesLignes" length="<%=  listeActivitesLignes.getCountInBlock()  %>" 
            			offset="<%=  listeActivitesLignes.getOffset(0) %>"
						type="com.socgen.bip.metier.ActiviteLigne"
						indexId="index"> 
			<% 
			if ( i == 0) i = 1; else i = 0;
			 %>
					<tr class="<%= strTabCols[i] %>">
						<td class="contenu"><bean:write name="element" property="pid" /></td>
    			  		<td>&nbsp;</td>
						<td class="contenu"><bean:write name="element" property="lib_ligne"/></td>
    			  		<td>&nbsp;</td>
    			  		<td align="contenu">
    			  			<input type="submit" name="boutonSupprimer" value="Supprimer" onclick="VerifierSupprimer(this.form, 'supprimer', '<bean:write name="element" property="pid"/>');" class="input">
						</td>
    			  		<td>&nbsp;</td>
    			  	</tr>
             </logic:iterate>      
                      <html:hidden property="pid_choisi"/>
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr>
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeActivitesLignes"/>
					</td>
				</tr>
	 			<tr><td colspan="4">&nbsp;
	 			</tr>
	 			<tr>
	 				<td width="25%">
               		</td> 
               		<td width="25%">
                	 <div align="center">
                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider');"/>
                	 </div>
               		</td> 
               		<td width="25%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler');"/>
              		 </div>
                	</td>
                	<td width="25%">
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
</body>
<% 
Integer id_webo_page = new Integer("4002"); 
com.socgen.bip.commun.form.AutomateForm formWebo = activiteLigneForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
