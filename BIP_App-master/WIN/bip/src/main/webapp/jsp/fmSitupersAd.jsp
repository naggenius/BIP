<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="personneForm" scope="request" class="com.socgen.bip.form.PersonneForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bPersonneAd.jsp"/> 
 <%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("situpers",personneForm.getHParams()); 
  pageContext.setAttribute("choix1", list1);  
  
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	
  request.setAttribute("soccode", personneForm.getSoccode());
  request.setAttribute("menu", menuId);
  
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String Rtype = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("rtype")));
	String sRtype="";
	
	if(Rtype.equals("A"))
		   sRtype = "un agent SG ";
    else if(Rtype.equals("P"))
		   sRtype = "une prestation ";
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="personneForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
   }
    if (document.forms[0].datsitu.selectedIndex==-1){
	 	document.forms[0].datsitu.selectedIndex=0;
	}
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
 
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
    if (form.action.value=='modifier') {
    	form.mode.value = 'update';
    }
    if (form.action.value=='supprimer') {
    	form.mode.value = '';
    }

   }

   return true;
}

</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr > 
          <td> 
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
			</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><div id="titre" ><!-- #BeginEditable "titre_page" -->Situations 
            d'<%= sRtype %><!-- #EndEditable --></div></td>
        </tr>
        <tr> 
          <td>
		  <div id="content">
		  <!-- #BeginEditable "debut_form" --><html:form action="/situpers"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
                <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              	<html:hidden property="action"/>
		  		<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		  		<html:hidden property="rtype"/>
		  		<html:hidden property="soccode"/>
		  		<html:hidden property="flaglock"/>
		  	    <html:hidden property="keyList0"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                 <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="texteGras">Nom :</td>
                  <td class="texte"><b><bean:write name="personneForm"  property="rnom" /></b>
                    	<html:hidden property="rnom"/>
                  </td>
                  <td width="30">&nbsp;</td>
                  <td class="texteGras"> Identifiant :</td>
                  <td class="texte">
                  		<bean:write name="personneForm"  property="ident" />
                    	<html:hidden property="ident"/>
                  
                     </td>
                </tr>
                <tr> 
                  <td class="texteGras" >Pr&eacute;nom :</td>
                  <td class="texte">
                  		<bean:write name="personneForm"  property="rprenom" />
                    	<html:hidden property="rprenom"/>
                  </td>
                  <td >&nbsp;</td>
                  <td class="texteGras"> Matricule :</td>
                  <td class="texte">
                     	<bean:write name="personneForm"  property="matricule" />
                    	<html:hidden property="matricule"/>
                  </td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td >&nbsp;</td>
                  <td class="texteGras"> IGG :</td>
                  <td class="texte">
                  		<bean:write name="personneForm"  property="igg" />
                    	<html:hidden property="igg"/>
                  </td>
                </tr>
                
                <tr> 
                  <td align=center >&nbsp;</td>
                </tr>
                 </table>
                 <table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="200">
                <tr> 
                  <td align=center class="texte"><u>Liste des situations existantes</u> 
                    : </td>
                </tr>
                <tr> 
                  <td class="texteGras"><b>
			        <span STYLE="position: relative; left:  4px; z-index: 1;">Date début</span>
					<span STYLE="position: relative; left:  7px; z-index: 1;">Date fin </span>	
					<span STYLE="position: relative; left: 30px; z-index: 1;">DPG</span>
					<span STYLE="position: relative; left: 55px; z-index: 1;">Prest.</span>
					<span STYLE="position: relative; left: 60px; z-index: 1;">Soc.</span>	
                <%					
				 if(!"SG..".equals(personneForm.getSoccode())){
                 %>
  				   <span STYLE="position: relative; left: 120px; z-index: 1;">Coût HT
                 <%
                 } else  {
  	               if("DIR".equals(menuId)) {
                   %> 								
			       <span STYLE="position: relative; left: 65px; z-index: 1;">Niv.&nbsp; 			        		
                   <%  
	               }	
                 }//fin else
                %>			    	
			        </span>
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
                </tr>
				<tr>
					<td align="center">
						<table width="100%" border="0">
					
							<tr> 
							  <td width=10%>&nbsp;</td>
							  <td width="20%" align="center">  
							  <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
							  </td>
							  <td width="20%" align="center">  
							  <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
							  </td>
							  <td width="20%" align="center">  
							  <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
							  <td width="20%" align="center">  
							  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'retour', '', true);"/>
							  </td>
							  <td width=10%>&nbsp;</td>
							  
							</tr>
						</table>
					</td>
				</tr>
				<tr> 
					<td >&nbsp;</td>
				</tr>
			</table>
             <!-- #EndEditable --></div>
		</td>
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --></div>
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