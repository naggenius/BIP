<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>

<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*"    errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="extractionForm" scope="request" class="com.socgen.bip.commun.form.ExtractionForm" />
<jsp:useBean id="listeDynamique" scope="request" class="com.socgen.bip.commun.liste.ListeDynamique" />
<html:html locale="true">

<head>

<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>

<title>Edition</title>

<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<bip:VerifUser page="jsp/xAnaImmoAd.jsp"/>
<script language="JavaScript" src="../js/function.cjs"></script>
<link rel="stylesheet" href="../css/base_style.css" type="text/css">
<link rel="stylesheet" href="../css/style_bip.css" type="text/css">
<script language="JavaScript">
var pageAide = "aide/hvide.htm";
var blnVerification = true;
<%
	

	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
int sizeList;
String Dossproj = null;
com.socgen.bip.user.UserBip userbip = (com.socgen.bip.user.UserBip)	session.getAttribute("UserBip");
com.socgen.bip.menu.item.BipItemMenu menuCourant =  userbip.getCurrentMenu();
String menu = menuCourant.getId();
	
try
{
	
	Dossproj = userbip.getDossProj();
		
	
	Hashtable hKeyList= new Hashtable();
	hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	ArrayList listeDosprojUser= listeDynamique.getListeDynamique("dosproj_user", hKeyList);
    pageContext.setAttribute("choixDosprojUser", listeDosprojUser);	
	sizeList = listeDosprojUser.size();
	 }
	 catch (Exception e) 
	 { 
		 sizeList = 0;
		 Dossproj = null;
	   %>alert("<%= listeDynamique.getErrorBaseMsg()%>");<%
	 }
    
    
	
%>
var pageAide = "<%= sPageAide %>";
var testmenu = "<%= menu %>";
var blnVerifFormat  = true;
var tabVerif        = new Object();


<%
	String sTitre;
	String sInitial;
	String sJobId="xAnaImmo";
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
	var Message="<bean:write filter="false"  name="extractionForm"  property="msgErreur" />";
	var Focus = "<bean:write name="extractionForm"  property="focus" />";
	
	if (Message != "") {
		alert(Message);
	}
	

	<% if(menu.equals("DIR"))
	{%>
	document.forms[0].p_param6.focus();
<% }%>
	
}

function Verifier(form, bouton, flag)
{
  blnVerification = flag;
}

function ValiderEcran(form)
{
    // VerifierAlphaMax(form.p_param6);
	// document.extractionForm.submit.disabled = true;
	return VerifierNum(document.forms[0].p_param6,5,0);
    //return true;
}

function rechercheDP(){
	window.open("/recupCodeDosProj.do?action=initialiser&nomChampDestinataire=p_param6&windowTitle=Recherche Code dossier projet"  ,"", "toolbar=no, directories=no, location=no, status=no, menubar=no, resizable=yes, scrollbars=yes, width=450, height=450") ;
	return ;
}

function nextFocusCreer(){document.forms[0].boutonExtraire.focus();}

</script>

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
          <td height="20" class="TitrePage"><%=sTitre%></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td> 
            
          </td>
        </tr>
        <tr> 
          <td>
		  <html:form action="/extract"  onsubmit="return ValiderEcran(this);">
		  		
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
            <input type="hidden" name="jobId" value="<%=sJobId%>">
				
            <input type="hidden" name="initial" value="<%= sInitial %>">
            <table width="100%" border="0">
              
                <tr> 
                  <td> 
                    <div align="center">
					<table border=0 cellspacing=2 cellpadding=2 class="tableBleu">
						<input type="hidden" name="pageAide" value="<%= sPageAide %>">
					  <tr>
                        <td colspan=5 align="center">&nbsp;</td>
                      </tr>
					     <%if (menu.equals("DIR"))
                        {%>
					  	<tr>
                        <td align="center"><b>Code dossier projet :</b></td>
                        
                        <td> 
                  	        <html:text property="p_param6" styleClass="input" size="5" maxlength="5" onchange="return VerifierNum(this,5,0);" />
                  	        <a href="javascript:rechercheDP();" onFocus="javascript:nextFocusCreer();">
                  	        <img border=0 src="/images/p_zoom_blue.gif"  alt="Rechercher Code dossier projet" title="Rechercher Code dossier projet" align="absbottom">
                  	        </a>
					    </td>
					  </tr>
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
				  <html:submit property="boutonExtraire" value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/>
                  </div>
                  </td>
                </tr>
					  
					   <%} else {
						   if (Dossproj == null || Dossproj.equalsIgnoreCase(""))
					   
					  {%>
					   <tr>
                        <td align="center"><b>Vous êtes habilité à visualiser aucun dossier projet</b></td>
                       </tr> 
					  <%}else {
						  
						  if (sizeList==1)
						  {
						  %>
					   <tr>
                        <td align="center"><b>Les projets auxquels vous êtes habilité ne font pas l'objet d'immobilisation cette année</b></td>
                       </tr> 
                       <%} else { %>
					  <tr>
                        <td align="center"><b>Code dossier projet :</b></td>
                                           
                        <td>
                    	<html:select property="p_param6" styleClass="input" size="1"> 
   						<html:options collection="choixDosprojUser" property="cle" labelProperty="libelle" />
						</html:select> 
                  		</td>
                  	
                  
                        
                        
					  </tr>
					  
					    	
				
					  
					  
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
				  <html:submit property="boutonExtraire" value="Extraire" styleClass="input" onclick="Verifier(this.form, 'Extraire', true);"/>
                  </div>
                  </td>
                </tr>
                	<%} %>
            <%} %>
            	<%} %>
            </table>
			  </html:form>
          </td>
        </tr>
		<tr> 
          <td>&nbsp;  
          </td>
        </tr>
        <tr> 
          <td> 
            <div align="center"><html:errors/></div>
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
