<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="sousTacheForm" scope="request" class="com.socgen.bip.form.SousTacheForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="/structLb.do"/> 
<%  
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
%> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">


var blnVerification = true;
var rafraichiEnCours = false;

function MessageInitial()
{
   var Message="<bean:write filter="false"  name="sousTacheForm"  property="msgErreur" />";
   if (Message != "") {
      alert(Message);
   }
   
   <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	   var Focus = "<bean:write name="sousTacheForm"  property="focus" />";
	   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
	    else {
		   document.forms[0].asnom.focus();
	    }
	</logic:notEqual>
    
    document.forms[0].tache.value = document.forms[0].keyList2.value;
    
    var aist = "<bean:write name="sousTacheForm"  property="aist" />";
    var libpid = "<bean:write name="sousTacheForm"  property="libpid" />";
   
    if((aist.substring(0,2).toUpperCase() == "FF")&&((libpid == "null" ) || (libpid == "" )))
     {
        if(!rafraichiEnCours)
	    {
		    rafraichir(document.forms[0]);
		    rafraichiEnCours = true;
	     }
	 }
    
}


function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;

} 
function ValiderEcran(form) {
  if (blnVerification == true) {
     if (!ChampObligatoire(form.acst, "le numéro de la sous-tâche")) return false;
     if (!ChampObligatoire(form.asnom, "le libelle de la sous-tâche")) return false;
     if (form.action.value == 'valider' &&  form.mode.value == 'update') {
		Replace_Double_Chiffre("acst");	//Mettre le n° sur 2 chiffres si bug onChange
		if ((form.acst.value=="00")|(form.acst.value=="0")){
			alert("Entrez un autre numéro de sous-tâche");
			form.acst.focus();
			return false;

		}
        if (!confirm("Voulez-vous modifier cette sous-tâche ?")) return false;
        
     }
     
  }
  // On désactive le bouton valider pour éviter un double click
  form.boutonValider.disabled=true;
  return true;
}


function chargeType(libCherche) {

 
   if(VerifierAlphaMax(libCherche))
   {
          
       if(document.forms[0].aist.value.substring(0,2).toUpperCase() == "FF")
       {

	      if(!rafraichiEnCours)
	      {
		     rafraichir(document.forms[0]);
		     rafraichiEnCours = true;
	       }
	   }
	   else
	       return true;
	}    
	
	else
	  return false;
}


