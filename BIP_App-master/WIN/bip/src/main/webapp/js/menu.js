var items = new Array() ;

function Item(prnt, nm, lnk, alt, aide)
{
	this.id = items.length ;
	items[this.id] = this ;
	this.parent = prnt ;
	this.ouvert = false ;
	this.link = lnk ;
	this.nom = nm ;
	this.fils = new Array() ;
	this.profondeur = 1 ;
	this.menu = null ;
	this.parentId = null;

	
	this.ouvrir = itemOuvrir ;
	this.fermer = itemFermer ;
	this.estOuvert = itemEstOuvert ;
	this.getHtml = itemGetHtml ;
	this.addFils = itemAddFils ;
	this.setMenu = itemSetMenu ;
	this.alt = alt;
	this.aide = aide;

	if (this.parent == null)
	{
		this.profondeur = 1 ;
	}
	else
	{
		this.profondeur = this.parent.profondeur + 1 ;	
		this.parent.addFils(this) ;
		this.parentId = this.parent.id;
	}
}

function itemSetMenu(menu)
{
	this.menu = menu ; 	
	
}

function itemOuvrir()
{
	this.ouvert = true ;
}

function itemFermer()
{
	this.ouvert = false ;
}

function itemEstOuvert()
{
	return this.ouvert ;
}

function itemGetHtml()
{
	var item ;
    var balise;
	var html = "";
	
	if (this.profondeur == 1) {
		var balise ="<td >" ;
	}
	else {
		var balise ="<td style='border-left:1px solid black; border-right:1px solid black;'>" ;
	}
	//balise  += "<a class='OptionMenuOpen"+this.profondeur +"' href='javascript:toggle(" + this.id + ");' title='"+this.alt+"'>" ;
	balise  += "<a class='OptionMenuOpen"+this.profondeur +"' href='javascript:refreshFrame(" + this.id + ");' title='"+this.alt+"'>" ;
	
	if (this.profondeur == 1)
	{
		if (this.estOuvert()) {
			html = "<tr class='fondNoir'>";
			html += balise ;
			//html += "<img src='images/ferme.gif'  align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
		}
		else {
			html = "<tr class='fondGris'>";
			html += balise ;
			//html += "<img src='images/ferme.gif'  align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
		}
	}
	if (this.profondeur == 2)
	{
		if (this.estOuvert()) {
			if (this.fils.length > 0) {
				html = "<tr class='fondBlanc'>";
				html += balise ;
				html += "<img src='images/fleche_noire_bas.gif' border=0 alt='"+this.alt+"'>" ;
			}
			else {
				html = "<tr class='fondGrisClair'>";
				html += balise ;
				html += "<img src='images/losange_noir.gif' align=texttop border=0 height=14 alt='"+this.alt+"'> &nbsp;" ;
			}
		}
		else {
			html = "<tr class='fondBlanc'>";
			html += balise ;
			html += "<img src='images/fleche_noire.gif'  border=0 alt='"+this.alt+"'>  &nbsp;" ;
		}
	}
	if (this.profondeur == 3)
	{
		if (this.estOuvert()) {
			if (this.fils.length > 0) {
				html = "<tr class='fondBlanc'>";
				html += balise ;
				html += "<img src='images/fleche_noire_bas.gif'  border=0 alt='"+this.alt+"'>" ;
			}
			else {
				html = "<tr class='fondGrisClair'>";
				html += balise ;
				html += "<img src='images/losange_noir.gif' align=texttop  border=0 height=14 alt='"+this.alt+"'> &nbsp;" ;
			}
		}
		else {
			html = "<tr class='fondBlanc'>";
			html += balise ;
			html += "<img src='images/fleche_noire.gif'  border=0 alt='"+this.alt+"'> &nbsp;" ;
		}
	}
	if (this.profondeur == 4)
	{
		if (this.estOuvert()) {
			if (this.fils.length > 0) {
				html = "<tr class='fondBlanc'>";
				html += balise ;
				html += "<img src='images/fleche_noire_bas.gif'  border=0 alt='"+this.alt+"'>" ;
			}
			else {
				html = "<tr class='fondGrisClair'>";
				html += balise ;
				html += "<img src='images/losange_noir.gif' align=texttop border=0 height=14 alt='"+this.alt+"'> &nbsp;" ;
			}
		}
		else {
			html = "<tr class='fondBlanc'>";
			html += balise ;
			html += "<img src='images/fleche_noire.gif'  border=0 alt='"+this.alt+"'> &nbsp;" ;
		}
	}
	
	/*if (this.estOuvert())
	{		
			if (this.profondeur = 1){
				html = "<tr class='fond4'>";
				html += balise ;
				html += "<img src='images/ferme.gif'  align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
			}
			else {
				if (this.fils.length > 0){
			 		html = "<tr>";
					html += balise ;
					html += "<img  src='images/ouvert.gif' align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
				}
				else {
			 		html = "<tr class='fond2'>";
					html += balise ;
					html += "<img border='0' src='images/puce.gif'  align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
			
					this.ouvert = false ;
				}
			}
	}
	else
	{       
			if (this.profondeur = 1){
					html = "<tr class='fond3'>";
					html += balise ;
					html += "<img src='images/ferme.gif'  align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
			}
			else {
				html = "<tr class='fond3'>";
				html += balise ;
				html += "<img src='images/ferme.gif'  align=texttop border=0 height=14 alt='"+this.alt+"'>" ;
			}
	}*/
		
	html += this.nom + "</a>" ;	
	html += "</td>" ;
	html += "</tr>" ;

	
	if (this.estOuvert())
	{
		for (var i = 0; i < this.fils.length; i++)
		{ //Afficher le niveau suivant
			item = this.fils[i] ;
			html += item.getHtml() ;
		}
	}

	return html ;
}

