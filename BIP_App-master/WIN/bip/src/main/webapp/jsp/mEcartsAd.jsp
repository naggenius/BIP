<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.lang.reflect.InvocationTargetException"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ecartsForm" scope="request" class="com.socgen.bip.form.EcartsForm" />
<!-- l'ID du bean PaginationVector doit être le même que celui défini dans BipConstantes -->
<jsp:useBean id="listeEcarts" scope="session" class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!--  ABN - HP PPM 57787 - DEBUT  -->
 <!-- #BeginEditable "doctitle" --> 
<title>
	<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
	<%=rb.getString("env.titrepage")%>
</title>
<!--  ABN - HP PPM 57787 - FIN  -->


<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">

<bip:VerifUser page="/ecarts.do"/>
<% 	int i = 0;
   	int j = 0;
   	int k = 0;
  	int mois=0;
	int nbligne = 0;
	String libCdeb="";
	String libIdent="";
	String libType="";
	String libValide="";
	String libCommentaire="";
	String[] strTabCols = new String[] {  "fond1" , "fond2" };
	
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
	
var blnVerification = true;
var allCodeActivite = new Array();

<%

    String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sIndexMenu = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("indexMenu")));

%>

function MessageInitial()
{
	var Message="<bean:write filter="false"  name="ecartsForm"  property="msgErreur" />";
	var Focus = "<bean:write name="ecartsForm"  property="focus" />";
	
	if (Message != "") {
    	alert(Message);
    	<% ecartsForm.setMsgErreur(""); %>
	}
}


function Verifier(form, action, flag)
{
  blnVerification = flag;
  form.action.value = action;
}

function ValiderEcran(form)
{
  
   return true;
}


function paginer(page, index , action){
	document.forms[0].action.value = action;
	document.forms[0].page.value   = page;
    document.forms[0].index.value  = index;
    document.forms[0].submit();
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
          <td height="20" class="TitrePage">Liste des Ecarts<bean:write name="ecartsForm"  property="msgtrait" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td> 
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
            <!-- #BeginEditable "debut_form" -->
            <html:form action="/ecarts"  onsubmit="return ValiderEcran(this);">
            <!-- #EndEditable --> 
            <table width="100%" border="0">
            
              <tr><td>&nbsp;</td></tr>
              <tr><td>&nbsp;</td></tr>
              
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
				                                    	
                    <input type="hidden" name="pageAide">
                    <input type="hidden" name="indexMenu" value="<%= sIndexMenu %>">
                    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                 	<html:hidden property="page" value="modifier"/>
             		<input type="hidden" name="index" value="modifier">
             	   
                    <html:hidden property="numtrait"/>             				
                    <html:hidden property="msgtrait"/>
                    <html:hidden property="nexttrait"/>		
                    	
				    <!-- Tableau des écarts -->
                    <table width="95%" border="0" cellspacing="0" cellpadding="2" >
                            <tr class="titreTableau">
                              <td align="center" width="2%" class="lib"><b>Valider</b></td>
					          <td align="center" width="6%" class="lib"><b>Dpg</b></td>
					          <td align="center" width="6%" class="lib"><b>Date</b></td>
					          <td align="center" width="6%" class="lib"><b>Id</b></td>
					          <td align="left" width="8%" class="lib"><b>Nom</b></td>
					          <td align="center" width="8%" class="lib"><b>D&eacute;but situation</b></td>
					          <td align="center" width="8%" class="lib"><b>Fin contrat</b></td>
					          <td align="center" width="6%" class="lib"><b>Type</b></td>
					          <td align="center" width="4%" class="lib"><b>Nb jours BIP</b></td>
					          <td align="center" width="4%" class="lib"><b>Nb jours GERSH</b></td>
					          <td align="center" width="4%" class="lib"><b>Nb jours MOIS</b></td>
					          <td align="left" width="25%" class="lib"><b>Commentaire</b></td>
					          
					        </tr>
      		<logic:iterate id="element" name="listeEcarts" length="<%= listeEcarts.getCountInBlock() %>" 
            		offset="<%= listeEcarts.getOffset(0) %>" type="com.socgen.bip.metier.Ecart" indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   libCdeb="lib_cdeb_"+nbligne;
			   libIdent="lib_ident_"+nbligne;
			   libType="lib_type_"+nbligne;
			   libValide="lib_valide_"+nbligne;
			   libCommentaire="lib_commentaire_"+nbligne;
								  		
			 %>
			        <tr class="<%= strTabCols[i] %>">
						
						<td class="contenuCenter">
						   <logic:equal name="element" property="valide" value="N">
                  		          <input TYPE="checkbox" NAME="<%= libValide %>" VALUE="<bean:write name="element" property="valide"/>" >
                           </logic:equal>
                           <logic:notEqual name="element" property="valide" value="N">
                  		          <input TYPE="checkbox" NAME="<%= libValide %>" VALUE="<bean:write name="element" property="valide"/>" checked>
                           </logic:notEqual>
                        </td>
                        	
						<td class="contenuCenter"><bean:write name="element" property="codsg" /></td>
						<td class="contenuCenter"><bean:write name="element" property="cdeb" /></td>
						<input type="hidden" name="<%=libCdeb%>" value="<bean:write name="element" property="cdeb"/>">
    			  		<td class="contenuCenter"><bean:write name="element" property="ident" /></td>
    			  		<input type="hidden" name="<%=libIdent%>" value="<bean:write name="element" property="ident"/>">
    			  		<td class="contenu"><bean:write name="element" property="nom" /></td>
    			  		<td class="contenuCenter"><bean:write name="element" property="datsitu" /></td>
    			  		<td class="contenuCenter"><bean:write name="element" property="datdep" /></td>
						<td class="contenuCenter"><bean:write name="element" property="type"/></td>
						<input type="hidden" name="<%=libType%>" value="<bean:write name="element" property="type"/>">
						<td class="contenuCenter"><bean:write name="element" property="nbjbip"/></td>
						<td class="contenuCenter"><bean:write name="element" property="nbjgersh"/></td>
						<td class="contenuCenter"><bean:write name="element" property="nbjmois"/></td>
						<td class="contenu"><input type="text" size="50" maxlength="255" name="<%=libCommentaire%>" value="<bean:write name="element" property="commentaire" />" ></td>
						
					
    			  	</tr>
				  
                              
                           		
			</logic:iterate> 
                                                              
                              
                                               
                          </table>
             
             	          <table width="100%" border="0" cellspacing="0" cellpadding="0">
			   	            <tr>
					          <td align="center" colspan="4" class="contenu">
						        <bip:pagination beanName="listeEcarts"/>
					          </td>
				            </tr>
	 			            <tr><td colspan="4">&nbsp;</td></tr>
	 			            <tr>
              		          <td width="25%">&nbsp;</td>
                	          <td width="25%">
                	            <div align="center">
                	              <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/>
                	            </div>
               		          </td> 
               		          <td width="25%"> 
                  	            <div align="center"> 
                	              <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false);"/>
              		            </div>
                              </td>
                              <td width="25%">&nbsp;</td>
            	            </tr>
     
				          </table>
				        </td>
            	      </tr>
     
				    </table>
				  </table>

                  </div>
                </td>
              </tr>
            </table>
            
            </html:form>
            
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
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
Integer id_webo_page = new Integer("1037"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ecartsForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
