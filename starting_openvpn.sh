!/bin/zsh

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

        clear
        echo "¿Quieres añadir o borrar algo en el /etc/hosts? "
        echo "1. Añadir"
        echo "2. Borrar"
        echo "3. No hacer cambios"
        read opcion_hosts

        case $opcion_hosts in
            1 )
                clear
                echo -n "Ingresa la dirección IP: "
                read ip
                echo -n "Ingresa el nombre de host: "
                read hostname
                echo "$ip $hostname" | sudo tee -a /etc/hosts >/dev/null
                echo "Contenido añadido exitosamente."
                mostrar_contenido_hosts
                ;;
            2 )
                clear
                echo -n "Ingresa el nombre de host que deseas borrar: "
                read hostname
                sudo sed -i "/$hostname/d" /etc/hosts
                echo "Entrada eliminada exitosamente."
                mostrar_contenido_hosts
                ;;
            3 )
                clear
                echo "No se realizaron cambios en el /etc/hosts."
                ;;
            * )
                clear
                echo "Opción no válida."
                ;;
        esac
    }

    conectar_vpn
    manipular_hosts

    if [[ "$opcion_hosts" == "3" && "$opcion_vpn" == "3" ]]; then
        echo "No se realizaron cambios ni en el archivo /etc/hosts ni en las conexiones VPN."
    fi
}

gestionar_opciones


