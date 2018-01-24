 
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<html:html locale="true">
<jsp:useBean id="societeForm" scope="request" class="com.socgen.bip.form.SocieteForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<!-- #EndEditable -->  <!-- #BeginTemplate "/Templates/Page_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>


<!-- #BeginEditable "doctitle" --> 
<title>Page BIP</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/bSocieteAd.jsp"/>
<%
  java.util.ArrayList list1 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("soccat"); 
  pageContext.setAttribute("choixSoccat", list1);
  
  java.util.ArrayList list2 = com.socgen.bip.commun.liste.ListeStatique.getListeStatique("nature"); 
  pageContext.setAttribute("choixNature", list2);
  
  java.util.ArrayList list3= new com.socgen.bip.commun.liste.ListeDynamique().getListeDynamique("siren_agence",societeForm.getHParams());
  pageContext.setAttribute("siren_agence", list3); 
%>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));

	String toppresence = societeForm.getToppresence();




%>
var pageAide = "<%= sPageAide %>";
var toppresence = "<%= toppresence %>";


var blnVerifFormat  = true;
var tabVerif = new Object();


function MessageInitial()
{
	
   tabVerif["socnat"]	= "VerifierAlphanum(document.forms[0].socnat)";
   tabVerif["soclib"]	= "VerifierAlphanum(document.forms[0].soclib)";
   tabVerif["socfer_ch"]= "VerifierDate(document.forms[0].socfer_ch, 'mm/aaaa')";
   tabVerif["socnou"]	= "VerifierAlphaMax(document.forms[0].socnou)";
   tabVerif["soccop"]	= "VerifierAlphanum(document.forms[0].soccop)";
   tabVerif["socfer_cl"]= "VerifierDate(document.forms[0].socfer_cl, 'mm/aaaa')";
   tabVerif["soccom"]	= "VerifierAlphanum(document.forms[0].soccom)";
   var Message="<bean:write filter="false"  name="societeForm"  property="msgErreur" />";
   var Focus = "<bean:write name="societeForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
   if (Focus != "") (eval( "document.forms[0]."+Focus )).focus();
   else if (document.forms[0].soclib){
	  document.forms[0].soclib.focus();

   }
    
    
}

function Verifier(form, action, mode, flag)
{
   blnVerification = flag;
   if (action=="valider") {
     form.mode.value = mode;
     
   }
   form.action.value = action;
} 
function ValiderEcran(form)
{
   if (blnVerification) {
	
	if (form.mode.value!="delete") {
		if (!ChampObligatoire(form.soclib, "le libellé")) return false;
		if (form.socnat && (form.socnat.value != "")){
			form.socnat.value = (form.socnat.value).toUpperCase();
		}
	}
	
	if (form.mode.value == 'update') {
	
	
			if ((form.siren.value == 0) && (form.socfer_ch.value != "") && (form.socnou.value != "") && (toppresence == "N"))
			{
				alert("renseigner le siren de la societé");
				return false;
			}
        	if (!confirm("Voulez-vous modifier cette société  ?")) return false;
    }
    if (form.mode.value == 'delete') {
        	if (!confirm("Voulez-vous supprimer cette société ?")) return false;
    }
	
    }

   return true;
}

