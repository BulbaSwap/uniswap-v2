# Deploying

Modify .env.example and save into .env

## Local

Requires foundry installation https://book.getfoundry.sh/getting-started/installation

Export env vars

```
export $(cat .env | xargs)
```

run script

```
./deploy.sh
```

## Docker

Build image
```
docker build --no-cache --progress=auto -t forge-deploy-univ2:latest .
```

Run image command
```
docker run --env-file .env forge-deploy-univ2:latest
```