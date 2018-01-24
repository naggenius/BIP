<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.Hashtable,java.util.ArrayList,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.menu.PaginationVector,com.socgen.ich.ihm.*,com.socgen.bip.metier.Favori,com.socgen.bip.user.UserBip"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<jsp:useBean id="listeMsgForm" scope="request" class="com.socgen.bip.form.ListeMsgForumForm" />
<jsp:useBean id="listeMessageForum" scope="session"	class="com.socgen.ich.ihm.menu.PaginationVector" />

<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<title>Page BIP</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="/forumListe.do"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	String sTitre    = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("titre")));

    int index1;
    PaginationVector liste = (PaginationVector) (request.getSession(false)).getAttribute("listeMessageForum");
    index1 = liste.getCurrentBlock();

	java.util.ArrayList listeNbEnr = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("listeNbLigne"); 
	pageContext.setAttribute("listeNbEnr", listeNbEnr);

	java.util.ArrayList listeTri = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("triForumSujet"); 
	pageContext.setAttribute("listeTri", listeTri);

	UserBip sUser = (UserBip) session.getAttribute("UserBip");

	int wTitre = 445;
	if (listeMsgForm.getTypeEcran().equals("MesMessages")) {
		wTitre=565;
		sTitre="Mes Messages";
	} else if ( (listeMsgForm.getTypeEcran().equals("recherche")) || 
	            (listeMsgForm.getTypeEcran().equals("rechercheAvancee")) ){
		wTitre=565;
		sTitre="R&eacute;sultat recherche";
	}
	if (sTitre==null) sTitre = "Forum";

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
	document.forms[0].action.value =action;
	document.forms[0].page.value=page;
    document.forms[0].index.value=index;
    document.forms[0].submit();
}

function changeAffichage(){
	document.forms[0].action.value="initialiser";
    document.forms[0].submit();
}

function nouveauSujet(){
	document.forms[0].action.value="nouveauSujet";
    document.forms[0].submit();
}

function afficheTxt(numMsg) {
    var objTxt = document.getElementById("texte"+numMsg);
    var img    = document.getElementById("img"+numMsg);
    var span   = document.getElementById("span"+numMsg);
    if (objTxt.style.display == "" || objTxt.style.display == "none") {
        objTxt.style.display = "block";
        img.src = "/images/descendre.png";
        span.className = "gras";
    } else {
        objTxt.style.display = "none";
        img.src = "/images/ferme.gif";
        span.className = "normal";
    }
}

function goDiscussion(idSujet) {
	document.forms[0].parent_id.value = idSujet;
	document.forms[0].action.value="goDiscussion";
    document.forms[0].submit();
}

function Rechercher(form) {
	form.action.value    = "initialiser";
	form.typeEcran.value = "recherche";
    form.submit();
}

function backSujet(form) {
	form.action.value    = "initialiser";
	form.typeEcran.value = "";
	form.chaineRecherche.value = "";
	form.parent_id.value = "";
	form.id.value = "";
    form.submit();
}

