<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="tablerepartForm" scope="request" class="com.socgen.bip.form.TableRepartForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/tabRepartJH.do"/> 
<%
	Hashtable hKeyList= new Hashtable();
	try {
		hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
		ArrayList listeDirection = listeDynamique.getListeDynamique("dirme_peri", hKeyList);
		
		hKeyList.put("coddir", ""+tablerepartForm.getCoddir());
		ArrayList listeDPG = listeDynamique.getListeDynamique("codsg", hKeyList);
		
		pageContext.setAttribute("choixDPG", listeDPG);
	    pageContext.setAttribute("choixDirection", listeDirection);
	    
	}
      catch (Exception e) {
	    pageContext.setAttribute("choixDirection", new ArrayList());
	    pageContext.setAttribute("choixDPG", new ArrayList());
	   
        %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
    }

  java.util.ArrayList listFlag = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon"); 
  pageContext.setAttribute("choixFlagActif", listFlag);
 %>
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
var rafraichiEnCours = false;

function MessageInitial()
{

   var Message="<bean:write filter="false"  name="tablerepartForm"  property="msgErreur" />";
   var Focus = "<bean:write name="tablerepartForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	   <!--document.forms[0].sigdep.focus();-->
   }
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}



function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (form.mode.value != 'delete') {
	     if (!ChampObligatoire(form.codrep, "le code")) return false;
	     if (!ChampObligatoire(form.librep, "le libellé")) return false;
	     if (!ChampObligatoire(form.coddir, "la direction")) return false;
	     if (!ListeObligatoire(form.coddeppole, "le DP")) return false;
     
     	 if (!form.flagactif[0].checked && !form.flagactif[1].checked) {
        	alert("Choisissez Active ou Inactive");
        	return false;
     	 }
     }
   

     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier cette table de répartition ?")) return false;
     }

  }

   return true;
}

function raffraichiListe(){
	if(!rafraichiEnCours)
	{
	rafraichir(document.forms[0]);
	rafraichiEnCours = true;
	}
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
          <bean:write name="tablerepartForm" property="titrePage"/> une table de r&eacute;partition<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/tabRepartJH"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
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
                  <td class="lib"><b>Code table de r&eacute;partition :</b></td>
                  <td>
					  <b><bean:write name="tablerepartForm" property="codrep"/></b><html:hidden property="codrep"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Libell&eacute; table de r&eacute;partition :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
  						<html:text property="librep" styleClass="input" size="50" maxlength="250"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="tablerepartForm" property="librep"/><html:hidden property="librep"/>
  					</logic:equal>
                  </td>
                </tr>
                <tr> 
                 <td  class="lib" ><b>Direction :</b></td>
                  <td> 
                   <logic:notEqual parameter="action" value="supprimer">
					   <html:select property="coddir" styleClass="input" onchange="raffraichiListe();"> 
					   		<option value=" "> </option>
                	        <html:options collection="choixDirection" property="cle" labelProperty="libelle" />
					   </html:select>
				   </logic:notEqual>
  				   <logic:equal parameter="action" value="supprimer">	
  					   <bean:write name="tablerepartForm" property="coddir"/>&nbsp;-&nbsp;<bean:write name="tablerepartForm" property="libdir"/>
  				   </logic:equal>
                  </td>
                </tr>
                <%if(tablerepartForm.getCoddir()!=null) { %>
                <tr> 
                  <td  class="lib" ><b>CODE DP:</b></td>
                  <td> 
                   <logic:notEqual parameter="action" value="supprimer">
					   <html:select property="coddeppole" styleClass="input" size="1"> 
                	        <html:options collection="choixDPG" property="cle" labelProperty="libelle" />
					   </html:select>
				   </logic:notEqual>
  				   <logic:equal parameter="action" value="supprimer">	
  					   <bean:write name="tablerepartForm" property="coddeppole"/>&nbsp;-&nbsp;<bean:write name="tablerepartForm" property="libdeppole"/>
  				   </logic:equal>
                  </td>
                </tr>
                <tr>   
                <tr> 
                <%}else{ %>
                <html:hidden property="codsg" value="" />
                <%} %>
                  <td class="lib"><b>Table active :</b> 
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixFlagActif">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="flagactif" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="tablerepartForm" property="flagactif"/>
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
Integer id_webo_page = new Integer("1047"); 
com.socgen.bip.commun.form.AutomateForm formWebo = tablerepartForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
