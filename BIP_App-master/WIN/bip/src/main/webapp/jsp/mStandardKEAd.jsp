<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="standardKEForm" scope="request" class="com.socgen.bip.form.StandardKEForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" -->
 <bip:VerifUser page="jsp/fStandardAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

<%
java.util.Hashtable hP = new java.util.Hashtable();
hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fourcopi",hP);
//list3.add(0,new ListeOption(null,valeurARenseigner));
pageContext.setAttribute("listeFourCopi", list3);
%>

<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";
var tab_niveau=new Array('a','b','c','d','e','f','g','h','i','j','k','hc');
var tab_metier=new Array('Me','Mo','Hom','Gap','Exp','Sau');

function numberConversion(value) {
	return Number(value);
}
var arrRange = [];
var codsg_bas_tmp;
var codsg_haut_tmp;


function MessageInitial()
{
 
  
   var Message="<bean:write filter="false"  name="standardKEForm"  property="msgErreur" />"; 
   var Focus = "<bean:write name="standardKEForm"  property="focus" />";

   arrRange = []; 
   
   var arrNum1 = [];
  var arrStr1 = document.forms[0].SGValue.value.split(' ');
	for (var i = 0; i <= arrStr1.length; i=i+2) {
		if (arrStr1[i] !== '' && arrStr1[i+1] !== '') {
   		 arrNum1.push({
        fromRange: numberConversion(arrStr1[i]),
        toRange: numberConversion(arrStr1[i+1])
   		 });
	}
}
arrRange = arrNum1;
 
   if (Message != "") {
      alert(Message);
   }
   
   codsg_bas_tmp = Number(document.forms[0].codsg_bas_new.value);
	codsg_haut_tmp = Number(document.forms[0].codsg_haut_new.value);
	
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
    else {
       if(document.forms[0].mode.value!="delete" ) {
	    document.forms[0].codsg_bas_new.focus();
	    }
    }
    if (document.forms[0].action.value=="creer"){
    
	    //Initialisation des DPG et des couts
	    	document.forms[0].codsg_bas_new.value='0000000';
	    	document.forms[0].codsg_haut_new.value='9999999';
	    	                  
	    	document.forms[0].cout_Me.value='0,00';
	    	document.forms[0].cout_Mo.value='0,00';
	    	document.forms[0].cout_Hom.value='0,00';
	    	document.forms[0].cout_Gap.value='0,00';
	    	document.forms[0].cout_Exp.value='0,00';
	    	document.forms[0].cout_Sau.value='0,00';
	   
	    
	    		
    }
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.mode.value =mode;
   form.action.value = action;

} 


function rangeCheck(form) {
	var tcodsg_bas = Number(form.codsg_bas_new.value);
	var tcodsg_haut = Number(form.codsg_haut_new.value);
	var tmp = 0;
	if(form.mode.value === 'insert') {
		if(tcodsg_bas <= arrRange[0].fromRange && tcodsg_haut >= arrRange[arrRange.length - 1].toRange) {
		return true;
	}
	for(var i = 0; i < arrRange.length; i++) {
		 if ((tcodsg_bas >= arrRange[i].fromRange) && (tcodsg_bas <= arrRange[i].toRange) || (tcodsg_haut >= arrRange[i].fromRange) && (tcodsg_haut <= arrRange[i].toRange)) {
			return true;
		} else {
			tmp++;
		}
	}
	if(tmp === arrRange.length) {
		return false;
	}
} else if (form.mode.value === 'update') {

	if(tcodsg_bas <= arrRange[0].fromRange && tcodsg_haut >= arrRange[arrRange.length - 1].toRange) {
		return true;
	}

	if((tcodsg_bas >= codsg_bas_tmp && tcodsg_bas < codsg_haut_tmp) && (tcodsg_haut > codsg_bas_tmp && tcodsg_haut <= codsg_haut_tmp)) {
		return false;
	} 
	for(var i = 0; i < arrRange.length; i++) {
	if(!(arrRange[i].fromRange === codsg_bas_tmp && arrRange[i].toRange === codsg_haut_tmp)) {
		 if ((tcodsg_bas >= arrRange[i].fromRange) && (tcodsg_bas <= arrRange[i].toRange) || (tcodsg_haut >= arrRange[i].fromRange) && (tcodsg_haut <= arrRange[i].toRange)) {
			return true;
		} else {
			tmp++;
		}
		}
	}
	if(tmp === arrRange.length-1) {
		return false;
	}
}
	return false;
}


