<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="datesEffetForm" scope="request" class="com.socgen.bip.form.DatesEffetForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmDatesEffetAd.jsp"/> 
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
   var Message="<bean:write filter="false"  name="datesEffetForm"  property="msgErreur" />";
   var Focus = "<bean:write name="datesEffetForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!='delete'){
	   document.forms[0].dateffet.focus();
   }
}

function Verifier(form, action, mode,flag)
{
   blnVerification = flag;
   form.action.value = action;
}

function renverseStrDate(sIn) {
  var sOut = "";
  if(sIn!=""){
	  sOut = sIn.charAt(6) + sIn.charAt(7) + sIn.charAt(8)+ sIn.charAt(9) + "/" + sIn.charAt(3)+ sIn.charAt(4) + "/" + sIn.charAt(0)+ sIn.charAt(1)
  }
  return(sOut);
}

function ValiderEcran(form)
{
  if (blnVerification == true) {
  
  	 var dateeffet = renverseStrDate(form.dateffet.value);
  	 var datefin = renverseStrDate(form.datfin.value);
  	
  	 if ((form.datfin.value!="" && dateeffet > datefin) ||
  	 	 ((form.heurfin.value!="" && form.dateffet.value == form.datfin.value) && form.heureffet.value >= form.heurfin.value)){
	  	  alert('Date de fin doit être égale ou ultérieure à la date de début');
	  	  form.datfin.value = '';
	  	  form.heurfin.value = '';
	  	  return false;
  	  } 

  	 if ((form.action.value!="valider")&&(form.action.value!="annuler")&&(form.action.value!="suite"))
 		 form.action.value ="valider";
 		 
     if (form.mode.value == 'delete') {
     	if (!confirm("Voulez-vous supprimer ce paramètre BIP ?")) return false;
	 }
	 else {
	     //if (!ChampObligatoire(form.codaction, "le code action")) return false;
	     //if (!ChampObligatoire(form.codversion, "le code version")) return false;
	     //if (!ChampObligatoire(form.commentaire, "le commentaire")) return false;
	     if (!ChampObligatoire(form.dateffet, "la date effet")) return false;
	     //if (!ChampObligatoire(form.heureffet, "l'heure effet")) return false;
	     //if (!ChampObligatoire(form.datfin, "la date fin")) return false;
	     //if (!ChampObligatoire(form.heurfin, "l'heure fin")) return false;
	     
	     if (form.mode.value == 'update' && form.action.value == 'valider') {
	        if (!confirm("Voulez-vous modifier ce paramètre BIP ?")) return false;
	     }
     }
   }
   return true;
}
 
//Methodes permettant de verifier l'heure
function isNumeric(sText)
{
	var ValidChars = "0123456789";
	var IsNumber=true;
	var Char;
	
	for (i = 0; i < sText.length && IsNumber == true; i++)
	{
	Char = sText.charAt(i);
	if (ValidChars.indexOf(Char) == -1)
	{
	IsNumber = false;
	}
	}
	return IsNumber;
}

function verifierTime(heure)
{
	var IsTime = true;
	if (heure.value.length==5)
	{
		var Hrs = (isNumeric(heure.value.substring(0,2)) ? heure.value.substring(0,2) : -1);
		var Mins = (isNumeric(heure.value.substring(3,5)) ? heure.value.substring(3,5) : -1);
		
		if ( Hrs>=0 && Hrs<24 && Mins>=0 && Mins<60 && (heure.value.toLowerCase().substring(2,3)==":")){
			IsTime = true;
		}
		else{
			heure.value = "";
			IsTime = false;
		}
	}
	else
		if(heure.value.length==0){
			IsTime = true;
			}
		else
			{
			IsTime = false;
			heure.value = "";
			}
	
	
	if (!IsTime)
		alert ("Heure invalide (HH:mm)");
}

function limite( this_,  max_){
  var Longueur = this_.value.length;

  if ( Longueur > max_){
    this_.value = this_.value.substring( 0, max_);
    Longueur = max_;
   }
  document.getElementById('reste').innerHTML = (max_ - Longueur) +" sur 200 caractères restant";
}

function effacerRetourChariot(champ){
    
    document.forms[0].commentaire.value = champ.value.replace(/[\r\n]/g,' ');
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
          <bean:write name="datesEffetForm" property="titrePage"/> un paramètre BIP<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/majDatesEffet"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			
			
			  
	
			  <html:hidden property="titrePage"/>
              <html:hidden property="action" value="creer"/>
              <html:hidden property="mode"/>
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
			  <table cellspacing="2" cellpadding="2" class="tableBleu">
			    <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td  >&nbsp; </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code Action :</b></td>
                  <td><b><bean:write name="datesEffetForm"  property="codaction"/></b> 
                    <html:hidden property="codaction"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Code Version :</b></td>
                  <td><b><bean:write name="datesEffetForm"  property="codversion"/></b> 
                    <html:hidden property="codversion"/>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Date Effet :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="dateffet" styleClass="input" maxlength="10" size="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="datesEffetForm"  property="dateffet" />
                    	<html:hidden property="dateffet"/>
  					</logic:equal>
                  </td>
                </tr>
        		<tr> 
                  <td class="lib"><b>Heure Effet :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="heureffet" styleClass="input" maxlength="5" size="5" onchange="return verifierTime(this);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="datesEffetForm"  property="heureffet" />
                    	<html:hidden property="heureffet"/>
  					</logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Date Fin :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="datfin" styleClass="input" maxlength="10" size="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="datesEffetForm"  property="datfin" />
                    	<html:hidden property="datfin"/>
  					</logic:equal>
                  </td>
                </tr>
        		<tr > 
                  <td class="lib"><b>Heure Fin :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="heurfin" styleClass="input" maxlength="5" size="5" onchange="return verifierTime(this);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="datesEffetForm"  property="heurfin" />
                    	<html:hidden property="heurfin"/>
  					</logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td class="lib"><b>Commentaire :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:textarea name="datesEffetForm" property="commentaire" rows="6" cols="60" style="white-space: wrap;" styleClass="input" onkeyup="limite(this,200);" onchange="effacerRetourChariot(this);"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<html:textarea name="datesEffetForm" property="commentaire" readonly="true" rows="6" cols="60" style="white-space: wrap;" styleClass="input" onkeyup="limite(this,200);"/>
  					</logic:equal>
                  </td>
                </tr>
                <tr>
	                <td>&nbsp;</td>
	                <td><b><div id="reste"></div></b></td>
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
                <td width="33%"> 
                  <div align="center"> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
                  </div>
                </td>
                <td width="33%">
                	<div align="center"> 
                		<logic:notEqual name="datesEffetForm" property="mode" value="update">
                			<html:submit property="boutonLignes" value="Lignes" styleClass="input" disabled="true"/> 
                 		 </logic:notEqual>
                 		 <logic:equal name="datesEffetForm" property="mode" value="update">
                			<html:submit property="boutonLignes" value="Lignes" styleClass="input" onclick="Verifier(this.form, 'suite', 'suite',true);"/> 
                 		 </logic:equal>
                  	</div>
                </td>
                <td width="33%"> 
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/> 
                  </div>
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
</body>
<% 
Integer id_webo_page = new Integer("1001"); 
com.socgen.bip.commun.form.AutomateForm formWebo = datesEffetForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
