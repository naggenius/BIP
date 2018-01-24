/*
 * Cr�� le 26 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import com.socgen.bip.rbip.commun.RBipConstants;


/**
 * @author X039435 / E.GREVREND
 *
 * RBipEnregistrement est utilis� pour repr�sent� les types d'enregistrement de la Bip.<br>
 * Aujourd'hui il n'est pas n�cessaire d'�tablir un lien p�re/fils entre les enregistrements.br>
 * Mais s'il devient n�cessaire d'int�grer cette hi�rarchie, c'est via cette classe m�re que seront pos�es les comportement g�n�raux. 
 */
public abstract class RBipEnregistrement implements RBipConstants
{}