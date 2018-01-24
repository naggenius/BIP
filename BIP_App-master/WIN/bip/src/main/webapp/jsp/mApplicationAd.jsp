<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="applicationForm" scope="request" class="com.socgen.bip.form.ApplicationForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/fmApplicationAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	java.util.ArrayList caDisponibles = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("ca",applicationForm.getHParams()); 
java.util.ArrayList bloc = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("bloc_actif_npsi",applicationForm.getHParams());
pageContext.setAttribute("choixBloc", bloc);

	pageContext.setAttribute("choixCA", caDisponibles);

	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	// Liste déroulante Liens Application / CA
	java.util.ArrayList listeType = new java.util.ArrayList();
	listeType.add(0,new com.socgen.bip.commun.liste.ListeOption("", ""));
	listeType.add(1,new com.socgen.bip.commun.liste.ListeOption("A", "Avec"));
	listeType.add(2,new com.socgen.bip.commun.liste.ListeOption("S", "Sans"));
	pageContext.setAttribute("choixLienCodeApplicationCA", listeType);
	
	// Liste déroulante Type d'activité
	java.util.ArrayList listeTypeActCA = new java.util.ArrayList();
	listeTypeActCA.add(0,new com.socgen.bip.commun.liste.ListeOption("", ""));
	listeTypeActCA.add(1,new com.socgen.bip.commun.liste.ListeOption("EXP", "EXP"));
	listeTypeActCA.add(2,new com.socgen.bip.commun.liste.ListeOption("MAINT", "MAINT"));
	pageContext.setAttribute("choixTypeActiviteCA", listeTypeActCA);
	
%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="applicationForm"  property="msgErreur" />";
   var Focus = "<bean:write name="applicationForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value!="delete"){
	  document.forms[0].alibel.focus();
   }
   if (document.forms[0].mode.value=="insert") {
		document.forms[0].acdareg.value = document.forms[0].airt.value;	
	}
	
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
}
function ValiderEcran(form)
{
  if (blnVerification == true) {
     if (form.alibel && !ChampObligatoire(form.alibel, "le libellé")) return false;
	
     if (form.mode.value== 'update') {
        if (!confirm("Voulez-vous modifier cette application  ?")) return false;
     }
     if (form.mode.value== 'delete') {
        if (!confirm("Voulez-vous supprimer cette application  ?")) return false;
     }
  }
 
   return true;
}

function limite( this_,  max_){
  var Longueur = this_.value.length;

  if ( Longueur > max_){
    this_.value = this_.value.substring( 0, max_);
    Longueur = max_;
   }
  document.getElementById('reste').innerHTML = (max_ - Longueur) +" sur 420 caractères restant";
}

