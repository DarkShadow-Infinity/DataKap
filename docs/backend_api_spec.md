# DataKap Backend API Specification

Esta especificación describe los endpoints mínimos para sustituir Firebase por un backend HTTP propio manteniendo el comportamiento actual de la app móvil. La estructura sigue un patrón REST, usa JSON como formato de intercambio y tokens Bearer para autenticación.

## Convenciones generales

- **Base URL**: `https://api.datakap.mx/v1`
- **Autenticación**: Todas las rutas (salvo login) requieren el encabezado `Authorization: Bearer <token>`.
- **Zona horaria**: Tiempos en formato ISO 8601 (`YYYY-MM-DDThh:mm:ssZ`).
- **Paginación**: Parámetros opcionales `page`, `limit` (por defecto `page=1`, `limit=20`).
- **Errores**: Respuesta uniforme

```json
{
  "code": "string",
  "message": "Descripción legible",
  "details": {
    "campo": ["errores de validación"]
  }
}
```

## 1. Autenticación y sesión

### POST `/auth/login`
Inicia sesión con email y contraseña.

**Request**
```json
{
  "email": "user@example.com",
  "password": "Secreta123"
}
```

**Response 200**
```json
{
  "token": "jwt-token",
  "refreshToken": "jwt-refresh",
  "expiresIn": 3600,
  "user": {
    "id": "2d43lGSELnPo3Om426elCxCm8Kd2",
    "email": "user@example.com",
    "role": "promoter" // admin | leader | promoter
  }
}
```

**Errores comunes**
- 401 `INVALID_CREDENTIALS`
- 423 `USER_DISABLED`

### POST `/auth/complete-invite`
Finaliza el primer acceso de promotores o líderes invitados. Valida el código de verificación recibido por correo y fuerza el cambio de contraseña temporal.

**Request**
```json
{
  "email": "promoter@example.com",
  "temporaryPassword": "Tmp#2025",
  "verificationCode": "ABCD1234",
  "newPassword": "Seguro#123"
}
```

**Response 200**
```json
{
  "token": "jwt-token",
  "refreshToken": "jwt-refresh",
  "expiresIn": 3600,
  "user": {
    "id": "usr-99",
    "email": "promoter@example.com",
    "role": "promoter"
  }
}
```

**Errores comunes**
- 400 `INVALID_VERIFICATION_CODE`
- 410 `INVITE_EXPIRED`

### POST `/auth/refresh`
Renueva el token cuando la app recupere conexión.

**Request**
```json
{
  "refreshToken": "jwt-refresh"
}
```

**Response 200**
```json
{
  "token": "nuevo-token",
  "expiresIn": 3600
}
```

### POST `/auth/logout`
Invalida tokens activos (opcional si se maneja solo en cliente).

**Response 204** sin cuerpo.

## 2. Perfil del usuario autenticado

### GET `/profile`
Obtiene la información del usuario actual y su rol.

**Response 200**
```json
{
  "id": "2d43lGSELnPo3Om426elCxCm8Kd2",
  "email": "user@example.com",
  "role": "leader",
  "fullName": "Diego Palomares",
  "phone": "+52 55 5555 5555"
}
```

## 3. Registros de ciudadanos (Promovidos / Líderes)

Los formularios recaban los mismos campos para captura manual o mediante INE; la diferencia es la foto y el indicador `requiresPhoto`.

### POST `/registrations`
Crea un registro local o remoto. Si el dispositivo está offline, se almacena localmente y se sincroniza después mediante los endpoints de sincronización.

**Cabeceras especiales**
- `X-Client-Request-Id`: UUID generado por la app para evitar duplicados al reintentar.

**Request (Manual)**
```json
{
  "role": "promoter",
  "requiresPhoto": false,
  "fields": {
    "claveElector": "ABC1234567890",
    "sexo": "M",
    "nombre": "Juan",
    "apellidoPaterno": "Pérez",
    "apellidoMaterno": "López",
    "direccion": "Calle 1 #123",
    "codigoPostal": "01010",
    "vigencia": "2027",
    "estado": "Ciudad de México",
    "municipio": "Álvaro Obregón",
    "localidad": "San Ángel",
    "telefono": "5512345678",
    "whatsapp": "5512345678"
  }
}
```

**Request (Captura con INE)**
Multipart `form-data`:
- Campo `metadata`: JSON igual al request manual con `requiresPhoto=true`.
- Campo `photo`: archivo JPEG/PNG ≤ 10 MB.

**Response 201**
```json
{
  "id": "srv-6f0c1",
  "status": "pending_validation"
}
```

### GET `/registrations`
Lista registros del usuario actual (promoter/leader) filtrando por `syncStatus` (`pending`, `synced`, `failed`).

**Query params**: `syncStatus`, `from`, `to`, `role`.

**Response 200**
```json
{
  "items": [
    {
      "id": "srv-6f0c1",
      "role": "promoter",
      "requiresPhoto": true,
      "fields": {"nombre": "Juan", "telefono": "5512345678"},
      "photoUrl": "https://.../srv-6f0c1.jpg",
      "createdAt": "2025-02-01T17:24:00Z",
      "syncedAt": "2025-02-01T17:30:00Z",
      "syncStatus": "synced"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 42
  }
}
```

### GET `/registrations/{id}`
Devuelve el detalle completo de un registro.

### PATCH `/registrations/{id}`
Permite actualizar campos cuando el servidor rechaza la información.

### DELETE `/registrations/{id}`
Marca el registro como eliminado (solo admins o dueño antes de sincronizar).

## 4. Sincronización offline

La app mantiene un listado local de registros pendientes. Estos endpoints permiten sincronizarlos una vez que vuelve la conectividad.

