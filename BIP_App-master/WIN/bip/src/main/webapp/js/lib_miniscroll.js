// MiniScroll Object
// gives controls to a set of 2 layers for scrolling
// 19990410

// Copyright (C) 1999 Dan Steinman
// Distributed under the terms of the GNU Library General Public License
// Available at http://www.dansteinman.com/dynapi/

function MiniScroll(content, hauteurclip, largeurclip) {
	this.content = content
	this.content.slideTo = DynLayerSlideTo
	this.content.slideStart = DynLayerSlideStart
	this.content.slide = DynLayerSlide	
	this.content.moveTo = DynLayerMoveTo
	this.content.moveBy = DynLayerMoveBy	
	this.content.onSlide = new Function()
	this.content.onSlideEnd = new Function()
	this.content.slideActive = false	
	this.inc = 8
	this.speed = 20
	this.contentHeight = this.content.h
	this.contentWidth = this.content.w
	this.clipHeight = hauteurclip
	this.clipWidth = largeurclip
	this.up = MiniScrollUp
	this.down = MiniScrollDown
	this.left = MiniScrollLeft
	this.right = MiniScrollRight
	this.stop = MiniScrollStop
	this.activate = MiniScrollActivate
	this.activate(this.contentWidth,this.contentHeight)
}
function MiniScrollActivate() {
	this.offsetHeight = this.contentHeight
	this.offsetWidth = this.contentWidth
	this.enableVScroll = (this.offsetHeight>0)
	this.enableHScroll = (this.offsetWidth>0)
}
function MiniScrollUp() {
    
	if (this.enableVScroll) this.content.slideTo(null,0,this.inc,this.speed, this.clipHeight, this.clipWidth)
}
function MiniScrollDown() {
    //alert('yag');
	if (this.enableVScroll) this.content.slideTo(null,-this.offsetHeight,this.inc,this.speed, this.clipHeight, this.clipWidth)
}
function MiniScrollLeft() {
	if (this.enableHScroll) this.content.slideTo(0,null,this.inc,this.speed, this.clipHeight, this.clipWidth)
}
function MiniScrollRight() {
	if (this.enableHScroll) this.content.slideTo(-this.offsetWidth,null,this.inc,this.speed, this.clipHeight, this.clipWidth)
}
function MiniScrollStop() {
	this.content.slideActive = false
}

// Slide Methods
function DynLayerSlideTo(endx,endy,inc,speed, hauteurclip, largeurclip,fn) {
	if (endx==null) endx = this.x
	if (endy==null) endy = this.y
	var distx = endx-this.x
	var disty = endy-this.y
	this.slideStart(endx,endy,distx,disty,inc,speed, hauteurclip, largeurclip,fn)
}

function DynLayerSlideStart(endx,endy,distx,disty,inc,speed, hauteurclip, largeurclip,fn) {
	if (this.slideActive) return
	if (!inc) inc = 10
	if (!speed) speed = 20
	var num = Math.sqrt(Math.pow(distx,2) + Math.pow(disty,2))/inc
	if (num==0) return
	var dx = distx/num
	var dy = disty/num
	if (!fn) fn = null
	this.slideActive = true
	this.slide(dx,dy,endx,endy,num,1,speed, hauteurclip, largeurclip,fn)
}

function DynLayerSlide(dx,dy,endx,endy,num,i,speed, hauteurclip, largeurclip,fn) {
	if (!this.slideActive) return
	if (i++ < num) {
		this.moveBy(dx,dy, hauteurclip, largeurclip)
		this.onSlide()
		if (this.slideActive) setTimeout(this.obj+".slide("+dx+","+dy+","+endx+","+endy+","+num+","+i+","+speed+","+hauteurclip+","+largeurclip+",\""+fn+"\")",speed)
		else this.onSlideEnd()
	}
	else {
		this.slideActive = false
		this.moveTo(endx,endy, hauteurclip, largeurclip)
		this.onSlide()
		this.onSlideEnd()
		eval(fn)
	}
}

function DynLayerMoveTo(x,y, b, r) {
	old_x = this.x
	if (x!=null) {
		this.x = x;
		this.css.left=x; }
	old_y = this.y	
	if (y!=null) {
		this.y = y;
		this.css.top=y; }

	t = this.ct+ (old_y-this.y)
	l = this.cl+ (old_x-this.x)
				
	this.ct=t; this.cr=r; this.cb=b; this.cl=l
	if(bw.ns4){
		this.css.clip.top=t;this.css.clip.right=r
		this.css.clip.bottom=b;this.css.clip.left=l
	}else{
		if(t<0)t=0;if(r<0)r=0;if(b<0)b=0;if(b<0)b=0
		this.css.clip="rect("+t+","+r+","+b+","+l+")";
	}
	this.css.width=r; this.css.height=b
}

function DynLayerMoveBy(x,y, hauteurclip, largeurclip) {
	this.moveTo(this.x+x,this.y+y, hauteurclip, largeurclip)
}