function effacerRetourChariot(champ){
    
    document.forms[0].adescr.value = champ.value.replace(/[\r\n]/g,' ');
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
           <bean:write name="applicationForm" property="titrePage"/> une application <!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/application"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>"> 
            <html:hidden property="action"/>
		    <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		    <html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu" >
                <tr> 
                  <td  >&nbsp;</td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Application :</b></td>
                  <td colspan="4">
                     <b> <bean:write name="applicationForm"  property="airt" /></b> 
                    <html:hidden property="airt"/>
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib" ><b>Libellé :</b></td>
                  <td colspan="4" > 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="alibel" styleClass="input" size="52" maxlength="50" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="alibel" />
                    </logic:equal> 
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Libell&eacute; court :</td>
                  <td colspan="4" > 
                   <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="alibcourt" styleClass="input" size="20" maxlength="20" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="alibcourt" />
                    </logic:equal> 
                  
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Description :</td>
                  <td colspan="4" > 
                  <logic:notEqual parameter="action" value="supprimer">
                   		<html:textarea name="applicationForm" property="adescr" rows="9" cols="69" style="white-space: wrap;"  styleClass="input" onkeyup="limite(this,420);" onchange="effacerRetourChariot(this);" /> 
				</logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<html:textarea name="applicationForm" property="adescr" readonly="true" rows="9" cols="69" style="white-space: wrap;"  styleClass="input" onkeyup="limite( this,  420);" /> 
				</logic:equal> 
                 </td>
				  </tr>
                <tr>
                <td>&nbsp;</td>
                <td><b><div id="reste"></div></b></td> 
                
                            
                <tr> 
                  <td class="lib" >Code MO :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="clicode" styleClass="input" size="5" maxlength="5" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="clicode" />
                    </logic:equal>  
               		&nbsp;&nbsp;<bean:write name="applicationForm"  property="alibmo" />
                   	<html:hidden property="alibmo"/>
                  </td>
                  <!--  <td>&nbsp;</td>  -->
                  <td class="lib">Nom MO :</td>
                  <td>
                     <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="amop" styleClass="input" size="35" maxlength="35" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="amop" />
                    </logic:equal>  
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Code ME :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="codsg" styleClass="input" size="7" maxlength="7" onchange=" return VerifierNum(this,7,0);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codsg" />
                    </logic:equal>  
                	&nbsp;&nbsp;<bean:write name="applicationForm"  property="alibme" />
                   	<html:hidden property="alibme"/> 
                  </td>
                 <!--  <td>&nbsp;</td>  -->
                  <td class="lib">Nom ME :</td>
                  <td > 
                     <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="acme" styleClass="input" size="35" maxlength="35" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="acme" />
                    </logic:equal>  
                   
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Code gestionnaire d'application :</td>
                  <td >
                     <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="codgappli" styleClass="input" size="5" maxlength="5" onchange="return VerifierAlphaMax(this)"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codgappli" />
                    </logic:equal>   
                    &nbsp;&nbsp;<bean:write name="applicationForm"  property="alibgappli" />
                   	<html:hidden property="alibgappli"/> 
                  </td>
                  <!--  <td>&nbsp;</td>  -->
                  <td class="lib">Nom gestionnaire d'application :</td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="agappli" styleClass="input" size="35" maxlength="35" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="agappli" />
                    </logic:equal> 
                    
                  </td>
                </tr>
                <tr> 
                  <td class="lib">Mnémonique :</td>
                  <td >
                     <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="amnemo" styleClass="input" size="20" maxlength="20" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="amnemo" />
                    </logic:equal> 
                    
                  </td>
                  <!--  <td>&nbsp;</td>  -->

                  <td class="lib">Code application de regroupement :</td>
                  <td >
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="acdareg" styleClass="input" size="5" maxlength="5" onchange="return VerifierAlphanum(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="acdareg" />
                    </logic:equal> 
                  </td>
                </tr>
                <tr> 
                  <td class="lib" >Date de fin d'utilisation de l'application :</td>
                  <td> 
                  	<logic:notEqual parameter="action" value="supprimer">
           				<html:text property="datfinapp" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this, 'jj/mm/aaaa');"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="datfinapp" />
                    </logic:equal>                      
                  </td>
                  <td class="lib" >Lien NPSI (Bloc) :</td>
                  <td colspan="4"> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="bloc" styleClass="input"> 
   						<html:options collection="choixBloc" property="cle" labelProperty="libelle" />
					  </html:select>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="lib_bloc" />
                    	
                    </logic:equal>                   
                  </td>
                </tr>    
				<tr> 
                  <td class="lib" >Liens code Application/CA :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="licodapca" styleClass="input" > 
								<bip:options collection="choixLienCodeApplicationCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="licodapca" />
                  		<html:hidden property="licodapca"/>                    
                    </logic:equal>                 
                  </td>
                </tr> 
<!-- Début Données CA 1 -->
                <tr> 
                  <td class="lib" >Code CA1 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo1" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo1" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca1" />
						<html:hidden property="codcamo1"/>
                    </logic:equal> 
                  </td>
                  
                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca1" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca1" />
                  		<html:hidden property="typactca1"/>                    
                    </logic:equal>                 
                  </td>
               
                </tr>				

     			<tr> 
                  <td class="lib" >Responsable de la validation du lien CA1 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval1" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval1" />
                    </logic:equal>   					 
                  </td>
                  
                 <!--  <td width="30">
                  	&nbsp;
				  </td>-->

                  <td class="lib" >Date de validité du lien CA1 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli1" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli1" />
						<html:hidden property="datvalli1"/>
 					</logic:notEqual>
                  </td>  
                          
                </tr>				
<!-- Fin Données CA 1 -->
<!-- Début Données CA 2 -->
                <tr> 

                  <td class="lib" >Code CA2 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo2" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo2" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca2" />
						<html:hidden property="codcamo2"/>
                    </logic:equal> 
                  </td>
                  
                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca2" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca2" />
                  		<html:hidden property="typactca2"/>                    
                    </logic:equal>                 
                  </td>
                                
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA2 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval2" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval2" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA2 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli2" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli2" />
						<html:hidden property="datvalli2"/>
 					</logic:notEqual>
                  </td>   
                                    
                </tr>				
<!-- Fin Données CA 2 -->
<!-- Début Données CA 3 -->
                <tr> 
                
                  <td class="lib" >Code CA3 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo3" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo3" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca3" />
						<html:hidden property="codcamo3"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca3" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca3" />
                  		<html:hidden property="typactca3"/>                    
                    </logic:equal>                 
                  </td>
                 
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA3 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval3" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval3" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA3 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli3" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli3" />
						<html:hidden property="datvalli3"/>
 					</logic:notEqual>
                  </td> 
                                   
                </tr>				
<!-- Fin Données CA 3 -->
<!-- Début Données CA 4 -->
                <tr> 
                
                  <td class="lib" >Code CA4 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo4" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo4" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca4" />
						<html:hidden property="codcamo4"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca4" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca4" />
                  		<html:hidden property="typactca4"/>                    
                    </logic:equal>                 
                  </td>
            
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA4 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval4" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval4" />
                    </logic:equal>   					 
                  </td>

                  <td class="lib" >Date de validité du lien CA4 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli4" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli4" />
						<html:hidden property="datvalli4"/>
 					</logic:notEqual>
                  </td>                       
                  
                </tr>				
