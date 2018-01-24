package com.socgen.bip.excell;

import java.io.IOException;
import java.io.InputStream;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPrintSetup;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;


public class DocumentExcell {

	private HSSFWorkbook wb;
	private HSSFFont fontTitre;
	private HSSFFont fontEntete;
	private HSSFFont fontNormal;
	
	private HSSFCellStyle styleTitre;
	private HSSFCellStyle styleNormal;
	private HSSFCellStyle styleNormalDate;
	private HSSFCellStyle styleEntete;
	private HSSFCellStyle styleEntete1;
	private HSSFCellStyle styleEntete1Gauche;
	private HSSFCellStyle styleEntete1Droite;
	private HSSFCellStyle styleEntete2;
	private HSSFCellStyle styleEntete2Gauche;
	private HSSFCellStyle styleEntete2Droite;
	private HSSFCellStyle styleCell0;
	private HSSFCellStyle styleTableau;
	private HSSFCellStyle styleTableauGauche;
	private HSSFCellStyle styleTableauDroite;
	private HSSFCellStyle styleTableauDate;
	private HSSFCellStyle styleTableauGaucheDate;
	private HSSFCellStyle styleTableauDateHeure;
	private HSSFCellStyle styleTableauMontant;
	private HSSFCellStyle styleTableauPourcent;
	private HSSFCellStyle styleTableauCentre;
	private HSSFCellStyle StyleColonneError;

	public DocumentExcell() {
		wb = new HSSFWorkbook();
		init();
	}

	public DocumentExcell(InputStream input) throws IOException {
		wb = new HSSFWorkbook(input);
		init();
	}

	private void init() {
		initFontTitre();
		initFontEntete();
		initFontNormal();

		initStyleTitre();
		initStyleNormal();
		initStyleNormalDate();
		initStyleEntete();
		initStyleEntete1();
		initStyleEntete1Gauche();
		initStyleEntete1Droite();
		initStyleEntete2();
		initStyleEntete2Gauche();
		initStyleEntete2Droite();
		initStyleCell0();
		initStyleTableau();
		initStyleTableauGauche();
		initStyleTableauDroite();
		initStyleTableauDate();
		initStyleTableauGaucheDate();
		initStyleTableauDateHeure();
		initStyleTableauMontant();
		initStyleTableauPourcent();
		initStyleTableauCentre();
		initStyleColonneError();
	}
	
	public HSSFWorkbook getWb() {
		return this.wb;
	}
	
	public HSSFSheet createSheet(String nom) {
		HSSFSheet sheet = this.wb.createSheet(nom);
		sheet.setAutobreaks(true);
		sheet.setFitToPage(true);
		sheet.setMargin(HSSFSheet.LeftMargin, 0);
		sheet.setMargin(HSSFSheet.RightMargin, 0);
		sheet.setMargin(HSSFSheet.TopMargin, 0);
		sheet.setMargin(HSSFSheet.BottomMargin, 0);

		sheet.getPrintSetup().setPaperSize(HSSFPrintSetup.A4_PAPERSIZE);
		sheet.getPrintSetup().setLandscape(true);
		sheet.getPrintSetup().setFitHeight((short) 800);
		sheet.getPrintSetup().setFitWidth((short) 1);
		return sheet;
	}
	
	private void initFontTitre(){
		this.fontTitre=this.wb.createFont();
		this.fontTitre.setFontHeightInPoints((short)12);
		this.fontTitre.setFontName("Arial");
		this.fontTitre.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	}

	/**
	  * Méthode permettant d'initialiser le style de la police de caractère utilisée dans l'en-tête du tableau
	  */

	private void initFontEntete(){
		this.fontEntete = this.wb.createFont();
		this.fontEntete.setFontHeightInPoints((short)10);
		this.fontEntete.setFontName("Arial");
		this.fontEntete.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
	}

	/**
	  * Méthode permettant d'initialiser le style de la police de caractère utilisée dans le corps du tableau
	  */

	private void initFontNormal(){
		this.fontNormal = this.wb.createFont();
		this.fontNormal.setFontHeightInPoints((short)10);
		this.fontNormal.setFontName("Arial");
	}

	private void initStyleTitre() {
		this.styleTitre = this.wb.createCellStyle();
		this.styleTitre.setFont(this.fontTitre);
	}
	
