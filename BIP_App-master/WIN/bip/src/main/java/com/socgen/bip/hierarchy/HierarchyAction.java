package com.socgen.bip.hierarchy;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFCellStyle;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.socgen.bip.commun.Tools;
import com.socgen.bip.commun.action.AutomateAction;
import com.socgen.bip.exception.ReportException;
import com.socgen.bip.user.UserBip;
import com.socgen.cap.fwk.config.Config;

public class HierarchyAction extends AutomateAction  {

	public static String P_PARAM8 = "P_param8";
	public static String P_PARAM7 = "P_param7";
	public static String P_PARAM6 = "P_param6";
	public static String P_PARAM1 = "P_param1";
	public static String P_PARAM9 = "P_param9";
	public static final String PARAM_DESNAME="desname";
	public static String HEADER_NAME = "Nom_Prenom";
	public static String HEADER_N = "N";
	public static String HEADER_LIGNE = "Nb lignes";
	public static String NO = "N";
	public static String YES = "Y";
	static int rowCount = 0;
	static int globalColumnCnt = 0;
	static int startVerticalLine = 10000;
	
	public static XSSFCellStyle selectioStyle;
	public static XSSFCellStyle inActiveStyle;
	public static XSSFCellStyle ligneBipCntStyle;
	public static XSSFCellStyle normalStyle;
	public static XSSFCellStyle headerStyle;
	public static XSSFCellStyle boarderLeftline;
	public static XSSFCellStyle boarderLeftTopline;
	public static XSSFCellStyle fullBoarder;
	public static XSSFCellStyle boarderLeftBottomline;

	/**
	 * Method to generate a Excel report for Hierarchy
	 * @param hParamReport
	 * @param sReportOut
	 * @param cfgReports 
	 * @param userBip 
	 * @throws IOException
	 * @throws ReportException 
	 */
	public String generateExcel(Hashtable<?, ?> hParamReport, String sReportOut,
			Config cfgReports, UserBip userBip) throws IOException, ReportException {

		String signatureMethode = "HierarchyAction - generateExcel()";
		logBipUser.entry(signatureMethode + " - Start");
		logBipUser.entry("hParamReport.get(P_PARAM8) - CHOICE : "+ hParamReport.get(P_PARAM8).toString());
		
		XSSFWorkbook workbook = new XSSFWorkbook();
		String ident;

		if ("1".equalsIgnoreCase(hParamReport.get(P_PARAM8).toString())	|| "2".equalsIgnoreCase(hParamReport.get(P_PARAM8).toString())) {
			ident = getIdent(hParamReport);
			try {
				workbook = writeWorkbook(workbook, hParamReport, sReportOut, ident,	cfgReports);
			} catch (ReportException e) {
				logBipUser.debug("HierarchyAction-generateExcel() --> Exception :"+ e.getMessage());
			}
		} else if ("4".equalsIgnoreCase(hParamReport.get(P_PARAM8).toString())) {
			logBipUser.debug("hParamReport.get(P_PARAM6) : "+ hParamReport.get(P_PARAM6).toString());
			ident = hParamReport.get(P_PARAM6).toString();
			ident = "*".equalsIgnoreCase(String.valueOf(ident.charAt(ident.length() - 1)))?ident.substring(0,ident.length() - 1):ident;
			workbook = writeWorkbook(workbook, hParamReport, sReportOut, hParamReport.get(P_PARAM6).toString(), cfgReports);
		} else {
			// if choice is in 3 or 5 write another block
			List<String> chefProjList = new ArrayList<String>();
			chefProjList = ("3".equalsIgnoreCase(hParamReport.get(P_PARAM8).toString())?userBip.getChefProjet():getChefProj(hParamReport, chefProjList));
			ident = ("3".equalsIgnoreCase(hParamReport.get(P_PARAM8).toString())?getIdent(hParamReport):hParamReport.get(P_PARAM7).toString());;
			for (String chefProj : chefProjList) {
				try {
					logBipUser.debug("***************************************************************");
					workbook = writeWorkbook(workbook, hParamReport,
							sReportOut, chefProj, cfgReports);
				} catch (Exception e) {
					logBipUser
							.debug("HierarchyAction-generateExcel() --> Exception :"
									+ e.getMessage() + " " + chefProj);
				}
			}
		}

		String sReportfolder = cfgReports.getString("extractParam.fichier");
		logBipUser.debug("End of Sheets Preparation - " + sReportfolder+(String) hParamReport.get(PARAM_DESNAME)+"_"+ident+".xlsx");		
		FileOutputStream outputStream = new FileOutputStream(sReportfolder+(String) hParamReport.get(PARAM_DESNAME)+"_"+ident+".xlsx");
		
		try {
			workbook.write(outputStream);
		} catch (Exception e) {
			logBipUser.debug("HierarchyAction-generateExcel() --> Exception :"
					+ e.getMessage());
			throw new ReportException(ReportException.REPORT_FAILURE, e);
		}

		logBipUser.entry(signatureMethode + " - End");
		
		return ident;
	}