<!-- Fin Données CA 4 -->
<!-- Début Données CA 5 -->
                <tr> 
                  <td class="lib" >Code CA5 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo5" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo5" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca5" />
						<html:hidden property="codcamo5"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca5" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca5" />
                  		<html:hidden property="typactca5"/>                    
                    </logic:equal>                 
                  </td>
               
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA5 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval5" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval5" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA5 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli5" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli5" />
						<html:hidden property="datvalli5"/>
 					</logic:notEqual>
                  </td>                    
                  
                </tr>				
<!-- Fin Données CA 5 -->
<!-- Début Données CA 6 -->
                <tr> 
                  <td class="lib" >Code CA6 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo6" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo6" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca6" />
						<html:hidden property="codcamo6"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca6" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca6" />
                  		<html:hidden property="typactca6"/>                    
                    </logic:equal>                 
                  </td>
                
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA6 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval6" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval6" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA6 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli6" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli6" />
						<html:hidden property="datvalli6"/>
 					</logic:notEqual>
                  </td>                   
                  
                </tr>				
<!-- Fin Données CA 6 -->
<!-- Début Données CA 7 -->
                <tr> 
                
                  <td class="lib" >Code CA7 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo7" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo7" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca7" />
						<html:hidden property="codcamo7"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca7" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca7" />
                  		<html:hidden property="typactca7"/>                    
                    </logic:equal>                 
                  </td>
                 
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA7 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval7" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval7" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA7 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli7" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli7" />
						<html:hidden property="datvalli7"/>
 					</logic:notEqual>
                  </td>                  
                 
                </tr>				
<!-- Fin Données CA 7 -->
<!-- Début Données CA 8 -->
                <tr> 
                
                  <td class="lib" >Code CA8 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo8" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo8" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca8" />
						<html:hidden property="codcamo8"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca8" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca8" />
                  		<html:hidden property="typactca8"/>                    
                    </logic:equal>                 
                  </td>
               
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA8 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval8" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval8" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA8 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli8" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli8" />
						<html:hidden property="datvalli8"/>
 					</logic:notEqual>
                  </td>                     
                  
                </tr>				
<!-- Fin Données CA 8 -->
<!-- Début Données CA 9 -->
                <tr> 
                
                  <td class="lib" >Code CA9 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo9" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo9" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca9" />
						<html:hidden property="codcamo9"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca9" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca9" />
                  		<html:hidden property="typactca9"/>                    
                    </logic:equal>                 
                  </td>
                
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA9 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval9" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval9" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA9 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli9" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli9" />
						<html:hidden property="datvalli9"/>
 					</logic:notEqual>
                  </td> 
                  
                </tr>				
<!-- Fin Données CA 9 -->
<!-- Début Données CA 10 -->
                <tr> 
                
                  <td class="lib" >Code CA10 :</td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                   	  <html:select property="codcamo10" styleClass="input"> 
   						<html:options collection="choixCA" property="cle" labelProperty="libelle" />
					  </html:select>					 
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="codcamo10" />
                    	&nbsp;&nbsp;<bean:write name="applicationForm"  property="clibca10" />
						<html:hidden property="codcamo10"/>
                    </logic:equal> 
                  </td>

                  <td class="lib" >Type d'activité :</td>
                  <td> 
				    <logic:notEqual parameter="action" value="supprimer">
                  		<html:select property="typactca10" styleClass="input" > 
								<bip:options collection="choixTypeActiviteCA" />
                           </html:select>
                     </logic:notEqual>
                     <logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="typactca10" />
                  		<html:hidden property="typactca10"/>                    
                    </logic:equal>                 
                  </td>
                   
                </tr>				

     			<tr> 
     			
                  <td class="lib" >Responsable de la validation du lien CA10 :</td>
                  <td>
                    <logic:notEqual parameter="action" value="supprimer">
                   		<html:text property="respval10" styleClass="input" size="40" maxlength="40" onchange="return VerifierAlphaMax(this);"/>
                    </logic:notEqual>
                    <logic:equal parameter="action" value="supprimer">
                    	<bean:write name="applicationForm"  property="respval10" />
                    </logic:equal>   					 
                  </td>
                  
                  <td class="lib" >Date de validité du lien CA10 :</td>
				  <td>
 					<logic:equal parameter="action" value="supprimer">
                  		<bean:write name="applicationForm"  property="datvalli10" />
                  	</logic:equal> 
                   	<logic:notEqual parameter="action" value="supprimer">             
                   		<bean:write name="applicationForm"  property="datvalli10" />
						<html:hidden property="datvalli10"/>
 					</logic:notEqual>
                  </td>                   
                  
                </tr>				
<!-- Fin Données CA 10 -->				                
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
Integer id_webo_page = new Integer("1025"); 
com.socgen.bip.commun.form.AutomateForm formWebo = applicationForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html>
<!-- #EndTemplate -->
