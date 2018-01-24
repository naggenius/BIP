<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<!-- #BeginEditable "imports" --> 
<%@ page language="java" import="org.owasp.esapi.ESAPI,java.util.*,java.sql.*,java.io.*,javax.servlet.*,javax.servlet.http.*,com.socgen.ich.ihm.*,com.socgen.bip.commun.liste.*"   errorPage="../jsp/erreur.jsp"  %>
<jsp:useBean id="paramLigneBipForm" scope="request" class="com.socgen.bip.form.ParamLigneBipForm" />
<html:html locale="true"> 
<!-- #EndEditable --> <!-- #BeginTemplate "/Templates/Page_filtre_maj.dwt" --><head>


<%@ taglib uri="/WEB-INF/bip.tld" prefix="bip" %>



<!-- #BeginEditable "doctitle" --> 
<title>Paramétrage</title>
<!-- #EndEditable -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- #BeginEditable "fichier" --> 
<bip:VerifUser page="jsp/xLigneBipAd.jsp"/> 
<script language="JavaScript" src="../js/function.cjs"></script>
<!-- <link rel="stylesheet" href="../css/base_style.css" type="text/css"> -->
<link rel="stylesheet" href="../css/style_bip_new.css" type="text/css">
<script language="JavaScript">
var blnVerification = true;
<%
	String arborescence = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("arborescence")));
String sPageAide = ESAPI.encoder().encodeForJavaScript(ESAPI.encoder().canonicalize(request.getParameter("pageAide")));
	
	
	
	 ListeDynamique listeDynamique = new ListeDynamique(); 
	 Hashtable hKeyList= new Hashtable();
     hKeyList.put("userid", ""+((com.socgen.bip.user.UserBip)session.getAttribute("UserBip")).getInfosUser());
	
	 int size=5;
	 String sizelist = String.valueOf(size);
	
	try{
        		
    java.util.ArrayList list1 = listeDynamique.getListeDynamique("paramChamp",hKeyList); 
    pageContext.setAttribute("choixChamp", list1);
    
    java.util.ArrayList list2 = listeDynamique.getListeDynamique("paramChampSelect",hKeyList); 
    pageContext.setAttribute("choixChampSelect", list2);
    
       if ( list1.size() > list2.size())
            sizelist = String.valueOf(list1.size());
       else
            sizelist = String.valueOf(list2.size());
    
    } catch (Exception e) {
    pageContext.setAttribute("choixCf", new java.util.ArrayList());
    %>alert("<%= listeDynamique.getErrorBaseMsg() %>");<%
   }
	
	
	  

%>
var pageAide = "<%= sPageAide %>";


function MessageInitial()
{
   var Message="<bean:write filter="false"  name="paramLigneBipForm"  property="msgErreur" />";
   var Focus = "<bean:write name="paramLigneBipForm"  property="focus" />";
   if (Message != "") {
      alert(Message);
   }
  
  
}

function Verifier(form, action, flag, type_action)
{
   
   for (i = 0; i < document.forms[0].champselect.length; i++)
      document.forms[0].champselect.options[i].selected=true;
          
   blnVerification = flag;
   form.action.value = action;
   form.type_action.value = type_action;
   
} 


function Verifier_init(form, action, flag, type_action)
{
                
   blnVerification = flag;
   form.action.value = action;
   form.type_action.value = type_action;
   
} 

function ValiderEcran(form)
{
     return true;
}



function selSwitch(btn)
{
   var i= btnType = 0;
   var isList1 = doIt = false;

   if (btn.value == "  >  " || btn.value == "  <  ") 
      btnType = 1;
   else if (btn.value == " >> " || btn.value == " << ") 
      btnType = 2;
   else
      btnType = 3;

   with (document.forms[0])
   {
      isList1 = (btn.value.indexOf('>') != -1) ? true : false;     

      with ( ((isList1)? champ: champselect) )
      {
         for (i = 0; i < length; i++)
         {
            doIt = false;
            if (btnType == 1)
            { 
               if(options[i].selected) doIt = true;
            }
            else if (btnType == 2)
            {
               doIt = true;
            } 
            else 
               if (!options[i].selected) doIt = true;
             
            if (doIt)
            {
               with (options[i])
               {
                  if (isList1)
                     champselect.options[champselect.length] 
                     = new Option( text, value );
                  else
                     champ.options[champ.length] 
                     = new Option( text, value );
               } 
               options[i] = null;
               i--;
            } 
            if(navigator.appName == "Netscape" ) 
              history.go(0);

         } // end for loop
         if (options[0] != null)
            options[0].selected = true;
      } // end with islist1
   } // end with document
   
   
    if ( document.forms[0].champ.length > document.forms[0].champselect.length)
    {
        document.forms[0].champ.size = document.forms[0].champ.length;  
        document.forms[0].champselect.size = document.forms[0].champ.length;
    } 
    else
    {
        document.forms[0].champ.size = document.forms[0].champselect.length;
        document.forms[0].champselect.size = document.forms[0].champselect.length;
    }
   
   
}

