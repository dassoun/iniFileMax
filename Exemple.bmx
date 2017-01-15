Include "iniFileMax.bmx"


If FileType("OUT.INI") = 0 Then
	iniCreerFichier("out.ini")

	iniCreerSection("out.ini", "Section 1")

	iniCreerVariableStr("out.ini", "Section 1", "Mot", "test 1")
	iniCreerVariableFloat("out.ini", "Section 1", "Valeurf", .15)
	iniCreerVariableInt("out.ini", "Section 1", "Valeuri", 15)

	iniCreerSection("out.ini", "Section 2")
	iniCreerVariableStr("out.ini", "Section 2", "Mot", "test 2")
	iniCreerVariableFloat("out.ini", "Section 2", "Valeurf", .30)
	iniCreerVariableInt("out.ini", "Section 2", "Valeuri", 30)
	
	iniCreerSection("out.ini", "Section 3")
	iniCreerVariableStr("out.ini", "Section 3", "Mot", "test 3")
	iniCreerVariableFloat("out.ini", "Section 3", "Valeurf", .45)
	iniCreerVariableInt("out.ini", "Section 3", "Valeuri", 45)
End If


' On peut toujours ajouter des variables apres coup
iniCreerVariableFloat("out.ini", "Section 1", "UN_TEST", 3.1415)


' Et on peut modifier une entree a n'importe quel moment
iniModifierVariableStr("out.ini", "Section 1", "Mot", "Changement")
iniModifierVariableInt("out.ini", "Section 2", "Valeuri", 78979879)
iniModifierVariableFloat("out.ini", "Section 2", "Valeurf", .78979879)


' Pour lire 
Print iniLireVariableStr("out.ini", "Section 2", "Mot")
Print iniLireVariableFloat("out.ini", "Section 2", "Valeurf")
Print iniLireVariableInt("out.ini", "Section 2", "Valeuri")