	public HSSFCellStyle getStyleTitre() { 
		return this.styleTitre;
	}

	private void initStyleNormal() {
		this.styleNormal = this.wb.createCellStyle();
		this.styleNormal.setFont(this.fontNormal);
	}
	
	public HSSFCellStyle getStyleNormal() { 
		return this.styleNormal;
	}

	private void initStyleNormalDate() {
		this.styleNormalDate = this.wb.createCellStyle();
		this.styleNormalDate.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy"));
		this.styleNormalDate.setFont(this.fontNormal);
	}
	
	public HSSFCellStyle getStyleNormalDate() { 
		return this.styleNormalDate;
	}


	private void initStyleEntete() {
		this.styleEntete = this.wb.createCellStyle();
		this.styleEntete.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		this.styleEntete.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		this.styleEntete.setBorderRight(HSSFCellStyle.BORDER_THIN);
		this.styleEntete.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		this.styleEntete.setFont(this.fontEntete);
	}
	
	public HSSFCellStyle getStyleEntete() { 
		return this.styleEntete;
	}


	private void setStyleEntete1(HSSFCellStyle style) {
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.NO_FILL);
		style.setBorderRight(HSSFCellStyle.NO_FILL);
		style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		style.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		style.setFont(this.fontEntete);
	}

	private void initStyleEntete1() {
		this.styleEntete1 = this.wb.createCellStyle();
		setStyleEntete1(this.styleEntete1);
	}

	public HSSFCellStyle getStyleEntete1() { 
		return this.styleEntete1;
	}

	private void initStyleEntete1Gauche() {
		this.styleEntete1Gauche = this.wb.createCellStyle();
		setStyleEntete1(this.styleEntete1Gauche);
		this.styleEntete1Gauche.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
	}

	public HSSFCellStyle getStyleEntete1Gauche() { 
		return this.styleEntete1Gauche;
	}

	private void initStyleEntete1Droite() {
		this.styleEntete1Droite = this.wb.createCellStyle();
		setStyleEntete1(this.styleEntete1Droite);
		this.styleEntete1Droite.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
	}

	public HSSFCellStyle getStyleEntete1Droite() { 
		return this.styleEntete1Droite;
	}


	private void setStyleEntete2(HSSFCellStyle style) {
		style.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderTop(HSSFCellStyle.BORDER_THIN);
		style.setFillForegroundColor(HSSFColor.LIGHT_CORNFLOWER_BLUE.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		style.setFont(this.fontNormal);
	}

	private void initStyleEntete2() {
		this.styleEntete2 = this.wb.createCellStyle();
		setStyleEntete2(this.styleEntete2);
	}

	public HSSFCellStyle getStyleEntete2() { 
		return this.styleEntete2;
	}

	private void initStyleEntete2Gauche() {
		this.styleEntete2Gauche = this.wb.createCellStyle();
		setStyleEntete2(this.styleEntete2Gauche);
		this.styleEntete2Gauche.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
	}

	public HSSFCellStyle getStyleEntete2Gauche() { 
		return this.styleEntete2Gauche;
	}

	private void initStyleEntete2Droite() {
		this.styleEntete2Droite = this.wb.createCellStyle();
		setStyleEntete2(this.styleEntete2Droite);
		this.styleEntete2Droite.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
	}

	public HSSFCellStyle getStyleEntete2Droite() { 
		return this.styleEntete2Droite;
	}

	private void initStyleCell0() {
		this.styleCell0 = this.wb.createCellStyle();
		this.styleCell0.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		this.styleCell0.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
		this.styleCell0.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
		this.styleCell0.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		this.styleCell0.setFont(this.fontEntete);
	}

	public HSSFCellStyle getStyleCell0() {
		return this.styleCell0;
	}

	
	private void setStyleTableau(HSSFCellStyle style) {
		style.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		style.setBorderLeft(HSSFCellStyle.BORDER_THIN);
		style.setBorderRight(HSSFCellStyle.BORDER_THIN);
		style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		style.setFont(this.fontNormal);
	}

	private void initStyleTableau() {
		this.styleTableau = this.wb.createCellStyle();
		setStyleTableau(this.styleTableau);
	}

	public HSSFCellStyle getStyleTableau() {
		return this.styleTableau;
	}

	private void initStyleTableauGauche() {
		this.styleTableauGauche = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauGauche);
		this.styleTableauGauche.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
	}

	public HSSFCellStyle getStyleTableauGauche() {
		return this.styleTableauGauche;
	}

	private void initStyleTableauDroite() {
		this.styleTableauDroite = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauDroite);
		this.styleTableauDroite.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
	}

	public HSSFCellStyle getStyleTableauDroite() {
		return this.styleTableauDroite;
	}

	private void initStyleTableauDate() {
		this.styleTableauDate = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauDate);
		this.styleTableauDate.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy"));
	}

	public HSSFCellStyle getStyleTableauDate() {
		return this.styleTableauDate;
	}

	private void initStyleTableauGaucheDate() {
		this.styleTableauGaucheDate = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauGaucheDate);
		this.styleTableauGaucheDate.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
		this.styleTableauGaucheDate.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy"));
	}

	public HSSFCellStyle getStyleTableauGaucheDate() {
		return this.styleTableauGaucheDate;
	}

	private void initStyleTableauDateHeure() {
		this.styleTableauDateHeure = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauDateHeure);
		this.styleTableauDateHeure.setDataFormat(HSSFDataFormat.getBuiltinFormat("m/d/yy h:mm"));
	}

	public HSSFCellStyle getStyleTableauDateHeure() {
		return this.styleTableauDateHeure;
	}

	private void initStyleTableauMontant() {
		this.styleTableauMontant = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauMontant);
		this.styleTableauMontant.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
	}

	public HSSFCellStyle getStyleTableauMontant() {
		return this.styleTableauMontant;
	}

	private void initStyleTableauPourcent() {
		this.styleTableauPourcent = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauPourcent);
		this.styleTableauPourcent.setDataFormat(HSSFDataFormat.getBuiltinFormat("0%"));
	}

	public HSSFCellStyle getStyleTableauPourcent() {
		return this.styleTableauPourcent;
	}

	private void initStyleTableauCentre() {
		this.styleTableauCentre = this.wb.createCellStyle();
		setStyleTableau(this.styleTableauCentre);
		this.styleTableauCentre.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	}

	public HSSFCellStyle getStyleTableauCentre() {
		return this.styleTableauCentre;
	}
	private void setStyleError(HSSFCellStyle style) {
		style.setBorderBottom(HSSFCellStyle.BORDER_THIN);
		style.setBorderLeft(HSSFCellStyle.NO_FILL);
		style.setBorderRight(HSSFCellStyle.NO_FILL);
		style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		style.setFillForegroundColor(HSSFColor.YELLOW.index);
		style.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		style.setFont(this.fontNormal);
	}
	private void initStyleColonneError()
	 {
		this.StyleColonneError = this.wb.createCellStyle();
		setStyleError(this.StyleColonneError);
		this.StyleColonneError.setAlignment(HSSFCellStyle.ALIGN_CENTER);
	}
	public HSSFCellStyle getStyleColonneError() {
		return this.StyleColonneError;
	}
	public void setCelluleVide(HSSFRow row, short colonne, HSSFCellStyle style) {
		HSSFCell cell = row.createCell(colonne);
		cell.setCellStyle(style);
	}

	public void setCellule(HSSFRow row, short colonne, String value, HSSFCellStyle style) {
		HSSFCell cell = row.createCell(colonne);
		if(value!=null)
			cell.setCellValue(value);
		else
			cell.setCellValue("");
		cell.setCellStyle(style);
		cell.setCellType(1);
	}

	public void setCellule(HSSFRow row, short colonne, double value, HSSFCellStyle style) {
		HSSFCell cell = row.createCell(colonne);
		cell.setCellValue(value);
		cell.setCellStyle(style);

	}

	public void setCellule(HSSFRow row, short colonne, Date value, HSSFCellStyle style) {
		HSSFCell cell = row.createCell(colonne);
		if (value != null) {
			cell.setCellValue(value);
		}
		cell.setCellStyle(style);
	}
	public void updateColorCelluleError(HSSFRow row, short colonne) {
		HSSFCell cell = row.getCell(colonne);
		cell.setCellStyle(StyleColonneError);
	}

}