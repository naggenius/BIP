
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="contratAveForm" scope="request" class="com.socgen.bip.form.ContratAveForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> <!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bContrataveOr.jsp"/>
<%
  java.util.ArrayList listNiche = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("niche");
  java.util.ArrayList listTypeFact = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("typeFact");
  java.util.ArrayList listRang = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("rang");
  java.util.ArrayList listSourceContrat = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("sourceContrat");
  java.util.ArrayList listAgrement = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("agrement");
  java.util.ArrayList listAffair = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("naffair");
 
  pageContext.setAttribute("choixNiche", listNiche );
  pageContext.setAttribute("choixTypeFact", listTypeFact);
  pageContext.setAttribute("choixRang", listRang);
  pageContext.setAttribute("choixSourceContrat", listSourceContrat);
  pageContext.setAttribute("choixAgrement", listAgrement);	
  pageContext.setAttribute("choixNaffair", listAffair);

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
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   tabVerif["cdatarr"]   = "VerifierDate2(document.forms[0].cdatarr,'jjmmaaaa')";
   tabVerif["cobjet1"]   = "VerifierAlphanum(document.forms[0].cobjet1)";
   tabVerif["cobjet2"]   = "VerifierAlphanum(document.forms[0].cobjet2)";
   tabVerif["crem"]      = "VerifierAlphanum(document.forms[0].crem)";
   tabVerif["codsg"]     = "VerifierAlphanum(document.forms[0].codsg)";

   tabVerif["comcode"]   = "VerifierAlphaMax(document.forms[0].comcode)";
   tabVerif["ccoutht"]   = "VerifierNum2(document.forms[0].ccoutht,12,2)";
   tabVerif["ccharesti"] = "VerifierNum2(document.forms[0].ccharesti,6,1)";
   tabVerif["cdatdeb"]   = "VerifierDate2(document.forms[0].cdatdeb,'jjmmaaaa')";
   tabVerif["cdatfin"]   = "VerifierDate2(document.forms[0].cdatfin,'jjmmaaaa')";

   var Message="<bean:write filter="false"  name="contratAveForm"  property="msgErreur" />";
   var Focus = "<bean:write name="contratAveForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }  
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();

//    else if (document.forms[0].cagrement)
//	  {
//	   document.forms[0].cagrement.focus();
//    }
	// Création d'un avenant ==> affaire nouvelle = NON
   	if ( (document.forms[0].mode.value == 'insert') && (document.forms[0].test.value == 'avenant')) 
   	 {
		document.forms[0].cnaffair[0].checked = false;
		document.forms[0].cnaffair[1].checked = true;
   	}
   	
  }

function Verifier(form, action,mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
    form.mode.value = mode;
 
}

