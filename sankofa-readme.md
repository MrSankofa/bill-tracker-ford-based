## start postgres with

```bash
psql -h localhost -p 5432 postgres
```

billtracker everything

start the docker postgres with

```bash
./gradlew bootRun
```

this is how you run it locally without docker

```bash
psql "postgresql://billtracker:billtracker@localhost:5432/billtracker"
```


you could run this once so git warns you before committing secrets

```bash
git config --global core.hooksPath .githooks
```