	/**
	 * Method to return list of chef_projs for choice 3 and 5
	 * @param hParamReport
	 * @param chefProj
	 * @return
	 */
	private List<String> getChefProj(Hashtable<?, ?> hParamReport, List<String> chefProjList) {
		
		String signatureMethode = "HierarchyAction - getChefProj()";
		logBipUser.entry(signatureMethode+" - Start");
				
		String rtfe = null;
		
		if(null != hParamReport.get(P_PARAM7)){
			logBipUser.debug("P_PARAM7 - " +(String) hParamReport.get(P_PARAM7));	
			rtfe = hParamReport.get(P_PARAM7).toString();
		} else{
			logBipUser.debug("P_PARAM1 - " +(String) hParamReport.get(P_PARAM1));
			rtfe = hParamReport.get(P_PARAM1).toString();
		}
		logBipUser.debug("Chef_Proj :"+rtfe);
		//chefProjList is the ; seperated		 
		 chefProjList = Arrays.asList(Tools.getChefProj(rtfe, (String) hParamReport.get(P_PARAM1)).split(";"));
	
		logBipUser.entry(signatureMethode+" - End");				
		return chefProjList;
	}

	private void flushLocalVariables() {
		rowCount = 0;
		globalColumnCnt = 0;
		startVerticalLine = 10000;
		
	}

	/**
	 * Actual preparation of workbook
	 * @param workbook 
	 * @param hParamReport
	 * @param sReportOut
	 * @param ident 
	 * @param cfgReports 
	 * @param resultHierarchy 
	 * @throws FileNotFoundException
	 * @throws ReportException
	 */
	private XSSFWorkbook writeWorkbook(XSSFWorkbook workbook, Hashtable<?, ?> hParamReport, String sReportOut, String ident, Config cfgReports) throws FileNotFoundException, ReportException {

		String signatureMethode = "HierarchyAction - writeWorkbook()";
		logBipUser.entry(signatureMethode+" - Start");
				
		// TODO have to iterate below path for choice 3 and 5
			Map<Integer, List<ResultHierarchy>> resultHierarchy = new HashMap<Integer, List<ResultHierarchy>>();
			String choice = hParamReport.get(P_PARAM8).toString();
			logBipUser.debug("Actual Choice - " +choice);
			logBipUser.debug("ident - " +ident);
			logBipUser.debug("Start Time :" + new java.util.Date());
			
		if ((choice.equalsIgnoreCase("3") || choice.equalsIgnoreCase("4") || choice
				.equalsIgnoreCase("5"))
				&& "*".equalsIgnoreCase(String.valueOf(ident.charAt(ident
						.length() - 1)))) {
			choice = "2";
			ident = ident.substring(0,ident.length() - 1);
			logBipUser.debug("Override Choice - " +choice);

		} else {
			if(!choice.equalsIgnoreCase("2")){
				choice = "1";
				logBipUser.debug("Override Choice - " +choice);
			}
		}
		
			logBipUser.debug("Order by Clause :- " +(hParamReport.get(P_PARAM9).toString().equalsIgnoreCase("1")?"Leur code":"Leur Nom et prenom"));
			resultHierarchy = Tools.getHierarchyReportdata(ident, choice, hParamReport.get(P_PARAM1).toString(),hParamReport.get(P_PARAM9).toString());
			logBipUser.debug("End Time :" + new java.util.Date());
			
		if (!resultHierarchy.isEmpty()) {
			workbook = writeSheet(workbook, ident, resultHierarchy, choice);			
		}
		logBipUser.entry(signatureMethode+" - End");
		return workbook;
	}

	/**
	 * Method to get a Ident for case 1,2 and 4
	 * @param hParamReport
	 * @return ident
	 */
	private String getIdent(Hashtable<?, ?> hParamReport) {
		String signatureMethode = "HierarchyAction - getIdent()";
		logBipUser.entry(signatureMethode+" - Start");
		String ident = null;
		if (null != hParamReport.get(P_PARAM1)) {
			ident = Tools.getIdentHierarchy(hParamReport.get(P_PARAM1)
					.toString());
		}
		logBipUser.debug("ident : " + ident);
		logBipUser.entry(signatureMethode+" - End");
		return ident;
	}

