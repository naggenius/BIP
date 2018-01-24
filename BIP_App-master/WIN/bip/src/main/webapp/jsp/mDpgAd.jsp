<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,org.threeten.bp.*,org.threeten.bp.format.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="dpgForm" scope="request" class="com.socgen.bip.form.DpgForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDpgAd.jsp"/> 
<%
  java.util.ArrayList list1 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("dirme",dpgForm.getHParams()); 
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeGlobale.getListeGlobale("filiale");
  java.util.ArrayList list3 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topFermeture"); 
  java.util.ArrayList list4 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("topDiva");
  java.util.ArrayList list5 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("ouiNon");
  pageContext.setAttribute("choixDirMe", list1);
  pageContext.setAttribute("choixFiliale", list2);
  pageContext.setAttribute("choixTopFer", list3);
  pageContext.setAttribute("choixTop_diva", list4);
  pageContext.setAttribute("choixTop_diva_int", list5);
  
  String top_diva = dpgForm.getTop_diva();
  String top_diva_int = dpgForm.getTop_diva_int();
  String db_topfer=dpgForm.getTopfer();
  String db_datFerm=dpgForm.getDatFerm();
    String currDate = LocalDateTime.now().format(DateTimeFormatter.ofPattern("MM/yyyy"));
  
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
   var Message="<bean:write filter="false"  name="dpgForm"  property="msgErreur" />";
   var Focus = "<bean:write name="dpgForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	   document.forms[0].sigdep.focus();
   }
  
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (form.mode.value != 'delete') {
	     if (!ChampObligatoire(form.sigdep, "le sigle du nouveau département")) return false;
	     if (!ChampObligatoire(form.sigpole, "le sigle du nouveau pôle")) return false;
	     if (!ChampObligatoire(form.libdsg, "le libellé du Département/Pôle/Groupe")) return false;
	     if (!ChampObligatoire(form.centractiv, "le centre d'activité")) return false;
	     if (!ChampObligatoire(form.top_diva, "le top diva lignes")) return false;
	     if (!ChampObligatoire(form.top_diva_int, "le top diva intervenants")) return false;
     
     	 if (!form.topfer[0].checked && !form.topfer[1].checked) {
        	alert("Choisissez Ouvert ou Fermé");
        	return false;
     	 }
     	 
     	
     	/* TD 720 afficher un message de confirmation de modification des tops diva*/ 
     	if (form.mode.value == 'update') 
     	{
     	 var top_diva = "<%= top_diva %>";
     	 var top_diva_int = "<%= top_diva_int %>";
     	     	  
     	  if(top_diva != form.top_diva.value )
     	  	if(!confirm('Vous confirmer la modification du top envoi des lignes vers DIVA'))
     	  	 return false;
     	  	 
     	  if(top_diva_int != form.top_diva_int.value )
     	  	if(!confirm('Vous confirmer la modification du top envoi des ressources vers DIVA'))
     	  	 return false;
     	 
     	 }
     	 
     }
   

     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier ce DPG ?")) return false;
     }
     if (form.mode.value == 'delete') {
        if (!confirm("Voulez-vous supprimer ce DPG ?")) return false;
     }
     
   return  verifiedatFerm();
  }

   return true;
}