### POST `/registrations/sync`
Recibe múltiples registros creados offline.

**Request**
```json
{
  "payload": [
    {
      "clientRequestId": "uuid-1",
      "role": "leader",
      "requiresPhoto": false,
      "fields": {"nombre": "María"},
      "createdAt": "2025-02-01T12:00:00Z"
    }
  ]
}
```

**Response 200**
```json
{
  "results": [
    {
      "clientRequestId": "uuid-1",
      "status": "synced",
      "serverId": "srv-6f0c1"
    }
  ]
}
```

### GET `/registrations/sync/summary`
Entrega estadísticas para la pantalla de sincronización.

```json
{
  "pending": 5,
  "syncedToday": 12,
  "failed": 1
}
```

## 5. Gestión de usuarios (rol Admin)

### GET `/admin/users`
Lista promotores y líderes gestionados por el admin.

**Query params**: `role=promoter|leader`, `status=active|pending|disabled`, `search`.

**Response 200**
```json
{
  "items": [
    {
      "id": "usr-1",
      "email": "promoter@example.com",
      "fullName": "Promotor Uno",
      "phone": "5512345678",
      "role": "promoter",
      "goal": 100,
      "status": "active",
      "verificationCode": "ABCD1234",
      "createdAt": "2025-01-20T10:15:00Z"
    }
  ]
}
```

### POST `/admin/users`
Crea un promotor o líder con contraseña temporal y código de verificación.

**Request**
```json
{
  "email": "nuevo@ejemplo.com",
  "fullName": "Nuevo Promotor",
  "phone": "5512345678",
  "role": "promoter",
  "goal": 150,
  "sendEmail": true,
  "expiresInHours": 48
}
```

**Response 201**
```json
{
  "id": "usr-99",
  "temporaryPassword": "Tmp#2025",
  "verificationCode": "KLMN4567",
  "expiresAt": "2025-02-01T18:00:00Z"
}
```

### GET `/admin/users/{id}`
Detalle de un usuario.

### PATCH `/admin/users/{id}`
Actualiza meta, estatus o reenvía invitación.

**Request ejemplo**
```json
{
  "goal": 200,
  "status": "active"
}
```

### DELETE `/admin/users/{id}`
Desactiva o elimina un usuario (respuesta `204`).

### POST `/admin/users/{id}/resend-invite`
Reenvía la contraseña temporal y el código de verificación.

## 6. Dashboard administrativo

### GET `/admin/dashboard/summary`
Devuelve métricas para las tarjetas de la pantalla principal.

**Response 200**
```json
{
  "promoters": {
    "active": 10,
    "pending": 2,
    "rejected": 1
  },
  "leaders": {
    "active": 5,
    "pending": 3,
    "rejected": 0
  },
  "registrations": {
    "today": 45,
    "thisWeek": 210,
    "thisMonth": 820
  }
}
```

## 7. Catálogos y utilidades

### GET `/catalogs/locations`
Entrega catálogos para formularios (estados, municipios, localidades).

**Query params**: `state`, `municipality`.

```json
{
  "states": ["Aguascalientes", "Baja California"],
  "municipalities": ["Álvaro Obregón"],
  "localities": ["San Ángel"]
}
```

### GET `/catalogs/roles`
Devuelve roles válidos (`admin`, `leader`, `promoter`).

## 8. Notas de implementación

- **Idempotencia**: usar `clientRequestId` para evitar duplicados al reintentar sincronización o registro manual.
- **Carga de fotos**: almacenar en CDN y devolver `photoUrl` al sincronizar.
- **Seguridad**: proteger endpoints admin con `role=admin` en el token; el backend debe validar roles antes de ejecutar la acción.
- **Versionado**: mantener campo `apiVersion` en la respuesta de `/profile` o `/admin/dashboard` para detectar incompatibilidades futuras.
- **Auditoría**: registrar `performedBy` (uid del admin) en cambios de usuarios.

## 9. Cobertura en la app móvil

La aplicación Flutter ya tiene pantallas y controladores que consumen los datos descritos en esta especificación. Una vez que el backend exponga los endpoints, basta con reemplazar las implementaciones actuales de Firebase dentro de la capa `data/` para conectar la UI existente.

| Módulo | Pantallas/controladores relevantes | Endpoints principales |
| --- | --- | --- |
| Autenticación | `LoginPage`, `AuthController` | `/auth/login`, `/auth/refresh`, `/auth/logout`, `/profile` |
| Invitaciones admin | `AdminAddPromoterPage`, `AdminAddLeaderPage`, `AdminUserFormController` | `/admin/users`, `/auth/complete-invite` |
| Dashboard admin | `HomeAdminPage`, `AdminUserController` | `/admin/dashboard/summary`, `/admin/users`, `/admin/users/{id}` |
| Captura manual / INE | `ManualRegistrationPage`, `IneRegistrationPage`, `RoleRegistrationController` | `/registrations`, `/registrations/{id}`, `/registrations/sync` |
| Sincronización offline | `RegistrationSyncPage`, `RegistrationSyncController` | `/registrations/sync`, `/registrations/sync/summary` |
| Navegación por rol | `RoleOptionsPage`, `RoleNavigationDrawer` | `/profile`, catálogos |

Los controladores ya encapsulan el manejo offline, la verificación de conectividad y la propagación de eventos UI mediante `SONotifier`, por lo que el reemplazo de Firebase por un backend REST implica principalmente nuevas implementaciones en `data/data_sources` y `data/repositories` sin cambios en la capa de presentación.

Con esta API la app actual puede operar en modo online/offline, gestionar roles y realizar el flujo completo de capturas y sincronización sin depender de Firebase.
