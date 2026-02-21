# Docker Setup para labReact

Este proyecto está configurado con Docker Compose para ejecutar el front, back y MySQL en contenedores.

## Requisitos Previos

- Docker Desktop instalado (https://www.docker.com/products/docker-desktop)
- Docker Compose (incluido en Docker Desktop)

## Estructura

```
labReact/
├── docker-compose.yml          # Orquestación de servicios
├── .dockerignore               # Archivos ignorados en builds
├── back/
│   ├── Dockerfile              # Imagen del servidor Node.js/Express
│   ├── package.json
│   └── src/
├── frontLab/
│   ├── Dockerfile              # Imagen con Nginx para servir React
│   ├── nginx.conf              # Configuración de Nginx
│   ├── package.json
│   └── src/
└── README.md (este archivo)
```

## Servicios

### MySQL (labReact-mysql)
- **Puerto**: 3306
- **Usuario**: root
- **Contraseña**: password
- **Base de datos**: lab_database
- **Volumen**: mysql_data (persistente)

### Backend (labReact-back)
- **Puerto**: 3000
- **Lenguaje**: Node.js + Express + TypeScript
- **Base de datos**: Sequelize + MySQL

### Frontend (labReact-front)
- **Puerto**: 5173
- **Tecnología**: Vite + React
- **Servidor**: Nginx

## Cómo usar

### 1. Levantar los servicios

Desde el directorio raíz del proyecto:

```bash
docker-compose up -d
```

Esto construirá las imágenes y levantará los tres contenedores.

### 2. Ver logs

```bash
# Todos los servicios
docker-compose logs -f

# Un servicio específico
docker-compose logs -f back
docker-compose logs -f front
docker-compose logs -f mysql
```

### 3. Acceder a los servicios

- **Frontend**: http://localhost:5173
- **Backend API**: http://localhost:3000
- **MySQL**: localhost:3306 (desde la aplicación) o 0.0.0.0:3306 (desde tu máquina)

### 4. Detener los servicios

```bash
docker-compose down
```

Para eliminar también los volúmenes (eliminaría los datos de MySQL):

```bash
docker-compose down -v
```

## Funcionalidades principales

### Variables de Entorno

El backend utiliza las siguientes variables de entorno definidas en `docker-compose.yml`:

- `DB_HOST`: Host de MySQL (dentro de la red Docker: `mysql`)
- `DB_USER`: Usuario de MySQL
- `DB_PASSWORD`: Contraseña
- `DB_NAME`: Nombre de la base de datos
- `DB_PORT`: Puerto de MySQL
- `NODE_ENV`: Ambiente (production/development)

El frontend usa:

- `VITE_API_URL`: URL de la API para las peticiones HTTP

### Comunicación entre servicios

- El **backend** se conecta a MySQL usando el hostname `mysql` (resolución de DNS en la red Docker)
- El **frontend** se comunica con el backend a través del proxy configurado en `nginx.conf`
- Las rutas `/api/*` se redirigen automáticamente al backend

## Troubleshooting

### El backend no puede conectar a MySQL

1. Verifica que MySQL esté healthy:
```bash
docker-compose ps
```

2. Espera a que MySQL esté listo (puede tomar 10-15 segundos)

3. Reinicia el backend:
```bash
docker-compose restart back
```

### Puerto ya en uso

Si algún puerto está en uso, edita `docker-compose.yml` y cambia los puertos:

```yaml
ports:
  - "3306:3306"  # cambiar el primer número
  - "3000:3000"  # cambiar el primer número
  - "5173:5173"  # cambiar el primer número
```

### Limpiar todo y empezar de nuevo

```bash
docker-compose down -v
docker system prune -a
docker-compose up -d
```

## Desarrollo

### Modo desarrollo (sin Docker)

Si necesitas desarrollar sin Docker:

#### Backend

```bash
cd back
npm install
npm run dev
```

#### Frontend

```bash
cd frontLab
npm install
npm run dev
```

Asegúrate de tener MySQL ejecutándose localmente en ese caso.

### Modo producción con Docker (build optimizado)

Los Dockerfiles ya están optimizados para producción:

- **Backend**: Compila TypeScript y ejecuta en Node.js
- **Frontend**: Usa multi-stage build y sirve con Nginx

## Recursos adicionales

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Express Documentation](https://expressjs.com/)
- [Vite Documentation](https://vitejs.dev/)
- [Sequelize Documentation](https://sequelize.org/)

---

**Nota**: Los datos de MySQL se persisten en el volumen `mysql_data`. Si necesitas resetear la base de datos, ejecuta `docker-compose down -v`.