function itemAddFils(element)
{
	if (element != null)
	{
		this.fils[this.fils.length] = element ;
	}
}


function Menu()
{
	this.afficher = menuAfficher ;
}

//Fonction qui permet l'affichage du menu
function menuAfficher()
{
	var item ;
	var html = "<table width='100%' border='0' cellpadding='0' cellspacing='0' >" ;

	for (var i = 0; i < items.length; i++)
	{
		item = items[i] ;
		
		if (item.profondeur == 1)
		{
			html += item.getHtml() ;
			
		}
		
	}
	
	html += "</table>" ;

	return html ;	
}

//Fonction qui permet de rafra?chir le menu
function toggle(index)
{
	var item = items[index] ;
	
	 refreshMenu(index);

	
	//on recupere le pathname complet, on fait un split pour recuperer les elements du chemin
	//a l'index 1 on a le 'bip'
	//var sPageAide = '/'+self.document.location.pathname.split('/')[1]+'/';
	//sPageAide = sPageAide + "jsp/"+item.aide;
	
	if (item.link != null)
	{
		parent.frames.main.location = item.link+"&indexMenu="+index;
	}
	else {
		parent.frames.main.location = "/listeFavoris.do?pageAide="+item.aide+"&addFav=no&action=initialiser";





		
	}
		
	
}

//Fonction de rafraichissement des frames
function refreshFrame(index) {
  
	if (index!=null) {
		parent.frames.menu.location = "javascript:toggle("+index+");";
		
		}
	    
	
}

//Fonction de rafraichissement du menu, juste la frame de gauche
function refreshMenu(index) {
  
	var item = items[index] ;
	this.tabParent = new Array() ;
	item.ouvert = !item.ouvert ;
	
	 
	
	//r?cup?rer tous les anc?tres
	getParent(index) ;
		
	if (item.parentId == null ) {
		//fermer toutes les entre?s sauf racine sel?ctionn?e
		for (var i = 0; i < items.length; i++)
	   {
	    if (i !=index )
			items[i].ouvert = false ;
		}
		
    }
  	else {
  	  for (var i = 0; i < items.length; i++)
	   {
	   		items[i].ouvert = false;
	   		for (var j= 0; j < this.tabParent.length; j++) {
	   	
	   		 if (i ==index ) {
	   		   items[i].ouvert = true;
	   		 }
	   		
	   		if (i ==this.tabParent[j]) {
				items[i].ouvert = true;
			}	
			
			}//for
		}//for
  	
  	}//else

	initMenu() ;
	    
	
}

//Fonction qui met dans un tableau tous les anc?tres
function getParent(index) {
   	var item = items[index] ;
	var parent = item.parentId;
	
	if (parent!=null) {
	 this.tabParent[this.tabParent.length]=parent;
	  getParent(parent);
	}
	
}