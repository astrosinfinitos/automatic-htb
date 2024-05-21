#!/bin/zsh

opcion_hosts=""
opcion_vpn=""

function gestionar_opciones {
    function conectar_vpn {
        clear
        echo "¿Qué deseas hacer?"
        echo "1. Conectar a VPN de laboratorio"
        echo "2. Conectar a VPN de starting point"
        echo "3. No conectar a ninguna VPN"
        read opcion_vpn

        case $opcion_vpn in
            1 )
                clear
                echo "Intentando conectar a VPN de laboratorio."
                sudo openvpn YOUR_VPN &>/dev/null &
                sleep 2
                if [[ $? -eq 0 ]]; then
                    echo "Conexión a VPN de laboratorio exitosa."
                else
                    echo "Error: La conexión a VPN de laboratorio falló."
                fi
                ;;
            2 )
                clear
                echo "Intentando conectar a VPN de starting point."
                sudo openvpn YOUR_VPN &>/dev/null &
                sleep 2
                if [[ $? -eq 0 ]]; then
                    echo "Conexión a VPN de starting point exitosa."
                else
                    echo "Error: La conexión a VPN de starting point falló."
                fi
                ;;
            3 )
                clear
                echo "No se realizó ninguna conexión VPN."
                ;;
            * )
                clear
                echo "Opción no válida."
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
                echo "$ip $nombre_host" | sudo tee -a /etc/hosts

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

                sudo sed -i".bak" "/$entrada/d" /etc/hosts

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
            * )
                clear
                echo "Opción no válida."
                ;;
        esac
    }

    clear
    echo "¿Qué deseas hacer?"
    echo "1. Conectar VPN"
    echo "2. Manipular archivo /etc/hosts"
    echo "3. Salir"
    read opcion_principal

    case $opcion_principal in
        1 )
            conectar_vpn
            ;;
        2 )
            manipular_hosts
            ;;
        3 )
            clear
            echo "Saliendo del script."
            exit 0
            ;;
        * )
            clear
            echo "Opción no válida."
            ;;
    esac
}

gestionar_opciones



