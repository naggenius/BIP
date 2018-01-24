 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="datesEffetForm" scope="request" class="com.socgen.bip.form.DatesEffetForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDatesEffetAd.jsp"/> 
 <%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("parambip",datesEffetForm.getHParams()); 
  pageContext.setAttribute("choix1", list1);  
  
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
	
  request.setAttribute("menu", menuId);
  
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));

%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="datesEffetForm"  property="msgErreur" />";
   
   if (Message != "") {
      alert(Message);
   }
    if (document.forms[0].num_ligne.selectedIndex==-1){
	 	document.forms[0].num_ligne.selectedIndex=0;
	}
}

function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value =action;
 
}

function ValiderEcran(form)
{
   var index = form.num_ligne.selectedIndex;

   if (blnVerification) {
	if ( (index==-1) && (form.action.value != 'creer') ) {
	   alert("Choisissez une ligne de paramètre BIP");
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Gestion des lignes d'un paramètre Bip <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/majLignesParamBip"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
                <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                <html:hidden property="arborescence" value="<%= arborescence %>"/>
              	<html:hidden property="action"/>
		  		<html:hidden property="mode"/>
		  		<html:hidden property="commentaire"/>
		  		<html:hidden property="dateffet"/>
		  		<html:hidden property="heureffet"/>
		  		<html:hidden property="datfin"/>
		  		<html:hidden property="heurfin"/>

              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib">Code action :</td>
                  <td ><b><bean:write name="datesEffetForm"  property="codaction" /></b>
                    	<html:hidden property="codaction"/>
                  </td>
                  <td width="30">&nbsp;</td>
                  <td class="lib"> Code version :</td>
                  <td >
                  		<bean:write name="datesEffetForm"  property="codversion" />
                    	<html:hidden property="codversion"/>
                  
                     </td>
                </tr>
                <tr> 
                  <td align=center >&nbsp;</td>
                </tr>
                 </table>
                 <table cellspacing="2" cellpadding="2" class="tableBleu" border="0" width="600">
                <tr> 
                  <td align=center ><u>Liste des lignes de ce paramètre Bip</u></td>
                </tr>
                <tr> 
                  <td class="lib"><b>
			        <span STYLE="position: relative; left:  4px; z-index: 1;">Ligne</span>
					<span STYLE="position: relative; left:  14px; z-index: 1;">active </span>	
					<span STYLE="position: relative; left: 30px; z-index: 1;">valeur (début)</span>
                      </b>	               
                  </td> 
                </tr>
                <tr> 
                  <td align=center>
                   	 <html:select property="num_ligne" style="width:600px;" styleClass="Multicol" size="20">
						  <bip:options collection="choix1"/>
					 </html:select>
                  </td>
                </tr>
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
                  <html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form, 'creer', true);"/>
                  </td>
				  <td width="20%" align="center"> 
				  <%if (list1.size()>0){%> 
     			  	<html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
     			  <%}else{%>
     			  	<html:submit property="boutonModifier" disabled="true" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', true);"/>
     			  <%}%>
                  </td>
				  <td width="20%" align="center">
				  <%if (list1.size()>0){%>   
				  	<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
				  <%}else{%>
				  	<html:submit property="boutonSupprimer" disabled="true" value="Supprimer" styleClass="input" onclick="Verifier(this.form, 'supprimer', true);"/>
				  <%}%>
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
</body>
</html:html> 

<!-- #EndTemplate -->