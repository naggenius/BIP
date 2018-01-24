<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.Hashtable,java.util.ArrayList,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.menu.PaginationVector,com.socgen.ich.ihm.*,com.socgen.bip.metier.Favori,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<jsp:useBean id="listeMsgForm" scope="request" class="com.socgen.bip.form.ListeMsgForumForm" />
<jsp:useBean id="listeDiscussionForum" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/forumListe.do"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<%	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

    int index1;
    PaginationVector liste = (PaginationVector) (request.getSession(false)).getAttribute("listeDiscussionForum");
    index1 = liste.getCurrentBlock();

	java.util.ArrayList listeNbEnr = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("listeNbLigne"); 
	pageContext.setAttribute("listeNbEnr", listeNbEnr);

   	String sStyleMsg = "";

	UserBip sUser = (UserBip) session.getAttribute("UserBip");
%>
var pageAide = "<%= sPageAide %>";
var blnVerification = true;

function MessageInitial() {
   var Message = "";
   var Focus = "";
   if (Message != "") {
      alert(Message);
   }
}

function paginer(page, index , action){
	document.body.style.cursor = "wait";
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

function changeAffichage(){
	document.body.style.cursor = "wait";
	document.forms[0].action.value="initialiser";
    document.forms[0].submit();
}

function afficheTxt(numMsg) {
    var objTxt = document.getElementById("texte"+numMsg);
    var img    = document.getElementById("img"+numMsg);
    var span   = document.getElementById("span"+numMsg);
    if (objTxt.style.display == "none") {
        objTxt.style.display = "block";
        img.src = "/images/descendre.png";
        span.className = "gras";
    } else {
        objTxt.style.display = "none";
        img.src = "/images/ferme.gif";
        span.className = "normal";
    }
}

function Verifier(form, action, mode, flag) {
    blnVerification = flag;
    form.action.value = action;
}

function ValiderMsg(form, p_id) {
	if (!confirm(" Etes-vous sûr de vouloir valider ce message ? " )) return false;
	
	document.body.style.cursor = "wait";
	form.id.value  = p_id;
	form.statut.value  = "V";
	form.action.value = "validerMsg";
	form.submit();
}

function saisieRejet(form, p_id) {
	window.open("/forumDiscussion.do?action=rejetInit&id="+p_id  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=650, height=210") ;
	return ;
}

function Repondre(form, p_id){
	form.id.value  = p_id;
	form.action.value = "repondre";
	document.body.style.cursor = "wait";
    form.submit();
}

function Modifier(form, p_id){
	form.id.value  = p_id;
	form.action.value = "modifier";
	document.body.style.cursor = "wait";
    form.submit();
}

function Supprimer(form, p_id) {
	if (!confirm(" Etes-vous sûr de vouloir supprimer ce message ? " )) return false;
	document.body.style.cursor = "wait";
	form.id.value  = p_id;
	form.action.value = "supprimer";
	form.submit();
}

function Clore(form, p_id) {
	if (!confirm(" Etes-vous sûr de vouloir clôre le sujet ? " )) return false;
	document.body.style.cursor = "wait";
	form.id.value  = p_id;
	form.statut.value  = "C";
	form.action.value = "validerMsg";
	form.submit();
}

</script>

</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();" style="">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            <div align="center">
              <%ToolBar tb = new com.socgen.ich.ihm.ToolBar("bip_ihm",false,false,true,false,false,false,false,false,false,request) ;%>
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
          <td height="20" class="TitrePage">
       		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgAValider" >
       		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgRejeter" >
	          	Forum : Fil de discussion
       		</logic:notEqual>
       		</logic:notEqual>
       		<logic:equal name="listeMsgForm" property="typeEcran" value="MsgAValider" >
       			Forum : Liste des messages &agrave; valider
       		</logic:equal>
       		<logic:equal name="listeMsgForm" property="typeEcran" value="MsgRejeter" >
       			Forum : Liste des messages rejet&eacute;s
       		</logic:equal>
          </td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td>
		    <!-- #BeginEditable "debut_form" -->
		  	<html:form action="/forumDiscussion">
		  	<!-- #EndEditable -->
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
			  		<html:hidden property="titrePage"/>
              		<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="page" value="modifier"/>
                    <input type="hidden" name="index" value="modifier">
              		<html:hidden property="id"/>
              		<html:hidden property="statut"/>
              		<html:hidden property="parent_id"/>
              		<html:hidden property="typeEcran"/>
              		<html:hidden property="chaineRecherche"/>
					<html:hidden property="mot_cle"/>
					<html:hidden property="chercheTitre"/>
					<html:hidden property="chercheTexte"/>
					<html:hidden property="auteur_rech"/>
					<html:hidden property="date_debut"/>
					<html:hidden property="date_fin"/>
					<html:hidden property="menu"/>
					<html:hidden property="listeMenu"/>

            		<table cellspacing="0" border="0" width="100%">
            			<tr>
            				<td width="5%">&nbsp;</td>
            				<td width="20%">
			            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgAValider" >
			            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgRejeter" >
						    	<input type="button" name="boutonRepondreSujet" value="R&eacute;pondre" onclick="Repondre(this.form, <bean:write name="listeMsgForm" property="parent_id" />);" class="input">
			            		</logic:notEqual>
			            		</logic:notEqual>
            				</td>
            				<td width="20%" align="center" class="lib"> Messages par page : </td>
            				<td width="5%">
            				    <html:select property="blocksize" styleClass="input" size="1" onchange="javascript:changeAffichage();">
                    				<html:options collection="listeNbEnr" property="cle" labelProperty="libelle" /> 
            				    </html:select>
            				</td>
            				<td width="10%">&nbsp;</td>
            				<td width="25%" align="center">
			            		<logic:equal name="listeMsgForm" property="typeEcran" value="MesMessages" >
								<html:submit property="boutonRetour" value="Retour &agrave; Mes messages" styleClass="input" onclick="Verifier(this.form, 'retour', '', true);"/>
			            		</logic:equal>
			            		<logic:equal name="listeMsgForm" property="typeEcran" value="recherche" >
								<html:submit property="boutonRetour" value="Retour r&eacute;sultat recherche" styleClass="input" onclick="Verifier(this.form, 'retour', '', true);"/>
			            		</logic:equal>
			            		<logic:equal name="listeMsgForm" property="typeEcran" value="rechercheAvancee" >
								<html:submit property="boutonRetour" value="Retour r&eacute;sultat recherche" styleClass="input" onclick="Verifier(this.form, 'retour', '', true);"/>
			            		</logic:equal>
			            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MesMessages" >
			            			<logic:notEqual name="listeMsgForm" property="typeEcran" value="recherche" >
				            			<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgAValider" >
					            			<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgRejeter" >
						            			<logic:notEqual name="listeMsgForm" property="typeEcran" value="rechercheAvancee" >
								<html:submit property="boutonRetour" value="Retour &agrave; liste des sujets" styleClass="input" onclick="Verifier(this.form, 'retour', '', true);"/>
					            				</logic:notEqual>
				            				</logic:notEqual>
			            				</logic:notEqual>
			            			</logic:notEqual>
			            		</logic:notEqual>
            				</td>
            				<td width="10%">&nbsp;</td>
            			</tr>
            		</table>
                  </div>
                </td>
              </tr>
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
					
		<table cellspacing="0" border="0" width="790">
			<tr>
				<td colspan="6">&nbsp;</td>
			</tr>
			<tr>
			    <td class="lib" width="20"></td>
			    <td class="lib" width="55" ><b>Date</b></td>
			    <td class="lib" width="445"><b>Titre</b></td>
			    <td class="lib" width="120"><b>Auteur</b></td>
			    <td class="lib" width="140" align="center"><b>Action</b></td>
			</tr>
<logic:iterate id="message" name="listeDiscussionForum" length="<%= listeDiscussionForum.getCountInBlock() %>" 
	offset="<%= listeDiscussionForum.getOffset(0) %>" type="com.socgen.bip.metier.MessageForum" indexId="it"> 
<% 	String sClass = "fond2" ;
   	if ((it.intValue()%2) == 0) sClass="fond2";
   	else sClass="fond1"; 

	if (message.getTab()>0) sStyleMsg = "margin-left: " + (30*message.getTab()) + "px";
	else sStyleMsg = "";
	
	String sClassRejet = "";
	if (message.getStatut().equals("R")) sClassRejet = "texteBarre";
%>
			<tr class="<%= sClass %>" valign="top" height="25px">
			    <td width="20">
					<logic:equal name="message" property="msg_important" value="O">
					 	<img src="/images/msgImportant.gif" border="0" alt="Message important">
					</logic:equal>                                                 
					<logic:equal name="message" property="statut" value="R">
					 	<img src="/images/puceRougeB.gif" border="0" alt="Message rejet&eacute;">
					</logic:equal>                                                 
<% // message à valider
   if ((message.getStatut().equals("A") || message.getStatut().equals("M") ) &&
       (sUser.isAdministrateur())
      ) { %>
					 	<img src="/images/moderer.gif" border="0" alt="Message &agrave; mod&eacute;rer">
<% } %>
				</td>
			    <td class="contenuisac" width="55"><bean:write name="message" property="date_msg"/></td>
			    <td class="contenuisac" width="445">
			        <div width="445" style="<%= sStyleMsg %>">
			            <div style="float:left;" ><a href="javascript:afficheTxt('<%= it %>')" onmouseover="window.status='';return true;"><img id="img<%= it %>" src="/images/descendre.png" border="0"></a></div>
			            <div style="float:left;" id="span<%= it %>" class="gras"><bean:write name="message" property="titre"/>
							<logic:equal name="message" property="statut" value="C">
							&nbsp;&nbsp;<span class="cligno">- CLOS -</span>
							</logic:equal>
			            </div>
			        </div>
			        <div style="clear: left;" style="<%= sStyleMsg %>" >
    			        <div id="texte<%= it %>" class="texteForum texteDiscussion <%= sClassRejet %>">
    			        	<bean:write name="message" property="texte"/>
<% if ( (sUser.getIdUser().equalsIgnoreCase(message.getUser_rtfe())) 
		|| ((!sUser.getIdUser().equalsIgnoreCase(message.getUser_rtfe())) && (sUser.isAdministrateur()) ) 
		|| ((!sUser.getIdUser().equalsIgnoreCase(message.getUser_rtfe())) && (!sUser.isAdministrateur()) && (message.getStatut().equals("V")) ) 
	  ) {
 		if ( (message.getDate_modification()!=null) && (message.getDate_modification().length()>0) ) { %>
        			        	<div class="edition">
        			        		Edit&eacute; le <bean:write name="message" property="date_modification" />
<% 			if ( ( (sUser.getIdUser().equalsIgnoreCase(message.getUser_rtfe())) || (sUser.isAdministrateur()) ) && (message.getTexte_modifie()!=null) && (message.getTexte_modifie().length()>0) ) { %>
        			        			, message en cours de validation : <br /><bean:write name="message" property="texte_modifie"/>
<% 			} %>
        			        	</div>
<% 		}
   } %>
    			        </div>
    			    </div>
					<logic:equal name="message" property="statut" value="R">
   			        <div class="motifRejet">
   			            Rejet&eacute; le <bean:write name="message" property="date_statut" /> pour le motif suivant : <br />
   			            <bean:write name="message" property="motif_rejet" />
   			        </div>
					</logic:equal>                                                 
			    </td>
			    <td class="contenuisac" width="120"><a href="mailto:<bean:write name="message" property="auteur"/>" onmouseover="window.status='';return true;"><bean:write name="message" property="auteur"/></a></td>
			    <td class="contenuisac" width="140" align="center">
            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgAValider" >
	            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MsgRejeter" >
<% // Modifier message
   if (sUser.getIdUser().equalsIgnoreCase(message.getUser_rtfe()) && (!message.getStatut().equals("C")) ) { %>
			    	<input type="button" name="boutonModifier" value="&nbsp;&nbsp;&nbsp;&nbsp;Modifier&nbsp;&nbsp;&nbsp;&nbsp;" onclick="Modifier(this.form, <bean:write name="message" property="id" />);" class="input">
<%     // suppression du sujet impossible
       if (it.intValue()>0) { %>
			    	<input type="button" name="boutonSupprimer" value="&nbsp;&nbsp;Supprimer&nbsp;&nbsp;" onclick="Supprimer(this.form, <bean:write name="message" property="id" />);" class="input">
<%     }
   }
   // Clore le sujet
   if ((sUser.getIdUser().equalsIgnoreCase(message.getUser_rtfe()) || (sUser.isAdministrateur())) && (it.intValue()==0) && (!message.getStatut().equals("C")) ) { %>
			    	<input type="button" name="boutonClore" value="Clôre le sujet" onclick="Clore(this.form, <bean:write name="message" property="id" />);" class="input">
<% }
   // Répondre au message
   if ((message.getStatut().equals("V")) && (!sUser.getIdUser().equals(message.getUser_rtfe()) && (it.intValue()>0)) ) { %>
			    	<input type="button" name="boutonRepondre" value="&nbsp;&nbsp;&nbsp;&nbsp;Répondre&nbsp;&nbsp;" onclick="Repondre(this.form, <bean:write name="message" property="id" />);" class="input">
<% } %>
            			</logic:notEqual>
            		</logic:notEqual>
<%   // Valider le message
   if ((message.getStatut().equals("A") || message.getStatut().equals("M") || message.getStatut().equals("R") ) &&
       (sUser.isAdministrateur())
      ) { %>
			    	<input type="button" name="boutonValider" value="&nbsp;&nbsp;&nbsp;&nbsp; Valider&nbsp;&nbsp;&nbsp;&nbsp;" onclick="ValiderMsg(this.form, <bean:write name="message" property="id" />);" class="input">
<% }
   // Rejeter le message
   if ((message.getStatut().equals("A") || message.getStatut().equals("M") || message.getStatut().equals("V") ) &&
       (sUser.isAdministrateur())
      ) { %>
			    	<input type="button" name="boutonRejeter" value="&nbsp;&nbsp;&nbsp;&nbsp; Rejeter&nbsp;&nbsp;&nbsp;&nbsp;" onclick="saisieRejet(this.form, <bean:write name="message" property="id" />);" class="input">
<% } %>
				</td>
			</tr>
</logic:iterate>						
		</table>
					</div>
                </td>
              </tr>
            
			   	<tr>
					<td align="center" class="contenu">
						<bip:pagination beanName="listeDiscussionForum"/>
					</td>
				</tr>

            </table>
            </html:form>
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
</body>
<% 
Integer id_webo_page = new Integer("1073");
com.socgen.bip.commun.form.AutomateForm formWebo = listeMsgForm;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
