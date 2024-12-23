#!/bin/zsh

opcion_hosts=""
opcion_vpn=""

function gestionar_opciones {
    function conectar_vpn {
        clear
        echo "¿Qué deseas hacer?"
        echo "1. Conectar a VPN de laboratorio"
        echo "2. Interrumpir la conexión VPN"
        echo "3. Volver al menú principal"
        echo "4. Salir del script"
        read opcion_vpn

        case $opcion_vpn in
            1 )
                #!/bin/bash
                clear
                echo "Intentando conectar a VPN de laboratorio..."

                # Ejecutar OpenVPN en segundo plano con redirección de salida a un archivo de log
                sudo openvpn TU_VPN > /tmp/openvpn.log 2>&1 &

                # Esperar 5 segundos para que la conexión se establezca
                sleep 5

                # Verificar si el proceso openvpn con el archivo de configuración específico se está ejecutando
                if pgrep -f "TU_VPN" > /dev/null; then
                echo "Conexión a VPN de laboratorio exitosa"
                else
                echo "Error: La conexión a VPN de laboratorio falló."
                # Mostrar los últimos 10 mensajes del archivo de log para ayudar a diagnosticar el problema
                echo "Últimos mensajes del log de OpenVPN:"
                tail -n 10 /tmp/openvpn.log
                fi
                ;;
            2 )
                clear
                echo "Interrumpiendo la conexión VPN."
                if pgrep openvpn &>/dev/null; then
                    sudo -S pkill openvpn
                    sleep 2
                    if ! pgrep openvpn &>/dev/null; then
                        echo "Conexion VPN interrumpida con exito "
                    fi
                else
                    echo "No hay conexión VPN activa."
                fi
                ;;
            3 )
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
                sudo -S sed -i".bak" "/$entrada/d" /etc/hosts
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
    echo "1. Conectar o desconectar la VPN"
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

gestionar_opciones



