#!/bin/bash

# Script para gestionar Docker Compose de labReact

set -e

command=$1

case $command in
  up)
    echo "🚀 Levantando servicios..."
    docker-compose up -d
    echo "✅ Servicios levantados:"
    echo "   - Frontend: http://localhost:5173"
    echo "   - Backend: http://localhost:3000"
    echo "   - MySQL: localhost:3306"
    ;;
  down)
    echo "🛑 Deteniendo servicios..."
    docker-compose down
    echo "✅ Servicios detenidos"
    ;;
  logs)
    service=$2
    if [ -z "$service" ]; then
      docker-compose logs -f
    else
      docker-compose logs -f $service
    fi
    ;;
  restart)
    service=$2
    if [ -z "$service" ]; then
      echo "🔄 Reiniciando todos los servicios..."
      docker-compose restart
    else
      echo "🔄 Reiniciando $service..."
      docker-compose restart $service
    fi
    echo "✅ Hecho"
    ;;
  status)
    echo "📊 Estado de servicios:"
    docker-compose ps
    ;;
  clean)
    echo "🧹 Limpiando contenedores y volúmenes..."
    docker-compose down -v
    echo "✅ Limpieza completada"
    ;;
  rebuild)
    service=$2
    if [ -z "$service" ]; then
      echo "🔨 Reconstruyendo todas las imágenes..."
      docker-compose up -d --build
    else
      echo "🔨 Reconstruyendo $service..."
      docker-compose up -d --build $service
    fi
    echo "✅ Reconstrucción completada"
    ;;
  shell)
    service=$2
    if [ -z "$service" ]; then
      echo "⚠️  Especifica un servicio: back, front, o mysql"
      exit 1
    fi
    docker-compose exec $service sh
    ;;
  *)
    echo "Uso: ./docker.sh <comando> [servicio]"
    echo ""
    echo "Comandos disponibles:"
    echo "  up              Levantar todos los servicios"
    echo "  down            Detener todos los servicios"
    echo "  logs [servicio] Ver logs de los servicios"
    echo "  restart [serv]  Reiniciar servicios"
    echo "  status          Ver estado de los servicios"
    echo "  clean           Eliminar contenedores y volúmenes"
    echo "  rebuild [serv]  Reconstruir imágenes"
    echo "  shell <serv>    Abrir terminal en un contenedor"
    echo ""
    echo "Ejemplos:"
    echo "  ./docker.sh up"
    echo "  ./docker.sh logs back"
    echo "  ./docker.sh restart back"
    echo "  ./docker.sh shell back"
    exit 1
    ;;
esac
