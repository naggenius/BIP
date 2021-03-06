<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="affectationForm" scope="request" class="com.socgen.bip.form.AffectationForm" />
<html:html locale="true"> 
 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!--  ABN - HP PPM 57787 - DEBUT  -->
<title>
	<% java.util.ResourceBundle rb = java.util.ResourceBundle.getBundle("log"); %>
	<%=rb.getString("env.titrepage")%>
</title>
<!--  ABN - HP PPM 57787 - FIN  -->

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/affectation.do"/> 
<%  
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("isac_sstachelb",affectationForm.getHParams());
    pageContext.setAttribute("choixAffect", list1);
%> 

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

function SetFocus()
{

if(document.forms[0].sous_tacheMulti.length==1){
document.forms[0].sous_tacheMulti.selectedIndex=0;
}
}


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="affectationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="affectationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action, mode, flag)
{
   getSelectValue();
   blnVerification = flag;
   form.action.value = action;
} 

function ValiderEcran(form)
{  
	if (blnVerification)
	{
		 return Valider_sstache_ident(form);
   	}
	return true;
}

function getSelectValue()
{
	
	var elmt = document.getElementById("sous_tacheMulti");

	//elmt.type != 'select-multiple'
	if(elmt.multiple == false)
	{
		return elmt.options[elmt.selectedIndex].value;
	}
	var values = "";
	for(var i=0; i< elmt.options.length; i++)
	{
		if(elmt.options[i].selected == true)
		{
						
			values = values.concat(elmt.options[i].value+"/");
			
		}
	}	
	values = values.substring(0,values.length-1);
	
	document.getElementById("SelectConcat").value = values;
		
}
</script>

</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial(); SetFocus();">
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
          <td height="20" class="TitrePage"><div id="titre" >Affecter une sous-t&acirc;che &agrave; une ressource</div></td>
        </tr>
        <tr> 
          <td>
			<div id="content">	
		    <html:form action="/affectation"  onsubmit="return ValiderEcran(this);"> 
            <div align="center">
         	<html:hidden property="action"/>
            <html:hidden property="mode"/>
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <html:hidden property="keyList0"/> <!--ident-->
            <html:hidden property="keyList1"/> <!--pid--> 
            <html:hidden property="ident"/>
            <html:hidden property="pid"/> 
            <html:hidden property="SelectConcat" id="SelectConcat" value =""/>
			<table border="0" cellpadding="2" cellspacing="2" class="TableBleu" >
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="texteGras"><b>Ressource :</b> </td>
					<td class="texte"> <b><bean:write name="affectationForm"  property="ressource" /><html:hidden property="ressource"/></b> 	</td>
				</tr>
				<tr>
					<td class="texteGras"><b>Ligne BIP :	</td>
					<td class="texte"> <b><bean:write name="affectationForm"  property="lib" /><html:hidden property="lib"/></b> 	</td>
				</tr>
			</table>
			<table border="0" cellpadding="2" cellspacing="0" class="TableBleu" width="700"> 
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="6" align="center" class="texte"><b>Choisissez une sous-t&acirc;che :</b>
					</td>
				</tr>
				<tr> 
					<td class="texteGras" width="199">Etape
					</td>
					<td class="texteGras" >Type
						</td>
					<td class="texteGras" width="200">T&acirc;che
					</td>
					<td class="texteGras"  width="203">Sous-t&acirc;che
					</td>
					<td class="texteGras" width="40">Type
					</td>
					<td class="texteGras" width="30">Affect&eacute;</td> 
				</tr>
				<tr>
					<td colspan="6">
					 <html:select id="sous_tacheMulti" property="sous_tacheMulti" multiple="true" styleClass="Multicol" size="10">
						  <bip:options collection="choixAffect"/>
					 </html:select>
					</td>
				</tr>
				<tr> 
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr> 
					<td align="center" colspan="6"> 
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
						</html:form></div>
					</td>
				</tr>
			</table>
			</div>	
        <tr> 
          <td>&nbsp; </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
Integer id_webo_page = new Integer("6006"); 
com.socgen.bip.commun.form.AutomateForm formWebo = affectationForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
