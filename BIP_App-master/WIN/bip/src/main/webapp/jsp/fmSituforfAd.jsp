<!DOCTYPE html> 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="forfaitForm" scope="request" class="com.socgen.bip.form.ForfaitForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bForfaitAd.jsp"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("situforf",forfaitForm.getHParams()); 
  pageContext.setAttribute("choix1", list1); 
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="forfaitForm"  property="msgErreur" />";
   var Focus = "<bean:write name="forfaitForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
    if (document.forms[0].datsitu.selectedIndex==-1){
	 	document.forms[0].datsitu.selectedIndex=0;
	}
}

function Verifier(form, action, mode, flag)
{
  blnVerification = flag;
  form.action.value =action;
   form.mode.value =mode;
}
function ValiderEcran(form)
{
   var index = form.datsitu.selectedIndex;

   if (blnVerification) {
	if ( (index==-1) && (form.action.value != 'creer') ) {
	   alert("Choisissez une situation");
	   return false;
	}
    if (form.action.value=='creer') {
    	form.mode.value = 'insert';
    }

   }

   return true;
}
</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr>  
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Situations 
            d'un forfait<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/situforf"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
               	<html:hidden property="action"/>
		  		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		  		<html:hidden property="flaglock"/>
		  	    <html:hidden property="keyList0"/>
				<html:hidden property="typeForfait"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td colspan="11">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="11">&nbsp;</td>
                </tr>
                <tr align="left"> 
                   <td class="texte" colspan="3" >Nom :</td>
                  <td class="texte"><b><bean:write name="forfaitForm"  property="rnom" /></b>
                    	<html:hidden property="rnom"/> 
                  </td>
                  <td colspan=2>&nbsp;</td>                  
                  <td class="texte" colspan="4">Type de ressource :</td>
                  <td class="texte" colspan="2">
					<% if ( ("F").equals(forfaitForm.getTypeForfait())) {%>
                  	  F - Forfait AVEC frais d'environnement
                   	<% }
                   	else { %>
               		  E - Forfait SANS frais d'environnement
               		<% } %>
                   	<html:hidden property="typeForfait"/>
                  </td>
                </tr>
                <tr align="left"> 
                   <td class="texte" colspan="3">Identifiant :</td>
                  <td class="texte"><bean:write name="forfaitForm"  property="ident" />
                    	<html:hidden property="ident"/>
                   </td>
                  <td colspan=2>&nbsp;</td>
                  <td class="texte" colspan="4"> Co&ucirc;t total :</td>
                  <td colspan="2" class="texte">
                  		<bean:write name="forfaitForm"  property="coutot" />
                    	<html:hidden property="coutot"/>
               
                  </td>
                </tr>
                <tr> 
                  <td align=center colspan=11>&nbsp;</td>
                </tr>
              </table>
			   <table cellspacing="2" cellpadding="2" class="tableBleu" width="300">
                <tr align="left"> 
                  <td align=center class="texte"><u>Liste des situations existantes</u> 
                    : </td>
                </tr>
                <tr align="left">
				<td class="lib"><b>
			        <span STYLE="position: relative; left:  4px; z-index: 1;">Date début</span>
					<span STYLE="position: relative; left:  17px; z-index: 1;">Date fin </span>	
					<span STYLE="position: relative; left: 50px; z-index: 1;">DPG</span>
					<span STYLE="position: relative; left: 75px; z-index: 1;">Prest.</span>
					<span STYLE="position: relative; left: 90px; z-index: 1;">Soc.</span>	
			        <span STYLE="position: relative; left: 140px; z-index: 1;">Coût HT</span>
			        <span STYLE="position: relative; left: 180px; z-index: 1;">Fact. au 12&egrave;me</span>
			        </b>	               
                  </td> 
                </tr>
                <tr> 
                  <td align=center>
                  	<html:select property="datsitu" styleClass="Multicol" size="5">
						  <bip:options collection="choix1"/>
					 </html:select>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                <tr> 
                  <td>&nbsp;</td>
                <tr> 
                  <td>&nbsp;</td>
              </table>
              <!-- #EndEditable --></div>
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
                <tr> 
                  <td width=10%>&nbsp;</td>
                  <td width="20%" align="center">  
                	 <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', 'insert', true);"/>
                  </td>
				   <td width="20%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', 'update', true);"/>
                  </td>
				   <td width="20%" align="center">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', '', true);"/>
                  </td>
				   <td width="20%" align="center">  
					<html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'retour', '', true);"/>
                  </td>
                  <td width=10%>&nbsp;</td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html> 

<!-- #EndTemplate -->