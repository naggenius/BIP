<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="prestationForm" scope="request" class="com.socgen.bip.form.PrestationForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true">
<!-- #EndEditable -->  <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmPrestationAd.jsp"/>
<% 

  Hashtable hKeyList= new Hashtable();
  hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
  
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topActif"); 
  pageContext.setAttribute("choixTop", list1);
  
 try {	
		
	    ArrayList listeDomaine = listeDynamique.getListeDynamique("domaine", hKeyList);
	    pageContext.setAttribute("choixDomaine", listeDomaine);
	    	    
	    ArrayList listeRtype = listeDynamique.getListeDynamique("rtype", hKeyList);
	    pageContext.setAttribute("choixRtype", listeRtype);
	  	        
	}   
  catch (Exception e) {
	    pageContext.setAttribute("choixDomaine", new ArrayList());
	    pageContext.setAttribute("choixRtype", new ArrayList());
  }	    
  
  
  
  
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


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="prestationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="prestationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].libprest){
	  
	  document.forms[0].libprest.focus();
   }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.mode.value =mode;
   form.action.value = action;

} 
function ValiderEcran(form)
{   

  if (blnVerification == true) {
     if (form.mode.value == 'delete') {
        if (!confirm("Voulez-vous supprimer ce code prestation ?")) return false;
     }
     else {
	     
	     //if (!ChampObligatoire(form.codfi, "le code coût standard")) return false;
	     
	     if (!ListeObligatoire(form.code_domaine, "le domaine")) return false;
	     if (!ChampObligatoire(form.libprest, "le libellé")) return false;
	     if (!ChampObligatoire(form.code_acha, "le code ACHA")) return false;
	     if (!ListeObligatoire(form.rtype, "le type de la ressource")) return false;
	      
	     if (form.mode.value == 'update') {
	        if (!confirm("Voulez-vous modifier ce code prestation ?")) return false;
	     }
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="prestationForm" property="titrePage"/> un code prestation<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --> <html:form action="/prestation"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
  			  <html:hidden property="titrePage"/>
		      <html:hidden property="action"/>
		      <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td  width="152" >&nbsp;</td>
                  <td width=205  >&nbsp;</td>
                </tr>
                <tr> 
                  <td  width="152" >&nbsp;</td>
                  <td width=205  >&nbsp; </td>
                </tr>
                <tr> 
                  <td   class="lib" ><b> Prestation :</b> </td>
                  <td ><b> <bean:write name="prestationForm"  property="codprest" /></b> 
                    <html:hidden property="codprest"/> 
                  
                  </td>
                </tr>
                
                <tr> 
                  <td  class="lib"><b>Domaine :</b> </td>
                  <td >
                  <logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="code_domaine" styleClass="input"> 
   						<bip:options collection="choixDomaine" />
						</html:select>
					</logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="prestationForm"  property="code_domaine" />
                   </logic:equal>
                 
                  </td>
                </tr>
                
                <tr> 
                  <td  class="lib" ><b>Libellé :</b></td>
                  <td  >
                  <logic:notEqual parameter="action" value="supprimer"> 
                  	<html:text property="libprest" styleClass="input" size="60" maxlength="60" />
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="prestationForm"  property="libprest" />
                   </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Code ACHA :</b> </td>
                  <td >
                  <logic:notEqual parameter="action" value="supprimer"> 
                   <html:text property="code_acha" styleClass="input" size="2" maxlength="2" onchange="return VerifierAlphaMax(this);"/> 
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="prestationForm"  property="code_acha" />
                   </logic:equal>
                  </td>
                </tr>
                
               <tr> 
                  <td  class="lib"><b>Type de ressource :</b> </td>
                  <td >
                  <logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="rtype" styleClass="input"> 
   						<html:options collection="choixRtype" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="prestationForm"  property="rtype" />
                   </logic:equal>
                 
                  </td>
                </tr>
                
                <tr> 
                  <td  class="lib"><b>Top Actif :</b> </td>
                  <td >
                  <logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="top_actif" styleClass="input"> 
   						<html:options collection="choixTop" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="prestationForm"  property="top_actif" />
                   </logic:equal>
                 
                  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> </tr>
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
				  	<div align="center">
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/>
                  	</div>
				  </td>
				  <td width="25%">  
				  	<div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
                  		</div>
				  </td>
				  <td width="25%">&nbsp;</td>
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
Integer id_webo_page = new Integer("1006"); 
com.socgen.bip.commun.form.AutomateForm formWebo = prestationForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->