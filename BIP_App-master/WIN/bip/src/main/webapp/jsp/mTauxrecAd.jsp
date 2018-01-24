<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="tauxrecForm" scope="request" class="com.socgen.bip.form.TauxrecForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmTauxrecAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<% String libFiliale=new String();
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("filiale");

 com.socgen.bip.commun.liste.ListeOption listeOption;
 int j=0;
for (java.util.Iterator i = list1.iterator(); i.hasNext(); ){
	  	try{
	  		listeOption= (com.socgen.bip.commun.liste.ListeOption)list1.get(j);
	  		j++;
	  	
  	  	}
  	  	catch(IndexOutOfBoundsException inde) {
  	  		break;
  	  	}
  		
  		if (listeOption.getCle().trim().equals(ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("filcode"))).toString().trim())){
  		libFiliale=listeOption.getLibelle();
  		break;
  		}
  		  
        list1.iterator().next();
}
                     	 
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="tauxrecForm"  property="msgErreur" />";

   if (Message != "") {
      alert(Message);
   }
   if(document.forms[0].mode.value!="delete")
		document.forms[0].taux_rec.focus();

}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
	if (blnVerification==true){
	     if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  			
  		 if (form.mode.value == 'delete') {
		 	if (!confirm("Voulez-vous supprimer ces taux ?")) return false;
		 }
		 else
   			if (form.taux_rec && !ChampObligatoire(form.taux_rec, "le taux de récupération")) return false;
   			if (form.filcode && !ChampObligatoire(form.filcode, "la filiale")) return false;
   			if (form.filcode == '01 ' ){
   			if (form.taux_sal && !ChampObligatoire(form.taux_sal, "le taux de charge salariale")) return false;}
   		 	if (form.mode.value == 'update') {
	        	if (!confirm("Voulez-vous modifier ces taux ?")) return false;
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
          <bean:write name="tauxrecForm" property="titrePage"/> les taux annuels
            <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/tauxrec"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
             	<html:hidden property="action"/>
             	<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
             	<html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                 
                  <td class="lib">Ann&eacute;e:</td>
                  <td>
					<b> <bean:write name="tauxrecForm" property="annee"/><html:hidden property="annee"/></b>
        
                  </td>
                </tr>
               <logic:notEqual parameter="action" value="supprimer"> 
                  <tr> 
                    <td class="lib" ><B>Taux de récupération : </B></td>
                  	<td>
                   		<b>
				<% 
				out.println(libFiliale);
				 %><html:hidden property="filcode"/></b>
						<html:text property="taux_rec" styleClass="input" size="10" maxlength="10" onchange="return VerifierNum(this,7,2);"/>
                   	</td>
                  </tr>
                  <logic:equal parameter="filcode" value="01"><tr> 
                    <td class="lib" ><B>Taux de charge salariale : </B></td>
                  	<td>
                   		<html:text property="taux_sal" styleClass="input" size="10" maxlength="10" onchange="return VerifierNum(this,7,2);"/>
                   	</td>
                  </tr> </logic:equal>  	
                </logic:notEqual>
                <logic:equal parameter="action" value="supprimer">
                   <tr>
                     <td class="lib" >Taux de récupération : </td>
                  	 <td><b>
                     	 <% out.println(libFiliale);
                     	 %></b>
                     	 <html:hidden property="filcode"/><bean:write name="tauxrecForm"  property="taux_rec"/>
                     </td>
                   </tr>
                   <logic:equal parameter="filcode" value="01"><tr>
                     <td class="lib" >Taux de charge salariale : </td>
                  	 <td>
                     	<bean:write name="tauxrecForm"  property="taux_sal"/>
                     </td>
                   </tr></logic:equal> 
                </logic:equal> 
                   
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                </tr>
                <tr> 
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
Integer id_webo_page = new Integer("1018"); 
com.socgen.bip.commun.form.AutomateForm formWebo = tauxrecForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
