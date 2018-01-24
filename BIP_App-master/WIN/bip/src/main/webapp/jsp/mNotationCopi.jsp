<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,java.text.SimpleDateFormat,org.apache.struts.util.LabelValueBean,java.util.ArrayList,java.util.Date,com.socgen.bip.commun.liste.ListeOption"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="notationDpcopiForm" scope="request" class="com.socgen.bip.form.NotationDpcopiForm" />

<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<%
   
	
	String valeurARenseigner = "--   A RENSEIGNER     ---";
	java.util.Hashtable hP = new java.util.Hashtable();
	hP.put("userid", ((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	java.util.ArrayList list1= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copiaxesstrategiques",notationDpcopiForm.getHParams());
	pageContext.setAttribute("listeAxesStrategiques", list1);
	
	java.util.ArrayList list2= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copietapes",notationDpcopiForm.getHParams());
	pageContext.setAttribute("listeEtapes", list2);
	
	java.util.ArrayList list3= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("bloc_actif_npsi",notationDpcopiForm.getHParams());
	 list3.add(0,new ListeOption("---", "      " ));
	pageContext.setAttribute("listeBlocsActifs", list3);
	
	
	java.util.ArrayList list4= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("domaine_npsi_actif",notationDpcopiForm.getHParams());
	 list4.add(0,new ListeOption("---", "      " ));
	pageContext.setAttribute("listeDomainesActifs", list4);
	
 
    ArrayList listeDirection = listeDynamique.getListeDynamique("direction", notationDpcopiForm.getHParams());
    pageContext.setAttribute("choixDirection", listeDirection);
    
  
    
%>

<!-- #BeginEditable "doctitle" --> 
<title>Filtre Maj</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/mBudgetCopiCreation.jsp"/>  

<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">

 

<script language="JavaScript">

 


var blnVerification = true;

var pageAide = "<%= sPageAide %>";
var rafraichiEnCours = false;


function MessageInitial()
{
 
   var Message="<bean:write filter="false"  name="notationDpcopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="notationDpcopiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  
  
    
}
 

function ValiderEcran(form)
{  

   if(document.forms[0].action.mode.value == 'delete' )  {
   
		var reponse = confirm("Etes vous sûr de vouloir supprimer cette Notification de DP COPI ?")
			if (reponse){
				  return true;
			}
			else{
				  return false;
			}
	}
	
   return true;
} 
 
 


function Supprimer()
{   
 
			
    document.forms[0].action.value = 'valider';	  
    document.forms[0].mode.value = 'delete';	  
 
}  
 
 
 

function Valider()
{  
    if (!ChampObligatoire(document.forms[0].etape, "l'étape du Dossier Projet COPI")) return false;
    if (!ChampObligatoire(document.forms[0].axeStrategique, "l'axe stratégique")) return false;        
    if (document.forms[0].bloc.value == "---")
		{
			alert("Entrez le code du bloc") 
		 return false;
		}
    if (document.forms[0].domaine.value == "---")
		{
			alert("Entrez le code du domaine") 
		 return false;
		}
    if (!ChampObligatoire(document.forms[0].directionRB, "la Direction du responsable bancaire")) return false;
     
    if(document.forms[0].action.value == "creer" ){
 
      document.forms[0].action.value = 'valider';	  
      document.forms[0].mode.value = 'insert';	  
    }
    if(document.forms[0].action.value == "modifier" ){
     
      document.forms[0].action.value = 'valider';	  
      document.forms[0].mode.value = 'update';	  
    }
    
 
} 

function Retour()
{
	document.forms[0].action.value = 'annuler';	   
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Notification Dossier Projet COPI<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td align="center">
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/notationDpcopi"  onsubmit="return ValiderEcran(this);" ><!-- #EndEditable -->
		  <!--  div align="center"><!-- #BeginEditable "contenu" -->
		  
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            <html:hidden  name="notationDpcopiForm" property="action"  />
            <html:hidden  name="notationDpcopiForm" property="mode" />
            
<html:hidden property="arborescence" value="<%= arborescence %>"/> 
              <html:hidden  name="notationDpcopiForm" property="type" value="creation"/>               
              <html:hidden  name="notationDpcopiForm" property="flaglock"  />               
              
			<table border="0" align="center"  cellpadding="2" cellspacing="2"  >
          
            <tr>        
                 <td width="10%">&nbsp;</td>
                  <td width="15%">&nbsp;</td>
                  <td>&nbsp;</td>
            </tr> 
             
           <!----------------  DP COPI en modification/création  ----------------------->     
           <tr width="100%"> 
                   <td width="10%">&nbsp;</td>
                  <td width="15%" class="lib"><b>Dossier Projet COPI : &nbsp;&nbsp;</b></td>                                     		
                    <td><b><bean:write name="notationDpcopiForm" property="dpCopi" /></b></td>
                  <html:hidden  name="notationDpcopiForm" property="dpCopi"/>
           </tr>      
           
          <tr>            
                  <td width="10%">&nbsp;</td>
                  <td width="15%">&nbsp;</td>
                  <td>&nbsp;</td>
           </tr>
             
             
           <!----------------  Etape  -----------------------> 
           <tr width="100%">   
			            <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Etape Actuelle </b></td>   
                  		  <logic:notEqual parameter="action" value="supprimer">               	                 		        				
					          <td>
								 <html:select property="etape"  name="notationDpcopiForm" styleClass="input"  > 
								    <html:options  collection="listeEtapes" property="cle" labelProperty="libelle" />
								 </html:select>  
							  </td>  
						  </logic:notEqual>
						  <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					         <td><%= notationDpcopiForm.getLibelleEtape() %></td>   
						   </logic:equal>
		  </tr> 
		   <!----------------  Dir Projet  ----------------------->
           <tr width="100%">   
                          <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Directeur(s) Projet </b></td>                  	                 		        				
                  		  <logic:notEqual parameter="action" value="supprimer">
					          <td><html:text name="notationDpcopiForm" property="directeurProjet" styleClass="input" size="50" maxlength="100" onchange="return VerifierAlphanum(this);"/></td>  
				          </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					          <td><bean:write name="notationDpcopiForm" property="directeurProjet" />  </td>   
						   </logic:equal>
		  </tr>
		   <!----------------  Responsable Bancaire  ----------------------->
           <tr width="100%">   
                          <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Responsable(s) Bancaire(s) </b></td>                  	                 		        				
                  		  <logic:notEqual parameter="action" value="supprimer">
				          <td><html:text name="notationDpcopiForm" property="responsableBancaire" styleClass="input" size="50" maxlength="100" onchange="return VerifierAlphanum(this);"/></td>  
				          </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					          <td><bean:write name="notationDpcopiForm" property="responsableBancaire" />  </td>   
						   </logic:equal>
		  </tr>
		   <!----------------  Sponsors  ----------------------->
           <tr width="100%">   
            			  <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Sponsor(s) </b></td>                  	                 		        				
                  		  <logic:notEqual parameter="action" value="supprimer">
				          <td><html:text name="notationDpcopiForm" property="sponsors" styleClass="input" size="50" maxlength="100" onchange="return VerifierAlphanum(this);"/></td>  
				           </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					          <td><bean:write name="notationDpcopiForm" property="sponsors" />  </td>   
						   </logic:equal>
		  </tr>			
           <!----------------  Axe Stratégique  ----------------------->
             <tr width="100%">   
                    <td width="10%">&nbsp;</td>
                  	<td   width="25%" class="lib"><b>Axe Stratégique : &nbsp </b></td> 
                  	 <logic:notEqual parameter="action" value="supprimer">
				       <td> 
					   <html:select property="axeStrategique" name="notationDpcopiForm" styleClass="input"  > 
					         <html:options collection="listeAxesStrategiques" property="cle" labelProperty="libelle" />
					   </html:select>
					   </td>  
						 </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					         <td><%=notationDpcopiForm.getLibelleAxe()%></td>  
  			  			 </logic:equal>
			     </tr>	 
            <!----------------  Bloc   -----------------------> 
             <tr width="100%">   
                    <td width="10%">&nbsp;</td>
                  	<td  width="25%" class="lib"><b>Bloc : &nbsp </b></td> 
                  	<logic:notEqual parameter="action" value="supprimer">
				    <td  > 
					   <html:select property="bloc" name="notationDpcopiForm" styleClass="input"  > 
					         <html:options collection="listeBlocsActifs" property="cle" labelProperty="libelle" />
					   </html:select>
					</td>  
					</logic:notEqual>
				    <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					 <td><%=notationDpcopiForm.getLibelleBloc()%></td>  
	  			   </logic:equal>
			 </tr>	        
    		<!----------------  Domaine ----------------------->
               <tr width="100%">   
                   <td width="10%">&nbsp;</td>
                  	<td align=left width="25%" class="lib"><b>Domaine : &nbsp </b></td> 
                  	<logic:notEqual parameter="action" value="supprimer">
				    <td width= > 
					   <html:select property="domaine" name="notationDpcopiForm" styleClass="input"  > 
					         <html:options collection="listeDomainesActifs" property="cle" labelProperty="libelle" />
					   </html:select>
					</td>  
					</logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					         <td><%= notationDpcopiForm.getLibelleDomaine() %></td>
	  			   </logic:equal>
			     </tr>
           <!----------------  Direction Bancaire  ----------------------->
               <tr width="100%">   
                    <td width="10%">&nbsp;</td>
                  	<td align=left width="25%" class="lib"><b>Direction Responsable Bancaire : &nbsp </b></td> 
                  	<logic:notEqual parameter="action" value="supprimer">
				    <td  > 
					   <html:select property="directionRB" name="notationDpcopiForm" styleClass="input"  > 
					         <html:options collection="choixDirection" property="cle" labelProperty="libelle" />
					   </html:select>
					</td>  
					</logic:notEqual>
				       <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					    <td><%=  ((ListeOption) listeDirection.get(Integer.parseInt(notationDpcopiForm.getDirectionRB()))).getLibelle()   %></td>
	  			   </logic:equal>
			   </tr>
           <!----------------  Note Stratégique  ----------------------->
           <tr width="100%">   
                          <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Note Stratégique </b></td>                  	                 		        				
                  		  <logic:notEqual parameter="action" value="supprimer">
				          <td><html:text name="notationDpcopiForm" property="noteStrategique" styleClass="input" size="10" maxlength="10" onchange="return VerifierNum(this,10,0);"/></td>  
				          </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					      <td><bean:write name="notationDpcopiForm" property="noteStrategique" />  </td>   
   	  			          </logic:equal>
		   </tr>	
		   <!----------------  Note ROI  ----------------------->
           <tr width="100%">   
                          <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Note ROI </b></td>                  	                 		        				
                  		   <logic:notEqual parameter="action" value="supprimer">
				          <td><html:text name="notationDpcopiForm" property="noteRoi" styleClass="input" size="10" maxlength="10" onchange="return VerifierNum(this,10,0);"/></td>  
				           </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					      <td><bean:write name="notationDpcopiForm" property="noteRoi" />  </td>   
   	  			          </logic:equal>
		   </tr>			
            <!----------------  Prochain COPI  ----------------------->
           <tr width="100%">   
                          <td width="10%">&nbsp;</td>
                  		  <td width="25%" class="lib"><b>Prochain COPI </b></td>              	                 		        				
                  		   <logic:notEqual parameter="action" value="supprimer">
				          <td><html:text name="notationDpcopiForm" property="prochainCopi" styleClass="input" size="10" maxlength="10" onchange="return VerifierDate(this,'jj/mm/aaaa');"/></td>  
				          </logic:notEqual>
				          <logic:equal parameter="action" value="supprimer"> 						                  	                 		        				
					      <td><bean:write name="notationDpcopiForm" property="prochainCopi" />  </td>   
   	  			          </logic:equal>
		   </tr>	
					 
                <tr> 
                  <td width="10%">&nbsp;</td> 
                  <td align=center>&nbsp;</td>
                  <td>&nbsp;</td> 
                </tr>
        </table>
			  <!-- #EndEditable </div-->
            
		</td>
		</tr>
		<tr>
		<td align="center">

		<table width="100%" border="0">
		
                <tr> 
                
                  <td width="15%">&nbsp;</td>
                  
                  
                  <logic:notEqual parameter="action" value="supprimer">
				  <td width="30%">
				     <table width="100%">
				        <tr>
				          <td> <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Valider();"/> </td>
				          <td width="30%"></td>
				          <td><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Retour();"/></td>
				        </tr>
				     </table>                  	                          
                  </td>
                  </logic:notEqual>
                  
                  
				  <logic:equal parameter="action" value="supprimer">
				   <td width="30%">
				      <table width="100%">
				         <tr>
				            <td><html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Supprimer();"/> </td>
				            <td width="30%"></td>
				            <td><html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Retour();"/></td>
				         </tr>
				      </table>			                  	                 		        									
				   </td>
   	  			  </logic:equal>
                  

                  <td></td>
				  
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
        
 