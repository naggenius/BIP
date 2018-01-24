 
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

 
	
	//java.util.ArrayList list3 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("fourcopi",hP);
	//list3.add(0,new ListeOption(null,valeurARenseigner));
	//pageContext.setAttribute("listeFourCopi", list3);
	
	java.util.ArrayList list4 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("metier",hP); 
	list4.remove(0);
	pageContext.setAttribute("listeMetiers", list4);
	 
	java.util.ArrayList list5 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copitypedemande",hP);
	//list5.add(0,new ListeOption(null,valeurARenseigner)); 
	pageContext.setAttribute("listeTypeDemandes", list5);
	
	 
	
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
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

function MessageInitial()
{   
   var Message="<bean:write filter="false"  name="budgetCopiForm"  property="msgErreur" />";
   var Focus = "<bean:write name="budgetCopiForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else {
	  document.forms[0].jhArbitresDemandes.focus();
   }
   
}

 
 
 
 

function Verifier(form, action, mode,flag)
{ 
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

function Retour()
{  
   document.forms[0].action.value = "annuler"; 
}

 
 
function Refresh()
{
 document.forms[0].action.value = "refresh";
}

 
function ValiderEcran(form){   
	if (form.mode.value == 'delete') {
	   if (!confirm("Voulez-vous supprimer ce  budget ?")) return false;
	}
    else 
    
    
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
          <logic:equal name="budgetCopiForm" property="mode" value="update">
          	 <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Mise à jour d'un Budget COPI<!-- #EndEditable --></td>
          </logic:equal> 
           <logic:notEqual name="budgetCopiForm" property="mode" value="update">
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Cr&#233ation d'un Budget COPI<!-- #EndEditable --></td>
          </</logic:notEqual> 
          
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
        
        <tr> 
          <td > </td>
        </tr>
        
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/BudgetCopi"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
              <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="valider"/> 
                <html:hidden name="budgetCopiForm" property="mode" /> 
                <html:hidden property="dpcopi" name="budgetCopiForm"  />
                <html:hidden property="datecopi" name="budgetCopiForm"  />
                <html:hidden property="metier" name="budgetCopiForm"  />
                <html:hidden property="annee" name="budgetCopiForm"  />
                <html:hidden  name="budgetCopiForm" property="type" /> 
                 <html:hidden property="fournisseurCopi" name="budgetCopiForm"  />
            
			<tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
			</tr>  
         
           
	           
	           
	           
			<tr>
				<td>
				 &nbsp; &nbsp; 
				</td>
			</tr>
				             
			<tr>
				<td>
				   &nbsp; &nbsp; 
				</td>
		    </tr>
				             
		 	<tr>
		 	  <td>
		 	  	<table border=0 cellpadding=2 cellspacing=2 class="tableBleu" width="100%">
		 	  	 <tr> 
                   <td class="lib" ><b>Dossier Projet COPI :&nbsp;</b></td> 
                    <td><bean:write property="dpcopi" name="budgetCopiForm"  /></td> 
                    <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                   <td class="lib" ><b>Année :&nbsp;</b></td>
                   <td><bean:write property="annee" name="budgetCopiForm"  /></td> 
                   <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				   <td class="lib" ><b>Date COPI:&nbsp;</b></td>
				   <td><bean:write property="datecopi" name="budgetCopiForm"  /></td>           
				   <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				  <td class="lib" ><b>Métier :&nbsp;</b></td>
				  <td><bean:write property="metier" name="budgetCopiForm"  /></td> 
				  <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				  <td class="lib" ><b>Fournisseur COPI :&nbsp;</b></td>
				  <td><bean:write property="fournisseurCopi" name="budgetCopiForm"  /></td>				  
				</tr>  
		 	  	</table>
		 	  </td>		 	
		 	</tr>
	           
	           	<tr>
				<td>
				 &nbsp; &nbsp; 
				</td>
			</tr>
				             
			<tr>
				<td>
				   &nbsp; &nbsp; 
				</td>
		    </tr>
		      
		       <tr>		 
				 <td>  
				     <table border=0 cellpadding=2 cellspacing=2 class="tableBleu" width="100%">      
				     		     
				     
				               <tr>  
	  			                <td class="lib" align=center ><b>Type de demande :</b></td>
	  			                <td   align=center ></td>
	  			                 <td   align=center ></td>
	  			                 <td   align=center ></td> 
				             </tr>
				             
				             <tr>
				               <logic:notEqual parameter="action" value="supprimer"> 
	  			                <td align=center><html:select property="typeDemande" name="budgetCopiForm" styleClass="input"> 
									                   <html:options collection="listeTypeDemandes" property="cle" labelProperty="libelle" />
									            </html:select></td>
							</logic:notEqual>
							<logic:equal parameter="action" value="supprimer">
							<td align=center>	<bean:write name="budgetCopiForm" property="typeDemande"/> </td>
							</logic:equal>
	  			                <td align=center></td>
	  			                <td align=center></td>
	  			                <td align=center ></td>	  	
				             </tr>			
				             
				              
				             
				            <tr>
				             	<td>
				             	&nbsp; &nbsp; 
				             	</td>
				            </tr>
				             
				      		
				      		
				            <tr>  
	  			                <td class="lib" align=center ><b>JH demandés :</b></td>
	  			                <td class="lib" align=center ><b>JH décidés :</b></td>
	  			                 <td class="lib" align=center ><b>JH Cantonnés demandés:</b></td>
	  			                 <td class="lib" align=center ><b>JH Cantonnés décides:</b></td> 
				             </tr>
				             
				             <tr>
				               <logic:notEqual parameter="action" value="supprimer"> 
	  			                <td align=center><html:text  name="budgetCopiForm" property="jhArbitresDemandes"  styleClass="input" size="6" maxlength="6" onchange="return VerifierNumNegatif(this,5,0);"   /></td>
	  			                <td align=center><html:text name="budgetCopiForm" property="jhArbitresDecides"  styleClass="input" size="6" maxlength="6"  onchange="return VerifierNumNegatif(this,5,0);"   /></td>
	  			                <td align=center><html:text name="budgetCopiForm" property="jhCantonnesDemandes"  styleClass="input" size="6" maxlength="6"  onchange="return VerifierNumNegatif(this,5,0);"   /></td>
	  			                <td align=center ><html:text name="budgetCopiForm" property="jhCantonnesDecides" styleClass="input" size="6" maxlength="6"  onchange="return VerifierNumNegatif(this,5,0);"/></td>	  	
				             	</logic:notEqual>
				            <logic:equal parameter="action" value="supprimer">
	  			                <td align=center><bean:write name="budgetCopiForm" property="jhArbitresDemandes"   /></td>
	  			                <td align=center><bean:write name="budgetCopiForm" property="jhArbitresDecides" /></td>
	  			                <td align=center><bean:write name="budgetCopiForm" property="jhCantonnesDemandes"  /></td>
	  			                <td align=center ><bean:write name="budgetCopiForm" property="jhCantonnesDecides"/></td>	  	
				             	</logic:equal>
				             
				             </tr>				             
				             
				    
				        
				             <tr>
				             	<td>
				             	&nbsp; &nbsp; 
				             	</td>
				             </tr>

				             
				             <tr>  
	   			                 <td class="lib" align=center ><b>KEuro demandés :</b></td>
	   			                 <td class="lib" align=center ><b>KEuro décidés :</b></td>
	  			                 <td class="lib" align=center ><b>KEuro Cantonnés demandés:</b></td>
     			                 <td class="lib" align=center ><b>KEuro Cantonnés décides:</b></td> 
					        </tr> 
					             
				            <tr >
     		  			        <td align=center ><bean:write name="budgetCopiForm" property="keJhArbitresDemandes" /></td>		  			               
		  			            <td align=center><bean:write name="budgetCopiForm" property="keJhArbitresDecides" /></td>		  			                
		  			            <td align=center><bean:write name="budgetCopiForm" property="keJhCantonnesDemandes" /></td>		  			              
		  			            <td align=center ><bean:write name="budgetCopiForm" property="keJhCantonnesDecides" /></td>	  	
				            </tr>
		  			           
		  			      
			  <tr>
				             	<td>
				             	&nbsp; &nbsp; 
				             	</td>
				            </tr>
				            
				             
		  			        <tr>           
		 
		  			               
		  			                <td class="lib" align=center ><b>JH Prévisionnel demandé :</b></td>
		  			            	   <td class="lib" align=center ><b>JH Prévisionnel décidé :</b></td>		                
		  			        <tr>
				             	 <logic:notEqual parameter="action" value="supprimer">     
						        <td align=center><html:text name="budgetCopiForm" property="jhCoutTotal"  styleClass="input"size="6" maxlength="6"  onchange="return VerifierNumNegatif(this,12,2);"  styleClass="input" /></td>		  			                
	 			                 <td align=center><html:text name="budgetCopiForm" property="jhPrevisionnelDecide"  styleClass="input" size="6" maxlength="6"  onchange="return VerifierNumNegatif(this,12,2);"  styleClass="input" /></td>		  			                
	 			                 
	 			                 	</logic:notEqual>
	 			                 		<logic:equal parameter="action" value="supprimer">
							  <td align=center><bean:write name="budgetCopiForm" property="jhCoutTotal" /></td> 
							              <td align=center><bean:write name="budgetCopiForm" property="jhPrevisionnelDecide" /></td>
							  	</logic:equal>	
				            </tr>   

					          <tr>
				             	<td>
				             	&nbsp; &nbsp; 
				             	</td>
				            </tr>
					         <tr>           
		 
		  			             
		  			            
		  			                <td class="lib" align=center ><b>KEuro Prévisionnel demandé:</b></td>
		  			                 <td class="lib" align=center ><b>KEuro Prévisionnel décidé:</b></td>
		  		   	  <tr>
				             	 <td align=center><bean:write name="budgetCopiForm" property="keJhCoutTotal" /></td>		  			                
		  			          	 <td align=center><bean:write name="budgetCopiForm" property="keJhPreviDecide" /></td>     
				            </tr>   
					         <tr>
				             	<td>
				             	&nbsp; &nbsp; 
				             	</td>
				            </tr>
					       
					   
				             
			              </table>
				   </td>
				    
				   
				</tr>              
				 <!-- --------------------  /LISTES INFOS ENTETE  -------------------- -->
				 
				 
				<tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>  
		        <tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>
		     	
  
         
         		<tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>  
		        <tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>
		     	<tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
		     	</tr>
		     	
         
			  <!-- #EndEditable -->
			  
			</div>
            
            
		</td>
		</tr>
		<tr>
		<td align="center">
       <logic:notEqual parameter="action" value="supprimer">     
						     
						          
						          
						        
		<table width="100%" border="0">
			 <tr>  
			        <td width="14%">&nbsp;</td>
	                <td width="14%"> 
	                  <div align="center"><html:submit  property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/> 
	                  </div>
	                </td>
	                 <td width="14%">&nbsp;</td>
	                <td width="14%"> 
	                  <div align="center"> <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Retour();"/> 
	                  </div>
	                </td>
	                 <td width="14%">&nbsp;</td>
	                <td width="14%"> 
	                  <div align="center"> <html:submit property="boutonCalculer" value="Valoriser" styleClass="input" onclick="Refresh();"/> 
	                  </div>
	                </td>
	                <td></td>
              </tr>
        </table>
         </logic:notEqual>
	 	<logic:equal parameter="action" value="supprimer">
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
		</logic:equal>
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