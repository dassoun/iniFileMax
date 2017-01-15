'####################################################
'												
' Bibliotheque iniFileMax v0.9						
' Gestion des fichiers .ini						
' Ecrit par Julien COIGNET	(ftbass) et RepeatUntil
' site : http://ftprods.free.fr					
' email : breddabasse@hotmail.com				
'
'####################################################

'#####################'
'	
' Version francaise 	'
'	
'#####################'


Global iniArray:String[10000]
Global iniIndexMax = 0

' Fonction de creation du fichier
'----------------------------------
Function iniCreerFichier(id:String)

Local fileout:TStream

	' Creation du fichier
	fileout = WriteFile(Upper(id)) 
	' Close the file 
	CloseStream(fileout) 

End Function

' Fonction de creation d'une section
'--------------------------------------
Function iniCreerSection(idFile:String, idSection:String)

Local fileout:TStream
Local SectionExiste = False
Local Ligne:String

	' Si le fichier n'existe pas, on le cree, et on ecrit le nom de la section
	If FileType(Upper(idFile)) = 0 Then 
		iniCreerFichier(Upper(idFile))
		fileout = OpenFile(Upper(idFile))
		WriteLine(fileout, "[" + Upper(idSection) + "]")
		CloseFile(fileout)
'		Return True
	Else 
		' Si le fichier existe, on le lit
		If FileType(Upper(idFile)) = 1 Then
			fileout = OpenFile(Upper(idFile))
			While Not Eof(fileout)

				Ligne = ReadLine(fileout)

				If  (Ligne = "[" + Upper(idSection) + "]") Then
					SectionExiste = True
				End If
				
			Wend 
			' Si la section n'y est pas, on l'y insere
			If SectionExiste = False Then
			
				SeekStream fileout, StreamSize(fileout)
			
				WriteLine(fileout, "")
				WriteLine(fileout, "[" + Upper(idSection) + "]")
'				Return True
'			Else
'				Return False
			End If
			CloseFile(fileout)
		End If 
	End If	
	
End Function

' Fonction qui determine si une ligne represente une section
Function iniEstUneSection(Chaine:String)
	If (Left(Chaine, 1) = "[") And (Right(Chaine, 1) = "]") Then
		Return True
	Else
		Return False
	End If
End Function

' Fonction qui determine si une section existe
Function iniSectionExiste(idFile:String, idSection:String)

Local filein:TStream
Local Resultat = False
Local Ligne:String

	filein = OpenFile(idFile)

	While (Not Eof(filein)) And Resultat = False
		Ligne = ReadLine(filein)
		If Ligne = ("[" + Upper(idSection) + "]") Then
			Resultat = True
		End If
	Wend
	
	CloseFile(filein)
	
	Return Resultat

End Function

' Fonction qui renvoie le nom de la section (sans les crochets)
Function iniNomSection:String(Chaine:String)

Local Resultat:String

	Return Left(Right(Chaine, Len(Chaine ) - 1), Len(Chaine) - 2)

End Function

' Fonction qui ecrit une variable de Type Float dans une section
Function iniCreerVariableFloat(idFile:String, idSection:String, idVar:String, valVar:Float)

Local fileout:TStream
Local Ligne:String
Local SectionExiste = False

	' Si le fichier n'existe pas, on le cree, et on ecrit le nom de la section
	If FileType(Upper(idFile)) = 0 Then
		iniCreerSection(idFile, idSection)
		fileout = OpenFile(Upper(idFile))
		While Not Eof(fileout)
			Ligne = ReadLine(fileout)
		Wend
		WriteLine(fileout, idVar + " = " + valVar)
		CloseStream(fileout)
	Else 
		' Si le fichier existe, on le lit
		If FileType(Upper(idFile)) = 1 Then
			Local result = iniFileToArray(idFile)
			If result = False Then Return
			Local goodSection = False
			Local iChange = 0
			Local i2 = 0
			Local iniArrayTemp:String[10000]
			For Local i = 0 To iniIndexMax
				If iniArray[i] = "[" + Upper(idSection) + "]" Then goodSection = True
				If goodSection = True Then
					If iniArray[i] = "" Then iChange = i
					If i = iniIndexMax Then iChange = i + 1
				EndIf
				If iChange <> 0 Then
					goodSection = False
					iniArrayTemp[i2] = iniArray[i]
					i2 :+ 1
				EndIf
			Next
			iniArray[iChange] = idVar + " = " + valVar
			i2 = 0
			' Decale le tableau pour rajouter une ligne
			For Local j = iChange To iniIndexMax
				iniArray[j + 1] = iniArrayTemp[i2]
				i2 :+ 1
			Next
			
			iniIndexMax :+ 1
			iniArrayToFile(idFile)
		End If
	End If
	
