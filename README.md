# lifelink

PUSL2023 Group 3 submission

## setting up

```bash
git clone https://github.com/libresoul/lifelink.git
cd lifelink
flutter run -d <device> # or debug with IDE
```

## To integrate with the Cloudflare Worker

```bash
flutter run -d <device> --dart-define=API_BASE_URL=http://<worker>
```
