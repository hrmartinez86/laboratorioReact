@echo off
REM Script para gestionar Docker Compose de labReact (Windows)

setlocal enabledelayedexpansion

set command=%1
set service=%2

if "!command!"=="up" (
    echo Levantando servicios...
    docker-compose up -d
    echo.
    echo Servicios levantados:
    echo    - Frontend: http://localhost:5173
    echo    - Backend: http://localhost:3000
    echo    - MySQL: localhost:3306
) else if "!command!"=="down" (
    echo Deteniendo servicios...
    docker-compose down
    echo Servicios detenidos
) else if "!command!"=="logs" (
    if "!service!"=="" (
        docker-compose logs -f
    ) else (
        docker-compose logs -f !service!
    )
) else if "!command!"=="restart" (
    if "!service!"=="" (
        echo Reiniciando todos los servicios...
        docker-compose restart
    ) else (
        echo Reiniciando !service!...
        docker-compose restart !service!
    )
    echo Hecho
) else if "!command!"=="status" (
    echo Estado de servicios:
    docker-compose ps
) else if "!command!"=="clean" (
    echo Limpiando contenedores y volumenes...
    docker-compose down -v
    echo Limpieza completada
) else if "!command!"=="rebuild" (
    if "!service!"=="" (
        echo Reconstruyendo todas las imagenes...
        docker-compose up -d --build
    ) else (
        echo Reconstruyendo !service!...
        docker-compose up -d --build !service!
    )
    echo Reconstruccion completada
) else if "!command!"=="shell" (
    if "!service!"=="" (
        echo Especifica un servicio: back, front, o mysql
        exit /b 1
    )
    docker-compose exec !service! sh
) else (
    echo Uso: docker.bat [comando] [servicio]
    echo.
    echo Comandos disponibles:
    echo   up              Levantar todos los servicios
    echo   down            Detener todos los servicios
    echo   logs [servicio] Ver logs de los servicios
    echo   restart [serv]  Reiniciar servicios
    echo   status          Ver estado de los servicios
    echo   clean           Eliminar contenedores y volumenes
    echo   rebuild [serv]  Reconstruir imagenes
    echo   shell [serv]    Abrir terminal en un contenedor
    echo.
    echo Ejemplos:
    echo   docker.bat up
    echo   docker.bat logs back
    echo   docker.bat restart back
    exit /b 1
)

endlocal