End Function


' Fonction qui ecrit une variable de Type Integer dans une section
Function iniCreerVariableInt(idFile:String, idSection:String, idVar:String, valVar:Int)

Local fileout:TStream
Local Ligne:String
Local SectionExiste = False

	' Si le fichier n'existe pas, on le cree, et on ecrit le nom de la section
	If FileType(Upper(idFile)) = 0 Then
		iniCreerSection(idFile, idSection)
		fileout = OpenFile(Upper(idFile))
		While Not Eof(fileout)
			Ligne = ReadLine(fileout)
		Wend
		WriteLine(fileout, idVar + " = " + valVar)
		CloseFile(fileout)
	Else 
		' Si le fichier existe, on le lit
		If FileType(Upper(idFile)) = 1 Then
			Local result = iniFileToArray(idFile)
			If result = False Then Return
			Local goodSection = False
			Local iChange = 0
			Local i2 = 0
			Local iniArrayTemp:String[10000]
			For Local i = 0 To iniIndexMax
				If iniArray[i] = "[" + Upper(idSection) + "]" Then goodSection = True
				If goodSection = True Then
					If iniArray[i] = "" Then iChange = i
					If i = iniIndexMax Then iChange = i + 1
				EndIf
				If iChange <> 0 Then
					goodSection = False
					iniArrayTemp[i2] = iniArray[i]
					i2 :+ 1
				EndIf
			Next
			iniArray[iChange] = idVar + " = " + valVar
			i2 = 0
			' Decale le tableau pour rajouter une ligne
			For Local j = iChange To iniIndexMax
				iniArray[j + 1] = iniArrayTemp[i2]
				i2 :+ 1
			Next
			
			iniIndexMax :+ 1
			iniArrayToFile(idFile)
		End If
	End If
	
End Function

' Fonction qui ecrit une variable de Type String dans une section
Function iniCreerVariableStr(idFile:String, idSection:String, idVar:String, valVar:String)

Local fileout:TStream
Local Ligne:String
Local SectionExiste = False

	' Si le fichier n'existe pas, on le cree, et on ecrit le nom de la section
	If FileType(Upper(idFile)) = 0 Then
		iniCreerSection(idFile, idSection)
		fileout = OpenFile(Upper(idFile))
		While Not Eof(fileout)
			Ligne = ReadLine(fileout)
		Wend
		WriteLine(fileout, idVar + " = " + valVar)
		CloseFile(fileout)
	Else 
		' Si le fichier existe, on le lit
		If FileType(Upper(idFile)) = 1 Then
			Local result = iniFileToArray(idFile)
			If result = False Then Return
			Local goodSection = False
			Local iChange = 0
			Local i2 = 0
			Local iniArrayTemp:String[10000]
			For Local i = 0 To iniIndexMax
				If iniArray[i] = "[" + Upper(idSection) + "]" Then goodSection = True
				If goodSection = True Then
					If iniArray[i] = "" Then iChange = i
					If i = iniIndexMax Then iChange = i + 1
				EndIf
				If iChange <> 0 Then
					goodSection = False
					iniArrayTemp[i2] = iniArray[i]
					i2 :+ 1
				EndIf
			Next
			iniArray[iChange] = idVar + " = " + valVar
			i2 = 0
			' Decale le tableau pour rajouter une ligne
			For Local j = iChange To iniIndexMax
				iniArray[j + 1] = iniArrayTemp[i2]
				i2 :+ 1
			Next
			
			iniIndexMax :+ 1
			iniArrayToFile(idFile)				
		End If
	End If
	