function doSel(selObj)
{
   var i = 0;
   for (i = 0; i < selObj.length; i++)
      alert("The value is '" + selObj.options[i].value + "'");

}



</script>
<!-- #EndEditable -->  


</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0" onLoad="MessageInitial();">
<div id="mainContainer">
<div id="topContainer">
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
            <div id="outils" align="center"><!-- #BeginEditable "barre_haut" -->
              <%ToolBarNew tb = new com.socgen.ich.ihm.ToolBarNew("bip_ihm",false,false,true,true,false,false,false,false,false,request) ;%>
				<%=tb.printHtml()%><!-- #EndEditable -->
		</div>
          </td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
        </tr>
<!--         <tr>  -->
<!--           <td background="../images/ligne.gif"></td> -->
<!--         </tr> -->
        <tr> 
          <td height="20" class="TitrePage"><!-- #BeginEditable "titre_page" -->Sélection de champs<!-- #EndEditable --></td>
        </tr>
        <tr> 
          <td background="../images/ligne.gif"></td>
        </tr>
        <tr> 
          <td>
		  <!-- #BeginEditable "debut_form" -->
		  <html:form action="/paramLigneBip.do" enctype="multipart/form-data" onsubmit="return ValiderEcran(this);">
		  <div align="center"><!-- #BeginEditable "contenu" -->
           <input type="hidden" name="pageAide" value="<%= sPageAide %>">
            
<html:hidden property="arborescence" value="<%= arborescence %>"/>
<html:hidden property="action" value="creer"/>
			<html:hidden property="type_action" value="modifier"/>
             
             
             
             <table width="70%" border="0" align=center>
<TBODY>            
	          <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                          
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="2">&nbsp;</td>
                </tr>
                
              <tr align="left">
                <td align="middle" class="TitrePage"><b>Champs non restitués</b></td>
                <td align="middle">&nbsp;</td>
                <td align="middle">&nbsp;</td>
                <td align="middle">&nbsp;</td>
                <td align="middle" class="TitrePage"><b>Champs affichés</b></td>
              </tr>  
                
              <tr>
                    <td align="middle">
                    
                    <html:select property="champ" multiple="true" size="<%= sizelist %>">
						  <bip:options collection="choixChamp"/>
				 	 </html:select>
                    
                    </td>
                    <td align="middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    <td align="middle">
                    	<input type="button" value="  &gt;  " onclick="selSwitch(this);"> 
                    	<input type="button" value="  &lt;  " onclick="selSwitch(this);"><br><br>
                    	<input type="button" value=" &gt;&gt; " onclick="selSwitch(this);">
                    	<input type="button" value=" &lt;&lt; " onclick="selSwitch(this);"><br><br>
                    </td>
                    <td align="middle">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                    
                    <td align="middle">
                    
                    <html:select property="champselect" multiple="true" size="<%= sizelist %>">
						  <html:options collection="choixChampSelect" property="cle" labelProperty="libelle" />
				 	 </html:select>
                    
                    </td>
                    
                   
                </tr>
</TBODY>            </table>
                      

		
            <table  width="100%" border="0" cellspacing="0" cellpadding="0">
					   
					  																							
			 			<tr><td height ="15" colspan="4">&nbsp;
			 			</tr>
			 			<tr>
		              		<td width="15%">&nbsp;</td>
		              			                	<td width="20%">
		                	 <div align="center">
		                	  <html:submit property="boutonValider" value="Valider" styleClass="input" onclick="Verifier(this.form, 'valider', true, 'valider_selection');"/>
		                	 </div>
		               		</td> 
		               		
		               		<td width="20%">
		                	<div align="center">
		                	  <html:submit property="boutonInitialiser" value="Initialiser" styleClass="input" onclick="Verifier_init(this.form, 'modifier', true, 'modifier_selection');"/>
		                	 </div>
		               		</td> 
		               		
		               		<td width="20%"> 
		                  	 <div align="center"> 
		                	  <html:submit property="boutonAnnuler" value="Annuler" styleClass="input" onclick="Verifier(this.form, 'annuler', false, 'type_action');"/>
		              		 </div>
		                </td>
		                <td width="15%">&nbsp;</td>
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
