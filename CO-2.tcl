

#-----------nouvelle ligne-----------------------------------

proc newline {}  {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	frame $new -background  red
	set larg 250
#	set qmax 0
#	set lmax 5.0
#	set longueur 0.0
	if {$testligne <= 0} {
	if {$ligne == $lignemax}  {
		set tab($ligne,0)  [expr $ligne + 1]
		set tab($ligne,1) 0.0
		set tab($ligne,2) 0.0
		set tab($ligne,3) 12.52
		set tab($ligne,4) 0.0
		for {set i 0} {$i <= 5} {incr i} {
			set tab($ligne,[expr 5 + $i]) 0.0
		}
		set tab($ligne,11) 0.0
		set tab($ligne,12) 0.0
		set tab($ligne,13) 1.0
		set tab($ligne,14) 0.0
		set tab($ligne,15) 0.0
		set qmax 0
		set lmax 5.0
		set longm 0.01
	}
	}
	for {set i 16} {$i <= 23} {incr i} {set tab($ligne,$i) 0.0}
	#noeud
	label $new.titre -text "Données du nouveau noeud n° [expr $ligne + 1]"
	set tab($ligne,0) [expr ($ligne + 1.0) * 1.0]
	#noeud amont
	if {$ligne == 0}  { set amontmini 0.0}  else {set amontmini 1.0}
	scale $new.amont -from $amontmini -to $ligne\
			-length $larg -label "N° du noeud amont"\
			-orient horizontal -showvalue true\
			-variable tab($ligne,1) -resolution 1
	#debit max des valeurs
	checkbutton $new.debit -text "Max des débits = $qmax"  -variable qmax		-command { 
			$new.debit configure -text "Max des débits = $qmax"	
			set tab($ligne,2) [expr $qmax * 1.0]
			}
	#dn
	set unit 0
	checkbutton $new.unit -text "DN ou in" -variable unit -command {
		$new.dn delete 0 11
		if {$unit == 0} {
			$new.dn insert 0 10 15 20 25 32 40 50 65 80 100 125 150
			} else {
			$new.dn insert 0 "3/8" "1/2" "3/4" "1" "1-1/4" "1-1/2" "2"  "2-1/2" "3" "4" "5" "6" 
		}
		$new.defil configure -command "$new.dn yview"
		}
	listbox $new.dn -selectmode browse -height 4\
			-yscrollcommand "$new.defil set"
	scrollbar $new.defil -command "$new.dn  yview"  
	$new.dn delete 0 11
	$new.dn insert 0 10 15 20 25 32 40 50 65 80 100 125 150
	button $new.dnvalid -text "validez ici \n  le DN sélectionné"  -command {
		set dint [$new.dn curselection]
				set tab($ligne,15) $dint
				puts "i $i   accindex $dint"
				set dn [$new.dn get $dint]
				$new.dn delete 0 11
				$new.dn insert 0 12.52 15.8 20.93 26.64 35.04 40.9  52.5  62.7 77.92 102.26 128.2 154.05
				set tab($ligne,3)  [$new.dn get $dint]
				$new.dn delete 0 11
				if {$unit == 0} {
					$new.dn insert  0 10 15 20 25 32 40 50 65 80 100 125 150
				} else {
					$new.dn insert 0 "3/8" "1/2" "3/4" "1" "1-1/4" "1-1/2" "2"  "2-1/2" "3" "4" "5" "6" 
				}
				$new.dnvalid configure -text "DN $dn   \n Dint $tab($ligne,3) "
		}
	#longueur droite
	label $new.ltitre -text "Longueur droite \n en mètre"
	button $new.longmax1		-text "Echelle des longueurs en m\n  +   "	   -command {
		set lmax [expr $lmax * 2.0  + 0.5] 
		$new.long configure -to $lmax 
		$new.long configure -tickinterval [expr int([expr $lmax / 5.0 *  10.0 ] ) / 10.0  ]
		}
	button $new.longmax2		-text "Echelle des longueurs en m\n	-   "	   -command {
		set lmax [expr $lmax / 2.0  + 0.5] 
		$new.long configure -to $lmax 
		$new.long configure -tickinterval [expr int([expr $lmax / 5.0 *  10.0 ] ) / 10.0  ]
		}
	scale $new.long -from 0.0 -to $lmax \
			-length $larg \
			-orient horizontal -showvalue true\
			-tickinterval [expr int([expr $lmax / 5.0 *  10.0 ] ) / 10.0  ]\
			-variable longm \
			-resolution 0.1
	#Nombre d'accéssoires
	set acc(0) "Coude à 45°"
	set acc(1) "Coude à 90° 3R"
	set acc(2) "Coude à 90° 5R"
	set acc(3) "Té de traversée (flux à 0°)"
	set acc(4) "Té latéral (flux à 90°)"
	set acc(5) "Vanne"
	set acc(6) "Raccord union"
	for {set i 0} {$i <= 6} {incr i} {	
		scale $new.acc$i -from 0.0 -to 50.0\
				-length $larg -label "Nombre de $acc($i)"\
				-orient horizontal -showvalue true\
				-variable tab($ligne,[expr 5 + $i])  -resolution 1
		}
	#buse

	set var 0
	checkbutton $new.dmax -text "Echelle des débits en kg/mi \n  100 ou  500  "	\
		 -variable var -command {
		if {$var == 1.0} {$new.dbuse configure -to 100.0 	}
		if {$var == 0.0} {$new.dbuse configure -to 500.0 	}
		}
	
	scale $new.dbuse -from 0.0 -to 500.0\
			-length $larg -label "Débit à la buse"\
			-orient horizontal -showvalue true -tickinterval 100\
			-variable tab($ligne,12) -resolution 0.1
	scale $new.orifice -from 1 -to 10\
			-length $larg -label "Nombre d'orifice de la buse"\
			-orient horizontal -showvalue true\
			-variable tab($ligne,13) -resolution 1
	#dénivellé	
	label $new.htitre -text "Altitude en mètre \n + vers le haut"
	scale $new.haut -from [expr -50.0] -to 50.0\
		-length $larg -label " Dénivelllé par rapport au noeud amont "\
		-orient horizontal	-showvalue true\
		-variable tab($ligne,14)   -resolution 0.1
	
	#bouton de validation ou d'annulation
	button $new.valid -text "Validez la ligne" -command {
		set tab($ligne,4) $longm
		for {set i 0} {$i <= 15} {incr i} {set tab($ligne,$i) [expr $tab($ligne,$i) * 1.0]}
		destroy $new
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2 $menu.b3
		return
	}
	button $new.annul -text "Annulez" -command {
		if {$testligne == 0 } {set lignemax  [expr $ligne - 1]}
		destroy $new
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2 $menu.b3
		return
	}
	if {$testligne == 1} {
		$new.dbuse configure  -to 500.0
#		puts "ligne $ligne  tab4 $tab($ligne,4)"
		set longm $tab($ligne,4) 
		$new.amont configure	-showvalue true 
		set qmax $tab($ligne,2)
		$new.debit configure	-text "Max des débits = $qmax"		
		$new.dnvalid configure -text  "Dint $tab($ligne,3)"  
		puts "longueur $longm"
		for {set i 0} {$i <= 6} {incr i} {$new.acc$i configure -showvalue true  }
		set lmax [expr $tab($ligne,4) * 2.0  ]
		$new.long configure -to $lmax  -tickinterval [expr int([expr $lmax / 5.0 *  10.0 ] ) / 10.0  ]
		$new.long configure -showvalue true
		$new.dbuse configure -showvalue true
		$new.orifice configure -showvalue true
		$new.haut configure -showvalue true
		set testligne -1
	}
	#Affichage éffectif	
	pack $new
	grid $new.titre -row 0 -column 0	
	grid $new.amont -row 0 -column 1
	grid $new.debit -row 0 -column 2
	grid $new.unit  -row 4 -column 1
	grid $new.dn  -row 4 -column 2
	grid $new.defil -row 4 -column 3
	grid $new.dnvalid -row 4 -column 0
	grid $new.longmax2 -row 5 -column 0
	grid $new.longmax1 -row 5 -column 2
	grid $new.long -row 5 -column 1
	for {set i 0} {$i < 3} {incr i} {grid $new.acc$i -row 1 -column $i}
	for {set i 3} {$i < 6} {incr i} {grid $new.acc$i -row 2 -column [expr $i - 3]}
	grid $new.acc6 -row 3 -column 0
	grid $new.dmax -row 6 -column 0
	grid $new.dbuse -row 6 -column 1
	grid $new.orifice  -row 6 -column 2
	grid $new.htitre -row 7 -column 0
	grid $new.haut -row 7 -column 1
	grid $new.valid   -row 8 -column 1
	grid $new.annul  -row 8 -column 2
	
}
#--------------------------------données---------------------------------------------
proc donnees {}  {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	frame $valeur -background yellow
	pack $valeur
	set n(1) "N°"
	set n(2) "N°amont"
	set n(3) "MaxQ"
	set n(4) "Dint"
	set n(5) "Long"
	set n(6) "C45"
	set n(7) "C90R3"
	set n(8) "C90R5"
	set n(9) "T (flux 0°)"
	set n(10) "T (flux à 90°)"
	set n(11) "Vanne"
	set n(12) "Union"
	set n(13) "Débit buse"
	set n(14) "Nb orifice"
	set n(15) "Dénivellé"
	
	
	frame $valeur.titre
	pack configure $valeur.titre
	for {set j 1} {$j <= 15} {incr j}  {
		label $valeur.titre.$j -text $n($j)  -width 9
		pack configure $valeur.titre.$j -side left
		}
	


	frame $valeur.res
	pack $valeur.res
	


	for {set u 0} {$u <= $lignemax} {incr u} {
		set mot($u) [format %13.1E $tab($u,0) ] 
		append mot($u) [format %13.1E $tab($u,1) ]
		for {set j 2} {$j <= 14} {incr j} {
			append mot($u) 	[format %12.1E $tab($u,$j) ]
		}
	}
	
		listbox $valeur.res.ligne -height 20  -yscrollcommand "$valeur.res.defil set" -width 147
		scrollbar $valeur.res.defil -command "$valeur.res.ligne yview"

	$valeur.res.ligne delete 0 $lignemax 
	for {set i 0} {$i <= $lignemax} {incr i} { $valeur.res.ligne insert end $mot($i) }

	pack $valeur.res.ligne -side left   -fill y
	
	pack $valeur.res.defil  -fill y





	button $valeur.valid -text "Retour au menu" -command {
		destroy $valeur
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
		}
	
	pack configure $valeur.valid
	if {$lignemax >= 0} {
		button $valeur.validnumero
		button $valeur.modif -text "Modifier une ligne" -command {
			scale $valeur.numeromodif -from 1.0 -to [expr $lignemax+1]\
					-length 180 -label "N° du noeud de la ligne à modifier"\
					-orient horizontal -showvalue true\
					-variable modifligne -resolution 1
				$valeur.validnumero configure\
					-text "Cliquez ici pour valider la ligne à modifier"\
					-command {destroy $valeur; set testligne 1; set ligne [expr $modifligne - 1]; newline  }
			destroy $valeur.modif
			pack forget $valeur.sup $valeur.ins
			pack $valeur.numeromodif
			pack $valeur.validnumero
			}
		button $valeur.sup -text "Supprimer une ligne" -command {
			if {$lignemax > 0} {
				scale $valeur.numerosupp -from 2.0 -to [expr $lignemax+1]\
					-length 180 -label "N° du noeud de la ligne à supprimer"\
					-orient horizontal -showvalue true\
					-variable suppligne -resolution 1
				$valeur.validnumero configure\
					-text "Cliquez ici pour valider la ligne à supprimer"\
					-command {destroy $valeur ;suppligne  [expr $suppligne - 1] }
				button $valeur.annul -text "retour au menu" -command {
				destroy $valeur
				pack $fichier $fichier.file
				pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
				}
				destroy $valeur.sup
				pack forget $valeur.modif $valeur.ins
				pack $valeur.numerosupp
				pack $valeur.validnumero	
				pack $valeur.annul
			}
		}
		
		button $valeur.ins -text "Insérer une ligne " -command {
			scale $valeur.numeroins -from 1.0 -to [expr $lignemax]\
					-length 180 -label "après le N° du noeud "\
					-orient horizontal -showvalue true\
					-variable insligne -resolution 1
				$valeur.validnumero configure\
					-text "Cliquez ici pour valider  votre choix"\
					-command {destroy $valeur; set insert 1; insligne $insligne }
			destroy $valeur.ins
			pack forget $valeur.sup $valeur.modif
			pack $valeur.numeroins
			pack $valeur.validnumero
			}
		pack configure $valeur.sup -padx 2 -pady 2
		pack configure $valeur.modif -padx 2 -pady 2
		pack configure $valeur.ins -padx 2 -pady 2
		}
	
}
#-----------------------suppression d'une ligne-----------
proc suppligne { k}  {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	set i $lignemax
	if {$k < $lignemax}  {
	while  {$i >= [expr $k + 1]}  {
		if { $tab($i,1) == $tab($k,1)}  { set tab($i,1)  $tab($k,0) }
		set i [expr $i - 1]
	}
	for {set i [expr $k + 1]} {$i <= $lignemax}  { incr i} {
		set tab($i,0)  [expr $tab($i,0) - 1]
		if {$tab($i,1)> $k} {set tab($i,1)  [expr $tab($i,1) - 1] }
		for {set j 0} {$j <= 15}  { incr j} { set tab([expr $i - 1],$j) $tab($i,$j) }
		
	}
	}
	set lignemax [expr $lignemax -1]
	destroy $valeur
	pack $fichier $fichier.file
	pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
	return
}
#--------------------------------insertion d'une ligne---------------------------
proc insligne {k} {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	set vari $lignemax
	while  {$vari >  $k }  {
		for {set j 0} {$j <= 15}  { incr j} { set tab([expr $vari + 1],$j) $tab($vari,$j) }
		set tab([expr $vari + 1],0) [expr $tab([expr $vari + 1],0) + 1.0]
		if {$tab([expr $vari + 1],1) > $k}	 { set tab([expr $vari + 1],1)  [expr $tab([expr $vari + 1],1) + 1]}
		if {$tab([expr $vari + 1],1) == $k}  { set tab([expr $vari + 1],1)  [expr $k *1.0]}
		set vari [expr $vari - 1]	
	}
	set lignemax [expr $lignemax +1]
	pack $fichier $fichier.file
	pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
}
#------------------------------sous programmes fichiers--------------------------------------------
proc openfile {filename} {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	set v "/n"
	set types {
		{{fichier co2} {.co2}}
	}
	set filename [tk_getOpenFile -filetypes $types]
	if {$filename == ""} {return }
	if {[catch {open $filename r} fd]} {
		tk_messageBox -title "Erreur" -type ok -icon error -message $fd
		return  
	}
	set io [open $filename r+]
	
	gets $io lignemax
	set lignemax [expr int($lignemax) - 1 ]

	
	for {set i 0} {$i <= $lignemax} {incr i} {
		for {set j 0} {$j < 16} {incr j} {
			gets $io  tab($i,$j)
			set tab($i,$j) [expr ($tab($i,$j)  * 1.0)   ]
		}

	}
	
	for {set i 0} {$i <= $lignemax} {incr i} {
		for {set j 16} {$j <= 23} {incr j} {
			set  tab($i,$j)  0.0
		}

	}
	
	
	
	gets $io Psource
	
	close $io
	return 
}




