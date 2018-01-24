package com.socgen.bip.metier;

public class InfosDirection {
	
	private String coddir;
	private String libdir;
	private String lienHref;
	
	public InfosDirection(String coddir, String libdir, String lienHref) {
		super();
		this.coddir = coddir;
		this.libdir = libdir;
		this.lienHref = lienHref;
		
	
		
	}
	
	public InfosDirection(String coddir, String libdir) {
		super();
		this.coddir = coddir;
		this.libdir = libdir;
		
	}

	public InfosDirection() {
		super();
		// TODO Raccord de constructeur auto-généré
	}
	public String getCoddir() {
		return coddir;
	}

	public void setCoddir(String coddir) {
		this.coddir = coddir;
	}

	public String getLibdir() {
		return libdir;
	}

	public void setLibdir(String libdir) {
		this.libdir = libdir;
	}

	public String getLienHref() {
		return lienHref;
	}

	public void setLienHref(String lienHref) {
		this.lienHref = lienHref;
	}

	
}
