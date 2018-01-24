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
 	
	java.util.ArrayList list2 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("datescopi",hP);
	list2.add(0,new ListeOption(null,valeurARenseigner));
	pageContext.setAttribute("listeDatesCopi", list2);
	
 
	
	java.util.ArrayList list4 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("metier",hP);
	list4.set(0,new ListeOption(null,valeurARenseigner)); 
	pageContext.setAttribute("listeMetiers", list4);
	 
	java.util.ArrayList list5 = new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("copitypedemande",hP);
	list5.add(0,new ListeOption(null,valeurARenseigner)); 
	pageContext.setAttribute("listeTypeDemandes", list5);
	
	
	
	
	
	int anneeEnCours= Integer.valueOf((new SimpleDateFormat("yyyy")).format(new Date()));
	anneeEnCours = anneeEnCours-2;
	ArrayList<LabelValueBean> liste = new ArrayList<LabelValueBean>(); 
	liste.add(0,new  LabelValueBean(valeurARenseigner,""));
	for(int i=0;i<6;i++){
		liste.add(new LabelValueBean(String.valueOf(anneeEnCours) ,  String.valueOf(anneeEnCours) )) ;
		anneeEnCours = anneeEnCours + 1 ;
	}
	pageContext.setAttribute("listeDesannees", liste);
	
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
	  document.forms[0].dpCopi.focus();
   }
 
   if (document.forms[0].action.value=="creer"){
    
	    //Initialisation des DPG et des couts 
	    	document.forms[0].jhArbitresDemandes.value ='0,00';
	    	document.forms[0].jhArbitresDecides.value='0,00';
	    	document.forms[0].jhCantonnesDemandes.value='0,00';
	    	document.forms[0].jhCantonnesDecides.value='0,00';
	    	document.forms[0].jhCoutTotal.value='0,00';
	    	document.forms[0].keJhArbitresDemandes.value='0,00';
	    	document.forms[0].keJhArbitresDecides.value='0,00'; 
	        document.forms[0].keJhCantonnesDemandes.value ='0,00';
	    	document.forms[0].keJhCantonnesDecides.value='0,00';
	    	document.forms[0].keJhCoutTotal.value='0,00';
	    	 
 
    }
    
}

 
function verifierListeSelectionnees(){
	if(document.forms[0].dpCopi.value = "<%= valeurARenseigner%>" ){
		return "Veuillez sélectionner un DP Copi !";
	}
	if(document.forms[0].dateCopi.value = "<%= valeurARenseigner%>" ){
		return "Veuillez sélectionner une anneé !";
	}
	if(document.forms[0].annee.value = "<%= valeurARenseigner%>" ){
		return "Veuillez sélectionner uen date COPI !";
	}
	if(document.forms[0].fournisseurCopi.value = "<%= valeurARenseigner%>" ){
		return "Veuillez sélectionner un fournisseur COPI!";
	}
	if(document.forms[0].metier.value = "<%= valeurARenseigner%>" ){
		return "Veuillez sélectionner un métier !";
	}
	if(document.forms[0].typeDemande.value = "<%= valeurARenseigner%>" ){
		return "Veuillez sélectionner un Type de demande!";
	}
	
	return "OK";

}
 

function Verifier(form, action, mode, flag)
{

 alert (action);
 
  alert(verifierListeSelectionnees());
   blnVerification = flag;
   form.mode.value =mode;
   form.action.value = action;

} 

