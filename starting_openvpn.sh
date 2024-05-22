#!/bin/zsh

opcion_hosts=""
opcion_vpn=""
sudo_password=""

# Comprobar si el script se ejecuta con permisos de root
if [[ $EUID -ne 0 ]]; then
    clear
    echo "Este script debe ser ejecutado como root." 1>&2
    exit 1
fi

function solicitar_sudo_password {
    clear
    echo -n "Introduce la contraseña de sudo: "
    read -s sudo_password
    echo
}

function gestionar_opciones {
    function conectar_vpn {
        clear
        echo "¿Qué deseas hacer?"
        echo "1. Conectar a VPN de laboratorio"
        echo "2. Conectar a VPN de starting point"
        echo "3. Interrumpir la conexión VPN"
        echo "4. Volver al menú principal"
        echo "5. Salir del script"
        read opcion_vpn

        case $opcion_vpn in
            1 )
                clear
                echo "Intentando conectar a VPN de laboratorio."
                echo $sudo_password | sudo -S openvpn YOUR_VPN &>/dev/null &
                sleep 2
                if pgrep openvpn &>/dev/null; then
                    echo "Conexión a VPN de laboratorio exitosa" 
                else
                    echo "Error: La conexión a VPN de laboratorio falló."
                fi
                ;;
            2 )
                clear
                echo "Intentando conectar a VPN de starting point."
                echo $sudo_password | sudo -S openvpn YOUR_VPN_LAB &>/dev/null &
                sleep 2
                if pgrep openvpn &>/dev/null; then
                    echo "Conexión a VPN de starting point exitosa."
                else
                    echo "Error: La conexión a VPN de starting point falló."
                fi
                ;;
            3 )
                clear
                echo "Interrumpiendo la conexión VPN."
                if pgrep openvpn &>/dev/null; then
                    echo $sudo_password | sudo -S pkill openvpn
                    sleep 2
                    if ! pgrep openvpn &>/dev/null; then
                        echo "Conexión VPN interrumpida exitosamente."
                    else
                        echo "Error: No se pudo interrumpir la conexión VPN."
                    fi
                else
                    echo "No hay conexión VPN activa."
                fi
                ;;
            4 )
                clear
                gestionar_opciones
                ;;
	    5 )
		clear
                echo "Saliendo del programa"
                exit 0
                ;;
            * )
                clear
                echo "Opción no válida."
		exit 127
                ;;
        esac
    }

    function manipular_hosts {
        function mostrar_contenido_hosts {
            clear
            echo "Contenido actual de /etc/hosts:"
            cat /etc/hosts
        }

        function agregar_entrada_host {
            local continuar="y"
            while [[ $continuar == "y" || $continuar == "Y" ]]; do
                clear
                echo "Agregar una nueva entrada al archivo /etc/hosts:"
                echo -n "Introduce la IP: "
                read ip
                echo -n "Introduce el nombre del host: "
                read nombre_host
                echo $sudo_password | sudo -S bash -c "echo '$ip $nombre_host' >> /etc/hosts"
                echo "¿Deseas agregar otra entrada? (y/n): "
                read continuar
            done

            # Mostrar el contenido actualizado del archivo /etc/hosts
            mostrar_contenido_hosts
        }

        function borrar_entrada_host {
            local continuar="y"
            while [[ $continuar == "y" || $continuar == "Y" ]]; do
                clear
                echo "Borrar una entrada del archivo /etc/hosts:"
                echo -n "Introduce la IP o el nombre del host a borrar: "
                read entrada
                echo $sudo_password | sudo -S sed -i".bak" "/$entrada/d" /etc/hosts
                echo "¿Deseas borrar otra entrada? (y/n): "
                read continuar
            done

            # Mostrar el contenido actualizado del archivo /etc/hosts
            mostrar_contenido_hosts
        }

        clear
        echo "¿Qué deseas hacer?"
        echo "1. Mostrar contenido de /etc/hosts"
        echo "2. Agregar entrada al archivo /etc/hosts"
        echo "3. Borrar entrada del archivo /etc/hosts"
        echo "4. Volver al menú principal"
        echo "5. Salir del script"
        read opcion_hosts

        case $opcion_hosts in
            1 )
                mostrar_contenido_hosts
                ;;
            2 )
                agregar_entrada_host
                ;;
            3 )
                borrar_entrada_host
                ;;
            4 )
                gestionar_opciones
                ;;
            5 )
		clear
                echo "Saliendo del programa"
	        exit 0
		;;
            * )
                clear
                echo "Opción no válida."
		exit 127
                ;;
        esac
    }

    clear
    echo "¿Qué deseas hacer?"
    echo "1. Conectar o desconectar la VPN de Hack the Box"
    echo "2. Manipular archivo /etc/hosts"
    echo "3. Volver al menú principal"
    echo "4. Salir del programa"
    read opcion_principal

    case $opcion_principal in
        1 )
            conectar_vpn
            ;;
        2 )
            manipular_hosts
            ;;
        3 )
            gestionar_opciones
	   ;; 
	4 )
            clear
            echo "Saliendo del script."
            exit 0
            ;;
        * )
            clear
            echo "Opción no válida."
	    exit 127
            ;;
    esac
}

solicitar_sudo_password
gestionar_opciones



