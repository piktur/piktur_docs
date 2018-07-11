# Piktur Docs

[![CircleCI](https://circleci.com/bb/piktur/piktur_docs.svg?style=svg)](https://circleci.com/bb/piktur/piktur_docs)

[piktur-docs](https://dashboard.heroku.com/apps/piktur-docs)
[piktur-docs-staging](https://dashboard.heroku.com/apps/piktur-docs-staging)

Build documentation for Piktur libraries locally with:

```sh
  rake yard:all
  rake yard:piktur_core
```

Fetch source from remote repository `rake yard:prepare`

Start documentation server `RACK_ENV=development rackup`

---

[Yard Cheatsheet](https://gist.github.com/chetan/1827484)

## Snippets

Generate symbolic link to nested README

```ruby
  %w(api admin blog client core store).each do |app|
    f = Rails.root.join("../piktur_#{app}/README.markdown")
    destination = Pathname(File.join(*f.to_s.rpartition("piktur_#{app}").insert(1, 'docs')))
    FileUtils.mkdir_p(destination.parent) unless destination.parent.exist?
    File.symlink(f, destination)
  end
```