function Paginer(nombre){

	if(nombre = "-10"){
	   document.forms[0].nombrePagesRelatif.value="-10";  
	}
	if(nombre = "-1"){
	   document.forms[0].nombrePagesRelatif.value="-10"; 
	}
	if(nombre = "1"){
		 document.forms[0].nombrePagesRelatif.value="-10"; 
	}
	if(nombre = "10"){
	   document.forms[0].nombrePagesRelatif.value="-10"; 
	}
 

  alert( document.forms[0].nombrePagesRelatif.value  );
   form.action.value = "suite";
 
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
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Modification d'un Budget COPI<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --><html:form action="/dpg"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
              <input type="hidden" name="pageAide" value="<%= sPageAide %>">
              
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/> 
            
			<tr> 
			                  <td align=center >&nbsp;</td>
			                  <td >&nbsp;</td>
			</tr>  
         
            <!-- --------------------  LISTES INFOS ENTETE  -------------------- -->
            <tr width="100%">
              <td>
						<table border=0  cellpadding=2 cellspacing=2 class="tableBleu" width="100%">
			               <tr width="100%">
			                	<td align=center  width="10%">     </td>
	  			                <td class="lib" align=center width="10%"><b>Code Dossier<BR>Projet COPI:&nbsp</b></td>
	  			                <td class="lib" align=center width="10%"><b>Date COPI:&nbsp</b></td>
				                <td class="lib" align=center width="10%"><b>Année:&nbsp</b></td>
				                <td class="lib" align=center width="10%"><b>Fournisseur:&nbsp</b></td>
				                <td class="lib" align=center width="10%"><b>Métier:&nbsp</b></td> 
				                <td class="lib" align=center width="10%"><b>Type de demande:&nbsp</b></td>
				                <td></td>
						  </tr>
						  <tr width="100%"> 
								<td align=center width="10%">     </td>
							 
							 	<!----------------  DP COPI  ----------------------->
				                 <td width="10%"> 
					                      
					             </td> 
				                <!----------------  Date COPI  -----------------------> 
					             <td width="10%"> 
					                      <html:select property="dateCopi"  name="budgetCopiForm" styleClass="input" size="5" value="valeurARenseigner"> 
					                          <html:options collection="listeDatesCopi" property="cle" labelProperty="libelle" />
					                      </html:select>
								</td>
								<!----------------  Année  ----------------------->
				                <td width="10%">
							              <html:select property="annee"  name="budgetCopiForm" styleClass="input" size="5" value="valeurARenseigner"> 
							                  <html:options  collection="listeDesannees" property="value" labelProperty="label" />
							              </html:select>  
								</td> 
								<!----------------  Fournisseur  ----------------------->
				                 <td width="10%"> 
					                      
					             </td>
				                 <!----------------  Metier  ----------------------->
				                 <td width="10%"> 
					                       <html:select property="metier" name="budgetCopiForm" styleClass="input"  size="5" value="valeurARenseigner"> 
					                          <html:options collection="listeMetiers" property="cle" labelProperty="libelle" />
					                      </html:select>
								</td>
								 <!----------------  Type Demande  ----------------------->
				                 <td width="10%"> 
					                       <html:select property="typeDemande" name="budgetCopiForm" styleClass="input"  size="5" value="valeurARenseigner"> 
					                          <html:options collection="listeTypeDemandes" property="cle" labelProperty="libelle" />
					                      </html:select>
								</td>
								<td></td>
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
		     	
 
		     	 <tr >
                   <td>
                        <table border=0  cellpadding=2 cellspacing=2 class="tableBleu">
			               <tr width="100%"> 
			                    <td width="10%"> </td>
	  			                <td class="lib" align=center ><b>JH Arbitrés demandés :</b></td>
	  			                <td><html:text name="budgetCopiForm" property="jhArbitresDemandes"  styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"  style="alignRight"/></td>
	  			                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>Keur non JH Arbitrés demandés :</b></td>
	  			                <td><html:text name="budgetCopiForm" property="keJhArbitresDemandes" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td></td>
	  			           </tr>     
	  			           <tr width="100%"> 
	  			                <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>Keur non JH Arbitrés décidés  :</b></td>
	  			                <td><html:text name="budgetCopiForm" property="jhArbitresDecides" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>Keur non JH Arbitrés décidés :</b></td>
	  			                <td><html:text name="budgetCopiForm" property="keJhArbitresDecides" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td></td>
	  			           </tr>     
	  			           <tr width="100%">   
	  			                <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>JH Cantonnés demandés:</b></td> 
	  			                <td><html:text name="budgetCopiForm" property="jhCantonnesDemandes" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>Keur non JH Cantonnés demandés:</b></td>
	  			                <td><html:text name="budgetCopiForm" property="keJhCantonnesDemandes" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td></td>
	  			            </tr>     
	  			           <tr width="100%">     
	  			                <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>JH Cantonnés décides :</b></td> 
	  			                <td><html:text name="budgetCopiForm" property="jhCantonnesDecides" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>Keur non JH Cantonnés décides :</b></td>
	  			                <td><html:text name="budgetCopiForm" property="keJhCantonnesDecides" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td></td>
	  			             </tr>     
	  			           <tr width="100%">    
	  			                <td width="10%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>JH Coût total        :</b></td> 
	  			                <td><html:text name="budgetCopiForm" property="jhCoutTotal" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
	  			                <td class="lib" align=center ><b>Keur non JH Coût total        :</b></td>
	  			                <td><html:text name="budgetCopiForm" property="keJhCoutTotal" styleClass="input" size="16" maxlength="16" onchange="return VerifierNum(this,12,2);"/></td>
	  			                <td></td> 
	  			              </tr>
	  			           </table>
	  			         </td>   
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
		<table width="100%" border="0">
			 <tr> 
	                <td width="25%">&nbsp;</td>
	                <td width="25%"> 
	                  <div align="center"> <html:submit property="boutonCréer" value="Créer" styleClass="input" onclick="Verifier(this.form, 'creer', this.form.mode.value,true);"/> 
	                  </div>
	                </td>
	                <td width="25%"> 
	                  <div align="center"> <html:submit property="boutonModifier" value="Modifier" styleClass="input" onclick="Verifier(this.form, 'modifier', null, false);"/> 
	                  </div>
	                </td>
	                <td width="25%">&nbsp;</td>
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
          <td>&nbsp;  
          </td>
        </tr>
        
        <tr> 
          <td>&nbsp;  
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
        
 