</script>
<!-- #EndEditable --> 
</head>
<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
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
	          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
	           <div id="titre" ><bean:write name="sousTacheForm" property="titrePage"/> une sous-t&acirc;che <!-- #EndEditable --></div></td>
	        </tr>
	        <tr> 
	          <td>
	          	<!-- #BeginEditable "debut_form" --> <html:form action="/sousTache"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
	          	<div id="content"> 
	            <div align="center"><!-- #BeginEditable "contenu" -->
	            <html:hidden property="action"/>
	          	<html:hidden property="mode"/>
				<html:hidden property="arborescence" value="<%= arborescence %>"/>
	            <html:hidden property="keyList0"/> <!--pid-->
	            <html:hidden property="keyList1"/> <!--n°etape-->
	            <html:hidden property="keyList2"/> <!--n°tache-->
	            <html:hidden property="keyList3"/> <!--ECET - LIBETAPE-->
	            <html:hidden property="keyList4"/> <!--ACTA - LIBTACHE-->
	            <html:hidden property="etape"/>
	            <html:hidden property="tache"/>
	            <html:hidden property="sous_tache"/>
	            <html:hidden property="pid"/>
	            <html:hidden property="flaglock"/>
			    <html:hidden property="titrePage"/>
			    <html:hidden property="typproj"/>
			     <html:hidden property="btRadioStructure"/>	
			      <html:hidden property="direction"/>	
	              <table border="0" cellpadding="0" cellspacing="0"   width="100%" class="tableBleu" >
		   		<tr>
					<td>&nbsp;</td>
	    	   </tr>
			    <tr>
					<td>&nbsp;</td>
	    	   </tr>
	    	   </table>
	    	   	<table border=2 cellspacing=0 cellpadding=10  class="TableBleu" bordercolor="#2E2E2E">
	            <tr>	
	                  <td align="center" colspan="2" class="texte"> <b>Ligne BIP </b>:<b> <bean:write name="sousTacheForm"  property="lib" /><html:hidden property="lib"/></b> 
	                </td>
	            </tr>
	              
	            <tr>	
	                  <td align="center" class="texte"> <b>Etape </b>: <b> <bean:write name="sousTacheForm"  property="keyList3" /><html:hidden property="keyList3"/></b> 
	                </td>	
	                  <td align="center" class="texte"> <b>Tâche </b>: <b> <bean:write name="sousTacheForm"  property="keyList4" /><html:hidden property="keyList4"/></b> 
	                </td>
	            </tr> 
	            </table>
	            <table border="0" cellpadding="2" cellspacing="2"   class="tableBleu" >
	                <tr>
						<td>&nbsp;</td>
	    	   		</tr>
			   	    <tr>
						<td>&nbsp;</td>
	    	   		</tr>
	                <tr align="left"> 
	                  <td class="texteGras"> <b>N°sous-tâche :</b></td>
	                  <td class="texte"> 
	                  <logic:equal name="sousTacheForm"  property="mode" value="update">
	                   		<html:text property="acst" styleClass="input" size="3" maxlength="2" onchange="return Replace_Double_Chiffre(this.name);"/>
	                    </logic:equal> 
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="update"> 
	                    	<bean:write name="sousTacheForm"  property="acst" />
	                    	<html:hidden property="acst"/>
	                   </logic:notEqual>
	      
	                  </td>
	                  <td class="texteGras"> Type : </td>
	                  <td class="texte"> 
	                  	 <%// Si mode suppression %>
	                  	 <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                     	<bean:write name="sousTacheForm"  property="aist" />
	                    	<html:hidden property="aist"/>
	                     </logic:equal>
	                     <logic:notEqual name="sousTacheForm"  property="mode" value="delete"> 
	                     	<html:text property="aist" styleClass="input" size="8" maxlength="6" onchange="return chargeType(this);"/>
	                     </logic:notEqual>
	                  </td>
	                </tr>
	                
	                 <%					
					 if(sousTacheForm.getLibpid() != null){
	                 %>
	                
	                <tr>
	                     
	                    <td class="texteGras">Libellé de la Ligne BIP <b><%= sousTacheForm.getAist().substring(2) %></b> : </td>                   
	                    <td class="texte">
	                 	<bean:write name="sousTacheForm"  property="libpid" />
						<html:hidden property="libpid"/>
						</td>
	                
	                </tr>
	                
	                <tr>
	                
	                    <td class="texteGras">Code DPG : </td>
	                     <td class="texte">
	                  	 <bean:write name="sousTacheForm"  property="codsg" /> - <bean:write name="sousTacheForm"  property="libcodsg" />
						 <html:hidden property="codsg"/>
						 <html:hidden property="libcodsg"/>
	                     </td>
	                     
	                </tr>
	                  
	                <%					
					 }
	                %>                   
	             
	                
	                <tr align="left"> 
	                  <td class="texteGras"><b>Libellé :</b> </td>
	                  <td colspan="3" class="texte"> 
	                     <%// Si mode suppression %>
	                     <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                     	<bean:write name="sousTacheForm"  property="asnom" />
							<html:hidden property="asnom"/>
	                     </logic:equal>
	                     <logic:notEqual name="sousTacheForm"  property="mode" value="delete"> 
	                     <!--  KRA PPM 58087 : controle des caracteres speciaux  -->
	                     	<html:text property="asnom" styleClass="input" size="35" maxlength="30" onblur="return  VerifAlphaMaxCarSpecSansEffCle(this,'Libellé');"/>
	                     </logic:notEqual>
	                  </td>
	                </tr>
	                <tr> 
	                  <td colspan=4> 
	                    <hr>
	                  </td>
	                </tr>
	                <tr align="left"> 
	                  <td class="texteGras">Date deb.initiale : </td>
	                  <td class="texte"> 
	                    <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="adeb" />
							<html:hidden property="adeb"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="adeb" styleClass="input" size="11" maxlength="10" onchange="return VerifierDateIsac(this,'jjmmaaaa');"/>
	                    </logic:notEqual>
	                  </td>
	                  <td class="texteGras">Date fin initiale : </td>
	                  <td class="texte"> 
	                    <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="afin" />
							<html:hidden property="afin"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="afin" styleClass="input" size="11" maxlength="10" onchange="return VerifierDateIsac(this,'jjmmaaaa');"/>
	                    </logic:notEqual>
	                  </td>
	                </tr>
	                <tr align="left"> 
	                  <td class="texteGras">Date deb.révisée : </td>
	                  <td class="texte"> 
	                    <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="ande" />
							<html:hidden property="ande"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="ande" styleClass="input" size="11" maxlength="10" onchange="return VerifierDateIsac(this,'jjmmaaaa');"/>
	                    </logic:notEqual>
	                  </td>
	                  <td class="texteGras">Date fin révisée : </td>
	                  <td class="texte"> 
	                  	 <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="anfi" />
							<html:hidden property="anfi"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="anfi" styleClass="input" size="11" maxlength="10" onchange="return VerifierDateIsac(this,'jjmmaaaa');"/>
	                    </logic:notEqual>
	                  </td>
	                </tr>
	                <tr align="left"> 
	                  <td class="texteGras">Statut : </td>
	                  <td class="texte">
	                    <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="asta" />
							<html:hidden property="asta"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="asta" styleClass="input" size="3" maxlength="2" /> 
	                    </logic:notEqual>
	                  </td>
	                  <td class="texteGras">Durée de la sous-tâche :</td>
	                  <td class="texte">
	                    <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="adur" />
							<html:hidden property="adur"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="adur" styleClass="input" size="5" maxlength="5" />
	                    </logic:notEqual>
	                  </td>
	                </tr>
	                <tr align="left"> 
	                  <td class="texteGras">Paramètre Local : </td>
	                  <td class="texte">
	                    <logic:equal name="sousTacheForm"  property="mode" value="delete"> 
	                    	<bean:write name="sousTacheForm"  property="paramLocal" />
							<html:hidden property="paramLocal"/>
	                	</logic:equal>
	                    <logic:notEqual name="sousTacheForm"  property="mode" value="delete">
	                    	<html:text property="paramLocal" styleClass="input" size="5" maxlength="5" /> 
	                    </logic:notEqual>
	                  </td>
	                  <td>&nbsp;</td>
	                  <td>&nbsp;</td>
	                </tr>
					 <tr>
	                  <td colspan="4">&nbsp;</td>
	                </tr>
	                <tr>
	                  <td colspan="4">&nbsp;</td>
	                </tr>
	                <tr> 
	                  <td colspan="4">&nbsp;</td>
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
	                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', this.form.mode.value, false);"/> 
	                  </div>
	                </td>
	                <td width="25%">&nbsp;</td>
	              </tr>
	            </table>
	            <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable --> 
	            </div>
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
</div>
<div id="bottomContainer">
	<div>&nbsp;</div>
</div>
</div>
</body>
</html:html>
<% 
Integer id_webo_page = new Integer("6003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = sousTacheForm ;
%>
<%@ include file="/incWebo.jsp" %>
<!-- #EndTemplate -->
