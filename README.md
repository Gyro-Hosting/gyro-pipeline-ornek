# gyro-pipeline-ornek

Gyro Pipeline için örnek uygulama: her `git push`'ta Gyro Kapsayıcı (ECS) kodu yalıtılmış bir derleme ortamında **Dockerfile** ile derler, imajı ortamın özel deposuna koyar ve `web` servisini kesintisiz yeni sürüme geçirir. Sağlık kontrolü geçmezse önceki sürüme kendiliğinden dönülür.

Example app for Gyro Pipeline: on every `git push` Gyro Containers (ECS) builds the code from its **Dockerfile** in an isolated build environment, pushes the image to the environment's private registry and rolls the `web` service out to the new version without downtime. If the health check fails, the previous version comes back automatically.

## Kullanım / Usage

1. Gyro Kapsayıcı hizmetinizde 8080 portlu, internete açık bir `web` servisi oluşturun (sağlık yolu `/healthz`).
2. **Pipeline** sekmesinde yeni pipeline: depo `https://github.com/<siz>/gyro-pipeline-ornek`, dal `main`.
3. Panelin gösterdiği webhook adresini ve gizli anahtarı deponuza ekleyin (Settings → Webhooks, `application/json`, push).
4. `git push` — derleme logunu panelden canlı izleyin.

Ayarlar `gyro-pipeline.yml` dosyasında. Ayrıntı: Gyro Bilgi Merkezi → Gyro Pipeline.

## Dosyalar / Files

- `Dockerfile` — imaj tarifi (nginx-unprivileged, 8080)
- `gyro-pipeline.yml` — derleme komutları + dağıtılacak servisler
- `site/` — statik site; `version.txt` derlemede commit ile yazılır