	/**
	 * Method to generate sheet - can be reusable
	 * @param workbook
	 * @param ident 
	 * @param choice 
	 * @return sheet
	 */
	private XSSFWorkbook writeSheet(XSSFWorkbook workbook, String ident, Map<Integer, List<ResultHierarchy>> resultHierarchy, String choice) {

		String signatureMethode = "HierarchyAction - writeSheet()";
		logBipUser.entry(signatureMethode + " - Start");
		int columnCount = -1;

		XSSFSheet sheet = workbook.createSheet("ress " + ident + (choice.equalsIgnoreCase("2")?"x":"").trim());
		workbook = confStyles(workbook);

		setStyles(workbook);
		Row row = null;

		for (Map.Entry<Integer, List<ResultHierarchy>> entry : resultHierarchy
				.entrySet()) {
			// this loop should iterate only 1 time
			Cell cell = null;
			insertData(workbook, sheet, row, cell, columnCount,
					entry.getValue(), entry.getKey(), resultHierarchy);
			break;
		}
		writeHeader(sheet, globalColumnCnt);

		logBipUser.entry(signatureMethode + " - End");
		flushLocalVariables();
		return workbook;
	}

	/**
	 * Different styles across Workbook
	 * @param workbook
	 * @return workbook
	 */
	private XSSFWorkbook confStyles(XSSFWorkbook workbook) {

		selectioStyle = workbook.createCellStyle();
		inActiveStyle = workbook.createCellStyle();
		ligneBipCntStyle = workbook.createCellStyle();
		normalStyle = workbook.createCellStyle();
		headerStyle = workbook.createCellStyle();
		boarderLeftline = workbook.createCellStyle();
		boarderLeftTopline = workbook.createCellStyle();
		fullBoarder = workbook.createCellStyle();
		boarderLeftBottomline = workbook.createCellStyle();

		return workbook;
	}

	/** Excel sheet styles configuration
	 * @param workbook
	 */
	private void setStyles(XSSFWorkbook workbook) {

		selectioStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
		selectioStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		selectioStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		selectioStyle.setWrapText(true);

		Font font1 = workbook.createFont();
		font1.setColor(HSSFColor.GREY_40_PERCENT.index);
		inActiveStyle.setFont(font1);
		inActiveStyle.setWrapText(true);
		inActiveStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

		// Font font = workbook.createFont();
		Font font2 = workbook.createFont();
		font2.setColor(HSSFColor.RED.index);
		font2.setBoldweight(Font.BOLDWEIGHT_BOLD);
		ligneBipCntStyle.setFont(font2);
		ligneBipCntStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		ligneBipCntStyle.setWrapText(true);

		Font font3 = workbook.createFont();
		font3.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		headerStyle.setFont(font3);
		headerStyle.setWrapText(true);
		headerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

		boarderLeftline.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);

		boarderLeftBottomline.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
		boarderLeftBottomline.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

		boarderLeftTopline.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		boarderLeftTopline.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
		boarderLeftTopline.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

		fullBoarder.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
		fullBoarder.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
		fullBoarder.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
		fullBoarder.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
		fullBoarder.setWrapText(true);
		// boarderDownline.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