End Function

' Fonction qui lit une variable de Type Float dans une section
Function iniLireVariableFloat:Float(idFile:String, idSection:String, idVar:String)

Local filein:TStream
Local Ligne:String
Local Resultat:Float

	filein = ReadFile(Upper(idFile))
	Ligne = ReadLine(filein)
	
	While Not Eof(filein) And Ligne <> "[" + Upper(idSection) + "]"
		ligne = ReadLine(filein)
	Wend
	
	While Not Eof(filein) And (Left(Ligne, Len(idVar)) <> idVar)
		Ligne = ReadLine(filein)
	Wend

	Resultat = Float(Right(Ligne, (Len(Ligne) - (Len(idVar) + 3))))
	
	CloseFile(filein)
	Return Resultat
	
End Function

' Fonction qui lit une variable de Type Integer dans une section
Function iniLireVariableInt:Int(idFile:String, idSection:String, idVar:String)

Local filein:TStream
Local Ligne:String
Local Resultat:Int

	filein = ReadFile(Upper(idFile))
	Ligne = ReadLine(filein)
	
	While Not Eof(filein) And Ligne <> "[" + Upper(idSection) + "]"
		Ligne = ReadLine(filein)
	Wend

	While Not Eof(filein) And (Left(Ligne, Len(idVar)) <> idVar)
		Ligne = ReadLine(filein)
	Wend

	Resultat = Int(Right(Ligne, (Len(Ligne) - (Len(idVar) + 3))))
	
	CloseFile(filein)
	Return Resultat
	
End Function

' Fonction qui lit une variable de Type String dans une section
Function iniLireVariableStr:String(idFile:String, idSection:String, idVar:String)

Local filein:TStream
Local Ligne:String
Local Resultat:String
Local i:Int = 0
	
	filein = ReadFile(Upper(idFile))
	Ligne = ReadLine(filein)
	
	While Not Eof(filein) And Ligne <> "[" + Upper(idSection) + "]"
		ligne = ReadLine(filein)
	Wend

	While Not(Eof(filein) Or (Left(Ligne, Len(idVar)) = idVar))
		Ligne = ReadLine(filein)
	Wend

	Resultat = Right(Ligne, (Len(Ligne) - (Len(idVar) + 3)))
	
	CloseFile(filein)
	Return Resultat
	
End Function


' Fonction pour modifier une variable dans le fichier
Function iniModifierVariableInt(idFile:String, idSection:String, idVar:String, valVar:Int)
	Local result = iniFileToArray(idFile)
	If result = False Then Return
	Local goodSection = False
	Local lengthVar = Len(idVar + " =")
	For Local i = 0 To iniIndexMax
		If iniArray[i] = "[" + Upper(idSection) + "]" Then goodSection = True
		If goodSection = True Then
			If iniArray[i] = "" Then Exit
			If Left(iniArray[i], lengthVar) = idVar + " =" Then
				iniArray[i] = idVar + " = " + valVar
				Exit
			EndIf
		EndIf
	Next
	
	iniArrayToFile(idFile)
End Function


' Fonction pour modifier une variable dans le fichier
Function iniModifierVariableFloat(idFile:String, idSection:String, idVar:String, valVar:Float)
	Local result = iniFileToArray(idFile)
	If result = False Then Return
	Local goodSection = False
	Local lengthVar = Len(idVar + " =")
	For Local i = 0 To iniIndexMax
		If iniArray[i] = "[" + Upper(idSection) + "]" Then goodSection = True
		If goodSection = True Then
			If iniArray[i] = "" Then Exit
			If Left(iniArray[i], lengthVar) = idVar + " =" Then
				iniArray[i] = idVar + " = " + valVar
				Exit
			EndIf
		EndIf
	Next
	
	iniArrayToFile(idFile)
