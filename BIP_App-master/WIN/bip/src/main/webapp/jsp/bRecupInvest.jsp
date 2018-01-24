<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- Imports --> 
<%@ page   import="org.owasp.esapi.ESAPI,com.socgen.ich.ihm.*" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="RecupInvestForm" scope="request" class="com.socgen.bip.form.RecupInvestForm" />
<jsp:useBean id="listeRechercheInvest" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<html:html locale="true"> 
<!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

  
<title>Page BIP</title>
 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- Page autorisée à tous les utilisateurs -->
<bip:VerifUser page="jsp/eMonProfilAd.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<% String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="RecupInvestForm"  property="msgErreur" />";
   var Focus = "<bean:write name="RecupInvestForm"  property="focus" />";
   
   // Placer le focus la zone de recherche
   document.forms[0].nomRecherche.focus();
   
   if (Message != "") 
   {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].bpmontme_1)
   {
	  document.forms[0].bpmontme_1.focus();
   }
}

function ValiderEcran(form)
{
    return true;
}

function paginer(page, index , action){
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

function Verifier(form)
{
	form.action.value="modifier";
    if(form.nomRecherche.value != "")
    {       
    	form.nomRecherche.value = form.nomRecherche.value.toUpperCase()
       	form.submit();
    	return true; 
    }else{
 		alert("Veuillez saisir une lettre au moins !"); 
       	return false;	
    }      
}

function Quitter()
{
	window.close();
}
    
function fill(num)
{
	var cible = "<%=RecupInvestForm.nomChampDestinataire%>";
	var action = "<%=RecupInvestForm.rafraichir%>";
	window.opener.document.forms[0].elements[cible].value = lpad(num,'0',4);
	if(action == 'OUI')
		{
			window.opener.document.forms[0].focus.value = cible;
		   	rafraichir(window.opener.document.forms[0]);
		}
		window.close();
}
</script>
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
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request);%>
              <%=tb.printHtml()%>
            </div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><bean:write name="RecupInvestForm" property="windowTitle" /></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td></td>
        </tr>
        <tr> 
          <td><html:form action="/recupInvest.do">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="page" value="modifier"/>
                     <html:hidden name="RecupInvestForm" property="nomChampDestinataire"/>
                     <html:hidden name="RecupInvestForm" property="windowTitle"/>
                     <html:hidden name="RecupInvestForm" property="habilitationPage"/>  
                                              
                     <input type="hidden" name="index" value="modifier">                                                          
                        <table align="center">					
				        	<tr>
				            	<td class="lib">Code Investissement :&nbsp;<BR>
				                 (Veuillez saisir les premières lettres du sigle)
				                </td>
				                <td>
				                	<html:text property="nomRecherche" size="20" maxlength="20"/>
				                </td>    
				          	</tr>                                            	  				                     		
                    	  	<% int i =0;
                     	    	String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
                     	    %>   
         				</table>
         				<table width=80%>            	
             				<% if (listeRechercheInvest.size() == 99){%>
            				 <tr>
            					<td colspan="3" class="contenu"><B>Le nombre de codes trouvés est supérieur à 100<BR>
            		 			 Veuillez saisir un sigle plus long afin de mieux limiter la recherche</B>
            					</td>
            				 </tr>
            				 <tr>
            					<td >&nbsp;</td>
            				 </tr>
            				<%}%>
 
							<logic:present name="listeRechercheInvest">   
							<% if  	(listeRechercheInvest.size()>0){%>
								<tr>
									<td colspan ="4" class="contenu">Cliquez sur un code investissement pour le sélectionner</td>
								</tr>
								<BR>
 								<tr>
					 				<td class="lib" width="25%" >Code Investissement</td>
 									<td class="lib" colspan="3" >Libellé</td>
								</tr>
								<logic:iterate id="element"  name="listeRechercheInvest"  length="<%=listeRechercheInvest.getCountInBlock()%>" 
          							offset="<%=listeRechercheInvest.getOffset(0)%>"
									type="com.socgen.bip.metier.InfosInvestissement"
									indexId="index"> 
									<% if ( i == 0) i = 1; else i = 0;%>
				   						<tr class="<%= strTabCols[i] %>">
							   				<td class="contenu" >
							   					<bean:write name="element" property="lienHref" filter="false"/>
							   					<bean:write name="element" property="id" />
							   					</a>
							   				</td>
							   				<td class="contenu" ><bean:write name="element" property="name" /></td>
				   						</tr>	   
								</logic:iterate>
								<tr>
									<td align="center" colspan="4" class="contenu">
										<bip:pagination beanName="listeRechercheInvest"/>
									</td>
								</tr>						
							<%}%>				
							</logic:present>                                           	                   
          				</table>    
						<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   				<tr>
								<td align="center" colspan="4" class="contenu"></td>					
							</tr>
							<tr>
								<td align="center" colspan="4" class="contenu"></td>
							</tr>
	 						<tr>
	 							<td colspan="4">&nbsp;</td>
	 						</tr>
	 						<tr>
              					<td width="25%">&nbsp;</td>
                				<td width="25%">
                	 				<div align="center">
                	  					<html:button property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form);"/>                	                  	  
                	 				</div>
               					</td> 
               					<td width="25%"> 
                  	 				<div align="center">
                	  					<html:button property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Quitter();"/>
              		 				</div>
                				</td>
                				<td width="25%">&nbsp;</td>
            				</tr>
     					</table>
                    </div>
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
</html:html>       