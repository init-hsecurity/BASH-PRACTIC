#!/bin/bash
# Desarrollado por Gustavo Báez Moreno
subprograma=`zenity --entry  --title="Selección de accion" --text="1.-Unir PDF
2.- Seccionar páginas en archivos
3.- Extraer páginas
4.- Insertar marca de agua
5.- Proteger PDF
6.- Reparar PDF
7.-Convertir a PDF (Cualquier formato soportado en OpenOffice!!!!!!!))"`
case $subprograma in

# Unir PDF
1)
clear
Seleccion=`zenity --title "Selecciona en orden los pdfs que quieres unir"  --file-selection --multiple|sed -e 's/|/\" \"/g'`
echo \'$Seleccion\'
echo "Ha seleccionado los siguientes PDF  \"$Seleccion\""
Salida=$(zenity --file-selection --title "Selecciona la ruta y escribe el nombre del PDF que quieres crear " --save --confirm-overwrite)
echo pdftk \"$Seleccion\" cat output $Salida>/home/$USER/Escritorio/temporal_mezclar
chmod +x /home/$USER/Escritorio/temporal_mezclar
/home/$USER/Escritorio/temporal_mezclar
rm /home/$USER/Escritorio/temporal_mezclar
;;
# Seccionar en páginas
2)
FILE=`zenity --file-selection  --title="Selecciona el archivo pdf del cual quiere extraer cada una de las páginas como archivos independientes"`

        case $? in
                 0)
                        echo "\"$FILE\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "Ha ocurrido un error inesperado.";;
        esac
salida=$(zenity --file-selection --save --confirm-overwrite);
	
	pdftk "$FILE" burst output "$salida"_%02d.pdf
;;
# Extraer páginas
3)
clear
FILE=`zenity --file-selection  --title="Selecciona el archivo pdf del cual quiere extraer las páginas"`

        case $? in
                 0)
                        echo "\"$FILE\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "Ha ocurrido un error inesperado.";;
        esac
DESDE=`zenity --entry  --title="Selección de primera página" --text="Número de la primera página que quiere extraer"`
HASTA=`zenity --entry  --title="Selección de última página" --text="Número de la última página que quiere extraer"`
salida=$(zenity --file-selection --save --confirm-overwrite);
	
	pdftk A="$FILE" cat 'A'$DESDE-$HASTA output "$salida"
echo "pdftk A="$FILE" cat "$FILE"$DESDE-$HASTA "$FILE2" output "$salida""
;;
#Insertar marca de agua
4)
clear
 FILE=`zenity --file-selection  --title="Selecciona el archivo pdf a insertar la marca de agua"`

        case $? in
                 0)
                        echo "\"$FILE\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "No ha seleccionado ningún archivo.";;
        esac
zenity --info \
          --text="Cuando acepte este cuadro se abrirá un diálogo para seleccionar el archivo que hará de marca de agua. El archivo que va a seleccionar como marca de agua debe ser pdf, no vale un jpg."

	FILE2=`zenity --file-selection --title="Selecciona el archivo pdf  que servirá de marca de agua"`

        case $? in
                 0)
                        echo "\"$FILE2\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "No ha seleccionado ningún archivo.";;
        esac


	salida=$(zenity --file-selection --save --confirm-overwrite);echo $salida
	
	pdftk "$FILE" background "$FILE2" output "$salida"
;;
# Proteger PDF
5)
clear
FILE=`zenity --file-selection  --title="Selecciona el archivo pdf que quiere proteger"`

        case $? in
                 0)
                        echo "\"$FILE\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "Ha ocurrido un error inesperado.";;
        esac
salida=$(zenity --file-selection --save --confirm-overwrite);
USUARIO=`zenity --entry  --title="CONTRASEÑA DE PROPIETARIO" --text="Introduzca un nombre de usuario sin espacios (necesario para revocar/dar permisos en el futuro)"`
opcion=`zenity --entry  --title="CLAVE PARA APERTURA" --text="¿Se requerirá contraseña de apertura? Escriba s (de si)  ó   n (de no)"`
	if test $opcion = n 
	then
   	CONTRASE=ninguna
  	else
	CONTRASE=`zenity --entry  --title="CONTRASEÑA DE APERTURA---sin espacios y diferente a la de usuario---" --text="Introduzca una contraseña (necesaria para abrir el documento)"`
	fi
zenity --info \
          --text="Opciones: Printing= Se permite impresión a alta calidad; DegradedPrinting= Se permite impresión a baja calidad ; ModifyContents= Modificar contenidos, incluso reensamblado; Assembly= se permite extraer/ unir páginas ; CopyContents= Se permite copiar contenidos y lectores de pantalla ; ScreenReaders= Se permiten los lectores de pantalla ; ModifyAnnotations= Se permiten modificar las anotaciones incluido rellenado de formulario ; FillIn= Se permite el rellenado del formulario AllFeatures= Se permite todo lo anterior "
PERMISOS=`zenity --entry  --title="PERMISOS" --text="Escriba cada opción separada por espacios: Printing DegradedPrinting ModifyContents ScreenReaders ModifyAnnotations FillIn AllFeatures"`
	if test $opcion = n  
	then
	pdftk "$FILE" output "$salida" owner_pw $USUARIO allow $PERMISOS
	else
	pdftk "$FILE" output "$salida" owner_pw $USUARIO user_pw $CONTRASE allow $PERMISOS
	fi
;;
# Reparar PDF
6)
clear
FILE=`zenity --file-selection  --title="Selecciona el archivo pdf corrupto que quieres intentar reparar"`

        case $? in
                 0)
                        echo "\"$FILE\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "Ha ocurrido un error inesperado.";;
        esac
salida=$(zenity --file-selection --save --confirm-overwrite);
	
	pdftk "$FILE" output "$salida"
;;
# Convertir a PDF::::: Convierte cualquier formato soportado por OpenOffice::::::Requiere Cups PDF y OpenOffice
7)
clear
FILE=`zenity --file-selection  --title="Selecciona el documento que quieres transformar a PDF (.odt, .doc, jpeg ...etc--Todos los soportados por OpenOffice---"`

        case $? in
                 0)
                        echo "\"$FILE\" seleccionado.";;
                 1)
                        echo "No ha seleccionado ningún archivo.";;
                -1)
                        echo "Ha ocurrido un error inesperado.";;
        esac
zenity --info \
          --text="El documento generado se guradará en \"$USER\"/Carpeta definida en CUPS-PDF (Vistar http://www.guia-ubuntu.org/index.php?title=Instalar_impresora#Instalar_una_impresora_PDF      ó      ejecutar script http://www.atareao.es/ubuntu/conociendo-ubuntu/instalar-una-impresora-pdf-en-ubuntu-con-un-script/ "
soffice  -pt PDF "$FILE"
esac

