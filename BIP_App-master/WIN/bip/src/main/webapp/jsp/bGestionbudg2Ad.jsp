<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%
/**
Cette jsp de consultation est utilisée pour les 3 écrans suivants :
- Consulter les budgets d'une année pour une ligne Bip
- Consulter un arbitré et son historique
- Consulter un réestimé et son historique

Action associée : GestBudgAction.java
Formulaire associé : GestBudgForm.java
*/
%>
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.apache.commons.lang.StringUtils"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="gestBudgForm" scope="request" class="com.socgen.bip.form.GestBudgForm" />
<%@page import="com.socgen.bip.form.GestBudgForm"%>
<html:html locale="true">
<head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Page BIP</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/bGestionbudgAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial() {
   var Message="<bean:write filter="false"  name="gestBudgForm"  property="msgErreur" />";
   var Focus = "<bean:write name="gestBudgForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
}

function Verifier(form, action,mode, flag) {
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
   if (ValiderEcran(form)) {
   		form.submit();
   }
}

function ValiderEcran(form) {
   return true;
}

function AjusterLargeurDivComm(largeurMax) {
	AjusterLargeurDiv(largeurMax,"divArbComm");
	AjusterLargeurDiv(largeurMax,"divReesComm");
}

function AjusterLargeurDiv(largeurMax, nomElementsDiv) {
	var elementsDiv = document.getElementsByTagName("div");
	if (elementsDiv) {
		var elementDiv;
		for (var i=0; i<elementsDiv.length; i++) {
			elementDiv = elementsDiv.item(i);
			if (elementDiv  && elementDiv.getAttribute("name") == nomElementsDiv) {
				// Si la largeur dépasse la largeur max
				if ((elementDiv.offsetWidth) > parseInt(largeurMax)) {
					elementDiv.style.width = largeurMax + 'px';
				}
			}
		}
	}
}

function TraitementInitial() {
	MessageInitial();
	AjusterLargeurDivComm('500');
}

