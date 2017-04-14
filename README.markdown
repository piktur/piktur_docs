# Piktur Docs

[![CircleCI](https://circleci.com/bb/piktur/piktur_docs.svg?style=svg)](https://circleci.com/bb/piktur/piktur_docs)

[piktur-docs-staging](https://dashboard.heroku.com/apps/piktur-docs-staging)
[piktur-docs](https://dashboard.heroku.com/apps/piktur-docs)

Build documentation for Piktur libraries locally with:

```
  rake yard:all
  rake yard:all OPTS='--override --default --opts'
  rake yard:piktur_core
```

Fetch source from remote repository `rake yard:prepare`

Start documentation server `RACK_ENV=development rackup`
