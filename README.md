# Scripts

This repository is archived. All scripts are stored in `scripts` folder in [tags-drive/tags-drive](https://github.com/tags-drive/tags-drive) repository.

---

This repository contains Dockerfile and scripts for building a Docker image of **Tags Drive**.

## Flags

| Flag           | Usage                                      | Default    | Example                   |
| -------------- | ------------------------------------------ | ---------- | ------------------------- |
| --name         | name of a Docker image                     | tags-drive | `--name="tags-drive"`     |
| --tag          | tag of a Docker image                      | latest     | `--tag="0.5.3"`           |
| --backend-tag  | tag (or branch), which should be cloned    | master     | `--backend-tag="master"`  |
| --frontend-tag | tag (or branch), which should be cloned    | master     | `--frontend-tag="v0.5.3"` |
| --no-cache     | use `--no-cache` option for `docker build` | false      | `--no-cache`              |

## Example

```sh
python build.py --name="tags-drive" --tag="0.5.3" --backend-tag="master" --frontend-tag="v0.5.3" --no-cache
```
