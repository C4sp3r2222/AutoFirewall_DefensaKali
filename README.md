# Firewall Defensa - Kali Linux

Script Bash para gestionar la seguridad de tu máquina Kali mediante reglas de iptables. Permite aplicar diferentes niveles de protección, ver reglas activas y restaurar la configuración inicial. Incluye análisis de puertos antes y después de aplicar las reglas para comprobar los cambios en tiempo real.

.
.

-----------------------------------------------

-Nivel 1: protege la máquina pero deja accesibles servicios comunes para uso normal y pruebas.
= “puertas cerradas, pero algunas permanecen abiertas para servicios comunes”.


-Nivel 2: máxima protección, bloquea todos los puertos entrantes excepto los esenciales, ideal si quieres minimizar exposición ante la red.
= “puertas cerradas hacia fuera, pero yo puedo salir”.
|
|
Diagrama de flujo de paquetes – Nivel 2

        Internet
           |
           |   (Paquetes entrantes no solicitados)
           |   ❌ BLOQUEADOS
           |
       [INPUT]  <-- Solo permite ESTABLISHED/RELATED
           |
       +---------+
       |  Kali   |
       +---------+
           |
           |   (Paquetes salientes)
           |   ✅ PERMITIDOS
           v
       [OUTPUT]
           |
        Internet


------------------------------------------------------

.
.

### Instalación:

-1º Descargar el script y guardarlo en tu Kali:
-2º Dar permisos de ejecución:

$ chmod +x defensa.sh



-3º Ejecutar como root:

$ sudo ./defensa.sh

.
.

### Uso: ---------------------------------------------

Al ejecutar el script, debemos hacerlo como root, verás un menú con opciones:

Opción	Función
1	Nivel 1 – Protección básica: bloquea el tráfico entrante excepto SSH (22), HTTP (80) y HTTPS (443). Permite todo el tráfico saliente.
2	Nivel 2 – Protección estricta: bloquea todo el tráfico entrante no solicitado. Solo permite tráfico saliente y loopback.
3	Restaurar configuración inicial – Limpia reglas y vuelve a aceptar todo.
4	Ver reglas actuales – Muestra las reglas activas de iptables con detalle.
0	Salir – Cierra el script.

[+] Funcionalidades adicionales

Análisis de puertos abiertos antes y después de aplicar cada nivel (usa ss y nmap).

Registro de acciones en /var/log/defensa_firewall.log.

Interfaz visual con colores y banners para mayor claridad.

.
.

### CAPTURAS: ---------------------------------------------

-Menú:

![Defensaimg0](https://github.com/user-attachments/assets/a20fcba5-75ea-4fd4-b5ca-44014a578f5f)


-Nivel 1 iptables:

![Defensaimg2](https://github.com/user-attachments/assets/7ca8f315-c26d-487d-8ecf-8632a20394ea)


-Nivel 2 iptables:

![Defensaimg3](https://github.com/user-attachments/assets/927f85b6-d77c-4234-8686-79f5b497fbdf)

.
.

### Notas: ---------------------------------------------------

Se recomienda hacer un backup de reglas de iptables si quieres restaurar manualmente:

sudo iptables-save > backup_iptables.rules


Para restaurar desde el backup:

sudo iptables-restore < backup_iptables.rules