function rechercheID(){
	window.open("/recupIdPersonneType.do?action=initialiser&rtype=A&nomChampDestinataire=identgdm&windowTitle=Recherche Identifiant GDM&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
  	return ;
}  

function nextFocusLoupePersonne(){
	document.dpgForm.identgdm.focus();
}


function rechercheMatricule(){
	window.open("/recupMatriculePersonne.do?action=initialiser&rtype=A&nomChampDestinataireMatricule=matricule&nomChampDestinataireNomPrenom=gnom&windowTitle=Recherche de Matricule&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
  	return ;
}  

function nextFocusLoupeMatricule(){
	document.dpgForm.matricule.focus();
}

function verifieMatricule(champMatricule){
		
        var valeurInitiale = champMatricule.value ; 	
		if(VerifierAlphanum(champMatricule,7,0)) {
			document.forms[0].action.value = "refresh";
			document.forms[0].submit();
		};		
		
		this.value = valeurInitiale ; 		
		
}  

function verifiedatFerm(){


	if(document.forms[0].topfer[1].checked){
	//if date is greater than sysdate  
	var tmpDat=document.forms[0].datFerm.value;
	if(null!=<%=db_datFerm%> && <%=db_datFerm%>!=""){
		if(tmpDat== null || tmpDat==""){
	
		alert("La date d'effet est obligatoire si le Top Fermeture du DPG est à \"Fermé ");
		document.forms[0].datFerm.focus();
		return false;
		}
	}
	var tmpFerDat= document.forms[0].datFerm.value.split("/");
	var ferDat= new Date(tmpFerDat[0]+"/01/"+tmpFerDat[1]);	
	var tmpCurDat="<%=currDate%>".split("/");
	var curDat= new Date(tmpCurDat[0]+"/01/"+tmpCurDat[1]);
		if(ferDat.getTime()>curDat.getTime()){
		alert("Quand le Top Fermeture est à \"Fermé\", la Date d'effet fermeture doit être antérieure ou égale au mois de la dernière mensuelle définitive");
		document.forms[0].datFerm.focus();
		return false;
		}
	
	}
	
}

function verifieNomEtMatricule(champNom){
		
		if(VerifierAlphanum(this)){
		   
		}
		
		
		
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          <bean:write name="dpgForm" property="titrePage"/> un DPG<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/dpg"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			
			
			  
	
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <html:hidden property="flaglock"/>
			  <table cellspacing="2" cellpadding="2" class="tableBleu">
			   <!--  
			   		  <html:text property="flagRetourRechercheMatricule" styleClass="input" size="4" maxlength="3"/>
			   		
			   < -->
			   
                <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code Départ/Pôle/Groupe :</b></td>
                  <td><b><bean:write name="dpgForm"  property="codsg" /></b> 
                    <html:hidden property="codsg"/>
                    
                  </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Branche/Direction :</b></td>
                  <td   > 
                    <logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="coddir" styleClass="input"> 
   						<html:options collection="choixDirMe" property="cle" labelProperty="libelle" />
						</html:select>	
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="dpgForm" property="coddir"/><html:hidden property="coddir"/>
  					</logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td  class="lib" ><b>Sigle nouveau département :</b></td>
                  <td> 
                   <logic:notEqual parameter="action" value="supprimer">
						  <html:text property="sigdep" styleClass="input" size="4" maxlength="3" onchange="return VerifierAlphaMax(this);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="sigdep"/>
  					</logic:equal>
                   
                  </td>
                </tr>
                <tr> 
                  <td  class="lib"><b>Sigle nouveau pôle :</b></td>
                  <td >
                     <logic:notEqual parameter="action" value="supprimer">
						  <html:text property="sigpole" styleClass="input" size="4" maxlength="3" onchange="return VerifierAlphaMax(this);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="sigpole"/>
  					</logic:equal> 

                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Libellé dépt./pôle/groupe :</b></td>
                  <td>
                     <logic:notEqual parameter="action" value="supprimer">
						  <html:text property="libdsg" styleClass="input" size="32" maxlength="30" onchange="return VerifierAlphanum(this);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="libdsg"/>
  					</logic:equal> 

                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Nom du responsable :</b></td>
                  <td> 
                     <logic:notEqual parameter="action" value="supprimer">
						  <html:text property="gnom" styleClass="input" size="32" maxlength="30" 
						  onchange="return verifieNomEtMatricule(this);" />
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="gnom"/>
  					</logic:equal> 
                   
                  </td>
                </tr>                
               <tr>                                
                  <td class="lib"><b>Matricule du responsable :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
						<html:text property="matricule" styleClass="input" size="7" maxlength="7" onchange="return verifieMatricule(this);" />&nbsp;&nbsp;                           
                        <a href="javascript:rechercheMatricule();" onFocus="javascript:nextFocusLoupeMatricule();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Matricule" title="Rechercher Matricule"></a>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="matricule"/>
  					</logic:equal> 
                  </td>
               </tr>
               
                <tr> 
                  <td class="lib"><b>Centre d'activité :</b></td>
                  <td> 
                     <logic:notEqual parameter="action" value="supprimer">
						  <html:text property="centractiv" styleClass="input" size="6" maxlength="6" onchange="return VerifierNum(this,7,0);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="centractiv"/>
  					</logic:equal> 
                    
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>CA pour FI :</b></td>
                  <td> 
                     <logic:notEqual parameter="action" value="supprimer">
						  <html:text property="cafi" styleClass="input" size="6" maxlength="6" onchange="return VerifierNum(this,7,0);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="cafi"/>
  					</logic:equal> 
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Filiale :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">	
						<html:select property="filcode" styleClass="input" > 
                		<html:options collection="choixFiliale" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
	    			<logic:equal parameter="action" value="supprimer">
	    				<bean:write name="dpgForm" property="filcode"/><html:hidden property="filcode"/>
  					</logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Centre de frais :</td>
                  <td> 
                    <bean:write name="dpgForm" property="scentrefrais"/>
                   <logic:notEqual parameter="action" value="supprimer">
					 	<html:hidden property="scentrefrais"/>	 
					</logic:notEqual>
  					
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Top fermeture :</b> 
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
				 		 <logic:iterate id="element" name="choixTopFer">
							<bean:define id="choix" name="element" property="cle"/>
							<html:radio property="topfer" value="<%=choix.toString()%>" />
			 				<bean:write name="element" property="libelle"/>
						</logic:iterate> 
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="topfer"/>
  					</logic:equal>
                    </td>
                </tr>
                 <tr> 
                 
                 <logic:notEqual parameter="action" value="supprimer">
                 	<logic:notEqual parameter="action" value="creer">
                  <td class="lib" align="right">Date d'effet fermeture : 
                  <td> 
                    
				 		<html:text property="datFerm" styleClass="input" size="10" maxlength="7" onchange="return VerifierDate( this, 'mm/aaaa' );" 
						  /> 
					
  					</td>
  						</logic:notEqual>
  					</logic:notEqual>
                </tr>
                <tr> 
                  <td class="lib">GDM rattach&eacute; :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
						<html:text property="identgdm" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);"/>&nbsp;&nbsp;                           
                        <a href="javascript:rechercheID();" onFocus="javascript:nextFocusLoupePersonne();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Identifiant" title="Rechercher Identifiant"></a>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">	
  						<bean:write name="dpgForm" property="identgdm"/>
  					</logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Top DIVA lignes:</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">	
						<html:select property="top_diva" styleClass="input" > 
						<option value="" >A saisir</option>
                		<html:options collection="choixTop_diva" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
	    			<logic:equal parameter="action" value="supprimer">
	    				<bean:write name="dpgForm" property="top_diva"/><html:hidden property="top_diva"/>
  					</logic:equal> 
                  </td>
                </tr>
                
                <tr> 
                  <td class="lib">Top DIVA intervenants:</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">	
						<html:select property="top_diva_int" styleClass="input" > 
						<option value="" >A saisir</option>
                		<html:options collection="choixTop_diva_int" property="cle" labelProperty="libelle" />
						</html:select>
					</logic:notEqual>
	    			<logic:equal parameter="action" value="supprimer">
	    				<bean:write name="dpgForm" property="top_diva_int"/><html:hidden property="top_diva_int"/>
  					</logic:equal> 
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
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = dpgForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
