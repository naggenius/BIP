/*
 * Cr�� le 7 f�vr. 05
 *
 */
package com.socgen.bip.menu.filtre;

import com.socgen.bip.user.UserBip;

/**
 *
 * @author X039435
 */
public class FiltreOK extends FiltreMenu
{
	public boolean eval(UserBip userBip) {return !bNot;}
}
