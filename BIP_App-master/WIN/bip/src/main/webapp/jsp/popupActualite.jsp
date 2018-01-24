 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="popupActualiteForm" scope="request" class="com.socgen.bip.form.PopupActualiteForm" />
<jsp:useBean id="listeRechercheId" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title><bean:message key="bip.ihm.actualite.popup.titre"  /></title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">

<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
	{
	   var Message="<bean:write filter="false"  name="popupActualiteForm"  property="msgErreur" />";
	   var Focus = "<bean:write name="popupActualiteForm"  property="focus" />";
	   if (Message != "") {
	      alert(Message);
	   }
	}
   function Verifier(form, action)
   {
   
	<%
		String codes_a_valider="";
	for(int i=0; i< Integer.parseInt(listeRechercheId.getCountInBlock()); i++)
	{
	com.socgen.bip.metier.InfosActualite elt = (com.socgen.bip.metier.InfosActualite)listeRechercheId.get(i);
	if(i==0)codes_a_valider= elt.getCode_actu();
	else
		codes_a_valider+= "|" + elt.getCode_actu();
	}
	
	%>
	form.codes.value='<%=codes_a_valider%>';
	
	form.action.value = action;
	
	
	window.close();
	}
function verifFocus(){	
		if (unElementDuFormulaireAFocus == false){
			window.focus();
		}
		var timer = setTimeout(verifFocus, 10);
	}

	function gagneFocus(){
		unElementDuFormulaireAFocus = true;
	}
	function perteFocus(){
		unElementDuFormulaireAFocus = false;
	}	
</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();gagneFocus(); verifFocus();" onBlur="perteFocus()">
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:message key="bip.ihm.actualite.popup.titre"  /><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --><html:form action="/popupActualite"  onsubmit="return ValiderEcran(this);gagneFocus(); verifFocus();"><!-- #EndEditable --> 
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" --> 
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="codes"/>
			<html:hidden property="action"/>
			<html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			 <% int i =0;
              String[] strTabCols = new String[] {  "fond1" , "fond2" }; 
            %> 
		                    <table border=1 cellspacing=2 cellpadding=2 class="TableBleu">
		                    <tr class="lib">
             <td  align="center" class="contenu"  ><b>Date</b></td>
               <td  align="center" class="contenu" ><b>Titre</b></td>
               <td  align="center" class="contenu"  ><b>Texte</b></td>
               </tr>
    	    <logic:present name="listeRechercheId">   
			<% if  	(listeRechercheId.size()>0){%>

			<logic:iterate id="element"  name="listeRechercheId"  length="<%=listeRechercheId.getCountInBlock()%>" 
					          offset="<%=listeRechercheId.getOffset(0)%>"
			   				  type="com.socgen.bip.metier.InfosActualite"
			 					  indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;%>
			
 			<tr class="<%= strTabCols[i] %>">
 			<td class="contenu" align="center">
				   <b><bean:write name="element" property="date_affiche" /></b>
				</td>
				<td class="contenu" align="center">
				   <b><bean:write name="element" property="titre" /></b>
				</td>
			   <td class="contenu" align="center">
					<b><bean:write name="element" property="texte" />
			    </td>
			    
		   </tr>
		   </logic:iterate>       		
		   <tr>
				<td align="center" colspan="4" class="contenu">
					<bip:pagination beanName="listeRechercheId"/>
				</td>
			</tr>						
			<%}%>				
			</logic:present>                                           	                   
            <tr> 
                      </table>
                   
                    <table width="100%" border="0">
                     <tr> 
                       <td width="33%" align="center">  
                        <input type="submit"    name="boutonCreer" value="valider" onclick="Verifier(this.form, 'creer');"/>
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
</body></html:html>
<!-- #EndTemplate -->
