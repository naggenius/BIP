<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.text.SimpleDateFormat,org.apache.struts.util.LabelValueBean,java.util.ArrayList,java.util.Date,com.socgen.bip.commun.liste.ListeOption"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="budgetCopiForm" scope="request" class="com.socgen.bip.form.BudgetCopiForm" />

<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<%

	String valeurARenseigner = "--   A RENSEIGNER     ---";
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
//	hP.put("dpcopi", ""+budgetCopiForm.getDpcopi());
//	hP.put("annee", ""+budgetCopiForm.getAnnee());
//	hP.put("datecopi", ""+budgetCopiForm.getDatecopi());
//	hP.put("metier", ""+budgetCopiForm.getMetier());
	
	
	
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
 

	String Titre = null;
	

		Titre = " Modification ou Suppression d'un budget COPI unitaire ";
		
		java.util.ArrayList list1= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("anneebud",budgetCopiForm.getHParams());
		pageContext.setAttribute("listeAnneeBud", list1); 
		java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("datescopibudget",budgetCopiForm.getHParams());
		pageContext.setAttribute("listeDatesCopi", list2);
		java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("metierscoutskebud",budgetCopiForm.getHParams());
		pageContext.setAttribute("listeMetiers", list3);
		java.util.ArrayList list5 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fourcopibud",budgetCopiForm.getHParams());
		pageContext.setAttribute("listeFourCopi", list5);
	 
	

 
%>

<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mBudgetCopi.jsp"/>  

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
 


<script language="JavaScript">

 


var blnVerification = true;

var pageAide = "<%= sPageAide %>"; 
var rafraichiEnCours = false;


function MessageInitial()
{
  
   var Message="<bean:write filter="false"  name="budgetCopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budgetCopiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   
   
  
    
}
 

function ValiderEcran(form)
{ 
     
	if ( !ChampObligatoire(document.forms[0].dpcopi ,"le code Dossier Projet COPI")) { 
		 return false;
	} 
	if ( !ChampObligatoire(document.forms[0].fournisseurCopi ,"le code Fournisseur COPI")) { 
		 return false;
	} 
	
   if(document.forms[0].action.mode == "delete" )  {
   
		var reponse = confirm("Etes vous s�r de vouloir supprimer ce Budget COPI ?")
			if (reponse){
				  return true;
			}
			else{
				  return false;
			}
	}
	
   return true;
} 
 

function Verifier( action )
{ 
    document.forms[0].action.value = action;	  
} 

function Supression(){ 
  document.forms[0].action.value = "valider";
  document.forms[0].action.mode = "delete"; 
}
  