</script>
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="TraitementInitial();">
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
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr > 
          <td> 
            &nbsp;
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
          <td height="20" class="TitrePage">
          	<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterGlobalement %>">
          		<%= GestBudgForm.titrePageConsulterGlobalement %>	
          	</logic:equal>
          	<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoArb %>">
          		<%= GestBudgForm.titrePageConsulterHistoArb %>	
          	</logic:equal>
          	<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoRees %>">
          		<%= GestBudgForm.titrePageConsulterHistoRees %>	
          	</logic:equal>
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> </td>
        </tr>
        <tr> 
          <td> <html:form action="/gestBudg">
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center">
					<input type="hidden" name="pageAide" value="<%= sPageAide %>"> <html:hidden property="action"/> 
                    <html:hidden property="mode"/>
					<html:hidden property="arborescence" value="<%= arborescence %>"/> 
                <table cellspacing="2" cellpadding="2" class="tableBleu" border="0" >
                <tr> 
                  <td height="20" colspan=4>&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan=4>&nbsp;</td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Ligne BIP :</td>
                  <td class="texte"><b><bean:write name="gestBudgForm"  property="pid" /><html:hidden property="pid"/></b></td>
                  <td class="texte" colspan=2><bean:write name="gestBudgForm"  property="pnom" /><html:hidden property="pnom"/></td>
                </tr>
                <tr align="left"> 
                  <td class="texte">DPG :</td>
                  <td class="texte"><bean:write name="gestBudgForm"  property="codsg" /><html:hidden property="codsg"/></td>
                  <td class="texte" colspan=2><bean:write name="gestBudgForm"  property="libdsg" /><html:hidden property="libdsg"/></td>
                </tr>
                <tr align="left"> 
                  <td class="texte">Année :</td>
                  <td class="texte"><bean:write name="gestBudgForm"  property="annee" /><html:hidden property="annee"/></td>
                  <td class=texte align=right>Statut :</td>
                  <td class="texte">&nbsp;<bean:write name="gestBudgForm"  property="astatut" />
                    	<html:hidden property="astatut"/>
                   </td>
                </tr>
                <tr> 
                	<td colspan=4 height="10px"></td>
                </tr>
                <tr align="left"> 
                  <td rowspan=2 colspan=2 class="lib" align=center>BUDGET</td>
                  <td colspan=2 class="lib" align=center>
				    Derni&egrave;re mise &agrave; jour
				  </td>
                </tr>
                <tr align="left"> 
                  <td class="lib" align=center>
				    DATE
				  </td>
				  <td class="lib" align=center>
				    PAR
				  </td>
                </tr>
                <logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterGlobalement %>">
	                <% if ((menuId.equals("ME"))||(menuId.equals("DIR"))) {%>
	                <tr align="left"> 
	                  <td class="texte">Proposé Fournisseur :</td>
	                  <td class="texte" align="right">
					    <bean:write name="gestBudgForm"  property="bud_prop" />
	                    <html:hidden property="bud_prop"/>
					  </td>
					  <td align="right" class="texte">
					   	<bean:write name="gestBudgForm"  property="bpdate" />
	                    <html:hidden property="bpdate"/>
					  </td>
	                  <td align="right" class="texte">
	                  <bean:write name="gestBudgForm"  property="ubpmontme" />
	                    <html:hidden property="ubpmontme"/>
					  </td>
	                </tr>
	                <%} else { %>
		              
	                    <html:hidden property="bud_propmo"/> 
	                <%} %>
	                <tr align="left"> 
	                  <td class="texte">Proposé Client :</td>
	                  <td class="texte" align="right">
					    <bean:write name="gestBudgForm"  property="bud_propmo" />
	                    <html:hidden property="bud_propmo"/>
					  </td>
					  <td align="right" class="texte">
					   	<bean:write name="gestBudgForm"  property="bpmedate" />
	                    <html:hidden property="bpmedate"/>
					  </td>
	                  <td align="right" class="texte">
	                  	<bean:write name="gestBudgForm"  property="ubpmontmo" />
	                    <html:hidden property="ubpmontmo"/>
					  </td>
	                </tr>
	                
	                <tr align="left"> 
	                  <td class="texte">Notifié :</td>
	                  <td class="texte" align="right">
					    <bean:write name="gestBudgForm"  property="bud_not" />
	                    <html:hidden property="bud_not"/>
					  </td>
					  <td align="right" class="texte">
					   	<bean:write name="gestBudgForm"  property="bndate" />
	                    <html:hidden property="bndate"/>
					  </td>
					  <td align="right" class="texte">
					   	<bean:write name="gestBudgForm"  property="ubnmont" />
	                    <html:hidden property="ubnmont"/>
					  </td>
	                </tr>
                </logic:equal>
                <!-- Si mode Consulter globalement, ou Consulter historique arbitré -->
                <% if (GestBudgForm.modeConsulterGlobalement.equals(gestBudgForm.getMode())
                		|| GestBudgForm.modeConsulterHistoArb.equals(gestBudgForm.getMode())) { %>
	                <tr align="left"> 
	                  <td class="texte" >
	                  	<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoArb %>">
			          		
			          	</logic:equal>
	                  	<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterGlobalement %>">
		          			<%= GestBudgForm.libelleArbitre %>	
		          		</logic:equal>
		 				<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoArb %>">
		          			<b><%= GestBudgForm.libelleArbitreActuel %></b>	
		          		</logic:equal>
		          		<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoArb %>">
			          		
			          	</logic:equal>
		          	  </td>
	                  <td class="texte" align="right">
					    <bean:write name="gestBudgForm"  property="bud_arb" />
	                    <html:hidden property="bud_arb"/>
					  </td>
					  <td class="texte" align="right">
					    <bean:write name="gestBudgForm"  property="bnadate" />
	                    <html:hidden property="bnadate"/>
					  </td>
					  <td class="texte"  align="right">
					    <bean:write name="gestBudgForm"  property="uanmont" />
	                    <html:hidden property="uanmont"/>
					  </td>
	                </tr>
		  			<!-- Si le commentaire aribitré n'est pas vide -->
	        		 <% if (StringUtils.isNotEmpty(gestBudgForm.getArbcomm())) { %>
		                 <tr align="left"> 
		                  <td class="texte" colspan=4>
						    <div name="divArbComm" align="justify">
						    	<bean:write name="gestBudgForm" property="arbcomm" />
						    </div>
		                    <html:hidden property="arbcomm"/>
						  </td>
		                </tr>
		            <%} %>
		            <!-- Conditionnement de l'espacement entre les blocs -->
		            <% if ((GestBudgForm.modeConsulterGlobalement.equals(gestBudgForm.getMode()) && StringUtils.isNotEmpty(gestBudgForm.getArbcomm()))
                		|| GestBudgForm.modeConsulterHistoArb.equals(gestBudgForm.getMode())) { %>
		                <tr> 
		                	<td colspan=4 height="10px"></td>
		                </tr>
	                <%} %>
	                 <logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoArb %>">
	                	<tr align="left"> 
		                  <td class="texte">
				          	<b><%= GestBudgForm.libelleHistorique %></b>
			          	  </td>
			          	  <!-- Si l'historique des arbitrés est inexistant ou vide -->
						  <logic:empty name="gestBudgForm" property="arbHisto"> 
				          	  <td class="texte" align="right">
								  <%= GestBudgForm.valeurNeant %>
							  </td>
							  <td colspan=2>
							  </td>
						  </logic:empty>
						  <!-- Si l'historique des arbitrés n'est pas vide -->
						  <logic:notEmpty name="gestBudgForm" property="arbHisto"> 
				          	  <td colspan=3 style="border-bottom:2px solid #e7e7eb" align="right">&nbsp;
							  </td>
						  </logic:notEmpty>
						</tr>
						<!-- Si l'historique des arbitrés n'est pas vide -->
        				<logic:notEmpty name="gestBudgForm" property="arbHisto"> 
							<% int compteurListeArbHisto = 0; %>
							<logic:iterate name="gestBudgForm" property="arbHisto" id="listeArbHistoId">
								<% compteurListeArbHisto++; %>
								<tr align="left"> 
				                  <td class="texte" align="right">
					          	  </td>
				                  <td class="texte" align="right">
								    <bean:write name="listeArbHistoId"  property="valeur" ignore="true"/>
								  </td>
								  <td class="texte" align="right">
								    <bean:write name="listeArbHistoId"  property="dateModif" ignore="true"/>
								  </td>
								  <td class="texte" align="right">
								    <bean:write name="listeArbHistoId"  property="matricule" ignore="true"/>
								  </td>
				                </tr>
				                <!-- Si le commentaire aribitré n'est pas vide -->
			        		 	<logic:notEmpty name="listeArbHistoId" property="commentaire"> 
									<tr> 
									<!-- fix for PPM 65174  -->
									  <td class="texte" colspan=4 style="border-bottom:2px solid #e7e7eb">
										<div name="divArbComm" align="justify">
											<bean:write name="listeArbHistoId" property="commentaire" ignore="true"/>
										</div>
									  </td>
									</tr>
								</logic:notEmpty>
				            	<!-- Conditionnement de l'espacement entre les blocs : si ce n'est pas le dernier élément -->
					            <% if (compteurListeArbHisto < gestBudgForm.getArbHisto().size()) { %>
				                <tr> 
				                	<td colspan=4 height="10px"></td>
				                </tr>
				                <%} %>
			                </logic:iterate>
			             </logic:notEmpty>
	                </logic:equal>
                <% } %>
                <!-- Si mode Consulter globalement, ou Consulter historique réestimé -->
                <% if (GestBudgForm.modeConsulterGlobalement.equals(gestBudgForm.getMode())
                		|| GestBudgForm.modeConsulterHistoRees.equals(gestBudgForm.getMode())) { %>
	                <tr align="left"> 
	                  <td class="texte">
						<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoRees %>">
							
						</logic:equal>
						<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterGlobalement %>">
							<%= GestBudgForm.libelleReestime %>	
						</logic:equal>
						<logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoRees %>">
							<b><%= GestBudgForm.libelleReestimeActuel %>	</b>
						</logic:equal>
	                  	  <logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoRees %>">
			          		
			          	  </logic:equal>
	                  </td>
	                  <td align="right" class="texte">
					    <bean:write name="gestBudgForm" property="bud_rst" />
	                    <html:hidden property="bud_rst"/>
					  </td>
					  <td align="right" class="texte">
					    <bean:write name="gestBudgForm" property="redate" />
	                    <html:hidden property="redate"/>
					  </td>
					  <td align="right" class="texte">
					  	<bean:write name="gestBudgForm" property="ureestime" />
	                    <html:hidden property="ureestime"/>
					  </td>
	                </tr>
		            <!-- Si le commentaire réestimé n'est pas vide -->
	        		 <% if (StringUtils.isNotEmpty(gestBudgForm.getReescomm())) { %>
		                 <tr> 
		                  <td align="right" class="texte" colspan=4>
						    <div name="divReesComm" align="justify">
						    	<bean:write name="gestBudgForm" property="reescomm" />
		                    </div>
						  </td>
		                </tr>
					<%} %>
					<!-- Conditionnement de l'espacement entre les blocs -->
		            <% if ((GestBudgForm.modeConsulterGlobalement.equals(gestBudgForm.getMode()) && StringUtils.isNotEmpty(gestBudgForm.getReescomm()))
                		|| GestBudgForm.modeConsulterHistoRees.equals(gestBudgForm.getMode())) { %>
		                <tr> 
		                	<td colspan=4 height="10px"></td>
		                </tr>
	                <%} %>
	                <logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterHistoRees %>">
	                	<tr align="left"> 
		                  <td  class="texte">
				          	<b><%= GestBudgForm.libelleHistorique %></b>
			          	  </td>
			          	  <!-- Si l'historique des réestimés est inexistant ou vide -->
						  <logic:empty name="gestBudgForm" property="reesHisto"> 
				          	  <td  class="texte" align="right">
								  <%= GestBudgForm.valeurNeant %>
							  </td>
							  <td colspan=2>
							  </td>
						  </logic:empty>
						  <!-- Si l'historique des réestimés n'est pas vide -->
						  <logic:notEmpty name="gestBudgForm" property="reesHisto"> 
				          	  <td colspan=3 style="border-bottom:2px solid #e7e7eb">&nbsp;
							  </td>
						  </logic:notEmpty>
						</tr>
						<!-- Si l'historique des réestimés n'est pas vide -->
        				<logic:notEmpty name="gestBudgForm" property="reesHisto"> 
							<% int compteurListeReesHisto = 0; %>
							<logic:iterate name="gestBudgForm" property="reesHisto" id="listeReesHistoId">
								<% compteurListeReesHisto++; %>
								<tr align="left"> 
				                  <td class="texte">
					          	  </td>
				                  <td class="texte" align="right">
								    <bean:write name="listeReesHistoId"  property="valeur" ignore="true"/>
								  </td>
								  <td class="texte" align="right">
								    <bean:write name="listeReesHistoId"  property="dateModif" ignore="true"/>
								  </td>
								  <td class="texte" align="right">
								    <bean:write name="listeReesHistoId"  property="matricule" ignore="true"/>
								  </td>
				                </tr>
				                <!-- Si le commentaire réestimé n'est pas vide -->
			        		 	<logic:notEmpty name="listeReesHistoId" property="commentaire"> 
									<tr> 
									  <td  class="texte" colspan=4 style="border-bottom:2px solid #F0F0DF">
										<div name="divReesComm" align="justify">
											<bean:write name="listeReesHistoId" property="commentaire" ignore="true"/>
										</div>
									  </td>
									</tr>
								</logic:notEmpty>
				            	<!-- Conditionnement de l'espacement entre les blocs : si ce n'est pas le dernier élément -->
					            <% if (compteurListeReesHisto < gestBudgForm.getReesHisto().size()) { %>
				                <tr> 
				                	<td colspan=4 height="10px"></td>
				                </tr>
				                <%} %>
			                </logic:iterate>
			             </logic:notEmpty>
	                </logic:equal>
	            <% } %>
                
                <logic:equal name="gestBudgForm" property="mode" value="<%= GestBudgForm.modeConsulterGlobalement %>">
	                <!-- YNI FDT 892 -->
	                <% if (menuId.equals("DIR")) {%>
	                <tr align="left">
	                  <td class="texte" colspan=1>R&eacute;serve :</td>
	                  <td align="right" class="texte">
						<bean:write name="gestBudgForm"  property="reserve" />
						<html:hidden property="reserve"/> 
					  </td>
					   <td align="right" class="texte">
					    <bean:write name="gestBudgForm" property="bresdate" />
	                    <html:hidden property="bresdate"/>
					  </td>
					  <td  align="right" class="texte">
					  	<bean:write name="gestBudgForm" property="ureserve" />
	                    <html:hidden property="ureserve"/>
					  </td>
					</tr>
					<%} %>
				</logic:equal>
	                <!-- Fin YNI FDT 892 -->
	               </table> 
	               <table cellspacing="2" cellpadding="2" class="tableBleu" border="0" >
					<tr>
	                	<td colspan=4>&nbsp;</td>
					</tr>
				</table>
			  <table width="100%" border="0">
			  <tr>
				<td height="20"></td>
				</tr>
              <tr> 
                 <td> 
                  <div align="center"> <html:button property="boutonAnnuler" value="Retour" styleClass="input" onclick="Verifier(this.form, 'annuler', null,true);"/> 
                  </div>
                </td>
               </tr>
            </table>
              </div>
                </td>
              </tr>
            </table>
            </html:form> 
          </td>
        </tr>
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
Integer id_webo_page = new Integer("1053"); 
com.socgen.bip.commun.form.AutomateForm formWebo = gestBudgForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>