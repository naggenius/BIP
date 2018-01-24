var min_x_size = 750;
var min_y_size = 410;

function yg_verif_navigateur(){
	this.ver=navigator.appVersion
	this.dom=document.getElementById?1:0
	this.ie5=(this.ver.indexOf("MSIE 5")>-1 && this.dom)?1:0;
	this.ie6=(this.ver.indexOf("MSIE 6")>-1 && this.dom)?1:0;
	this.ie7=(this.ver.indexOf("MSIE 7")>-1 && this.dom)?1:0;
	this.ie4=(document.all && !this.dom)?1:0;
	this.ie=this.ie4||this.ie5|| this.ie6 || this.ie7;
	this.ff=(this.dom && navigator.userAgent.indexOf("Firefox")>-1)?1:0;
	this.ns5=(this.dom && parseInt(this.ver) >= 5) ?1:0; 
	this.ns4=(document.layers && !this.dom)?1:0;
	this.bw=(this.ie5 || this.ie4 || this.ie6 || this.ns4 || this.ns5 ||this.ie7||this.ff)
	return this
}

function yg_taille_document(){ 
	this.x=0;this.x2=bw.ie && document.body.offsetWidth-20||innerWidth||0;
	this.y=0;this.y2=bw.ie && document.body.offsetHeight-5||innerHeight||0;
	return this;
}

function yg_verif_pourcent(num,w){
	if(num){
		if(num.toString().indexOf("%")!=-1){
			if(w) {
				num=(page.x2*parseFloat(num)/100);
				if(num<min_x_size) num=min_x_size;
			}
			else {
				num=(page.y2*parseFloat(num)/100);
				if(num<min_y_size) num=min_y_size;
			}
		}else num=parseFloat(num)
	}else num=0
	return num
}

function yg_message_alerte(txt){
	alert(txt)
	return false
}

function yg_objet(obj,nest){
	function yg_deplacer(x,y){ //D?placement vers une position sp?cifique  
		x= yg_verif_pourcent(x,true);
	        y=yg_verif_pourcent(y,false);
	        this.x=x;this.y=y
	        this.css.left=x;this.css.top=y
	}
	function yg_deplacer_de(x,y){ //D?placement d'un certain nombre de pixels
	        this.deplacer(this.x+x,this.y+y)
	}
	function yg_montrer(){ //Montrer un calque
	        this.css.visibility="visible"
	}
	function yg_cacher(){ //Masquer un calque
	        this.css.visibility="hidden"
	}
	function yg_couleur_fond(color){ //Changer la couleur de fond
	        if(bw.dom || bw.ie4) this.css.backgroundColor=color
	        else if(bw.ns4) this.css.bgColor=color  
	}
	function yg_ecrire(text,startHTML,endHTML){  //Ecrire le nouveau contenu dans le calque
	        if(bw.ns4){
	                if(!startHTML){startHTML=""; endHTML=""}
	                this.ref.open("text/html"); this.ref.write(startHTML+text+endHTML); this.ref.close()
	        }else this.evnt.innerHTML=text //NOTE: Fonctionne uniquement avec Explorer4+5 et Gecko M16+
	}
	function yg_redimensionner(t,r,b,l,setwidth){ //Redimensionner vers des donn?es sp?cifiques
	        r= yg_verif_pourcent(r,true);
	        b=yg_verif_pourcent(b,false);
		this.ct=t; this.cr=r; this.cb=b; this.cl=l
		if(bw.ns4){
			this.css.clip.top=t;this.css.clip.right=r
			this.css.clip.bottom=b;this.css.clip.left=l
		}else{
			if(t<0)t=0;if(r<0)r=0;if(b<0)b=0;if(b<0)b=0
			this.css.clip="rect("+t+","+r+","+b+","+l+")";
			if(setwidth){this.css.width=r; this.css.height=b}
		}
	}
	function yg_redimensionner_de(t,r,b,l,setwidth){ //Redimensionner d'un certain nombre de pixels
		this.redimensionner(this.ct+t,this.cr+r,this.cb+b,this.cl+l,setwidth)
	}
	function yg_change_couleur_texte(color){
		if(bw.ie4){
			this.evnt.children[0].style.color=color
		}else{
			this.evnt.childNodes[0].style.color=color
		}
	}
	function yg_ajuster_hauteur_contenu(largeur) { //Ajuste la hauteur de l'objet ? celle de son contenu
		largeur = yg_verif_pourcent(largeur,true);
	  	if(bw.ie || bw.ff){
	  		this.redimensionner(0,largeur,this.evnt.scrollHeight+2,0,1);
	  	}else{
			window.document.height = this.ref.height +  this.y +2;
	  		this.redimensionner(0,largeur,this.ref.height,0,1);
		}
	}
	if(!bw.bw) return message('Old browser')
	this.evnt=bw.dom && document.getElementById(obj)||bw.ie4 && document.all[obj]|| (nest?bw.ns4 && document[nest].document[obj]:bw.ns4 && document.layers[obj]);
	if(!this.evnt) return yg_message_alerte('The layer does not exist ('+obj+') - Exiting script\n\nIf your using Netscape please check the nesting of your tags!')
	this.css=bw.dom||bw.ie4?this.evnt.style:this.evnt;
	this.ref=bw.dom||bw.ie4?document:this.css.document;
	this.x=this.css.left||this.css.pixelLeft||this.evnt.offsetLeft||0
	this.y=this.css.top||this.css.pixelTop||this.evnt.offsetTop||0
	this.w=yg_verif_pourcent(this.ref.width||this.evnt.offsetWidth||this.css.pixelWidth||0,true)
	this.h=yg_verif_pourcent(this.ref.height||this.evnt.offsetHeight||this.css.pixelHeight||0,false)
	this.deplacer=yg_deplacer; this.deplacer_de=yg_deplacer_de; 
	this.montrer=yg_montrer; this.cacher=yg_cacher;
	this.ecrire=yg_ecrire; this.couleur_fond=yg_couleur_fond;
	this.couleur_texte=yg_change_couleur_texte;
	//Clip values
	this.c=0
	if((bw.dom || bw.ie4) && this.css.clip) {
		this.c=this.css.clip; this.c=this.c.slice(5,this.c.length-1); 
		this.c=this.c.split(' '); 
		for(var i=0;i<4;i++){this.c[i]=parseInt(this.c[i])}
	}
	this.ct=this.css.clip.top||this.c[0]||0; 
	this.cr=this.css.clip.right||this.c[1]||this.w||0
	this.cb=this.css.clip.bottom||this.c[2]||this.h||0; 
	this.cl=this.css.clip.left||this.c[3]||0
	this.redimensionner=yg_redimensionner;	this.redimensionner_de=yg_redimensionner_de;
	this.ajuster = yg_ajuster_hauteur_contenu;
	this.obj = obj + "Object"; 	eval(this.obj + "=this")
	return this
}