proc sauvefilecomme {filename } {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	set types {
		{{Rajouter l'extention .co2} {.co2}}
	}
	set v "\n"
	set filename [tk_getSaveFile -filetypes $types]
	if {$filename == ""}   {return}
	if {[catch {open $filename w} fd]} {
		tk_messageBox -title "Erreur" -type ok -icon error -message $fd
		return
	}
	set io [open $filename w+]
	fconfigure $io -encoding ascii
	puts $io  [format %.5E [expr $lignemax + 1]]
#	puts $io "\n"
	for {set i 0} {$i <= $lignemax} {incr i} {
		for {set j 0} {$j < 16} {incr j} {
			puts $io	[format %.5E $tab($i,$j)]
		}
#		puts $io "\n"
	}

	puts $io $Psource
	close $io
}

proc quit {} {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	frame .fin
	pack .fin
	pack forget $menu $fichier
	label .fin.msg -text "Avez vous enregistré votre travail !!!\n"
	button .fin.valid -text "Quitter le programme" -command { destroy .}
	button .fin.retour -text "Retour au programme" -command {
		destroy .fin
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
	}
	pack .fin.msg .fin.retour .fin.valid 
}
#---------------------Résultat-------------------------
proc result {} {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi qmax tab
	
	frame $final -background green
	pack configure $final
		
	if {$lignemax < 0} {destroy $final
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
	}
	set testres 0
	set debit 0.0
	for {set i 0} {$i <= $lignemax} {incr i} {
		for {set  j  16} {$j <= 21} {incr j} {
			set tab($i,$j) 0.0
		}
	}	


	#calcul de la longueur équivalente
	for {set i 0} {$i <= $lignemax} {incr i} {
		set tab($i,17) $tab($i,4)
		#Calcul de la longueur équivalente
		for {set j 0} {$j <= 6} {incr j} {
			set tab($i,17) [expr $tab($i,17) + $equi($j,[expr int ($tab($i,15))]) * int($tab($i,[expr $j+5]) ) ]
			}
	}


	for {set i 0} {$i <= $lignemax} {incr i} {
		set tab($i,16) $tab($i,12)
	}	
	for {set i 0} {$i <= $lignemax} {incr i} {
		#calcul de q par buse et calcul des débits
		set j $i
		while {$tab($j,1) > 0} {
			set k  [expr int($tab($j,1))-1]
			set tab($k,16) [expr $tab($k,16) + $tab($i,16)]
			set j $k
			}
	}
	
	for {set i 0} {$i <= $lignemax} {incr i} {
		puts "$i  Q   $tab($i,16)"
	}	
	
		for {set i $lignemax} {$i >= 0} {set i [expr $i - 1]} {
		set qo($i) 0.0
		if {$tab($i,2) == 1} {
			for {set j [expr $i + 1]} {$j <= $lignemax} {incr j} {
				if {$tab($j,1) == $tab($i,0)} { 
					if {$qo($i) < $tab($j,16)}  {set qo($i) $tab($j,16)}
				}
			}
			if {$tab($i,16) > $qo($i)}  {
				set dif [expr $tab($i,16) - $qo($i)]
				set tab($i,16) $qo($i)
				set u0 [expr int($tab($i,1)) ]
				while {$u0 >= 1} {
					set tab([expr $u0 - 1],16) [expr $tab([expr $u0 - 1],16) - $dif]
					set u0 [expr int($tab([expr $u0 - 1],1)) ]
				}
			}
		}
	}
	
	
	for {set i 0} {$i <= $lignemax}  {incr i}  {
	if {$i == 0} {
		set Pamont $Psource
		} else {
		set Pamont $tab([expr int($tab($i,1)) - 1],18)
		}
	set D $tab($i,3)
	set Q $tab($i,16)
	set L $tab($i,17)
	set nb 17
	puts "D Q L nb	 $D  $Q   $L  $nb"
	set Lequi [expr  (0.8725 * pow(10,-5) * pow($D,5.25) * [ap_dec Piso Yiso $nb $Pamont -1]) / pow($Q,2) ]
	puts "i $i Lequi  $Lequi"
	set Lequi [expr $Lequi - ( 0.04319 * pow($D,1.25) * [ap_dec Piso Ziso $nb $Pamont -1]) ]
	set L [expr $L + $Lequi]
	puts "i $i Lequi  $Lequi"
	set tab($i,17) $L
	for {set j 0} {$j <= $nb } {incr j} {set mat($j) 0.0}
	set v 0
	for {set j 0} {$j <= $nb} {incr j} {
		if {$Pamont <= $Piso($v)} {incr v}
	}
	set v [expr $v - 1]
	puts "v $v"
	set max 0.0
	for {set j $v} {$j <= $nb } {incr j} {
		set mat($j) [expr pow([expr (0.8725 * pow(10,-5) * pow($D,5.25) * $Yiso($j) ) / ($L + ( 0.04319 * pow($D,1.25) * $Ziso($j)))],0.5)]
		if {$max < $mat($j)} {set max $mat($j)}
		puts "j $j mat $mat($j)  max $max"
	}
	if {$max < $Q }  {
		button $final.erreur -text "DN trop petit ou Longueur trop importante   noeud [expr $i + 1]"  -command {
			destroy $final
			pack $fichier $fichier.file
			pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
			}
		pack $final.erreur
		return
		}
	set Pfinal [ap_dec mat Piso $nb $Q  1]
	puts "Pfinal $Pfinal"
	set Pfinal [expr $Pfinal  - ( [ap_dec Piso Fcor $nb $Pfinal -1] * $tab($i,14))]
	set tab($i,18) $Pfinal
	puts "Pfinal $tab($i,18)"
	set tab($i,19)  [ap_dec Piso Yiso $nb $Pfinal -1]
	set tab($i,20)	[ap_dec Piso Ziso $nb $Pfinal -1]
	set Dponderal [ap_dec Piso Demi $nb $Pfinal -1]
	puts "Dponderal $Dponderal"
	if {$tab($i,12) > 0.0} { 
			set tab($i,21)  [expr $tab($i,16) / $Dponderal]
			set tab($i,22)  [expr pow([expr 4 * $tab($i,21) / (3.14 * $tab($i,13))],0.5) ]
			set tab($i,23) $tab($i,13)
		}
	}
	
	
	set n(1) "N°"
	set n(2) "N°amont"
	set n(3) "Débit"
	set n(4) "Long equi"
	set n(5) "P"
	set n(6) "Y"
	set n(7) "Z"
	set n(8) "S"
	set n(9) "d orifice"
	set n(10) "Nb orifice"
	

	label $final.titre -text "Résultat"
	pack configure $final.titre
	for {set j 1} {$j <= 10} {incr j}  {
		label $final.titre.$j -text $n($j)  -width 12
		pack configure $final.titre.$j -side left  
	}
	
	
		
	set testres 0
	set test 0
	frame $final.res
	pack $final.res
	

	for {set u 0} {$u <= $lignemax} {incr u} {
		set mot($u) [format %15.2E $tab($u,0) ] 
		append mot($u) [format %15.2E $tab($u,1) ]
		for {set j 16} {$j <= 23} {incr j} {
			append mot($u) 	[format %17.2E $tab($u,$j) ]
		}
	}
	
		listbox $final.res.ligne -height 20  -yscrollcommand "$final.res.defil set" -width 130
		scrollbar $final.res.defil -command "$final.res.ligne yview"



		
	$final.res.ligne delete 0 $lignemax 
	for {set i 0} {$i <= $lignemax} {incr i} { $final.res.ligne insert end $mot($i)}
	pack $final.res.ligne -side left   -fill y
	pack $final.res.defil  -fill y

	set Porigine $Psource
	set debit $tab(0,16)
	
	frame $final.pression
	label $final.pression.origine -text "Pression  au noeud 0 = [format %.2f $Porigine] 	bar"
	pack configure $final.pression $final.pression.origine
	
	frame $final.débit
	label $final.débit.origine -text "Débit au noeud 0 = [format %.2f $debit] en litre/min"   
	pack configure $final.débit $final.débit.origine

		
	

	button $final.valid -text "Retour au menu" -command {
		destroy $final
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
	}
	pack $final.valid
}
#------------------------------interpolation-------------------------------
proc ap_dec {Tab1 Tab2 nb coord signe} {
	upvar $Tab1 X
	upvar $Tab2 Y
	if {$signe > 0}  {
	for {set u [expr $nb -1]}  {$u >=  0} {set u  [expr $u -1 ]}  {
		if {$X($u) <= $coord}  {
				set a [expr ( $Y([expr $u + 1])  - $Y($u) ) / ( $X([expr $u + 1])  - $X($u) ) ]
				puts "a $a   coord $coord	u $u  signe $signe"
				return [expr  $a * ($coord  - $X($u) ) + $Y($u)]

		}
	}
	} else {
	for {set u 0} {$u <   $nb} {incr u}  {
		if {$X([expr $u +1]) <= $coord}  {
				set a [expr ( $Y([expr $u + 1])  - $Y($u) ) / ( $X([expr $u + 1])  - $X($u) ) ]
				puts "a $a   coord $coord	u $u  signe $signe"
				return [expr -1 * $a * ( $X($u) - $coord ) + $Y($u)]

		}
	}
	}
}
#---------------------Main----------------------------
wm title . "Calcul d'une isomètrie d'un réseau CO2 HP suivant la norme ISO 6183"
wm positionfrom . user
wm sizefrom . user
set i 0
set ligne 0
set lmax 0.0
set longm 0.01
set qmax 0
set lignemax -1
set testligne 0
set testres 1

set Psource 51.7

#menu
set menu ".menu"
set new ".new"
set valeur ".valeur"
set final ".final"
set fichier ".fichier"
set  filenam "co2"
set imprimname "co2rtf"

set equi(0,0) 0.18
set equi(0,1) 0.24
set equi(0,2) 0.3
set equi(0,3) 0.4
set equi(0,4) 0.52
set equi(0,5) 0.61
set equi(0,6) 0.79
set equi(0,7) 0.94
set equi(0,8) 1.2
set equi(0,9) 1.5
set equi(0,10) 1.9
set equi(0,11) 2.3

set equi(1,0) 0.4
set equi(1,1) 0.52
set equi(1,2) 0.67
set equi(1,3) 0.85
set equi(1,4) 1.1
set equi(1,5) 1.3
set equi(1,6) 1.7
set equi(1,7) 2.0
set equi(1,8) 2.5
set equi(1,9) 3.26
set equi(1,10) 4.08
set equi(1,11) 4.94

set equi(2,0) 0.24
set equi(2,1) 0.3
set equi(2,2) 0.43
set equi(2,3) 0.56
set equi(2,4) 0.7
set equi(2,5) 0.82
set equi(2,6) 1.1
set equi(2,7) 1.2
set equi(2,8) 1.6
set equi(2,9) 2.0
set equi(2,10) 2.6
set equi(2,11) 3.08

set equi(3,0) 0.24
set equi(3,1) 0.3
set equi(3,2) 0.43
set equi(3,3) 0.56
set equi(3,4) 0.7
set equi(3,5) 0.82
set equi(3,6) 1.1
set equi(3,7) 1.2
set equi(3,8) 1.6
set equi(3,9) 2.0
set equi(3,10) 2.6
set equi(3,11) 3.08

set equi(4,0) 0.82
set equi(4,1) 1.0
set equi(4,2) 1.4
set equi(4,3) 1.7
set equi(4,4) 2.3
set equi(4,5) 2.7
set equi(4,6) 3.41
set equi(4,7) 4.08
set equi(4,8) 5.06
set equi(4,9) 6.64
set equi(4,10) 8.35
set equi(4,11) 10.0

set equi(5,0) 0.09
set equi(5,1) 0.12
set equi(5,2) 0.15
set equi(5,3) 0.18
set equi(5,4) 0.24
set equi(5,5) 0.27
set equi(5,6) 0.37
set equi(5,7) 0.43
set equi(5,8) 0.55
set equi(5,9) 0.73
set equi(5,10) 0.91
set equi(5,11) 1.1

set equi(6,0) 0.09
set equi(6,1) 0.12
set equi(6,2) 0.15
set equi(6,3) 0.18
set equi(6,4) 0.24
set equi(6,5) 0.27
set equi(6,6) 0.37
set equi(6,7) 0.43
set equi(6,8) 0.55
set equi(6,9) 0.73
set equi(6,10) 0.91
set equi(6,11) 1.1

set Piso(0) 51.7
set Piso(1) 51.0
set Piso(2) 50.5
set Piso(3) 50.0
set Piso(4) 47.5
set Piso(5) 45.0
set Piso(6) 42.5
set Piso(7) 40.0
set Piso(8) 37.5
set Piso(9) 35.0
set Piso(10) 32.5
set Piso(11) 30.0
set Piso(12) 27.5
set Piso(13) 25.0
set Piso(14) 22.5
set Piso(15) 20.0
set Piso(16) 17.5
set Piso(17) 14.0

set Yiso(0) 0.1
set Yiso(1) 554.0
set Yiso(2) 972.0
set Yiso(3) 1325.0
set Yiso(4) 3037.0
set Yiso(5) 4616.0
set Yiso(6) 6129.0
set Yiso(7) 7256.0
set Yiso(8) 8283.0
set Yiso(9) 9277.0
set Yiso(10) 10050.0
set Yiso(11) 10823.0
set Yiso(12) 11507.0
set Yiso(13) 12193.0
set Yiso(14) 12502.0
set Yiso(15) 12855.0
set Yiso(16) 13187.0
set Yiso(17) 14408.0

set Ziso(0) 0.0001
set Ziso(1) 0.0035
set Ziso(2) 0.06
set Ziso(3) 0.0825
set Ziso(4) 0.210
set Ziso(5) 0.330
set Ziso(6) 0.427
set Ziso(7) 0.570
set Ziso(8) 0.7
set Ziso(9) 0.83
set Ziso(10) 0.95
set Ziso(11) 1.086
set Ziso(12) 1.24
set Ziso(13) 1.430
set Ziso(14) 1.620
set Ziso(15) 1.840
set Ziso(16) 2.14
set Ziso(17) 2.59

set Fcor(0) 0.0796
set Fcor(1) 0.077
set Fcor(2) 0.075
set Fcor(3) 0.074
set Fcor(4) 0.066
set Fcor(5) 0.058
set Fcor(6) 0.052
set Fcor(7) 0.045
set Fcor(8) 0.039
set Fcor(9) 0.035
set Fcor(10) 0.031
set Fcor(11) 0.027
set Fcor(12) 0.024
set Fcor(13) 0.02
set Fcor(14) 0.018
set Fcor(15) 0.015
set Fcor(16) 0.013
set Fcor(17) 0.0102

set Demi(0) 3.255
set Demi(1) 3.028
set Demi(2) 2.865
set Demi(3) 2.703
set Demi(4) 2.299
set Demi(5) 2.014
set Demi(6) 1.792
set Demi(7) 1.615
set Demi(8) 1.466
set Demi(9) 1.334
set Demi(10) 1.209
set Demi(11) 1.094
set Demi(12) 0.98
set Demi(13) 0.868
set Demi(14) 0.763
set Demi(15) 0.661
set Demi(16) 0.56
set Demi(17) 0.483

frame $menu   -background blue
button $menu.b1 -text "Nouvelle ligne" -command {
		set testligne 0
		pack forget $menu $fichier
		incr lignemax
		set ligne $lignemax
		newline 
		}

button $menu.b2 -text "Tableau des données"  -command {pack forget $menu $fichier; donnees }

button $menu.b3 -text "Tableau des résultats" -command {pack forget $menu $fichier ; result }

frame $fichier
menubutton $fichier.file -text "Fichier" -menu $fichier.file.choix

menu $fichier.file.choix
$fichier.file.choix add command -label "Ouvrir" -command { openfile $filenam }
$fichier.file.choix add cascade -label "Enregistrer sous  (Pour une sauvegarde)" -command {sauvefilecomme $filenam }
$fichier.file.choix add cascade \
	 -label "Enregistrer  sous (Pour une  impression uniquement) " \
	-command {imprim $imprimname}
$fichier.file.choix add separator
$fichier.file.choix add command -label "paramètrage - Pression source" -command {pack forget $fichier   $menu  ; source}


#$fichier.file.choix add separator
#$fichier.file.choix add command -label "Renseignements" -command {renacc}
$fichier.file.choix add separator
$fichier.file.choix add command -label "A propos de" -command {auteur}
$fichier.file.choix add command -label "Quiter" -command {quit}



pack $fichier $fichier.file
pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5


###--------------------fichier pour impression---------------------------
proc imprim {imprimname} {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi tab
	if {$testres == 1} {return}
	frame .impr
	pack .impr
	pack forget $menu $fichier
	
	button .impr.retour -text "Pour avoir les résultats à jour, cliquez avant  Tableau des résulltats \n Retour au programme \n" \
		-command {
		destroy .impr
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
	}
	label .impr.txt -text "Saisissez vos references pour le fichier impression"
	entry .impr.msg -textvariable refimprim -relief sunken
	button .impr.ok -text "OK" -command {
	set types {
		{{Rajouter l'extention .rtf} {.rtf}}
	}
	set v "\n"
	set filename [tk_getSaveFile -filetypes $types]
	if {$filename == ""}  {return}
	if {[catch {open $filename w} fd]} {
		tk_messageBox -title "Erreur" -type ok -icon error -message $fd
		return
	}
	set io [open $filename w+]
	fconfigure $io -encoding ascii
	puts $io "\n"
	puts $io "\n"
	puts $io "xxxxxxxx"
	puts $io "\n"
	set maintenant [clock seconds]
	puts $io "Date = [clock format $maintenant -format "%d/%m/%Y"]"
	puts $io "\n"
	puts $io "Reference"
	puts $io $refimprim
	puts $io "\n"
	puts $io "CALCUL D'UN RESEAU CO2 HP SUIVANT LA NORME ISO 6183"
	puts $io "\n"
	puts $io "Nombre de lignes"
	puts $io  [format %.3u [expr $lignemax + 1]]
	puts $io "\n"
	
	puts $io "Colonne  1 : Numero du noeud"
	puts $io "Colonne  2 : Noeud amont"
	puts $io "Colonne  3 : Maximun des debits"
	puts $io "Colonne  4 : Diametre interieur"
	puts $io "Colonne  5 : Longueur droite"
	puts $io "Colonne  6 : Coude a 45"
	puts $io "Colonne  7 : Coude a 90 rayon court"
	puts $io "Colonne  8 : Coude a 90 rayon long"
	puts $io "Colonne  9 : Te (flux a 0)"
	puts $io "Colonne 10 : Te (flux a 90)"
	puts $io "Colonne 11 : Vanne "
	puts $io "Colonne 12 : Raccord union"
	puts $io "Colonne 13 : Debit a la buse"
	puts $io "Colonne 14 : Nombre d orifice de la buse"
	puts $io "Colonne 15 : Denivelle par rapport au noeud amont en m"

	puts $io "\n"
	puts $io "DONNEES"
	set mot(0)  [format %3.0f 1.0 ]
	append mot(0)  [format %3.0f 2.0 ]
	append mot(0)  [format %7.0f 3.0 ]
	append mot(0)  [format %7.0f 4.0 ]
	append mot(0)  [format %7.0f 5.0 ]
	append mot(0)  [format %7.0f 6.0 ]
	append mot(0)  [format %7.0f 7.0 ]
	append mot(0)  [format %7.0f 8.0 ]
	append mot(0)  [format %7.0f 9.0 ]
	append mot(0)  [format %7.0f 10.0 ]
	append mot(0)  [format %7.0f 11.0 ]
	append mot(0)  [format %7.0f 12.0 ]
	append mot(0)  [format %7.0f 13.0 ]
	append mot(0)  [format %7.0f 14.0 ]
	append mot(0)  [format %7.0f 15.0 ]
	puts "\n"
	puts $io $mot(0)
	puts $io "\n"
	for {set i 0} {$i <= $lignemax} {incr i} {
		set u [expr $i + 1]
		set mot($u) [format %3.0f $tab($i,0)] 
		append mot($u) [format %3.0f $tab($i,1)]
		for {set j 2} {$j < 15} {incr j} {
			append mot($u) 	[format %7.1f $tab($i,$j)]
		}
		puts $io $mot($u)
	}
	puts $io "\n"
	puts $io "Pression au noeud 0 en bar"
	puts $io  [format %.2f  $Psource ]
	puts $io "Debit au noeud 0 en kg par minute ="
	puts $io [format %.2f  $tab(0,18) ]
	puts $io "\n"
	puts $io "Colonne  1 : Numero du noeud"
	puts $io "Colonne  2 : Noeud amont"
	puts $io "Colonne  3 : Debit en kg par min"
	puts $io "Colonne  4 : Longueur equivalente en m"
	puts $io "Colonne  5 : Pression au noeud  en bar"
	puts $io "Colonne  6 : Y"
	puts $io "Colonne  7 : Z"
	puts $io "Colonne  8 : Section totale des orifices de la buse"
	puts $io "Colonne  9 : diametre de l'orifice a la buse"
	puts $io "Colonne 10 : nombre d'orifice a la buse"
	puts $io "\n"
	puts $io "RESULTATS"
	set mot(0)  [format %3.0f 1.0 ]
	append mot(0)  [format %3.0f 2.0 ]
	append mot(0)  [format %11.0f 3.0 ]
	append mot(0)  [format %11.0f 4.0 ]
	append mot(0)  [format %11.0f 5.0 ]
	append mot(0)  [format %11.0f 6.0 ]
	append mot(0)  [format %11.0f 7.0 ]
	append mot(0)  [format %11.0f 8.0 ]
	append mot(0)  [format %11.0f 9.0 ]
	append mot(0)  [format %11.0f 10.0 ]
	puts $io $mot(0)
	puts $io "\n"
	for {set i 0} {$i <= $lignemax} {incr i} {
		set u [expr $i + 1]
		set mot($u) [format %3.0f $tab($i,0)] 
		append mot($u) [format %3.0f $tab($i,1)]
		for {set j 16} {$j <= 23} {incr j} {
			append mot($u) 	[format %11.2E $tab($i,$j)]
		}
		puts $io $mot($u)
	}

	close $io
	destroy .impr
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
	}
	pack .impr.retour  .impr.txt .impr.msg   .impr.ok
}

#------------------------Pression d'alimentation---------------------------
proc source {} {
global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi tab

set Ps 51.7
frame .alim
pack .alim
scale .alim.pression -from 40 -to 51.7   -length 400 -label "Pression source en bar"\
		-orient horizontal -showvalue true\
		-variable Ps -resolution 0.1
button  .alim.valid  -text "Retour au menu"	-command   {
		puts "Psource $Ps"
		set Psource $Ps
		destroy .alim
		pack $fichier $fichier.file 
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5 
		return 
		}
pack configure .alim.pression
pack configure .alim.valid
}
proc auteur {} {
	global   menu  new	  valeur final testligne fichier   lignemax	ligne i  lmax longm Psource  testres  equi	Piso Yiso Ziso Fcor Demi tab
	frame .aut
	pack .aut
	pack forget $menu $fichier
	
	button .aut.retour -text "Auteur : Pierre Lecanu \n Version 1.0 du 16 Mai 2004  \n Retour au programme" \
		-command {
		destroy .aut
		pack $fichier $fichier.file
		pack $menu $menu.b1 $menu.b2  $menu.b3 -padx 5 -pady 5
		return
	}
	pack .aut.retour
}

