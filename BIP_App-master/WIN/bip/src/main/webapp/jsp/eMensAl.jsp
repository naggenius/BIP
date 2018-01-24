<!DOCTYPE html>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.sql.*,java.io.*,java.lang.*,java.util.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*" errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="eMensuelForm" scope="request" class="com.socgen.bip.form.EMensuelForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />

<html:html locale="true">
<!-- #EndEditable --> 

<!-- #BeginTemplate "/Templates/Page_edition.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<!-- #BeginEditable "doctitle" --> 
<title>Edition</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/eMensAl.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
	String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
%>
var pageAide = "<%= sPageAide %>";

var blnVerifFormat  = true;
var tabVerif        = new Object();
var bTestGroupe		= false;

<%

	String sTitre;
	String sInitial;
	String sAction;
	String sJobId="eMensAl";
		
	com.socgen.bip.user.UserBip user = (com.socgen.bip.user.UserBip)session.getAttribute("UserBip") ;
    String p_global=((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser();
    
    String infosUser = user.getInfosUser(); 
    String ident = user.getIdUser() ;
    String dpg = user.getDpg_Defaut_Etoile(); 
 
	Hashtable hKeyList= new Hashtable();

	
	if (eMensuelForm.getAction() == null) 
    	hKeyList.put("codsg", ""+dpg);
	else
		 hKeyList.put("codsg", ""+eMensuelForm.getP_param6());
    hKeyList.put("userid", ""+infosUser);
    
    hKeyList.put("p_global",""+p_global);
    

   
    
    if (eMensuelForm.getAction() == null)
    	 sAction = "null";
    else
    	sAction = eMensuelForm.getAction();

    	
    	
    try
    { 
    ArrayList listePid = listeDynamique.getListeDynamique("pid", hKeyList);
    ArrayList listeRessource = listeDynamique.getListeDynamique("ress_dpg", hKeyList);
       
    pageContext.setAttribute("choixPid", listePid);
    pageContext.setAttribute("choixRessource", listeRessource);
   
    }
    catch (Exception e) 
    { 
       %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
    }
%>

function MessageInitial()
{
	<%
		sTitre = com.socgen.bip.metier.Report.getTitre(sJobId);
		if (sTitre == null)
		{
			//redirect sur la page d'erreur
			sTitre = "Pas de titre";
		}		
		sInitial=ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getQueryString()));
		if (sInitial == null)
			sInitial = request.getRequestURI();
		else
			sInitial = request.getRequestURI() + "?" + sInitial;
		sInitial = sInitial.substring(request.getContextPath().length());
	%>
	
	tabVerif["p_param6"] = "Ctrl_dpg_generique(document.eMensuelForm.p_param6)";
	
	var Message="<bean:write filter="false"  name="eMensuelForm"  property="msgErreur" />";
	var Focus = "<bean:write name="eMensuelForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}

		
	// initialisation de la liste avec le dpg par défaut lors du première affichage de la page
	<%if (!sAction.equals("refresh")) {%>
document.forms[0].p_param6.value = Replace_DoubleZero_by_DoubleEtoile( "<bean:write name="UserBip"  property="dpg_Defaut" />" );
	<%}%>


	if (Focus != "") (eval( "document.Forms[0]."+Focus )).focus();
	
	// permet de laisse afficher les listse deroulante des ressources et pids lors du changement de dpg si elles étaient cochées avant
	<% if (eMensuelForm.getListeReports().indexOf("21")!=-1) {%> 
  
	
		document.forms[0].p_param9.style.display="";
	<%}%>
	<% if (eMensuelForm.getListeReports().indexOf("22")!=-1) {%> 
  
	
		document.forms[0].p_param10.style.display="";
	<%}%>
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
  form.action.value = bouton;
}

