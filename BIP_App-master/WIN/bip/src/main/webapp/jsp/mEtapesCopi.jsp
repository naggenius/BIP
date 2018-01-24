<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>

<jsp:useBean id="listeNotificationCopiForm" scope="request" class="com.socgen.bip.form.ListeNotificationCopiForm" />
<html:html locale="true">
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_maj.dwt" --> 
<head>
 

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>
 <!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable --> 
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 

<bip:VerifUser page="jsp/mBudgetCopiCreation.jsp"/>

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;

<%

	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	java.util.ArrayList list1= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copiaxesstrategiques",hP);
	pageContext.setAttribute("listeAxesStrategiques", list1);
	ListeOption liste0 = new ListeOption(" "," ") ;
	list1.add(0,liste0) ; 
	
%>

var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   
   var Message="<bean:write filter="false"  name="listeNotificationCopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="listeNotificationCopiForm"  property="focus" />";
     
   if (Message != "") {
      alert(Message);
   }
   
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value != 'delete')
     {
     if(document.forms[0].libelle){
	   document.forms[0].libelle.focus();
     }
   }
   
 
     
   
}

function Verifier(form , action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}


function codeDejaExistantDansListe(){

var valeurEntreeCode  = document.forms[0].code.value ;
<% String cle ; 
   boolean existe = false ; 
   for (int i = 0 ; i < list1.size() ; i ++ ) { 
	   cle = ((ListeOption) list1.get(i)).getCle() ; %> 
		   if(valeurEntreeCode == "<%=cle%>"){
		      return true ; 
		   }	   
	 <%}%> 
	 return false; 
}

function ValiderEcran(form)
{

   
   if (blnVerification) { 
  		
  	
  	if(form.mode.value == 'insert'){
     if(codeDejaExistantDansListe()){
      alert("Le code que vous avez entré existe déjà dans la liste , veuillez en saisir un autre !") ;
      return false ; 
     }   
   }
   
    if(form.mode.value == 'update'){
     if(codeDejaExistantDansListe() == false){
      alert("Le code que vous voulez modifier n'existe pas !") ;
      return false ; 
     }   
   }
   
  		
  	if (form.mode.value == 'delete') { 
	   
	   if ( !ChampObligatoirePersonnalise(document.forms[0].codePourSupprimer ,"Veuillez sélectionner un Axe Stratégique !")) { 
		 	return false;
		} 
		else{
			if (!confirm("Voulez-vous supprimer cet Axe Stratégique ?")) 
			return false;
		} 		
	}
    else {
    
     
	   if (!ListeObligatoire(form.libelle,"le libellé de l'Axe Stratégique")) return false;
	       	  
	  if (!ListeObligatoire(form.code,"le code de l'Axe Stratégique")) return false;
	  	        	  
            
	   if (form.mode.value == 'update') {
		   if (!confirm("Voulez-vous modifier cet Axe Stratégique ?")) return false;
		}
		
	}
   }

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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->
          <bean:write name="listeNotificationCopiForm" property="titrePage"/>Créer / Modifier / supprimer un Axe Stratégique<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/axeStrategiqueCopi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage" name="listeNotificationCopiForm"/>
              <html:hidden property="action" name="listeNotificationCopiForm" />
              <html:hidden property="mode" name="listeNotificationCopiForm"/>
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
              
                <tr>                 
                <td colspan="4">&nbsp;</td>                 
                </tr>
 
                
                <tr> 
                 <td align="center" width="100%" colspan="4">
                 
                    <table align="center">
                      <tr>
                          <td class="lib" align="center"><b>Axes Stratégiques<BR>existants :</b></td>
                          <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                    	  <td  align="left" colspan="2"> 
                    	   <table border="0"  bgcolor="#ddddff" align="left">
                    	      <tr> 
                    	        <td> 
                    	         <html:select property="codePourSupprimer" styleClass="input"  size="30" > 
		   					       <html:options collection="listeAxesStrategiques" property="cle" labelProperty="libelle"/>
						      	  </html:select>	
						        </td>
                    	         <td>
                    			 	 <html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier(this.form,  'valider', 'delete' , true);"/>                        	          	
                    	         </td>
                    	      </tr>
                    	   </table> 
                    	   
				          </td>
                      </tr>
                      
                      <tr>
            			<td width="100%" colspan="4" class="contenu">Pour supprimer un axe Stratégique , veuillez d'abord le selectionner dans la liste et cliquer ensuite sur le bouton supprimer</td>           
          	   		  </tr>   
          	   		  
                      
                      <tr> 
                       <td colspan="4">&nbsp;</td>
                      </tr>
                      
                      <tr>
                        <td class="lib"><b>Saisir Axe Stratégique :</b></td>
                      	<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                      	 <td>
                      	    <table border="0" bgcolor="#ddddff">
                      	      <tr>
	                      	      <td class="contenu">Code :</td>
    		                    <td><html:text property="code" name="listeNotificationCopiForm" styleClass="input" size="2" maxlength="2" onchange="return VerifierNum(this,2,0);"/></td>
            		          	<td class="contenu">&nbsp;&nbsp;Libellé :</td>
                    		  	<td><html:text property="libelle" name="listeNotificationCopiForm" styleClass="input" size="50" maxlength="50" onchange="return VerifierAlphaNum(this);"/></td>                      	
                      			<td align="left"><html:submit property="boutonCreer" value="Cr&#233er" styleClass="input" onclick="Verifier(this.form , 'valider', 'insert' , true);"/></td>
                      			<td align="left"><html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form , 'valider', 'update' , true);"/></td>
                      	      </tr>
                      	    </table>
                      	 </td>                      	
                      	<td></td>
                      </tr> 
                      <tr>
                       
                       	 <td colspan="4"></td>
                       	
                      </tr>     
                                 
                    </table>
                 </td>
                </tr>
                
                
               
               
          
                  
               
                  
                  
                <tr> 
                  <td colspan=2>&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                  
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
                  <div align="center">  
                  </div>
                </td>
                <td width="25%"> 
                  <div align="center"> 
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
</body></html:html>
<!-- #EndTemplate -->
