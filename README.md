
# hihihi deploy hahaha


```bash
gh auth login
```

`.secrets` example:

```bash
DEPLOY_SSH_KEY=""
DEPLOY_USER=
DEPLOY_HOST=
DEPLOY_PATH=
PROXY_USER=
PROXY_HOST=
```

script usage:

```bash
./scripts/push-secrets.sh \
  dm-mzzkh/game1 \
  dm-mzzkh/game2 \
  dm-mzzkh/game3
```

check:

```bash
gh secret list --repo dm-mzzkh/my-game
```

reusable workflow usage:


```yaml
name: Export Web & Deploy

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  deploy:
    uses: dm-mzzkh/godot-ci/.github/workflows/godot-web-deploy.yml@main
    secrets: inherit
    with:
      godot_version: "4.6"
```
