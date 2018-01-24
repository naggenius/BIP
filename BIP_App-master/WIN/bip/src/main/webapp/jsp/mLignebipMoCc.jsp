<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="ligneBipMoForm" scope="request" class="com.socgen.bip.form.LigneBipMoForm" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bLignebipMoCc.jsp"/> 

<%
  String sAdatestatut;
  sAdatestatut = ligneBipMoForm.getAdatestatut();
  if (sAdatestatut==null) sAdatestatut="";
  
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("directionMo",ligneBipMoForm.getHParams()); 
  pageContext.setAttribute("choixClicode", list1);
  	
	// On récupère le menu courant	
	com.socgen.bip.menu.item.BipItemMenu menu = ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getCurrentMenu();
	String menuId = menu.getId();
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
   var Message="<bean:write filter="false"  name="ligneBipMoForm"  property="msgErreur" />";
   var Focus = "<bean:write name="ligneBipMoForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
	else if (document.forms[0].menu.value=="CDGMENU"){
	  document.forms[0].liste_objet.focus();
	  }
}

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
 
}

function ValiderEcran(form)
{
   if (blnVerification == true) {
  	 if (form.menu.value=="CDGMENU"){
  		if ((form.clicode)&&(!ChampObligatoire(form.clicode, "la direction cliente"))) return false;
      	 }
      if (!ChampObligatoire(form.liste_objet, "l'objet de la ligne BIP")) return false;
 		if ((form.pnmouvra)&&(!ChampObligatoire(form.pnmouvra,"le nom du correspondant MO"))) return false;
		form.pobjet.value=form.liste_objet.value;
		
		if (form.mode.value == "update") {
		if (!confirm("Voulez-vous modifier cette ligne bip ?")) return false;
         
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="ligneBipMoForm" property="titrePage"/>
		  une ligne BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/ligneBipMo"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="action"/> 
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			  <html:hidden property="flaglock"/> 
              <html:hidden property="flag"/>
              <html:hidden property="titrePage"/> 
              <input type="hidden" name="menu" value="<%= menuId %>">
            
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width="500">
                <tr> 
                  <td align=center >&nbsp;</td>
                </tr>
                <tr> 
                  <td class=lib nowrap>Code ligne BIP :</td>
                  <td nowrap> <b><bean:write name="ligneBipMoForm"  property="pid" /> </b>
                    <html:hidden property="pid"/>&nbsp;  </td>
                  <td class=lib >Libell&eacute; :</td>
                  <td nowrap> <bean:write name="ligneBipMoForm"  property="pnom" /> 
                    <html:hidden property="pnom"/> &nbsp; </td>
                  <td class=lib nowrap>Ann&eacute;e :</td>
                  <td nowrap> <b><bean:write name="ligneBipMoForm"  property="annee" /></b> 
                    <html:hidden property="annee"/> &nbsp; </td>
                </tr>
              
                <tr> 
                  <td class=lib>Type :</td>
                  <td > <bean:write name="ligneBipMoForm"  property="typproj" /> 
                    <html:hidden property="typproj"/> 
                     </td>
                
                  <td class=lib colspan="1">Typologie :</td>
                  <td colspan="1"><bean:write name="ligneBipMoForm"  property="arctype" /> 
                    <html:hidden property="arctype"/>   </td>
                  <td class=lib>Tri : </td>
                  <td> <bean:write name="ligneBipMoForm"  property="toptri" /> 
                    <html:hidden property="toptri"/> 
                  </td>
                </tr>
                
                 <tr> 
                  <td class=lib >Statut :</td>
                  <td ><bean:write name="ligneBipMoForm"  property="libstatut" /> 
                    <bean:write name="ligneBipMoForm"  property="astatut" /> <html:hidden property="astatut"/></td>
                  <td class=lib >Top fermeture :</td>
                  <td ><bean:write name="ligneBipMoForm"  property="topfer" /> 
                    <html:hidden property="topfer"/></td>
                  <td class=lib >Date :</td>
                  <td ><bean:write name="ligneBipMoForm"  property="adatestatut" /> 
                    <html:hidden property="adatestatut"/></td>
                </tr>
              </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width=500>
                <tr> 
                  <td width=171> 
                    <hr>
                  </td>
                  <td   width="141"><b> 
                    <center>
                      R&eacute;f&eacute;rentiel projets 
                    </center>
                    </b></td>
                  <td width=167> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                 <tr>
                  <td class=lib >Projet sp&eacute;cial :</td>
                  <td > <bean:write name="ligneBipMoForm"  property="codpspe" />  <bean:write name="ligneBipMoForm"  property="libpspe" /> 
                    <html:hidden property="codpspe"/>     
                    <html:hidden property="libpspe"/>  
                     </td>
                </tr>
            
                <tr> 
                  <td class="lib">Code Projet :</td>
                  <td > <bean:write name="ligneBipMoForm"  property="icpi" />  <bean:write name="ligneBipMoForm"  property="ilibel" /> 
                    <html:hidden property="icpi"/>     
                    <html:hidden property="ilibel"/>
                    </td>
                 </tr>
            
                <tr> 
                  
                  <td class=lib>Code Application :</td>
                  <td> <bean:write name="ligneBipMoForm"  property="airt" />  <bean:write name="ligneBipMoForm"  property="alibel" /> 
                    <html:hidden property="airt"/>     
                    <html:hidden property="alibel"/>
                
                  </td>
                 </tr>
            
                <tr> 
                  <td class=lib width=155>Code Dossier projet:</td>
                  <td> <bean:write name="ligneBipMoForm"  property="dpcode" />  <bean:write name="ligneBipMoForm"  property="dplib" /> 
                    <html:hidden property="dpcode"/>     
                    <html:hidden property="dplib"/>
                  </td> 
                </tr>
              </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                <tr> 
                  <td width=161> 
                    <hr>
                  </td>
                  <td   width="161"><b> 
                    <center>
                      Clients et Fournisseurs 
                    </center>
                    </b></td>
                  <td width=157> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                <tr> 
                  <td class=lib >Code DPG Fournisseur :</td>
                  <td colspan="3"> <bean:write name="ligneBipMoForm"  property="codsg" />  <bean:write name="ligneBipMoForm"  property="libdsg" /> 
                    <html:hidden property="codsg"/>     
                    <html:hidden property="libdsg"/>
                  </td>
                </tr>
                <tr>
                  <td class=lib>Chef de projet ME :</td>
                  <td > <bean:write name="ligneBipMoForm"  property="rnom" /> 
                    <html:hidden property="rnom"/>
                  </td>
                  <td class="lib">M&eacute;tier :</td>
                  <td > <bean:write name="ligneBipMoForm"  property="metier" /> 
                    <html:hidden property="metier"/>
                  </td>
                </tr>
                 <tr> 
                   <% if (menuId.equals("CDGMENU")) {%>
                  	<td class=lib >Nom du correspondant MO :</td>
                  	<td nowrap> <bean:write name="ligneBipMoForm"  property="pnmouvra" /> 
                    <html:hidden property="pnmouvra"/> </td>
                  <%} else { %>
                  <td class=lib nowrap>
                   	<% if (sAdatestatut.equals("")) {%>
                  		<b>Nom du correspondant MO :</b>
                  	<% }else{%>
                  		Nom du correspondant MO :
                  	<% }%>
                  	</td>
                  	<td>
                  	<% if (sAdatestatut.equals("")) {%>
                  		<html:text property="pnmouvra" styleClass="input" size="15" maxlength="15" onchange="return VerifierAlphanum(this);"/>
                  	<% }else{%>
						<bean:write name='ligneBipMoForm'  property='pnmouvra' />
						<html:hidden property="pnmouvra"/>
					<% }%>
			</td>
                  <%} %>
                 
                   <td class=lib>CA payeur : 
                  <td >  <bean:write name="ligneBipMoForm"  property="codcamo" /> 
                    <html:hidden property="codcamo"/>
                  </td>
                </tr>
                <tr> 
                 <% if (menuId.equals("CDGMENU")) {%>
                  <td class=lib ><b>Direction cliente :</b></td>
                   <td> <html:select property="clicode" styleClass="input" size="1"> 
                    <html:options collection="choixClicode" property="cle" labelProperty="libelle" /> 
                    </html:select>
                  </td>
                  <%} else { %>
                  <td class=lib nowrap>Direction cliente :</td>
                  <td><bean:write name="ligneBipMoForm"  property="clilib" /> 
                    <html:hidden property="clicode"/> 
				  </td>
                  <%} %>
                 <td class=lib nowrap>MO opérationnelle :</td>
                  <td><bean:write name="ligneBipMoForm"  property="clilib_oper" /> 
                    <html:hidden property="clilib_oper"/> 
				  </td>
                </tr>
                 
              </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                <tr> 
                  <td width=111> 
                    <hr>
                  </td>
                  <td   width="250"><b> 
                    <center>
                      Objet (Maximum 5 lignes de 60 caract&egrave;res) 
                    </center>
                    </b></td>
                  <td width=118> 
                    <hr>
                  </td>
                </tr>
              </table>
              <table border=0 cellspacing=2  cellpadding=2  class="tableBleu" width=500>
                <tr> 
                  <td align="center"> <html:hidden property="pobjet"/> 
                    <script language="JavaScript">
						var obj = document.forms[0].pobjet.value;
						<% if (menuId.equals("CDGMENU")) {%>
							document.write("<textarea name=liste_objet class='input' rows=5 cols=69 wrap onchange='return VerifierAlphanum(this);'>" + obj +"</textarea>");
						<%} else { %>
							document.write("<textarea name=liste_objet readonly rows=5 cols=69 >" + obj +"</textarea>");
						<%} %>	
					</script>
                    <!-- /script -->
                  </td>
                </tr>
                </table>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
				<tr>
					<td width="25%"><hr></td>
					<td align=center><b>Donn&eacute;es budg&eacute;taires en JH.</b></td>
					<td width="25%"><hr></td>
				</tr>
				</table>
				<table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="500" >
                 <tr> 
                  <td class="lib">Notifi&eacute; : </td>
                  <td>
				  <bean:write name="ligneBipMoForm"  property="bnmont" /> 
                    <html:hidden property="bnmont"/>
                  </td>
                  <td class="lib">Propos&eacute; fournisseur :</td>
                  <td>
				  <bean:write name="ligneBipMoForm"  property="bpmontme" /> 
                    <html:hidden property="bpmontme"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Arbitr&eacute; : </td>
                  <td>
				  <bean:write name="ligneBipMoForm"  property="anmont" /> 
                    <html:hidden property="anmont"/>
                  </td>
                  <td class="lib">Ré-estim&eacute;e fournisseur :</td>
                  <td>
				  <bean:write name="ligneBipMoForm"  property="reestime" /> 
                    <html:hidden property="reestime"/>
                  </td>
                </tr>
                 <tr> 
                  <td class="lib">Estimation pluriannuelle : </td>
                  <td>
				  <bean:write name="ligneBipMoForm"  property="estimplurian" /> 
                    <html:hidden property="estimplurian"/>
                  </td>
                  <td class="lib">R&eacute;alis&eacute; :</td>
                  <td>
				   <bean:write name="ligneBipMoForm"  property="cusag" /> 
                    <html:hidden property="cusag"/>
                  </td>
                </tr>
                
                <tr>
				<td class="lib">
				 	Propos&eacute; client :
				</td>
				<td >
				<% if (sAdatestatut.equals("")) {%>
				 		<html:text property='bpmontmo' styleClass='input' size='12' maxlength='12' onchange='return VerifierNum(this,12,2);'/>
				    <% }else{%>
				      	<bean:write name='ligneBipMoForm'  property='bpmontmo' />
				      	<html:hidden property="bpmontmo"/>
				     <% }%>
				</td>

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
Integer id_webo_page = new Integer("2001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = ligneBipMoForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