//Appel en ajaxx pour regarder si le DPG existe et ouvert
function testDpg(codsg){
	ajaxCallRemotePage('/dpg.do?action=testDpg&codsg='+codsg);
	if (document.getElementById("ajaxResponse").innerHTML!='') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

//Appel en ajaxx pour regarder si le DPG appartient au centre de frais
function isDpgFrais(codsg){

	ajaxCallRemotePage('/dpg.do?action=isDpgFrais&codsg='+codsg);

	if (document.getElementById("ajaxResponse").innerHTML!='') {
		alert(document.getElementById("ajaxResponse").innerHTML);
		return false;
	}
	return true;
}

function verifDpg(codsg){

	if ( codsg != '') {
		if (!testDpg(codsg)) {
			document.getElementById("codsg").value = '';
			document.getElementById("codsg").focus();
			return false;
		}
		if (!isDpgFrais(codsg)) {
			document.getElementById("codsg").value = '';
			document.getElementById("codsg").focus();
			return false;
		}	
	}
	
	return true;
}

function ValiderEcran(form)
{
   var temp = form.test.value;
   var msg  = (temp=="contrat"?"ce ":"cet ") + temp;
   
   if (blnVerification) {
	if ( !VerifFormat(null) ) return false;
	if (form.mode.value!="delete") {
		if (!form.cnaffair[0].checked && !form.cnaffair[1].checked) {
		   alert("Choisissez oui ou non");
		   return false;
		}
		if (!ChampObligatoire(form.cdatarr, "la date d'arrivée à GES/ACH")) return false;
		if (!ChampObligatoire(form.cobjet1, "l'objet du contrat")) return false;
		if (!ChampObligatoire(form.codsg, "le code Département/Pôle/Groupe")) return false;
		if (!ChampObligatoire(form.comcode, "le code comptable")) return false;
		if (!ChampObligatoire(form.siren, "le siren")) return false;
		if (!ChampObligatoire(form.ccoutht, "le coût évalué HT")) return false;
		if (!ChampObligatoire(form.ccharesti, "la charge estimée")) return false;
		if (!ChampObligatoire(form.cdatdeb, "la date de début")) return false;
		if (!ChampObligatoire(form.cdatfin, "la date de fin")) return false;
		
		if (form.comcode.value == 0){
			alert("Le code comptable ne peut être égal à 0");
			form.comcode.focus();
			return false;
		}
		
		if (form.csourcecontrat.value == "ASA"){
			alert("Entrez la source du contrat");
			form.csourcecontrat.focus();
			return false;
		}
		
		if (!verifDpg(form.codsg.value)) {
			return false;
		}
		
	}
	else
	   	if (!confirm("Voulez-vous supprimer "+msg+" ?")) return false;
	
	if (form.mode.value == 'update') {


	   if (!confirm("Voulez-vous modifier "+msg+" ?")) return false;
	}
  }
  
  return true;
}

function rechercheCodeDPG(){
	window.open("/recupDPG.do?action=initialiser&nomChampDestinataire=codsg&windowTitle=Recherche Code DPG&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
}  

function nextFocusLoupeCodeDPG(){
	document.forms[0].comcode.focus();
}

function rechercheCodeComptable(){
	window.open("/recupCodeCompta.do?action=initialiser&nomChampDestinataire=comcode&windowTitle=Recherche Code Comptable&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=600") ;
}  

function nextFocusLoupeCodeCompta(){
	document.forms[0].ccoutht.focus();
}

</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div style="display:none;" id="ajaxResponse"></div>
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><bean:write name="contratAveForm" property="titrePage"/> un 
            <bean:write name="contratAveForm" property="test"/> <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/contratAve"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
             <html:hidden property="titrePage"/>
			 <html:hidden property="action"/>
			 <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			 <html:hidden property="flaglock"/> 
			 <html:hidden property="test"/>
			 <html:hidden property="keyList0"/> 
			 <html:hidden property="keyList1"/>
			 <html:hidden property="keyList2"/>
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                
              </table>
			  
              <table border=0 cellspacing=2 cellpadding=2 class="TableBleu">
                <tr> 
                  <td class=lib >Code société - SIREN du contrat :</td>
                  <td ><bean:write name="contratAveForm"  property="soccont" /> - 
                      <bean:write name="contratAveForm"  property="siren" />
                    <html:hidden property="soccont"/>
                  </td>
    
                  <td class="lib" >Société :</td>
                  <td ><bean:write name="contratAveForm"  property="soclib" />
                    <html:hidden property="soclib"/>
                  </td>
                </tr>
                <tr> 
                  <td class=lib >N° de contrat :</td>
                  <td >
				  <bean:write name="contratAveForm"  property="numcont" /> 
                    <html:hidden property="numcont"/>
                  </td>
                       <td class="lib" >N° d'avenant : </td>
                  
                  <td >
				  <bean:write name="contratAveForm"  property="cav" /> 
                    <html:hidden property="cav"/>
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Niche :</b></td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="niche" styleClass="input"> 
   						<html:options collection="choixNiche" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="contratAveForm" property="niche"/><html:hidden property="niche"/>
  					</logic:equal>
                  </td>
                  <td>&nbsp;</td>
                  <td >
				  	<input type="hidden" name="cagrement" value=" ">
<!--               	<logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="cagrement" styleClass="input"> 
   							<html:options collection="choixAgrement" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
                   	<logic:equal parameter="action" value="supprimer">
                   		<bean:write name="contratAveForm"  property="cagrement" />
                   	</logic:equal>
--> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Affaire nouvelle :</b> 
                  <td >
				  <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixNaffair">
						<bean:define id="choix" name="element" property="cle"/>
						<html:radio property="cnaffair" value="<%=choix.toString()%>"/>
			 			<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="contratAveForm" property="cnaffair"/><html:hidden property="cnaffair"/>
  					</logic:equal>
				  </td>
                  <td class="lib" ><b>Rang :</b></td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="crang" styleClass="input"> 
   						<html:options collection="choixRang" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="contratAveForm"  property="crang" />
                   </logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td class=lib ><b>Date d'arrivée :</b></td>
                  <td >
				  <logic:notEqual parameter="action" value="supprimer">
				  <html:text property="cdatarr" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/>
                  </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
					<bean:write name="contratAveForm" property="cdatarr"/><html:hidden property="cdatarr"/>
				  </logic:equal>
				  </td>
				  <td class="lib" ><b>Source :</b></td>
				  <td >
                    <logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="csourcecontrat" styleClass="input"> 
   						<html:options collection="choixSourceContrat" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="contratAveForm"  property="csourcecontrat" />
                   </logic:equal> 
                  </td>
                </tr>
              
                <tr> 
                  <td class="lib" ><b>Objet :</b></td>
                  <td colspan=3>
				  <logic:notEqual parameter="action" value="supprimer">
				  <html:text property="cobjet1" styleClass="input" size="50" maxlength="50" onchange="return VerifFormat(this.name);"/>  
                  </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
					<bean:write name="contratAveForm" property="cobjet1"/><html:hidden property="cobjet1"/>
				  </logic:equal>
				  </td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td colspan=3><logic:notEqual parameter="action" value="supprimer">
				  <html:text property="cobjet2" styleClass="input" size="50" maxlength="50" onchange="return VerifFormat(this.name);"/>  
                  </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
					<bean:write name="contratAveForm" property="cobjet2"/><html:hidden property="cobjet2"/>
				  </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Remarques :</td>
                  <td colspan=3>
				  <logic:notEqual parameter="action" value="supprimer">
                    <html:text property="crem" styleClass="input" size="50" maxlength="50" onchange="return VerifFormat(this.name);"/>  
                  </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
					<bean:write name="contratAveForm" property="crem"/><html:hidden property="crem"/>
				  </logic:equal>
				  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Code DPG :</b></td>
                  <td > 
				  <logic:notEqual parameter="action" value="supprimer">
                    <html:text property="codsg" styleClass="input" size="7" maxlength="7" onblur="verifDpg(this.value);"/>  
                    &nbsp;&nbsp;<a href="javascript:rechercheCodeDPG();" onFocus="javascript:nextFocusLoupeCodeDPG();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code DPG" title="Rechercher Code DPG" align="absbottom"></a>
                  </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
					<bean:write name="contratAveForm" property="codsg"/><html:hidden property="codsg"/>
				  </logic:equal>
				  </td>
              
                  <td class="lib" ><b>Code comptable : </b></td>
                  <td > 
				  <logic:notEqual parameter="action" value="supprimer">
                    <html:text property="comcode" styleClass="input" size="16" maxlength="11" onchange="return VerifFormat(this.name);"/>  
                    &nbsp;&nbsp;<a href="javascript:rechercheCodeComptable();" onFocus="javascript:nextFocusLoupeCodeCompta();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Code Comptable" title="Rechercher Code Comptable" align="absbottom"></a>
					 </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
					<bean:write name="contratAveForm" property="comcode"/><html:hidden property="comcode"/>
				  </logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Type de Facturation :</b></td>
                  <td colspan=3>
				  <logic:notEqual parameter="action" value="supprimer"> 
						<html:select property="ctypfact" styleClass="input"> 
   						<html:options collection="choixTypeFact" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="contratAveForm"  property="ctypfact" />
                   <html:hidden property="ctypfact"/>
                   </logic:equal> 
                    </td>
                </tr>
                <tr>
                 <%
                Hashtable hKeyList= new Hashtable();
                try { 
                	hKeyList.put("soccode",  contratAveForm.getSoccont().toString()); 
                	java.util.ArrayList listeActivite = listeDynamique.getListeDynamique("siren", hKeyList);
                	request.setAttribute("listeSiren", listeActivite);
                	} catch (Exception e) {
                		 %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
                         request.setAttribute("listeSiren", new ArrayList());
                      
                     }
                	
                 %> 
                  <td class="lib" ><b>SIREN Societé :</b></td>
                  <td colspan=3>
                   <logic:notEqual parameter="action" value="supprimer">
				  	<html:select property="siren" styleClass="input" size="1" onChange="javascript:MAJCode();"> 
				  			<option value="" >A Renseigner</option>
                    		<html:options collection="listeSiren" property="cle" labelProperty="libelle" /> 
                      	</html:select>
                    </logic:notEqual>
                    
                    <logic:equal parameter="action" value="supprimer">
                    <bean:write name="contratAveForm"  property="siren" />
                    <html:hidden property="siren"/>
                   </logic:equal>
                  </td>
                  
                </tr>
                
                <tr> 
                  <td class="lib" ><b>Coût évalué H.T. :</b></td>
                  <td >
                   <logic:notEqual parameter="action" value="supprimer">
				    <html:text property="ccoutht" styleClass="input" size="13" maxlength="13" onchange="return VerifFormat(this.name);"/>   
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   	<bean:write name="contratAveForm"  property="ccoutht" />
                   	<html:hidden property="ccoutht"/>
                   </logic:equal> 
                  </td>
                  <td class="lib" ><b>Charge estimée :</b></td>
                  <td >
                   <logic:notEqual parameter="action" value="supprimer"> 
				    <html:text property="ccharesti" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>   
                   </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                    <bean:write name="contratAveForm"  property="ccharesti" />
                    <html:hidden property="ccharesti"/>
                   </logic:equal> 
                    </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Date de début :</b></td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">  
                     <html:text property="cdatdeb" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/>  
                    </logic:notEqual>
                   <logic:equal parameter="action" value="supprimer">
                   <bean:write name="contratAveForm"  property="cdatdeb" />
                   <html:hidden property="cdatdeb"/>
                   </logic:equal> 
                  </td>
                  <td class="lib" ><b>Date de fin :</b></td>
                  <td > 
                    <logic:notEqual parameter="action" value="supprimer">  
                     <html:text property="cdatfin" styleClass="input" size="10" maxlength="10" onchange="return VerifFormat(this.name);"/>  
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                     <bean:write name="contratAveForm"  property="cdatfin" />
                     <html:hidden property="cdatfin"/>
                    </logic:equal> 
                  </td>
                </tr>
                
                <tr> 
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
                  <td>&nbsp;</td>
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
Integer id_webo_page = new Integer("3001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = contratAveForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
