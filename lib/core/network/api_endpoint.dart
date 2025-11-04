/// Enum que centraliza todos los endpoints de la API para evitar errores de tipeo.
///
/// Cada miembro representa una ruta específica de la API.
/// El uso de '%s' permite la inserción de parámetros en la URL de forma segura.
enum ApiEndPoint {
  // === Auth ===
  /// POST /auth/login
  logIn('auth/login'),
  /// POST /auth/logout
  logOut('auth/logout'),
  /// POST /auth/complete-invite
  completeInvite('auth/complete-invite'),
  /// POST /auth/refresh
  refreshToken('auth/refresh'),

  // === Profile ===
  /// GET /profile
  getProfile('profile'),

  // === Registrations ===
  /// POST /registrations
  createRegistration('registrations'),
  /// GET /registrations
  getRegistrations('registrations'),
  /// GET /registrations/{registration_id}
  getRegistrationById('registrations/%s'),
  /// PATCH /registrations/{registration_id}
  updateRegistration('registrations/%s'),
  /// DELETE /registrations/{registration_id}
  deleteRegistration('registrations/%s'),
  /// POST /registrations/sync
  syncRegistrations('registrations/sync'),
  /// GET /registrations/sync/summary
  getSyncSummary('registrations/sync/summary'),

  // === Admin ===
  /// GET /admin/users
  getAdminUsers('admin/users'),
  /// GET /admin/users/{user_id}
  getAdminUserById('admin/users/%s'),
  /// PATCH /admin/users/{user_id}
  updateAdminUser('admin/users/%s'),
  /// DELETE /admin/users/{user_id}
  deleteAdminUser('admin/users/%s'),
  /// POST /admin/users/{user_id}/resend-invite
  resendInvite('admin/users/%s/resend-invite'),
  /// GET /admin/dashboard/summary
  getDashboardSummary('admin/dashboard/summary'),
  
  // === Catalogs ===
  /// GET /catalogs/locations
  getCatalogLocations('catalogs/locations'),
  /// GET /catalogs/roles
  getCatalogRoles('catalogs/roles'),

  // === Health Check ===
  /// GET /health
  healthCheck('health');


  /// La URL relativa del endpoint.
  final String url;

  /// Constructor para el enum.
  const ApiEndPoint(this.url);
}
