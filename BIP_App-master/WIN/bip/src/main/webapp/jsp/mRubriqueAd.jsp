<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"    errorPage="../jsp/erreur.jsp"  %>

<jsp:useBean id="rubriqueForm" scope="request" class="com.socgen.bip.form.RubriqueForm" />
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
<bip:VerifUser page="jsp/fmRubriqueAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	Hashtable hKeyList= new Hashtable();
    hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
    
    
	  
  try {	
		
	    ArrayList listeDirection = listeDynamique.getListeDynamique("direction", hKeyList);
	    pageContext.setAttribute("choixDirection", listeDirection);
	    
	    ArrayList listeRubrique = listeDynamique.getListeDynamique("rubrique", hKeyList);
	    listeRubrique.add(0,new ListeOption("", " "));
	    pageContext.setAttribute("choixRubrique", listeRubrique);
	    
	    	    
	    hKeyList.put("type", "D");
	    ArrayList listeComptedeb = listeDynamique.getListeDynamique("compte", hKeyList);
	    pageContext.setAttribute("choixComptedeb", listeComptedeb);
	    
	    hKeyList.put("type", "C");
	    ArrayList listeComptecre = listeDynamique.getListeDynamique("compte", hKeyList);
	    pageContext.setAttribute("choixComptecre", listeComptecre);
	    
	    
	       
  }   
  catch (Exception e) {
	    pageContext.setAttribute("choixDirection", new ArrayList());
	    pageContext.setAttribute("choixComptedeb", new ArrayList());
	    pageContext.setAttribute("choixComptecre", new ArrayList());
 }	 
	
	
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif = new Object();

function MessageInitial()
{
   
   var Message="<bean:write filter="false"  name="rubriqueForm"  property="msgErreur" />";
   var Focus = "<bean:write name="rubriqueForm"  property="focus" />";
   var codep = "<bean:write name="rubriqueForm"  property="codep" />";
   var codfei = "<bean:write name="rubriqueForm"  property="codfei" />";
   
   if (Message != "") {
      alert(Message);
   }
   
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].mode.value != 'delete')
     {
     if(document.forms[0].coddir){
	   document.forms[0].coddir.focus();
     }
   }
   
   document.forms[0].libelle.value = codep+'-'+codfei; 
     
   
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   form.action.value = action;
   form.mode.value = mode;
}

function ValiderEcran(form)
{
   if (blnVerification) {
   	if ((form.action.value!="valider")&&(form.action.value!="annuler"))
  		form.action.value ="valider";
  		
  	if (form.mode.value == 'delete') {
	   if (!confirm("Voulez-vous supprimer cette rubrique ?")) return false;
	}
    else {
    
       //if (!ListeObligatoire(form.coddir,"la direction")) return false;
	   //if (!ListeObligatoirelibellestd(form.libelle)) return false;
	   //if (!ChampObligatoire(form.cafi, "le CAFI")) return false;
	   //if (!ListeObligatoiredebiter(form.comptedeb)) return false;
	   //if (!ListeObligatoirecrediter(form.comptecre)) return false;
	   //if (!ChampObligatoireshemacpt(form.schemacpt)) return false;
	   //if (!ChampObligatoire(form.appli, "l'application")) return false;
    
     
	   if (!ListeObligatoire(form.coddir,"la direction")) return false;
	   if (!ListeObligatoire(form.libelle,"le libellé standard rubrique")) return false;
	   if (!ChampObligatoire(form.cafi, "le CAFI")) return false;
	   if (!ListeObligatoire(form.comptedeb,"Entrez le compte à débiter")) return false;
	   if (!ListeObligatoire(form.comptecre,"Entrez le compte à créditer")) return false;
	   if (!ChampObligatoire(form.schemacpt,"Entrez le code schéma comptable")) return false;
	   if (!ChampObligatoire(form.appli, "l'application")) return false;
	     	  
            
	   if (form.mode.value == 'update') {
		   if (!confirm("Voulez-vous modifier cette rubrique ?")) return false;
		}
		
	}
   }

   return true;
}


