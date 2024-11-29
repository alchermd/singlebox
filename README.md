# singlebox

## Development

```console
$ cp src/web/.env.dev.example src/web/.env.dev # Update as necessary
$ make dev
$ make migrate
```

## Deployment

```console
$ cp ./terraform/.tfvars.example ./terraform/.tfvars # Update values as necessary.
$ make init
$ make deploy
```
