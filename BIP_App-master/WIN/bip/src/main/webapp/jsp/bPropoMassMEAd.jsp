<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,java.lang.reflect.InvocationTargetException,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgMassForm" scope="request" class="com.socgen.bip.form.BudgMassForm" />
<jsp:useBean id="listeProposes" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_bip.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fBudgMassMEAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="budgMassForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budgMassForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].bpmontme_1){
	  document.forms[0].bpmontme_1.focus();
   }
}


function Verifier(form, action, flag, save)
{
  blnVerification = flag;
  form.action.value = action;
  form.save.value = save;
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


function CalculerTotMois(Obj,EF)
{
 if (!CalculerTotaux(Obj,EF)) { 
 EF.focus;
 return false;
 }
 return true; 
}

function CalculerTotaux(Obj,EF)
{
  
  tab = Obj.split('_');
  i=tab[1];
  
   
  PREE = eval("document.forms[0].bpmontme_"+i).value;
  OLD_PREE = eval("document.forms[0].oldbpmontme_"+i).value;
  totalbpmontme = eval("document.forms[0].tot_bpmontme").value;
  
  nombre='';
  if (!VerifierDecOLD( EF,8,2,EF.value)) return false;
  
  if (PREE=="") PREE=0;
  if (OLD_PREE=="") OLD_PREE=0;
  if (totalbpmontme=="") totalbpmontme=0;
  
  virgule=totalbpmontme.toString().split(',');
  totalbpmontme=parseFloat(virgule[0]+'.'+virgule[1]);
  
  virgule=PREE.toString().split(',');
  totalbpmontme=parseFloat(virgule[0]+'.'+virgule[1])+parseFloat(totalbpmontme); 
  
  virgule=OLD_PREE.toString().split(',');
  totalbpmontme=parseFloat(totalbpmontme)-parseFloat(virgule[0]+'.'+virgule[1]);
  
  
  virgule=totalbpmontme.toString().split('.');
  if(virgule[1])
  totalbpmontme=virgule[0]+','+virgule[1];
  else
     totalbpmontme=virgule[0];
    
  eval("document.forms[0].tot_bpmontme").value=(totalbpmontme==0?"":totalbpmontme);
  eval("document.forms[0].oldbpmontme_"+i).value = PREE;
  
  EF.focus;
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
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> &nbsp;
            
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage">Saisie en masse des propos&eacute;s pour un DPG</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20"> </td>
        </tr>
        <tr> 
          <td><html:form action="/propoMassME"  onsubmit="return ValiderEcran(this);">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					 <input type="hidden" name="pageAide" value="<%= sPageAide %>">
                     <html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                     <html:hidden property="save"/>
                     <html:hidden property="page" value="modifier"/>
                     <input type="hidden" name="index" value="modifier">
		             <html:hidden property="posClient"/> <!--position du client dans la liste-->
        		     <html:hidden property="posAppli"/> <!--position de l'application dans la liste-->
                     
				    <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                      <tr align="left">
                        <td  class="texte" ><b>DPG :</b></td>
                        <td colspan=3 class="texte">
                        	<bean:write name="budgMassForm" property="libcodsg"/>
                        	<html:hidden property="codsg"/>
                            <html:hidden property="libcodsg"/>
                        </td>
                      </tr>
                      <tr align="left">
                        <td class="texte"><b>Ann&eacute;e de proposition :</b></td>
                        <td colspan=3 class="texte"><bean:write name="budgMassForm" property="annee"/>
                          <html:hidden property="annee"/>
                        </td>
                      </tr>
<%	if ((budgMassForm.getClicode()!=null) && (budgMassForm.getClicode().length()>0)) { %>
                      <tr align="left">
                        <td  class="texte" >Client :</td>
                        <td colspan=3 class="texte">
                        	<bean:write name="budgMassForm" property="libclicode"/>
                        </td>
                      </tr>
<%	}
	if ((budgMassForm.getAirt()!=null) && (budgMassForm.getAirt().length()>0)) { %>
                      <tr align="left">
                        <td  class="texte" >Application :</td>
                        <td colspan=3 class="texte">
                        	<bean:write name="budgMassForm" property="libairt"/>
                        	<html:hidden property="airt"/>
                        </td>
                      </tr>
<%	} %>
                      <tr>
                        <td colspan=6 height="15">&nbsp;</td>
                      </tr>
                      </table>
                      <table border=0 cellspacing=0 cellpadding=2 >
                      <tr align="left" class="lib">
                        <td class="texte" align="center"><B>Direct</B></td>
                        <td class="texte" align="center"><B>Ligne</B></td>
                        <td class="texte" align="center"><B>Type</B></td>
                        <td class="texte" align="center"><B>Libell&eacute;</B></td>
                        <td class="texte" align="center"><B>Code <br> projet</B></td>
                        <td class="texte" align="center"><B>DPG</B></td>
                        <td class="texte" align="center"><B>Propos&eacute; <br> fournisseur</B></td>
                        <td class="texte" align="center"><B>Propos&eacute; client</B></td>
                        <!-- YNI -->
                        <td class="texte" align="center"><B>Date Derniere <br> modification</B></td>
                        <td class="texte" align="center"><B>Identifiant</B></td>
                        <!-- Fin YNI -->
                      </tr>
             <% int i = 0;
			   int nbligne = 0;
			   String libPid="";
			   String libFlaglock="";
			   String libProposeme="";
			   String oldlibProposeme="";
			   String bpmontme="";
			   Object oConso=null;
			   Class[] parameterString = {};
			   String[] strTabCols = new String[] {  "fond1" , "fond2" }; %>
			<logic:iterate id="element" name="listeProposes" length="<%=  listeProposes.getCountInBlock()  %>" 
            			offset="<%=  listeProposes.getOffset(0) %>"
						type="com.socgen.bip.metier.Propose"
						indexId="index"> 
			<% if ( i == 0) i = 1; else i = 0;
			   nbligne ++;
			   libPid="pid_"+nbligne;
			   libFlaglock="flaglock_"+nbligne;
			   libProposeme="bpmontme_"+nbligne;
			   oldlibProposeme="oldbpmontme_"+nbligne;
			 %>
						<tr align="left" class="<%= strTabCols[i] %>">
    			  		<td class="contenu" align="center"><bean:write name="element" property="clicode" /></td>
    			  		
						<td class="contenu"><bean:write name="element" property="pid" />
						<input type="hidden" name="<%=libPid%>" value="<bean:write name="element" property="pid" />">
						<input type="hidden" name="<%=libFlaglock%>" value="<bean:write name="element" property="flaglock" />">
						</td>
						
						<td class="contenu" align="center"><bean:write name="element" property="type" />
    			  		<td class="contenu"><bean:write name="element" property="pnom" /></td>
    			  		<td class="contenu" align="center"><bean:write name="element" property="icpi" /></td>
    			  		<td class="contenu" align="center"><bean:write name="element" property="codsg" /></td>
    			  		
    			  		<% try {
                        	   Object[] param1 = {};
                     
                        	   oConso= element.getClass().getDeclaredMethod("getBpmontme",parameterString).invoke((Object) element, param1);
                        	   if (oConso!=null) bpmontme=oConso.toString();
                        	   else bpmontme="";
				%>
				<td class="contenu" align="right">
					<input class="input" type="text" size="9" maxlength="9" name="<%=libProposeme%>" value="<%=bpmontme%>" onChange="return CalculerTotMois(this.name,this);" >
					<input type='hidden' name="<%=oldlibProposeme%>" value="<%=bpmontme%>">
				</td>
				<%} catch (NoSuchMethodException me) {
					%>
					NoSuchMethodException 
					
					<%
					} catch (SecurityException se) {
					%>SecurityException
					<%	
					} catch (IllegalAccessException ia) {
					%>IllegalAccessException
					<%
					} catch (IllegalArgumentException iae) {
					%>IllegalArgumentException
					<%
					} catch (InvocationTargetException ite) {
					%>InvocationTargetException
					<%	
					}%>
    			  		
    			  		
    			  		
    			  		
						<td class="contenu" align="right"><bean:write name="element" property="bpmontmo" /></td>
						<!-- YNI -->
						<td class="contenu" align="center"><bean:write name="element" property="bpdate" /></td>
						<td class="contenu"><bean:write name="element" property="ubpmontme" /></td>
						<!-- Fin YNI -->
						</tr>
                  </logic:iterate>      
                      
                   
                   <tr align="left" class="lib">
						<td class="texte"><B>Total</B></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
					    <td class="texte"></td>
						<td class="lib" align="right" >
						<B><html:text property="tot_bpmontme" styleClass="inputgrasleft" size="9" maxlength="9" readonly="true" /></B>
						<html:hidden property="old_tot_bpmontme"/>
						</td>
						<td class="lib" align="left" >
						<B><html:text property="tot_bpmontmo" styleClass="inputleft" size="9" maxlength="9" readonly="true"  /></B>
						<html:hidden property="old_tot_bpmontmo"/>
						</td>
						<!-- YNI -->		
						<td class="texte"></td>
					    <td class="texte"></td>						
						<!-- Fin YNI -->
				</tr>	
                   
                   
               	</table>
             
             	<table  width="100%" border="0" cellspacing="0" cellpadding="0">
			   	<tr align="left">
					<td align="center" colspan="4" class="contenu">
						<bip:pagination beanName="listeProposes"/>
					</td>
				</tr>
	 			<tr><td colspan="4" height="15">&nbsp;
	 			</tr>
	 			<tr>
              		<td width="20%">&nbsp;</td>
                	<td width="20%">
                	 <div align="center">
                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'NON');"/>
                	 </div>
               		</td> 
               		<td width="20%">
		                	 <div align="center">
		                	  <html:submit property="boutonSave" value="Sauvegarder" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'OUI');"/>
		                	 </div>
		               		</td> 
               		<td width="20%"> 
                  	 <div align="center"> 
                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false, 'NON');"/>
              		 </div>
                </td>
                <td width="25%">&nbsp;</td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
<% 
Integer id_webo_page = new Integer("1057"); 
com.socgen.bip.commun.form.AutomateForm formWebo = budgMassForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