function majListe(form)
{
	bTestGroupe = false;
	sListe = "";
	if (form.ck1.checked)
	{
		if (form.listeReports.value == "")
			sListe="1";
		else
			sListe = sListe + ";1";
	}

	if (form.ck2.checked)
	{
		bTestGroupe = true;
		if (form.listeReports.value == "")
			sListe="2";
		else
			sListe = sListe + ";2";
	}
	
	if (form.ck3.checked)
	{
		if (form.listeReports.value == "")
			sListe="3";
		else
			sListe = sListe + ";3";
	}
	
	if (form.ck4.checked)
	{
		bTestGroupe = true;
		if (form.listeReports.value == "")
			sListe="4";
		else
			sListe = sListe + ";4";
	}
	
	if (form.ck5.checked)
	{
		if (form.listeReports.value == "")
			sListe="5";
		else
			sListe = sListe + ";5";
	}
	
	if (form.ck6.checked)
	{
		if (form.listeReports.value == "")
			sListe="6";
		else
			sListe = sListe + ";6";
	}
	
	if (form.ck7.checked)
	{
		if (form.listeReports.value == "")
			sListe="7";
		else
			sListe = sListe + ";7";
	}
	
	if (form.ck8.checked)
	{
		bTestGroupe = true;
		if (form.listeReports.value == "")
			sListe="8";
		else
			sListe = sListe + ";8";
	}
	
	if (form.ck9.checked)
	{
		bTestGroupe = true;
		if (form.listeReports.value == "")
			sListe="9";
		else
			sListe = sListe + ";9";
	}
	
	if (form.ck10.checked)
	{
		if (form.listeReports.value == "")
			sListe="10";
		else
			sListe = sListe + ";10";
	}
	
	if (form.ck11.checked)
	{
		if (form.listeReports.value == "")
			sListe="11";
		else
			sListe = sListe + ";11";
	}
	
	if (form.ck12.checked)
	{
		if (form.listeReports.value == "")
			sListe="12";
		else
			sListe = sListe + ";12";
	}
	if (form.ck13.checked)
	{
		if (form.listeReports.value == "")
			sListe="13";
		else
			sListe = sListe + ";13";
	}
	if (form.ck14.checked)
	{
		if (form.listeReports.value == "")
			sListe="14";
		else
			sListe = sListe + ";14";
	}
	if (form.ck15.checked)
	{
		if (form.listeReports.value == "")
			sListe="15";
		else
			sListe = sListe + ";15";
	}
	if (form.ck16.checked)
	{
		if (form.listeReports.value == "")
			sListe="16";
		else
			sListe = sListe + ";16";
	}
	if (form.ck17.checked)
	{
		if (form.listeReports.value == "")
			sListe="17";
		else
			sListe = sListe + ";17";
	}
	if (form.ck18.checked)
	{
		if (form.listeReports.value == "")
			sListe="18";
		else
			sListe = sListe + ";18";
	}
	if (form.ck19.checked)
	{
		if (form.listeReports.value == "")
			sListe="19";
		else
			sListe = sListe + ";19";
	}
	if (form.ck20.checked)
	{
		if (form.listeReports.value == "")
			sListe="20";
		else
			sListe = sListe + ";20";
	}	 

	if (form.ck21.checked) 
		{
		if (form.listeReports.value == "")
			sListe="21";
		else
			sListe = sListe + ";21";
		}
		
	if (form.ck22.checked) 
		{
		if (form.listeReports.value == "")
			sListe="22";
		else
			sListe = sListe + ";22";
		}

	form.listeReports.value = sListe;
	
}

function ValiderEcran(form)
{
	var compt = 0;
	if (blnVerification == true)
	{
		if (form.listeReports.value == "")
		{
			alert("Vous devez cocher au moins une case") ;
			return false;
		}

		return Ctrl_dpg_generique(form.p_param6);

//		if (bTestGroupe)
//		{
			//alert("2 4 8 9");
//			for (compt=0;compt<4;compt++)
//			{
//				if(form.p_param6.value.charAt(compt) == "*")
//				{
//					alert("Vous devez choisir un département et un pole. Seul le groupe peut être en **");
//					return false;
//				}
//			}
//		}
	}
	form.submit.disabled = true;
	return true;
}

function ChangeAff(newAff){
	document.forms[0].p_param9.style.display="none";
	document.forms[0].p_param10.style.display="none";
	if (document.forms[0].ck21.checked) 
		{
		document.forms[0].p_param9.style.display="";
		}
	if (document.forms[0].ck22.checked) 
		{
		document.forms[0].p_param10.style.display="";
		}
}