End Function


' Fonction pour modifier une variable dans le fichier
Function iniModifierVariableStr(idFile:String, idSection:String, idVar:String, valVar:String)
	Local result = iniFileToArray(idFile)
	If result = False Then Return
	Local goodSection = False
	Local lengthVar = Len(idVar + " =")
	For Local i = 0 To iniIndexMax
		If iniArray[i] = "[" + Upper(idSection) + "]" Then goodSection = True
		If goodSection = True Then
			If iniArray[i] = "" Then Exit
			If Left(iniArray[i], lengthVar) = idVar + " =" Then
				iniArray[i] = idVar + " = " + valVar
				Exit
			EndIf
		EndIf
	Next
	
	iniArrayToFile(idFile)
End Function


' Fonction qui transcrit un fichier en tableau
Function iniFileToArray%(idFile:String)
	Local filein:TStream

	If FileType(Upper(idFile)) = 0 Then Return False

	filein = ReadFile(Upper(idFile))
	Local i = 0
	While Not Eof(filein)
		iniArray[i] = Trim(ReadLine(filein))
		i :+ 1
		If i >= 10000 Then Exit
	Wend
	iniIndexMax = i - 1

	CloseFile(filein)
	Return True
End Function


' Fonction qui transcrit le tableau global en fichier
Function iniArrayToFile(idFile:String)
	DeleteFile(Upper(idFile))
	Local fileout:TStream = WriteFile(Upper(idFile))

	For Local i = 0 To iniIndexMax
		WriteLine(fileout, iniArray[i])
	Next
	CloseFile(fileout)
End Function


'#####################'
'					'
' Version anglaise	'
'					'
'#####################'

Function iniCreateFile(id:String)
	iniCreerFichier(id:String)
End Function

Function iniCreateSection(idFile:String, idSection:String)
	iniCreerSection(idFile:String, idSection:String)
End Function

Function iniIsSection(Chaine:String)
	Return(iniEstUneSection(Chaine:String))
End Function

Function iniSectionExist(idFile:String, idSection:String)
	Return(iniSectionExiste(idFile:String, idSection:String))
End Function

Function iniSectionName:String(Chaine:String)
	Return(iniNomSection:String(Chaine:String))
End Function

Function iniCreateVarFloat(idFile:String, idSection:String, idVar:String, valVar:Float)
	iniCreerVariableFloat(idFile:String, idSection:String, idVar:String, valVar:Float)
End Function

Function iniCreateVarInt(idFile:String, idSection:String, idVar:String, valVar:Int)
	iniCreerVariableInt(idFile:String, idSection:String, idVar:String, valVar:Int)
End Function

Function iniCreateVarStr(idFile:String, idSection:String, idVar:String, valVar:String)
	iniCreerVariableStr(idFile:String, idSection:String, idVar:String, valVar:String)
End Function

Function iniGetVarFloat:Float(idFile:String, idSection:String, idVar:String)
	Return(iniLireVariableFloat:Float(idFile:String, idSection:String, idVar:String))
End Function

Function iniGetVarInt:Int(idFile:String, idSection:String, idVar:String)
	Return(iniLireVariableInt:Int(idFile:String, idSection:String, idVar:String))
End Function

Function iniGetVarStr:String(idFile:String, idSection:String, idVar:String)
	Return(iniLireVariableStr:String(idFile:String, idSection:String, idVar:String))
End Function

Function iniChangeVarInt(idFile:String, idSection:String, idVar:String, valVar:Int)
	iniModifierVariableInt(idFile:String, idSection:String, idVar:String, valVar:Int)
End Function

Function iniChangeVarFloat(idFile:String, idSection:String, idVar:String, valVar:Float)
	iniModifierVariableFloat(idFile:String, idSection:String, idVar:String, valVar:Float)
End Function

Function iniChangeVarStr(idFile:String, idSection:String, idVar:String, valVar:String)
	iniModifierVariableStr(idFile:String, idSection:String, idVar:String, valVar:String)
End Function
