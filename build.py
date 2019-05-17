import os
import argparse

# Init args
parser = argparse.ArgumentParser(description="This script builds a Docker image of Tags Drive")

parser.add_argument("--name",
                    type=str,
                    default="tags-drive",
                    help="name of a Docker image (default is 'tags-drive')")
parser.add_argument("--tag",
                    type=str,
                    default="latest",
                    help="tag of a Docker image (default is 'lastest')")
parser.add_argument("--backend-tag",
                    type=str,
                    default="master",
                    help="name of Git branch or tag of the repo with backend part of Tags Drive")
parser.add_argument("--frontend-tag",
                    type=str,
                    default="master",
                    help="name of Git branch or tag of the repo with frontend part of Tags Drive")
parser.add_argument("--no-cache",
                    default=False,
                    action="store_true",
                    help="use --no-cache for 'docker build' command")

# Parse args
args = parser.parse_args()

name = args.name
tag = args.tag
backendTag = args.backend_tag
frontendTag = args.frontend_tag
noCache = args.no_cache

# Display passed args
print(f"Name: {name}\nTag: {tag}\nBackend tag: {backendTag}\nFrontend tag: {frontendTag}\nUse '--no-cache': {noCache}")

if name == "" or tag == "" or backendTag == "" or frontendTag == "":
    print("[ERR] name and tags must be provided")
    exit(1)

# Build command
command = f"docker build -t {name}:{tag} "

if noCache:
    command += "--no-cache "

command += (f"--build-arg BACKEND_TAG={backendTag} " +
            f"--build-arg FRONTEND_TAG={frontendTag} " +
            ".")

os.system(command)