function rechercheID(){
	window.open("/recupIdCa.do?action=initialiser&nomChampDestinataire=cafi&cafidpg=OUI&windowTitle=Recherche Identifiant Centre d'Activité&habilitationPage=HabilitationLigneBip"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}  

function nextFocusComptedeb(){		
	
	document.forms[0].schemacpt.focus();
	
}

function changeLibelle(form)
{

   if (document.forms[0].libelle.value != "")
   {
   
   tab =  document.forms[0].libelle.value.split('-'); 
           
    i=tab[0];
    j=tab[1];

   eval("document.forms[0].codep").value=(i==0?"":parseInt(i));
        
   eval("document.forms[0].codfei").value=(j==0?"":parseInt(j));
   
   }
   else
   {
   
     eval("document.forms[0].codep").value=("");
     eval("document.forms[0].codfei").value=("");
   
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
          <bean:write name="rubriqueForm" property="titrePage"/> une rubrique<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> <!-- #BeginEditable "debut_form" --> <html:form action="/rubrique"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable --> 
            <div align="center"><!-- #BeginEditable "contenu" -->
			<input type="hidden" name="pageAide" value="<%= sPageAide %>">
			  <html:hidden property="titrePage"/>
              <html:hidden property="action"/>
              <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
              <html:hidden property="flaglock"/>
              <table cellspacing="2" cellpadding="2" class="tableBleu"  >
                <tr> 
                  <td colspan=2 >&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td colspan=2>&nbsp;</td>
                 
                </tr>
                <tr> 
                  <td class="lib"><b>Code Rubrique :</b></td>
                  <td><b><bean:write name="rubriqueForm" property="codrub"/></b>
  				  	<html:hidden property="codrub"/>
  				  	</td>
                </tr>
                
                <tr> 
                  <td class="lib"><b>Direction :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:select property="coddir" styleClass="input"> 
   						<bip:options collection="choixDirection" />
						</html:select>
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="libdir"/>
  						<html:hidden property="coddir"/>
  						<html:hidden property="libdir"/>
  					</logic:equal>
				  </td>
                </tr>
                
                
                      
                
                 <tr>
                 <td  class="lib" ><b>Libell&eacute; standard rubrique :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
                    	<html:select property="libelle" styleClass="input" onchange="return changeLibelle(this);" > 
   						<bip:options collection="choixRubrique" />
						</html:select>
					
                   </logic:notEqual>
  					
  					 <logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="libelle"/><html:hidden property="libelle"/>
  					</logic:equal>					
  					
                  </td>
                 </tr> 
                
                         
                 <tr>
                  <td  class="lib" ><b>Code &eacute;l&eacute;ment de pilotage :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
 						<html:text property="codep" styleClass="input" size="5" readonly="true"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="codep"/><html:hidden property="codep"/>
  					</logic:equal>
                  </td>
                 </tr>      
            
                 
                  <tr>
                  <td  class="lib" ><b>CODFEI :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
	 					 <html:text property="codfei" styleClass="input" size="1" readonly="true"/>
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="codfei"/><html:hidden property="codfei"/>
  					</logic:equal>
                  </td>
                 </tr>    
                                        
                 
                           
                  
                  <tr> 
                  <td class="lib"><b>Centre d'activit&eacute; cr&eacute;dit&eacute; CAFI :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="cafi" styleClass="input" size="6" maxlength="6" onchange="return VerifierNum(this,6,0);"/>&nbsp;&nbsp;
                  		<a href="javascript:rechercheID();" onFocus="javascript:nextFocusComptedeb();"><img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Identifiant" title="Rechercher Identifiant"  align="absbottom" ></a>
                    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="libcafi"/>
  						<html:hidden property="cafi"/>
  						<html:hidden property="libcafi"/>
  					</logic:equal>
				  </td>
                  </tr>
                   
                 
                  <tr> 
                  <td class="lib"><b>Code du sch&eacute;ma comptable :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="schemacpt" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);" />
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="schemacpt"/>
  					</logic:equal>
				  </td>
                </tr>
                 
                 
                 <tr>
                  <td  class="lib" ><b>Compte &agrave; d&eacute;biter :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="comptedeb" styleClass="input"> 
   						<bip:options collection="choixComptedeb" />
						</html:select>					
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="libcomptedeb"/>
  						<html:hidden property="comptedeb"/>
  						<html:hidden property="libcomptedeb"/>
  					</logic:equal>
                  </td>
                 </tr> 
                
                               
                  
                 <tr>
                  <td  class="lib" ><b>Compte &agrave; cr&eacute;diter :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer">
	 					<html:select property="comptecre" styleClass="input"> 
   						<bip:options collection="choixComptecre" />
						</html:select>							
					</logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="libcomptecre"/>
  						<html:hidden property="comptecre"/>
  						<html:hidden property="libcomptecre"/>
  					</logic:equal>
                  </td>
                 </tr>   
                 
                 
                 
                 
                 <tr> 
                  <td class="lib"><b>Application :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		BIP
                  		<input type="hidden" name="appli" value="BIP">
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="appli"/>
  					</logic:equal>
				  </td>
                </tr>
                 
                 
                <tr> 
                  <td class="lib"><b>Date de la demande :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="datedemande" styleClass="input" onchange="return VerifierDate( this, 'jj/mm/aaaa' );" size="10" maxlength="10" />
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="datedemande"/>
  					</logic:equal>
				  </td>
                </tr> 
                 
                 
                <tr> 
                  <td class="lib"><b>Date de retour :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="dateretour" styleClass="input" onchange="return VerifierDate( this, 'jj/mm/aaaa' );" size="10" maxlength="10" />
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="dateretour"/>
  					</logic:equal>
				  </td>
                </tr>  
                  
                <tr> 
                  <td class="lib"><b>Commentaires :</b></td>
                  <td> 
                    <logic:notEqual parameter="action" value="supprimer"> 
                  		<html:text property="commentaires" styleClass="input" size="60" maxlength="100" />
				    </logic:notEqual>
  					<logic:equal parameter="action" value="supprimer">
  						<bean:write name="rubriqueForm" property="commentaires"/>
  					</logic:equal>
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
</body></html:html>
<!-- #EndTemplate -->