</script>
<!-- #EndEditable --> 


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer" style="min-height:98%;">
<div id="entete"></div>
<div id="logo">
		<div id="logo_sg"><img src="../images/logo_SG.gif" width="162" height="33" border="0" /></div>
		<div id="nomdusite"><img src="../images/bip_logo.png" width="78" height="46" border="0" /></div>
</div>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr> 
    <td> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr> 
          <td>&nbsp;</td>
        </tr>
		<tr > 
		  <td> 
            &nbsp;
          </td>
        </tr>
        <tr> 
          <td><div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" --><%=sTitre%><!-- #EndEditable --></td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <table width="100%" border="0">                
	<tr> 
		<td> 
		<div align="center">
		<html:form action="/eMensuel"  onsubmit="return ValiderEcran(this);">
			<!-- #BeginEditable "debut_hidden" -->
            <input type="hidden" name="pageAide" value="<%= sPageAide %>">
			<html:hidden property="arborescence" value="<%= arborescence %>"/>
			<input type="hidden" name="jobId" value="<%=sJobId%>">
			<html:hidden property="listeReports" styleClass="input"/> 
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <input type="hidden" name="p_global" value="<%= p_global %>">
         
            <html:hidden property="action" styleClass="input"/> 
            
             
			<!-- #EndEditable -->
			
		    <input type="hidden" name="p_param14" value="<%=ident%>">
		
				<!--    table border=0 cellspacing=5 cellpadding=0 class="tableBleu" -->
						<!--	<table border=0 cellspacing=5 cellpadding=0 width=498> -->
						
	
			
			
				<table width="100%"> 
							<tr align="left">
							  <td width="5%">&nbsp;</td>
							   <td class="texte" nowrap width="40%" align="left"><B>Historique par ressource</B></td>
								<td width="2%">
									<html:checkbox name="eMensuelForm" property="ck1" value="1" onChange="majListe(this.form);"/>
            					</td>
								<td width="2%">&nbsp;</td>
								<td class="texte" nowrap width="40%" align="left"><B>Historique ressources par C.P</B></td>
								<td width="2%">
									<html:checkbox name="eMensuelForm" property="ck2" value="2" onChange="majListe(this.form);"/>
								
								</td>
								<td>&nbsp;</td>
							</tr>
							
							
							<tr align="left">
							    <td width="5%">&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Facturation attendue</B></td>
								<td>
										<html:checkbox name="eMensuelForm" property="ck3" value="3" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>D&eacute;tail des lignes BIP</B></td>
								<td>
										<html:checkbox name="eMensuelForm" property="ck4" value="4" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							
							<tr align="left">
							  <td width="5%">&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Suivi budg&eacute;taire mensuel</B></td>
								<td>
										<html:checkbox name="eMensuelForm" property="ck5" value="5" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Historique par ligne</B></td>
								<td>
										<html:checkbox name="eMensuelForm" property="ck6" value="6" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							
							<tr align="left">
							    <td width="5%">&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Projets re&ccedil;us/non re&ccedil;us</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck7" value="7" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Suivi budgets &eacute;tudes informatiques</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck8" value="8" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							
							<tr align="left"> 
							 <td width="5%">&nbsp;</td>
							   <td class="texte" nowrap align="left"><B>Etat d&eacute;taill&eacute; client</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck9" value="9" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Etat d&eacute;taill&eacute; client class&eacute; par MO</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck10" value="10" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr align="left">
							    <td width="5%">&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Etat d&eacute;taill&eacute; client par top tri </B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck11" value="11" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
		
							<tr align="left">
							    <td width="5%">&nbsp;</td>
							    <td class="texte" nowrap align="left"><B>PCA4 par Client</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck12" value="12" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>PCA4 par Groupe</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck13" value="13" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr align="left">
							  <td width="5%">&nbsp;</td>
							    <td class="texte" nowrap align="left"><B>PCA4 par Groupe et M&eacute;tier</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck14" value="14" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>PCA4 par Client avec sous-traitance</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck15" value="15" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr align="left">
							   <td width="5%">&nbsp;</td>
  							   <td class="texte" nowrap align="left"><B> Comparaison budg&eacute;taire lignes r&eacute;parties en T9</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck16" value="16" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>Etat d'anomalie des tables de répartition</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck17" value="17" onChange="majListe(this.form);"/>
								</td> 
								<td>&nbsp;</td>
					     </tr>