function rechercheDPCopi(){
		window.open("/recupDPCopi.do?action=initialiser&type=modifsupp&nomChampDestinataire=dpcopi&rafraichir=OUI&windowTitle=Recherche Code Dossier Projet COPI"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	
	return ;
}  

function nextFocusLoupeDpcopi(){
document.forms[0].dpcopi.focus();
}

function rechercheID(){
	window.open("/recupIdFourCopi.do?action=initialiser&nomChampDestinataire=fournisseurCopi&windowTitle=Recherche Identifiant Code Fournisseur COPI&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=650, height=550") ;
	return ;
}  

function raffraichiListe(){
 
	document.forms[0].action.value = "suite";
	
	 document.forms[0].submit();
}



function VerifierDPCOPI(champ)
{
	if (VerifierAlphanum(champ)) 
	{
	  document.forms[0].action.value="suite"; 
	 document.forms[0].submit();
	}	
}

 
</script>
<!-- #EndEditable -->  
	<!-- window.open("/recupDPCopi.do?action=initialiser&nomChampDestinataire=dpcopi&windowTitle=Recherche Code DP COPI&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ; -->

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
              <%=tb.printHtml()%> <!-- #EndEditable --></div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%= Titre %><!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/BudgetCopi"  onsubmit="return ValiderEcran(this);" ><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden  name="budgetCopiForm" property="action" value="creer"/>
            <html:hidden  name="budgetCopiForm" property="mode" value="delete"/>  
            <html:hidden  name="budgetCopiForm" property="type" value="modifsupp"/>
            
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
			<table border="0"  cellpadding="2" cellspacing="2" class="tableBleu">
                
                <tr> 
                  <td align=center >&nbsp;</td>
                  <td >&nbsp;</td>
                </tr>
                <tr> 
                  <td >&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                       
            <!-- --------------------  champ DP COPI  -------------------- -->
            
            <tr width="100%" > 
	              <td align=center width="20%"></td>
                  <td align=left width="20%"><b>Dossier Projet COPI: &nbsp </b></td>  
	    		  <td width="20%"> 
                     <html:text name="budgetCopiForm" property="dpcopi" styleClass="input" size="8" maxlength="6" onChange="VerifierDPCOPI(this)" />
                      	<a href="javascript:rechercheDPCopi();"><img border=0 src="/images/p_zoom_blue.gif" alt="Rechercher Dossier Projet COPI" title="Rechercher Dossier Projet COPI" align="absbottom"></a>
				</td> 
				 <td>&nbsp;</td>
				
           </tr>
           
           
           				<!----------------  Ann�e  ----------------------->
               <tr width="100%">  
               	          <td align=center width="20%"></td>
                  		  <td align=left width="20%"><b>Ann�e : &nbsp </b></td> 
	    		         <td width="20%">
						 	<html:select property="annee"  name="budgetCopiForm" styleClass="input" onChange="raffraichiListe();"> 
						 	 <bip:options collection="listeAnneeBud" /> 
					 			<!--  html:options collection="listeAnneeBud" property="cle" labelProperty="libelle" /-->
					       	</html:select> 
						  </td>  
						     <td>&nbsp;</td>
						  
			     </tr>
					
               			<!----------------  DateCopi  ----------------------->
               <tr width="100%">  
               	          <td align=center width="20%"></td>
                  		  <td align=left width="20%"><b>Date COPI: &nbsp </b></td>           				
				            <td width="20%"> 
					                       <html:select property="datecopi" name="budgetCopiForm" styleClass="input"  onChange="raffraichiListe();"  > 
					                          <html:options collection="listeDatesCopi" property="cle" labelProperty="libelle" />
					                      </html:select>
						    </td>  
						  <td>&nbsp;</td>
			     </tr>	 
                  
    
           
           
           
					
						<!----------------  Metier  ----------------------->
               <tr width="100%">  
               	          <td align=center width="20%"></td>
                  		  <td align=left width="20%"><b>M�tier : &nbsp </b></td>   
	    		     			<td width="10%"> 
					                       <html:select property="metier" name="budgetCopiForm" styleClass="input"  onChange="raffraichiListe();"    > 
					                          <html:options collection="listeMetiers" property="cle" labelProperty="libelle" />
					                      </html:select>
								</td>  
								<td>&nbsp;</td>
						  
			     </tr>	
				
				               
				<!----------------  Fournisseur  ----------------------->
               <tr width="100%">  
               	          <td align=center width="20%"></td>
                  		  <td align=left width="20%"><b>Fournisseur : &nbsp </b></td>   
				           <td width="10%"> 
					                       <html:select property="fournisseurCopi" name="budgetCopiForm" styleClass="input"     > 
					                          <html:options collection="listeFourCopi" property="cle" labelProperty="libelle" />
					                      </html:select>
					     </td>  
							<td>&nbsp;</td>
						
			     </tr>	
				
											
								
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td>
                </tr>
                <tr> 
                  <td align=center>&nbsp;</td>
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
	    		   <td width="25%" align="center">&nbsp;</td>  
				   <td width="25%" align="center">  
     				 <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier('modifier');"/>
                  </td>
				   <td width="25%" align="center">  
					<html:submit property="boutonSupprimer" value="Supprimer" styleClass="input" onclick="Verifier('supprimer');"/>
                  </td>
                  <td width="25%" align="center">&nbsp;</td>   
                </tr>
            
            </table>
            
            
		
			  <!-- #BeginEditable "fin_form" --></html:form><!-- #EndEditable -->
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
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
</html:html> 

<!-- #EndTemplate -->        
        
 