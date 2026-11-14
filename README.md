# gyro-pipeline-ornek

Gyro Pipeline için örnek uygulama: her `git push`'ta Gyro Kapsayıcı (ECS) kodu yalıtılmış bir derleme ortamında **Dockerfile** ile derler, imajı ortamın özel deposuna koyar ve `web` servisini kesintisiz yeni sürüme geçirir. Sağlık kontrolü geçmezse önceki sürüme kendiliğinden dönülür.

Example app for Gyro Pipeline: on every `git push` Gyro Containers (ECS) builds the code from its **Dockerfile** in an isolated build environment, pushes the image to the environment's private registry and rolls the `web` service out to the new version without downtime. If the health check fails, the previous version comes back automatically.

## Kullanım / Usage

1. Gyro Kapsayıcı hizmetinizde 8080 portlu, internete açık bir `web` servisi oluşturun (sağlık yolu `/healthz`).
2. **Pipeline** sekmesinde yeni pipeline: depo `https://github.com/<siz>/gyro-pipeline-ornek`, dal `main`.
3. Panelin gösterdiği webhook adresini ve gizli anahtarı deponuza ekleyin (Settings → Webhooks, `application/json`, push).
4. `git push` — derleme logunu panelden canlı izleyin.

Ayarlar `gyro-pipeline.yml` dosyasında. Ayrıntı: Gyro Bilgi Merkezi → Gyro Pipeline.

## Çok aşamalı Dockerfile / Multi-stage Dockerfile

Üretim aşamanız son aşama değilse derlenecek aşamayı seçin (`docker build --target` ile aynı):
If your production stage is not the last one, choose the stage to build (same as `docker build --target`):

```dockerfile
FROM node:20 AS base
WORKDIR /app
COPY . .
RUN yarn install --frozen-lockfile

FROM base AS production
RUN yarn build
CMD ["node", "dist/main"]

FROM base AS development
CMD ["yarn", "start:dev"]
```

- `gyro-pipeline.yml`: `build_target: production`
- Panel / Panel: **Derleme hedefi (Dockerfile aşaması)** / **Build target (Dockerfile stage)**
- API: `"build_target": "production"` · CLI: `gyro container pipeline update <id> <pipeline> --target production` · Terraform: `build_target = "production"`

Boş = son aşama. Olmayan aşama adı derlemeyi `build_target_not_found` hatasıyla durdurur. / Empty = last stage. An unknown stage stops the run with `build_target_not_found`.

## Dosyalar / Files

- `Dockerfile` — imaj tarifi (nginx-unprivileged, 8080)
- `gyro-pipeline.yml` — derleme komutları + dağıtılacak servisler
- `site/` — statik site; `version.txt` derlemede commit ile yazılır