function raffraichiListe(){

	document.forms[0].action.value = "initialiser";
	
	 document.forms[0].submit();
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
          <bean:write name="societeForm" property="titrePage"/> 
           une société<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" --> <html:form action="/societe"  onsubmit="return ValiderEcran(this);"><!-- #EndEditable -->
		  <div align="center"><!-- #BeginEditable "contenu" -->
<input type="hidden" name="pageAide" value="<%= sPageAide %>">
		  <html:hidden property="titrePage"/>
		  <html:hidden property="action"/>
		  <html:hidden property="mode"/>
<html:hidden property="arborescence" value="<%= arborescence %>"/>
		  <html:hidden property="flaglock"/>
		  <html:hidden property="toppresence"/>

	          <table cellspacing="2" cellpadding="2" class="tableBleu" width="600"  >
	          	<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
                <tr> 
                  <td width=110 class="lib"><b>Code : </b></td>
                  <td  border="1" width=110><b><bean:write name="societeForm"  property="soccode" />
                    <html:hidden property="soccode"/></b>
                 
                  </td>
                  <td width=110 class="lib"><b>Libellé :</b></td>
                  <td  width="151">
                    <logic:notEqual parameter="mode" value="delete"> 
                    	<html:text property="soclib" styleClass="input" size="27" maxlength="25" onchange="return VerifFormat(this.name);"/>
                    </logic:notEqual>
  					<logic:equal parameter="mode" value="delete">
  						<bean:write name="societeForm"  property="soclib" />
  					</logic:equal>
                  </td>
                </tr>
                <tr> 
                  <td width=110 class="lib">Nature :</td>
                  <td width="110" > 
                    <logic:notEqual parameter="mode" value="delete">
                    	<html:select property="socnat" styleClass="input"> 
   						<html:options collection="choixNature" property="cle" labelProperty="libelle" />
						</html:select>
                    </logic:notEqual>
  					<logic:equal parameter="mode" value="delete">
  						<bean:write name="societeForm"  property="socnat" />
  					</logic:equal>
                  </td>
                  <td width=110 class="lib"><b>Catégorie :</b></td>
                  <td  width="151"  >
                 <logic:equal parameter="mode" value="delete">
  						<bean:write name="societeForm"  property="soccat" />
  					</logic:equal>
                   <logic:notEqual parameter="mode" value="delete"> 
                       	<html:select property="soccat" styleClass="input"> 
   						<html:options collection="choixSoccat" property="cle" labelProperty="libelle" />
						</html:select>
                    </logic:notEqual>
                </tr>
                <tr> 
                  <td width=150 class="lib">Date Création :</td>
                  <td  width="110">
                    <bean:write name="societeForm"  property="soccre" />
                    <html:hidden property="soccre"/>
                  </td>
                  <td nowrap width=170 class="lib"><b>Code société-groupe :</b></td>
                  <td  width="151">
                    <logic:notEqual parameter="mode" value="delete"> 
                    	<html:text property="socgrpe" styleClass="input" size="5" maxlength="4" onchange="return VerifFormat(this.name);"/>
                    </logic:notEqual>
  					<logic:equal parameter="mode" value="delete">
  						<bean:write name="societeForm"  property="socgrpe" />
  					</logic:equal>
                  </td>
                </tr>
                <tr> 
                 
                </tr>
              </table> 
          <logic:equal parameter="mode" value="update">
    
			  <br>
		      <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="600" >
                <tr> 
                  <td width=171> 
                    <hr></td>
                  <td   width="141"> 
                    <center><u>Changement de société</u></center></td>
			       
                  <td width=167> 
                    <hr></td>
   			     </tr>
				
			  </table>
			  <br>
			  <%if (societeForm.getToppresence().equals("O"))
				  {%>
			  <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="600" >
                <tr> 
                  <td width=109 class="lib">Date Fermeture :</td>
                  <td  width="110" >
                  <bean:write name="societeForm"  property="socfer_ch" />
                  <html:hidden property="socfer_ch"/>
                   				  </td>
                  <td width=117 class="lib" colspan="-2">Nouvelle société :</td>
                  <td  width="137"  >
                  <bean:write name="societeForm"  property="socnou" />
                  <html:hidden property="socnou"/>
                    </td>
                </tr>
                <tr> 
                  <td width=109 class="lib">Commentaire :</td>
                  <td  width="110"  >
                    <html:text property="soccop" styleClass="input" size="20" maxlength="20" onchange="return VerifFormat(this.name);"/>  
                  </td>
                   <td width=117 class="lib" >Siren :</td>
                   <td > 
                   <bean:write name="societeForm"  property="siren" />
                    <html:hidden property="siren"/>
					   
				   </td>  
                </tr>
                <tr> 
                  
               
                  
                </tr>
              </table>
              <%}
			  else
			  {  %>
			   <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="600" >
                <tr> 
                  <td width=109 class="lib">Date Fermeture :</td>
                  <td  width="110" >
                    <html:text property="socfer_ch" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/> 
   				  </td>
                  <td width=117 class="lib" colspan="-2">Nouvelle société :</td>
                  <td  width="137"  >
                    <html:text property="socnou" styleClass="input" size="4" maxlength="4" onchange="raffraichiListe();"/> 
                  </td>
                </tr>
                <tr> 
                  <td width=109 class="lib">Commentaire :</td>
                  <td  width="110"  >
                    <html:text property="soccop" styleClass="input" size="20" maxlength="20" onchange="return VerifFormat(this.name);"/>  
                  </td>
                   <td width=117 class="lib" >Siren :</td>
                   <td > 
					    <html:select property="siren" name="societeForm" styleClass="input"     > 
					          <html:options collection="siren_agence" property="cle" labelProperty="libelle" />
					    </html:select>
				   </td>  
                </tr>
                <tr> 
              
                </tr>
              </table>
			  <%} %>
			  <br>
			   
			 
			  
			    <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="600" >
                <tr> 
                  <td width=140> 
                    <hr></td>
                  <td   width=200> 
                    <center> <u>Fermeture provisoire de la société</u></center></td>
			       
                  <td width=140> 
                    <hr></td>
			  </tr>
			 
			  </table>
			 <br>
              <table border="0" cellspacing="2" cellpadding="2" class="tableBleu" width="600" >
                <tr> 
                  <td width=109 class="lib">Date Fermeture :</td>
                  <td  width="110" >
                  <html:text property="socfer_cl" styleClass="input" size="7" maxlength="7" onchange="return VerifFormat(this.name);"/>   
                   
                  </td>
                  <td width=117 colspan="-2"></td>
                  <td  width="148"  > 
                  </td>
                </tr>
                <tr> 
                  <td width=109 class="lib">Commentaire :</td>
                  <td  colspan=4>
                  <html:text property="soccom" styleClass="input" size="20" maxlength="20" onchange="return VerifFormat(this.name);"/>   
                  </td>
                </tr>
			 	<tr>
					<td >&nbsp;</td> 
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
              </table>
        
		</logic:equal>
		<br>
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
                	 <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', this.form.mode.value,true);"/>
                  	</div>
				  </td>
				  <td width="25%">  
				  	<div align="center"> 
                	 <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', null, false);"/>
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
Integer id_webo_page = new Integer("1003"); 
com.socgen.bip.commun.form.AutomateForm formWebo = societeForm ;
%>
<%@ include file="/incWebo.jsp" %>
</html:html> 

<!-- #EndTemplate -->