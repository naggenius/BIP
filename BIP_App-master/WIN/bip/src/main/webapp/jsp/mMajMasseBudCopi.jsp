<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/struts-nested.tld" prefix="nested" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true"> 
<jsp:useBean id="budCopiMasseForm" scope="request" class="com.socgen.bip.form.BudCopiMasseForm" />

<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>
 
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/budCopiMasse.do"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">


<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String titre=ESAPI.encoder().encodeForHTML(ESAPI.encoder().canonicalize(request.getParameter("titre")));
	String type=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("type")));
	

	
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copitypedemande",budCopiMasseForm.getHParams());
	pageContext.setAttribute("listecopitypedemande", list1);
	
	  String[] strTabCols = new String[] {  "fond1" , "fond2" };
	  
		com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)	session.getAttribute("UserBip");
		com.socgen.bip.menu.item.BipItemMenu menuCourant =  userbip.getCurrentMenu();
		String menu = menuCourant.getId();
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="budCopiMasseForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budCopiMasseForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }

   
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
   
}

function ValiderEcran(form)
{
	if (form.action.value == 'valider') {
		if (!ChampObligatoire(form.dpcopi, "le code DP COPI")) return false;  
		if (!ChampObligatoire(form.date_copi, "la date COPI")) return false; 
		if (!ChampObligatoire(form.four_copi, "le fournisseur COPI")) return false;   
	}
	

	
   return true;
}

function afficherLigne()
{
	document.getElementById('Ligne2').style.display="";
	document.getElementById('Ligne6').style.display="";
	document.getElementById('Ligne8').style.display="";
} 


</script>
<!-- #EndEditable --> 

<style type="text/css">



.tableBleu1{
	font: normal 10pt Verdana,Arial,Helvetica,sans-serif;
	color: #000066;
	
}




