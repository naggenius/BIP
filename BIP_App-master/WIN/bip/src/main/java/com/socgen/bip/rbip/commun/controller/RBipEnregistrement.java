/*
 * Créé le 26 avr. 04
 *
 */
package com.socgen.bip.rbip.commun.controller;

import com.socgen.bip.rbip.commun.RBipConstants;


/**
 * @author X039435 / E.GREVREND
 *
 * RBipEnregistrement est utilisé pour représenté les types d'enregistrement de la Bip.<br>
 * Aujourd'hui il n'est pas nécessaire d'établir un lien père/fils entre les enregistrements.br>
 * Mais s'il devient nécessaire d'intégrer cette hiérarchie, c'est via cette classe mère que seront posées les comportement généraux. 
 */
public abstract class RBipEnregistrement implements RBipConstants
{}