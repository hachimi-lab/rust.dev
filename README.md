# rust.dev

```bash
docker build -t  rust.dev:v1.0 -f .\Dockerfile .
docker run -d --name rust.dev -h rust.dev -p 8927:8927 --restart unless-stopped rust.dev:v1.0
```