		normalStyle.setWrapText(true);

	}

	/**
	 * Method to insert data into Excel sheet
	 * @param workbook
	 * @param sheet
	 * @param row
	 * @param cell
	 * @param columnCount
	 * @param parentList
	 * @param key
	 * @return row
	 */
	private Row insertData(XSSFWorkbook workbook, XSSFSheet sheet, Row row,
			Cell cell, int columnCount, List<ResultHierarchy> parentList,
			Integer key, Map<Integer, List<ResultHierarchy>> resultHierarchy) {

		int tempColIndex = 0;
		boolean firstIdent = true;

		for (ResultHierarchy r : parentList) {
			tempColIndex = columnCount;
			row = sheet.createRow(++rowCount);
			// if(key != 1){
			cell = row.createCell(++tempColIndex);
			cell.setCellValue((int) r.getIdent());
			firstIdent = setIdentStyle(workbook, cell, r, firstIdent);
			/* for vertical tree connection */
			writeVerticalTreeLine(workbook, row, cell, r);
			cell = row.createCell(++tempColIndex);
			cell.setCellValue((String) r.getName());
			setNameStyle(sheet, cell, r);

			cell = row.createCell(++tempColIndex);
			cell.setCellValue((int) r.getLigneCnt());
			setLigneBipCntColor(cell, r);

			/*System.out.println("row : " + rowCount + " Ident :" + r.getIdent()
					+ " column : " + tempColIndex + " CPIdent :"
					+ r.getCpIdent());*/

			if (resultHierarchy.containsKey(key + 1)) {
				List<ResultHierarchy> childList = resultHierarchy.get(key + 1);
				List<ResultHierarchy> selectedChildList = new ArrayList<ResultHierarchy>();

				for (ResultHierarchy child : childList) {
					if (child.getCpIdent() == r.getIdent()
							&& (r.getActInd().equalsIgnoreCase(YES) || r.getSelInd().equalsIgnoreCase("1"))) {
						selectedChildList.add(child);
					}
				}
				if (!selectedChildList.isEmpty()) {
					XSSFCellStyle ss = (XSSFCellStyle) cell.getCellStyle();
					ss.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

					ss = (XSSFCellStyle) row.getCell(
							(cell.getColumnIndex() - 1)).getCellStyle();
					ss.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

					ss = (XSSFCellStyle) row.getCell(
							(cell.getColumnIndex() - 2)).getCellStyle();
					ss.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);

				}

				insertData(workbook, sheet, row, cell, tempColIndex,
						selectedChildList, key + 1, resultHierarchy);
			}
		}

		if (globalColumnCnt < tempColIndex) {
			globalColumnCnt = tempColIndex;
		}
		return row;
	}

	private void writeVerticalTreeLine(XSSFWorkbook workbook, Row row,
			Cell cell, ResultHierarchy r) {

		XSSFCellStyle leftline = workbook.createCellStyle();
		leftline.setBorderLeft((short) 2);
		int j = 1;
		int i = cell.getColumnIndex();
		while (i > startVerticalLine) {
			row.createCell(cell.getColumnIndex() - 3 * j)
					.setCellStyle(leftline);
			i = i - 3;
			j++;
		}
	}

	private boolean setIdentStyle(XSSFWorkbook workbook, Cell cell,
			ResultHierarchy r, boolean firstIdent) {

		if (startVerticalLine == 10000) {
			XSSFCellStyle leftlineDotted = workbook.createCellStyle();
			leftlineDotted.setBorderLeft((short) 10);
			cell.setCellStyle(leftlineDotted);
		} else {
			if (firstIdent) {
				cell.setCellStyle(boarderLeftTopline);
			} else {
				// cell.setCellStyle(boarderLeftline);
				cell.setCellStyle(boarderLeftBottomline);
			}
		}

		firstIdent = false;

		return firstIdent;
	}

	private void setLigneBipCntColor(Cell cell, ResultHierarchy r) {
		if (r.getManInd().equalsIgnoreCase(NO) && r.getLigneCnt() > 0) {
			cell.setCellStyle(ligneBipCntStyle);
		} else {
			cell.setCellStyle(normalStyle);
		}
	}

	private void setNameStyle(XSSFSheet sheet, Cell cell, ResultHierarchy r) {

		if (r.getSelInd().equalsIgnoreCase("1")) {
			cell.setCellStyle(selectioStyle);
			startVerticalLine = cell.getColumnIndex() + 2;
		}
		else if (r.getActInd().equalsIgnoreCase(NO)) {
			cell.setCellStyle(inActiveStyle);
		} else {
			cell.setCellStyle(normalStyle);
		}
	}

	/**
	 * Method to write Header of sheet
	 * @param sheet
	 * @param columnCount
	 */
	private void writeHeader(XSSFSheet sheet, int columnCount) {

		String signatureMethode = "HierarchyAction - writeHeader()";
		logBipUser.entry(signatureMethode + " - Start");
		Row row = sheet.createRow(0);
		columnCount = columnCount + 1;
		Cell cell = null;

		int tmpCnt = columnCount;
		int downStream = 0;
		boolean downStreamFlag = true;

		while (0 != columnCount) {

			// if (tmpCnt != columnCount) {
			cell = row.createCell(tmpCnt - (columnCount--));
			if (downStreamFlag) {
				cell.setCellValue((String) HEADER_N);
				downStreamFlag = false;
				cell.setCellStyle(headerStyle);
			} else {
				cell.setCellValue((String) HEADER_N + "-"
						+ (downStream < 10 ? 0 : null) + (++downStream));
				cell.setCellStyle(headerStyle);
			}
			// }

			cell = row.createCell(tmpCnt - (columnCount--));
			cell.setCellValue((String) HEADER_NAME);
			cell.setCellStyle(fullBoarder);
			// sheet.autoSizeColumn();
			sheet.setColumnWidth(cell.getColumnIndex(), 3350);

			cell = row.createCell(tmpCnt - (columnCount--));
			cell.setCellValue((String) HEADER_LIGNE);
			cell.setCellStyle(fullBoarder);
		}
		
		logBipUser.entry(signatureMethode + " - End");
	}

}