<!-- PCA4 KE -->							
						<tr>
					 	   <td  class="texte" align="center" colspan="6" height="40" valign="center" font="normal 8pt Arial, Helvetica, sans-serif" color="#000000"><B>Etats PCA4 en k&euro;</B></td> 
					    </tr> 
					     
							<tr align="left">
							     <td width="5%">&nbsp;</td>
							   <td class="texte" nowrap align="left"><B>PCA4 par Client en K&euro;</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck18" value="18" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<td class="texte" nowrap align="left"><B>PCA4 par Groupe en K&euro;</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck19" value="19" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr align="left">
							    <td width="5%">&nbsp;</td>
							   <td class="texte" nowrap align="left"><B>PCA4 par Groupe et M&eacute;tier en K&euro;</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck20" value="20" onChange="majListe(this.form);"/>
								</td>
								<td>&nbsp;</td>
								<!--   <td class="texte" nowrap><B>PCA4 par Client avec sous-traitance en K&euro;</B></td> -->
								<td><B> </B></td>
								<td>
									<!--  <input type="checkbox" name="ck21" value="21" onChange="majListe(this.form);">  --> 
								</td>
								<td>&nbsp;</td>
							</tr>
	         					

<!--  HISTORIQUE SELECTIF -->
					 	<tr>
					 	   <td class="texte" align="center" colspan="6" height="40" valign="center" font="normal 8pt Arial, Helvetica, sans-serif" color="#000000"><B>Historique selectif</B></td> 
					    </tr> 
					     
							<tr align="left">
							     <td width="5%">&nbsp;</td>
							   <td class="texte" nowrap align="left"><B>Historique par ressource</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck21" value="21" onChange="majListe(this.form);" onclick="ChangeAff(this.value);"/>
								</td>
								<td>&nbsp;</td>
								<td>				  				
					  				<html:select property="p_param9" styleClass="input" style="display='none'"> 
   										<option value="">Selectionnez une ressource</option>
   										<html:options collection="choixRessource" property="cle" labelProperty="libelle" />
					  				</html:select>
					  			</td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							
							<tr align="left">
							    <td width="5%">&nbsp;</td>
							   <td class="texte" nowrap align="left"><B>Historique par ligne</B></td>
								<td>
									<html:checkbox name="eMensuelForm" property="ck22" value="22" onChange="majListe(this.form);" onclick="ChangeAff(this.value);"/>
								</td>
								<td>&nbsp;</td>
								<td>
									<html:select property="p_param10" styleClass="input" style="display='none'"> 
   										<option value="">Selectionnez une ligne</option>
   										<html:options collection="choixPid" property="cle" labelProperty="libelle" />
					  				</html:select></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>  


						<!--</table>-->
					</table>
			 
			
 
		
	 
		
					
		<!--  /form> -->
		</div>
		</td>
	</tr>
	</table>


		
			
		 
			
						
            <table width="100%" border="0">
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
					<!-- #BeginEditable "contenu" -->
					  <tr>
                        <td colspan=5 align="center"></td>
                      </tr>
					<tr align="left"> 
						<td class="texte" align=center><b>Code DPG : </b></td>
						<td>				  				
					  	<html:text property="p_param6" styleClass="input" size="7" maxlength="7" onchange="if (Ctrl_dpg_generique(this) ) {rafraichir(this.form) };"/> 


   						
					  </td>

					</tr>
					<tr>
					
					</tr>
					  <tr>
                        <td colspan=5 align="center"></td>
                      </tr>
					<!-- #EndEditable -->
			   		</table>
					</div>
                  </td>
                </tr>
				<tr> 
          		  <td>&nbsp;  
          		  </td>
        		</tr>
                <tr> 
                  <td>  
                  <div align="center">
				  <html:submit value="Liste" styleClass="input" onclick="Verifier(this.form, 'liste', true);"/>
                  </div>
                  </td>
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
</div>
	<div id="bottomContainer">
			<div>&nbsp;</div>
	</div>
</div>
</body>
</html:html>

<!-- #EndTemplate -->