function backRecAvan(form) {
	form.action.value    = "backRecAvan";
    form.submit();
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
          <td height="20" class="TitrePage"><%= sTitre %></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td>
		    <!-- #BeginEditable "debut_form" -->
		  	<html:form action="/forumListe">
		  	<!-- #EndEditable -->
            <table width="100%" border="0">
              <tr> 
                <td> 
                  <div align="center"><!-- #BeginEditable "contenu" -->
			  		<html:hidden property="titrePage"/>
              		<html:hidden property="action"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
                    <html:hidden property="page" value="modifier"/>
                    <html:hidden property="index" value="modifier"/>
              		<html:hidden property="id"/>
              		<html:hidden property="parent_id"/>
              		<html:hidden property="typeEcran"/>
					<html:hidden property="mot_cle"/>
					<html:hidden property="chercheTitre"/>
					<html:hidden property="chercheTexte"/>
					<html:hidden property="auteur_rech"/>
					<html:hidden property="date_debut"/>
					<html:hidden property="date_fin"/>
					<html:hidden property="menu"/>
					<html:hidden property="listeMenu"/>

            		<table cellspacing="0" border="0" width="100%">
            		<logic:equal name="listeMsgForm" property="typeEcran" value="MesMessages" >
            			<tr>
            				<td width="35%">&nbsp;</td>
            				<td width="20%" align="center" class="lib"> Messages par page : </td>
            				<td width="5%">
            				    <html:select property="blocksize" styleClass="input" size="1" onchange="javascript:changeAffichage();">
                    				<html:options collection="listeNbEnr" property="cle" labelProperty="libelle" /> 
            				    </html:select>
            				</td>
            				<td width="35%">&nbsp;</td>
            			</tr>
            		</logic:equal>
            		<logic:equal name="listeMsgForm" property="typeEcran" value="recherche" >
              		<html:hidden property="chaineRecherche"/>
            			<tr>
            				<td width="35%">&nbsp;</td>
            				<td width="20%" align="center" class="lib"> Messages par page : </td>
            				<td width="5%">
            				    <html:select property="blocksize" styleClass="input" size="1" onchange="javascript:changeAffichage();">
                    				<html:options collection="listeNbEnr" property="cle" labelProperty="libelle" /> 
            				    </html:select>
            				</td>
            				<td ><input type="button" value="Retour liste sujet" class="input" onclick="backSujet(this.form);" ></td>
            				<td width="35%">&nbsp;</td>
            			</tr>
            		</logic:equal>
            		<logic:equal name="listeMsgForm" property="typeEcran" value="rechercheAvancee" >
              		<html:hidden property="chaineRecherche"/>
            			<tr>
            				<td width="35%">&nbsp;</td>
            				<td width="20%" align="center" class="lib"> Messages par page : </td>
            				<td width="5%">
            				    <html:select property="blocksize" styleClass="input" size="1" onchange="javascript:changeAffichage();">
                    				<html:options collection="listeNbEnr" property="cle" labelProperty="libelle" /> 
            				    </html:select>
            				</td>
            				<td ><input type="button" value="Recherche avanc&eacute;e" class="input" onclick="backRecAvan(this.form);" ></td>
            				<td width="35%">&nbsp;</td>
            			</tr>
            		</logic:equal>
            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MesMessages" >
            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="recherche" >
            		<logic:notEqual name="listeMsgForm" property="typeEcran" value="rechercheAvancee" >
            			<tr>
            				<td width="20">&nbsp;</td>
            				<td ><input type="button" value="Nouveau sujet" class="input" onclick="nouveauSujet();" ></td>
            				<td width="20">&nbsp;</td>
            				<td class="lib">&nbsp;Recherche par mots-clés : </td>
            				<td >
            					<html:text property="chaineRecherche" styleClass="input" size="50" maxlength="200" />
            					<html:submit property="boutonRechercher" value="Rechercher" styleClass="input" onclick="Rechercher(this.form);"/>
            				</td>
            				<td width="20">&nbsp;</td>
            			</tr>
            			<tr>
            			    <td colspan="6">&nbsp;</td>
            			</tr>
            		</table>
            		<table cellspacing="0" border="0" width="100%">
            			<tr>
            				<td width="160">&nbsp;</td>
            				<td width="60" align="center" class="lib"> Tri&eacute; par : </td>
            				<td >
            				    <html:select property="tri" styleClass="input" size="1" onchange="javascript:changeAffichage();">
                    				<html:options collection="listeTri" property="cle" labelProperty="libelle" /> 
            				    </html:select>
            				<td width="130" align="center" class="lib"> Messages par page : </td>
            				<td >
            				    <html:select property="blocksize" styleClass="input" size="1" onchange="javascript:changeAffichage();">
                    				<html:options collection="listeNbEnr" property="cle" labelProperty="libelle" /> 
            				    </html:select>
            				</td>
            				<td width="160">&nbsp;</td>
            			</tr>
            		</logic:notEqual>
            		</logic:notEqual>
            		</logic:notEqual>
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
			    <td class="lib" width="<%= wTitre %>"><b>Titre</b></td>
           		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MesMessages" >
			    <td class="lib" width="120"><b>Auteur</b></td>
           		</logic:notEqual>
			    <td class="lib" width="30" align="center"><b>R&eacute;p.</b></td>
			    <td class="lib" width="110" align="center"><b>Dernier message</b></td>
			</tr>
<logic:iterate id="message" name="listeMessageForum" length="<%= listeMessageForum.getCountInBlock() %>" 
	offset="<%= listeMessageForum.getOffset(0) %>" type="com.socgen.bip.metier.MessageForum" indexId="it"> 
<%	String sClass = "fond2" ;
	if ((it.intValue()%2) == 0) sClass="fond2";
	else sClass="fond1"; %>
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
       (sUser.isAdministrateur() && (!listeMsgForm.getTypeEcran().equals("MesMessages"))
       )
      ) { %>
					 	<img src="/images/moderer.gif" border="0" alt="Message &agrave; mod&eacute;rer">
<% } %>
				</td>
			    <td class="contenuisac" width="55"><bean:write name="message" property="date_msg"/></td>
			    <td class="contenuisac" width="<%= wTitre %>">
			        <div width="<%= wTitre %>">
			            <div style="float:left;" ><a href="javascript:afficheTxt('<%= it %>')" onmouseover="window.status='';return true;"><img id="img<%= it %>" src="/images/ferme.gif" border="0"></a></div>
			            <div style="float:left;" id="span<%= it %>" class="normal"><a class="titreMsg" href="javascript:goDiscussion(<bean:write name="message" property="id" />)" onmouseover="window.status='';return true;"><bean:write name="message" property="titre"/></a>
							<logic:equal name="message" property="statut" value="C">
							&nbsp;&nbsp;<span class="cligno">- CLOS -</span>
							</logic:equal>
			            </div>
			        </div>
			        <div style="clear: left;" >
    			        <div id="texte<%= it %>" class="texteForum">
    			        	<bean:write name="message" property="texte"/>
    			        </div>
    			    </div>
			    </td>
           		<logic:notEqual name="listeMsgForm" property="typeEcran" value="MesMessages" >
			    <td class="contenuisac" width="120"><a href="mailto:<bean:write name="message" property="auteur"/>" onmouseover="window.status='';return true;"><bean:write name="message" property="auteur"/></a></td>
           		</logic:notEqual>
			    <td class="contenuisac" width="30" align="center"><bean:write name="message" property="nbReponse"/></td>
			    <td class="contenuisac" width="110" align="center"><bean:write name="message" property="dateDernReponse"/></td>
			</tr>
</logic:iterate>						
		</table>
					</div>
                </td>
              </tr>
            
			   	<tr>
					<td align="center" class="contenu">
						<bip:pagination beanName="listeMessageForum"/>
					</td>
				</tr>

            </table>
            </html:form>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
          </td>
        </tr>
		<tr><td>&nbsp;</td></tr>
      </table>
    </td>
  </tr>
</table>
</body>
<% 
Integer id_webo_page = new Integer("1071");
com.socgen.bip.commun.form.AutomateForm formWebo = listeMsgForm;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
