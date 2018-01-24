<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.apache.commons.lang.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="factureForm" scope="request" class="com.socgen.bip.form.FactureForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bFactureOr.jsp"/> 
<%
  java.util.Hashtable hP = new java.util.Hashtable();
  if(!StringUtils.isEmpty((String) session.getAttribute("socfactcode"))){
  hP.put("keyList0", session.getAttribute("socfactcode"));
  }
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("statut_CS1");
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("statut");
  java.util.ArrayList list3;
  //Recuperation du code socfact pour l'affichage de la liste des fournisseurs
  if (StringUtils.isEmpty((String) session.getAttribute("socfactcode"))){
	  list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fournisseur",factureForm.getHParams()); 
  }else{
	  list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fournisseur",hP);
  }
  
  //java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fournisseur",hP); 
  //java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fournisseur",factureForm.getHParams()); 
  
  pageContext.setAttribute("choixStatutCS1", list1);
  pageContext.setAttribute("choixStatut", list2);
  pageContext.setAttribute("choixFournisseur", list3);
 %>  
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
var blnVerifFormat  = true;
var tabVerif        = new Object();
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
    // TD 582 
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
	com.socgen.bip.menu.item.BipItemMenu menu = user.getCurrentMenu();
	String menuId = menu.getId();
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{
   tabVerif["date_reception"] = "VerifierDate2(document.forms[0].date_reception,'jjmmaaaa')";
   tabVerif["fdeppole"]       = "VerifierAlphaMax(document.forms[0].fdeppole)";
   tabVerif["fcodcompta"]     = "VerifierAlphaMax(document.forms[0].fcodcompta)";
   tabVerif["fmoiacompta"]    = "VerifierDate2(document.forms[0].fmoiacompta,'mmaaaa')";
   
   var Message="<bean:write filter="false"  name="factureForm"  property="msgErreur" />";
   var Focus = "<bean:write name="factureForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else if (document.forms[0].mode.value!="delete"){
	   document.forms[0].date_reception.focus();
    }
    if (document.forms[0].mode.value=="insert"){
    	
    	    	document.forms[0].fmoiacompta.value= "<%= com.socgen.bip.commun.Tools.getStrDateMMAAAA(0,0) %>"
	}
	

    
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
   

    
}
function ValiderEcran(form)
{
if (blnVerification==true) {

   	if (form.mode.value!="delete"){
   
     	if ( !VerifFormat(null) ) return false;
		if (!ChampObligatoire(form.date_reception, "la date de réception")) return false;
		if (!ChampObligatoire(form.fdeppole, "le code Département/Pôle/Groupe")) return false;
		if (!ChampObligatoire(form.fcodcompta, "le code comptable")) return false;
		if (!ChampObligatoire(form.fmoiacompta, "le mois de comptabilisation")) return false;
		if (form.fcodcompta.value == 0){
			alert("Le code comptable ne peut être égal à 0");
			form.fcodcompta.focus();
			return false;
		}
    }

    if (form.mode.value=="update"){
       
		if (form.fstatut1.selectedIndex == -1) {
		   alert("Choisissez un statut CS1");
		   return false;
			}
		
		if (!confirm("Voulez-vous modifier cette facture ?")) return false;
	}
	
	if (form.mode.value=="delete"){	
		if (!confirm("Voulez-vous supprimer cette facture ?")) return false;
	}
}

   return true;
}


function rechercheCodeComptable(){
	window.open("/recupCodeCompta.do?action=initialiser&nomChampDestinataire=fcodcompta&windowTitle=Recherche Code Comptable&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=600") ;
}  

function nextFocusCodeCompta(){
	document.forms[0].fcodcompta.focus();
}