function ValiderEcran(form)
{
  var champ;
  if (blnVerification == true) {
   if (form.mode.value != 'delete') {
     
   
     if (form.codsg_bas_new &&!ChampObligatoire(form.codsg_bas_new, "le code DPG bas")) return false;
     if (form.codsg_haut_new &&!ChampObligatoire(form.codsg_haut_new, "le code DPG haut")) return false;
     if(rangeCheck(form)) {
 	 alert('Doublon avec l existant sur au moins 1 DPG de votre plage');
 	 return false;
 	 }
 
	}
     if (form.mode.value == 'update') {
        if (!confirm("Voulez-vous modifier ce coût standard ?")) return false;
     }
     if (form.mode.value == 'delete') {
	 	if (!confirm("Voulez-vous supprimer ce coût standard ?")) return false;
	 }
  }
arrRange = [];
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><!--  bean:write name="standardKEForm" property="titrePage"/>-->Gestion des coûts moyens complets<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/standardKE"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
		      <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		      <html:hidden property="choix"/>
		      <html:hidden property="keyList0"/>
		      <html:hidden property="flaglock"/>
		      
		      <html:hidden property="codsg_bas"/> 
		      <html:hidden property="codsg_haut"/>
		      <html:hidden property="SGValue"/>
		       
				<table cellspacing="2" cellpadding="2" class="tableBleu">
                <tr> 
                  <td>&nbsp;</td>
                  
                </tr>
                <tr> 
                  
                  <td><b>Année : <bean:write name="standardKEForm"  property="couann" /></b> 
                    		<html:hidden property="couann"/> 
                  </td>
				 
                </tr>
                <tr>
                  <td >&nbsp;</td>
                
                </tr>
              </table>
			  			  
			 
              <table border=0  cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td class="lib" colspan="2"><B>DPG BAS :</B></td>
                  <td colspan="2"> 
                     <!-- <bean:write name="standardKEForm"  property="codsg_bas" /> -->
                     <html:text property="codsg_bas_new" styleClass="input" size="7" maxlength="7" onchange="return VerifierNum(this,7,0);"/>
                     <!-- <html:hidden property="codsg_bas"/> -->
                  </td>
                </tr>
                <tr> 
                  <td class="lib" colspan="2"><b>DPG HAUT :</b></td>
                  <td colspan="2"> 
                     <!-- <bean:write name="standardKEForm"  property="codsg_haut"/> -->
                     <html:text property="codsg_haut_new" styleClass="input" size="7" maxlength="7"  onchange="return VerifierNum(this,7,0);"/>
                    <!--  <html:hidden property="codsg_haut"/> --> 
                  </td>
                </tr>
                <tr> 
                  <td colspan="3" >&nbsp;</td>
                 
                </tr>
              </table>
             
			  
			   <table cellspacing="2" cellpadding="2" class="tableBleu"  >              
                <tr>                                 
                  <td colspan="7" align="center" class="lib"><b> M&eacute;tiers</b>
                  </td>
                </tr>
                 <tr>  
                  <% if (Integer.parseInt(standardKEForm.getCouann()) >= 2010) {%>
                     <td>&nbsp;</td>
                    <%} %>                
                  <td >ME</td>
                  <td >MO</td>
                  <td >HOM</td>
                  <td >GAP</td>
                  <td >EXP</td>
                  <td >SAU</td>  
				  <td >Fournisseur COPI</td>                                    
                </tr>
                <tr>   
                    <% 
                    String fusionligne="";
                    if (Integer.parseInt(standardKEForm.getCouann()) >= 2010) {
                    	fusionligne="rowspan=2";             
                    %>
                     <td>Grand T1</td>
                    <%} %>
                  <td ><html:text  property="cout_Me_type1" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Mo_type1" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Hom_type1" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Gap_type1" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                   <td ><html:text property="cout_Exp_type1" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Sau_type1" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>                  
                  <!----------------  Fournisseur COPI ----------------------->
                 <td width="10%" <%= fusionligne %>> 
	                <html:select property="fournisseurCopi" name="standardKEForm" styleClass="input"    > 
	                        <html:options  collection="listeFourCopi" property="cle" labelProperty="libelle" />
	                </html:select>
                </td> 
                </tr>     
                
                <% if (Integer.parseInt(standardKEForm.getCouann()) >= 2010)
                	{%>
                   <tr>     
                  <td>Autres types</td>
                  <td ><html:text  property="cout_Me_type2" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Mo_type2" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Hom_type2" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Gap_type2" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                   <td ><html:text property="cout_Exp_type2" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>
                  <td ><html:text  property="cout_Sau_type2" styleClass="input" size="12" maxlength="12" onchange="return VerifierNum(this,12,2);"/> </td>                  
                   </tr>     
                	
                	
                	<%} %>              
                           
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
                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'suite', null, false);"/> 
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
Integer id_webo_page = new Integer("1007"); 
com.socgen.bip.commun.form.AutomateForm formWebo = standardKEForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