</style>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td>&nbsp;</td></tr>
        <tr><td> 
            <div align="center"><!-- #BeginEditable "barre_haut" --> 
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
              <%=tb.printHtml()%><!-- #EndEditable --></div>
          </td></tr>
        <tr><td>&nbsp;</td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
        <tr><td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=titre %><!-- #EndEditable --></td></tr>
        <tr><td background="../images/ligne.gif"></td></tr>
    </table>
     
    <html:form action="/budCopiMasse"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
    <input type="hidden" name="pageAide" value="<%= sPageAide %>">
    <input type="hidden" name="titre" value="<%= titre %>">
    <input type="hidden" name="type" value="<%= type %>">
    <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
	<html:hidden property="mode" value="update"/>
	<html:hidden property="page" value="modifier"/>
	<html:hidden property="annee"/>
	<input type="hidden" name="index" value="modifier">
		
    <table width="80%" border="0"  cellspacing=0 class="tableBleu" align="center">
    	
        <tr><td class="lib"><b>Date Copi : </b></td>
            <td><bean:write name="budCopiMasseForm"  property="date_copi" />
            	<html:hidden property="date_copi"/>
			</td>
				                    
            <td class="lib"><b>Dossier Projet COPI :</b></td>
            <td><bean:write name="budCopiMasseForm"  property="dpcopi" />
            <html:hidden property="dpcopi"/>
		    </td>
       
        <%if (type.equals("Prestation"))
        	{%>			                    
            <td class="lib"><b>Fournisseur :</b></td>
            <td><bean:write name="budCopiMasseForm"  property="four_copi" />
            <html:hidden property="four_copi"/>
		    </td>
		   
		     <%} else
        {%>
        <html:hidden property="four_copi"/>
        <%} %>
        </tr> 
        <tr>
        <td colspan=2>&nbsp; </td>
        <td class="lib"><b>Type demande : </b></td>
             <td><html:select property="type_demande" name="budCopiMasseForm" styleClass="input" onchange="rafraichir(document.forms[0]);"> 
				 <html:options collection="listecopitypedemande" property="cle" labelProperty="libelle" />
				 </html:select>
		     </td>
		     <td colspan=2>&nbsp; </td>
      </tr>
      <tr>
      <td>&nbsp;</td>
      </tr>
       </table>
 	
   	<table  width="80%" border="1" cellspacing=0 class="tableBleu" align="center" rules="groups" >
   		<tr align="center">
   		<td colspan=2>&nbsp; </td>
   		
   			
   			<%
   			int anneetmp = budCopiMasseForm.getAnnee();
   			int j =0;
   			String libBudget;
   			for (int i=0;i<6;i++)
   				{
   				budCopiMasseForm.setAnnee(anneetmp+i);
   			
   				%>
   			<td width="8%" ><b><bean:write name="budCopiMasseForm"  property="annee" /></b></td>
   		<%} %>
   		</tr>
   		
   				<%
   				int nbligne=0;
   				int nbcol=0;
   				Object obudgetCopi=null;
   				Class[] parameterString = {};
   				 String budgetCopi="";
   				if (menu.equals("REF"))
					nbcol =8;
				else
					nbcol =8;
   					
   				 %>
   			
   				<logic:iterate id="element" name="listeBudgetCopi" type="com.socgen.bip.metier.BudCopiMasse" > 
						<% if (element.getTyp_bud() == 1) {%>
						 	<tbody>
						<%} %>
						
						
						
						<% if ( j == 0) j = 1; else j = 0; 
						nbligne++;
						String visible="";
						String libelleBudget="";
						String cat_depense="";
						switch (element.getTyp_bud())
						{
						case 1 : libelleBudget="Prévisionnel demandé";break;
						case 2 : libelleBudget="Prévisionnel décidé";
								if (menu.equals("REF"))
								{
									if ( j == 0) j = 1; else j = 0; 
									
								}
								break;
						case 3 : libelleBudget="Engagé précédent (*)"; ;break;
						case 4 : libelleBudget="Cantonné précédent (*)";break;
						case 5 : libelleBudget="Demandé"; break;
						case 6 : libelleBudget="Décidé"; 
						if (menu.equals("REF"))
						{
							if ( j == 0) j = 1; else j = 0; 
							
						}
						
						break;
						case 7 : libelleBudget="Cantonné demandé"; visible="";break;
						case 8 : libelleBudget="Cantonné décidé"; 
						if (menu.equals("REF"))
						{
							if ( j == 0) j = 1; else j = 0; 
							
						}
						break;
						
						}%>
					
						<tr height="30" align="center">
						<%if (element.getTyp_bud() == 1)  {
						if (budCopiMasseForm.getFour_copi() == 99)  {
							
							switch (element.getMetier().charAt(0))
							{
							case 'A' : cat_depense="Autres coûts<br>(K euros HTR)";break;
							case 'M' : cat_depense="Coûts matériel<br>(K euros HTR)";break;
							case 'L' : cat_depense="Coût logiciel<br>(K euros HTR)"; break;
							
							}
							
						
							%>
						<td rowspan="<%= nbcol %>" width="8%"><b><%=cat_depense %></b></td>
							<html:hidden name="element" property="metier"/>
						<%} else { %>
						
							
							<td rowspan="<%= nbcol %>" width="8%"><b><bean:write name="element" property="metier" /></b></td>
							<%
						}
						} 
						
							if ((menu.equals("REF") && (element.getTyp_bud() != 2) && (element.getTyp_bud() != 6)&& (element.getTyp_bud() != 8))) {%>
						
							
							
							<td width="15%"><b><%=libelleBudget %></b></td>
							<html:hidden name="element" property="typ_bud"/>
							<%}else
						if ((menu.equals("DIR"))){%>
						<td width="15%"><b><%=libelleBudget %></b></td>
							<html:hidden name="element" property="typ_bud"/>
							<%}
							
							for(int k=1;k<7;k++) {
								
							libBudget="budgetCopi_"+nbligne+"_"+k;
			                Object[] param1 = {};
			         
			                obudgetCopi= element.getClass().getDeclaredMethod("getBudgetCopi_"+k,parameterString).invoke((Object) element, param1);
			            	   if (obudgetCopi!=null) budgetCopi=obudgetCopi.toString();
			            	   else budgetCopi="";
							
							            	   
			            	if ((element.getTyp_bud() == 3) || (element.getTyp_bud() == 4))
							{%>
							<td class="<%= strTabCols[j] %>" ><%=budgetCopi%></td>
					<%} else { %>
					
					<% 
					if ((menu.equals("REF") && (element.getTyp_bud() != 2) && (element.getTyp_bud() != 6)&& (element.getTyp_bud() != 8)))
					 {%>
					
					<td class="<%= strTabCols[j] %>" ><input class=input type='text' size="6" maxlength="6"   name="<%=libBudget%>" value="<%=budgetCopi%>" onchange="return VerifierNumNegatif(this,5,0);" ></td>
					<%}else
						if ((menu.equals("DIR"))){%>
						
					<td class="<%= strTabCols[j] %>" ><input class=input type='text' size="6" maxlength="6"   name="<%=libBudget%>" value="<%=budgetCopi%>" onchange="return VerifierNumNegatif(this,5,0);" ></td>
					
				<%	}}}%>
					</tr>
							<% if (element.getTyp_bud() == 8) {%>
						 	<tBody>
						 	<tr>
						 	
						 	<td colspan=8>&nbsp; </td>
						 	</tr>
						<%} %>	
						
			  </logic:iterate> 
   		
 
   	</table>
   
<input type='hidden' name="nbligne" value="<%=nbligne%>" >
<br>
	<table  width="95%" border="0" cellspacing=0 class="tableBleu" align="center" >
  <tr><td align="center"><b>
   (*) : les valeurs affichées pour ce champ sont des CUMULS pour tous les types de demande; pour cette date COPI, ce DP COPI et ce fournisseur
   </b></td></tr>
   	<tr><td >&nbsp; </td></tr>
</table>

	<table  border="0" width=50% align="center">
		<tr><td  align="center" ><html:submit property="boutonConsulter" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true);"/></td>
		    <td  align="center" ><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'initialiser', true);"/></td>
		</tr>
	
    </table>

            <!-- #BeginEditable "fin_form" -->
	<!-- #EndEditable --> 
         
    <table>
    	<tr><td> 
            <div align="center"><html:errors/><!-- #BeginEditable "barre_bas" --><!-- #EndEditable --></div>
          	</td></tr>
    </table>


</html:form>                              
</body><% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = budCopiMasseForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
