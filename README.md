# Scripts

This repository contains Dockerfile and scripts for building docker images of **Tags Drive**

## Flags

| Flag               | Usage                                   | Example       |
| ------------------ | --------------------------------------- | ------------- |
| -n, --name         | name of docker image                    | -n=tags-drive |
| -t, --tag          | tag of docker image                     | -t=v0.5       |
| -b, --backend-tag  | tag (or branch), which should be cloned | -b=master     |
| -f, --frontend-tag | tag (or branch), which should be cloned | -b=v0.4.5     |

## Example

```sh
python build.py -n="tags-drive" -t="v0.5" -b="master" -f="v0.4.5"
```