function rechercheDPG()
{
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=fdeppole&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
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
        <tr> 
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="factureForm" property="titrePage"/> une facture<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/facture"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
              <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              <input type="hidden" name="menu" value="<%= menuId %>"> <!-- TD 582 -->
            	  <html:hidden property="titrePage"/>
				  <html:hidden property="action"/> 
                  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
				  <html:hidden property="choixfsc"/>
				  <html:hidden property="ftva"/>
				  <html:hidden property="msg_info"/>
				  <html:hidden property="flaglock"/>
				  <html:hidden property="keyList0"/>	
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
            
                <tr> 
                  <td >&nbsp;</td>
                </tr>
        
                <tr> 
                  <td class="lib">Code société :</td>
                  <td ><b><bean:write name="factureForm"  property="socfact" /> 
                    <html:hidden property="socfact"/></b> 
                    </td> 
                  <td class="lib" >Société :</td>
                  <td> <bean:write name="factureForm"  property="soclib" /> 
                    <html:hidden property="soclib"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib">SIREN :</td>
                  <td ><bean:write name="factureForm"  property="siren" /> 
                    <html:hidden property="siren"/>
                   </td> 
                  <td></td>
                  <td></td>
                </tr>
                <logic:notEqual parameter="mode" value="delete"> 
                <tr>
                <tr>
                  <td class="lib" ><b>N° de contrat :</b></td>
                  <td > 
                    <bean:write name="factureForm"  property="numcont" /> 
                    <html:hidden property="numcont"/>
                  </td>
                  <td class="lib"><b>N° d'avenant :</b></td>
                  <td >
                    <bean:write name="factureForm"  property="cav" /> 
                    <html:hidden property="cav"/>
                  </td>
         
		
                </tr>
                 </logic:notEqual> 
                <tr> 
                  <td class="lib">N° de facture :</td>
                  <td ><b><bean:write name="factureForm"  property="numfact" /> 
                    <html:hidden property="numfact"/></b> 
                    </td>
                  <td class="lib">Type de facture :</td>
                  <td ><b><bean:write name="factureForm"  property="typfact" /> 
                    <html:hidden property="typfact"/></b> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Date de facture :</td>
                  <td ><b><bean:write name="factureForm"  property="datfact" /> 
                    <html:hidden property="datfact"/></b> 
                    </td>
                <% if ((menuId.equals("ACH"))||(menuId.equals("DIR"))) {%>
                  <td class="lib" >N° Expense :</td>
                  <td>
                      <logic:notEqual parameter="mode" value="delete">
				 		<html:text property="numexpense" styleClass="input" size="8" maxlength="8" onchange="return VerifierAlphaMax(this);"/> 
                      </logic:notEqual> 
                      <logic:equal parameter="mode" value="delete">
                         <bean:write name="factureForm"  property="numexpense" /> 
	                     <html:hidden property="numexpense"/> 
                      </logic:equal>
                  </td>                
                <%} else { %>
                  <td class="lib" >N° Expense :</td>
                  <td ><bean:write name="factureForm"  property="numexpense" /> 
	                  <html:hidden property="numexpense"/> 
                  </td>
                <%} %>                    
                </tr>
                 <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                <% if ((menuId.equals("ACH"))||(menuId.equals("DIR"))) {%>
                  <td class="lib" >Cusag Expense :</td>
                  <td>
                      <logic:notEqual parameter="mode" value="delete">
				 		<html:text property="cusagexpense" styleClass="input" size="8" maxlength="8" onchange="return VerifierNum(this,7,2);"/> 
                      </logic:notEqual> 
                      <logic:equal parameter="mode" value="delete">
                         <bean:write name="factureForm"  property="cusagexpense" /> 
	                     <html:hidden property="cusagexpense"/> 
                      </logic:equal>
                  </td>                
                <%} else { %>
                  <td class="lib" >Cusag Expense :</td>
                  <td><bean:write name="factureForm"  property="cusagexpense" /> 
	                  <html:hidden property="cusagexpense"/> 
                  </td>
                <%} %>                    
                </tr>
                <!-- SUPPRIMER -->
<logic:equal parameter="mode" value="delete"> 				
                <tr> 
                  <td class="lib" >Montant total HT :</td>
                  <td colspan=3><bean:write name="factureForm"  property="fmontht" /> 
                    <html:hidden property="fmontht"/></td>
                </tr>
                <tr> 
                  <td class="lib" >Date d'envoi à l'enregistrement comptable :</td>
                  <td colspan=3><bean:write name="factureForm"  property="fenrcompta" /> 
                    <html:hidden property="fenrcompta"/></td>
                </tr>
                <tr> 
                  <td class="lib">Date d'accord du pôle :</td>
                  <td colspan=3><bean:write name="factureForm"  property="faccsec" /> 
                    <html:hidden property="faccsec"/></td>
                </tr>
                <tr> 
                  <td class="lib">Date d'envoi au règlement comptable :</td>
                  <td colspan=3><bean:write name="factureForm"  property="fregcompta" /> 
                    <html:hidden property="fregcompta"/></td>
                </tr>
                <tr> 
                  <td class="lib" >Date de règlement demandé :</td>
                  <td colspan=3><bean:write name="factureForm"  property="fenvsec" /> 
                    <html:hidden property="fenvsec"/></td>
                </tr>
</logic:equal>
			
<!-- MODIFIER ET CREER --><logic:notEqual parameter="mode" value="delete"> 	
                <tr> 
                  <td class="lib" ><b>Date de réception :</b></td>
                  <td >
				  <html:text property="date_reception" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/>   
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code fournisseur :</b></td>
                  <td colspan=3> 
                    <html:select property="fsocfour" styleClass="input" size="1"> 
   						  <html:options collection="choixFournisseur" property="cle" labelProperty="libelle" />
						 </html:select>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code DPG :</b></td>
                  <td>
				  <html:text property="fdeppole" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>  
				  <a href="javascript:rechercheDPG();" onFocus="javascript:nextFocusCodeCompta();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>   
                  <td class="lib">Code DPG contrat :</td>
                  <td><bean:write name="factureForm"  property="codsg" /> 
                    <html:hidden property="codsg"/>
                    </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code comptable :</b></td>
                  <td > 
                    <html:text property="fcodcompta" styleClass="input" size="16" maxlength="11" onchange="return VerifFormat(this.name);"/> 
                    <a href="javascript:rechercheCodeComptable();" onFocus="javascript:nextFocusCodeCompta();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Comptable" title="Rechercher Code Comptable" align="absbottom"></a> 
                	</td>
            
                  <td class="lib">Code comptable contrat : 
                  <td ><bean:write name="factureForm"  property="comcode" /> 
                    <html:hidden property="comcode"/></td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Statut CS1 :</b></td>
                  <logic:equal parameter="mode" value="update"> 
				  <td colspan=3 > 
                    <html:select property="fstatut1" styleClass="input"> 
   						<html:options collection="choixStatutCS1" property="cle" labelProperty="libelle" />
						</html:select>
                  </td>
				  </logic:equal>
				  <logic:equal parameter="mode" value="insert">
				  	<td colspan=3 > 
				  		<logic:iterate id="element" name="choixStatut">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="fstatut1" value="<%=choix.toString()%>"/>
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate>
					</td>
					
				</logic:equal> 
                <tr> 
                  <td class="lib"><b>Mois de comptabilisation :</b>&nbsp;</td>
                  <td>
                  	<%= com.socgen.bip.commun.Tools.getStrDateMMAAAA(0,0) %> 
                  	<html:hidden property="fmoiacompta" value="<%= com.socgen.bip.commun.Tools.getStrDateMMAAAA(0,0) %>"/>
                  </td>
                </tr>
</logic:notEqual>


                <tr> 
                  <td colspan=6>&nbsp;</td>
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
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value ,true);"/> 
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
Integer id_webo_page = new Integer("3004"); 
com.socgen.bip.commun.form.AutomateForm formWebo = factureForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
