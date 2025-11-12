# taxi_app Frontend

| Funcionalidad consideradas                                           |
| -------------------------------------------------------------------- |
| Autenticar conductores y administrador                               |
| Conductor inicia una o más viajes con GPS                            |
| Conductor finaliza un viaje y registra la transacción (monto simple) |
| Administrador puede revisar viajes                                   |

## Demo

![Demo](az_recorder_faster.gif)

[Demo](az_recorder_faster.gif)

## Árbol de Carpetas

```bash
📦 taxi_app/
├── lib/                      # Código fuente principal de la app
│   ├── main.dart             # Punto de entrada de la aplicación
│   ├── models/               # Modelos (Estructuras de datos)
│   │   ├── driver_trip.model.dart               # Viaje del conductor
│   │   ├── driver_trip_full_report.model.dart   # Reporte completo del viaje (con coordenadas)
│   │   ├── driver_trip_report.model.dart        # Reporte breve del viaje
│   │   ├── tracking_trip.model.dart             # Posición GPS capturada con fecha
│   │   ├── user_account.model.dart              # Información de cuenta del usuario
│   │   └── user_data.model.dart                 # Datos de usuario breve
│   ├── pages/                # Páginas
│   │   ├── admin_dashboard.page.dart            # Página para mostrar el resumen de viajes (general)
│   │   ├── driver_done_trip_details.page.dart   # Detalles del viaje completado con coordenadas GPS
│   │   ├── driver_done_trips.page.dart          # Resumen de viajes completados (solo un conductor)
│   │   ├── driver_in_process_trip_details.page.dart # Viaje en tiempo real (coordenadas capturadas)
│   │   ├── driver_in_process_trips.page.dart    # Viajes en proceso a finalizar por el conductor
│   │   ├── login.page.dart                      # Página de Login (conductor o administrador)
│   │   └── start_trip.page.dart                 # Iniciar un nuevo viaje del conductor
│   ├── providers/           # Providers (manejo de estado)
│   │   ├── db.provider.dart                    # Simula la base de datos (reemplazar por backend real)
│   │   ├── driver_done_trips.provider.dart     # Datos de viajes completados del conductor
│   │   ├── driver_in_process_trips.provider.dart # Datos de viajes en proceso del conductor
│   │   ├── driver_trip_report.provider.dart    # Reportes para el panel de administración
│   │   ├── tracking_trips.provider.dart        # Carga de coordenadas GPS de un viaje
│   │   └── user_account.provider.dart          # Autenticación y datos de usuario
│   └── widgets/            # Widgets reutilizables
│       ├── driver_in_process_trip.widget.dart  # Lista de viajes en proceso del conductor
│       ├── driver_trip_status.widget.dart      # Estado del viaje (inprocess, done)
│       ├── price.widget.dart                   # Muestra el monto del viaje
│       └── user_roles.widget.dart              # Muestra los roles del usuario
```

## Apk de la aplicación

[Apk](app-release.apk)
