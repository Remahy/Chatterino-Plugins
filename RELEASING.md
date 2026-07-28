# Releasing

0. Create new branch.

1. Update "version" in "<pkg>/info.json"

2. Commit changes

3. Create new tag

```shell
git tag "<pkg>-v<semver>"
```

4. Push to the origin

```shell
git push
git push --tags
```

5. Squash PR into main.
