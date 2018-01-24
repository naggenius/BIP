package com.socgen.bip.metier;

public class InfosBranche {
	
	private String codbr;
	private String libbr;
	private String combr;
	private String lienHref;
	
	public InfosBranche(String codbr, String libbr, String combr, String lienHref) {
		super();
		this.codbr = codbr;
		this.libbr = libbr;
		this.combr = combr;
		this.lienHref = lienHref;
		
	
		
	}
	
	public InfosBranche(String codbr, String libbr, String combr) {
		super();
		this.codbr = codbr;
		this.libbr = libbr;
		this.combr = combr;
		
	}

	public InfosBranche() {
		super();
		// TODO Raccord de constructeur auto-généré
	}
	public String getCodbr() {
		return codbr;
	}

	public void setCodbr(String codbr) {
		this.codbr = codbr;
	}

	public String getLibbr() {
		return libbr;
	}

	public void setLibbr(String libbr) {
		this.libbr = libbr;
	}

	public String getLienHref() {
		return lienHref;
	}

	public void setLienHref(String lienHref) {
		this.lienHref = lienHref;
	}

	public String getCombr() {
		return combr;
	}

	public void setCombr(String combr) {
		this.combr = combr;
	}
	
}
