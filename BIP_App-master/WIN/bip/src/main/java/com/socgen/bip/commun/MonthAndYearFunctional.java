package com.socgen.bip.commun;

public class MonthAndYearFunctional {

	private int monthFunctional;
	private int yearFunctional;

	public MonthAndYearFunctional(int yearFunctional, int monthFunctional) {
		this.yearFunctional = yearFunctional;
		this.monthFunctional = monthFunctional;
	}

	public int getMonthFunctional() {
		return monthFunctional;
	}

	public int getYearFunctional() {
		return yearFunctional;
	}

	@Override
	public String toString() {
		return "MonthAndYearFunctional [monthFunctional=" + monthFunctional + ", yearFunctional=" + yearFunctional + "]";
	}
}
