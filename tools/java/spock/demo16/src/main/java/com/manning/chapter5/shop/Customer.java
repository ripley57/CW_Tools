package com.manning.chapter5.shop;

public class Customer {
	private boolean vip = false;
	private int bonusPoints = 0;

	public boolean isVip() {
		return vip;
	}
	public void setVip(boolean vip) {
		this.vip = vip;
	}

	public int getBonusPoints() {
		return bonusPoints;
	}
	public void setBonusPoints(int bonusPoints) {
		this.bonusPoints = bonusPoints;
	}
}
