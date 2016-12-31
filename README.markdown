# Piktur Docs

[![CircleCI](https://circleci.com/bb/piktur/piktur_docs.svg?style=svg)](https://circleci.com/bb/piktur/piktur_docs)


[piktur-docs-staging](https://dashboard.heroku.com/apps/piktur-docs-staging)
[piktur-docs](https://dashboard.heroku.com/apps/piktur-docs)

```

    # Build documentation for Piktur libraries locally with:
    bundle exec rake yard:api
    bundle exec rake yard:core
    # ...

    # Start server
    RACK_ENV=development rackup

```

Fetch current source from remote repository `rake yard:prepare`
