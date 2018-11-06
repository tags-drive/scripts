import os
import sys

name = os.environ.get("NAME", default="")
tag = os.environ.get("TAG", default="")
#
backendTag = os.environ.get("", default="")
frontendTag = os.environ.get("NAME", default="")

try:
    for arg in sys.argv[1:]:
        # name
        if arg.find("--name") != -1 or arg.find("-n") != -1:
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            name = temp[0]
        # tag
        elif arg.find("--tag") != -1 or arg.find("-t") != -1:
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            tag = temp[0]
        # backend tag
        elif arg.find("--backend-tag") != -1 or arg.find("-b") != -1:
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            backendTag = temp[0]
        # frontend tag
        elif arg.find("--frontend-tag") != -1 or arg.find("-f") != -1:
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            frontendTag = temp[0]

except Exception as e:
    print("[ERR]", e)
    exit(1)

print(f"Name: {name}\nTag: {tag}\nBACKEND_TAG: {backendTag}\nFRONTEND_TAG: {frontendTag}")

if name == "" or tag == "" or backendTag == "" or frontendTag == "":
    print("[ERR] name and tags must be provided")
    exit(1)

os.system(f"docker build -t {name}:{tag} " +
          f"--build-arg BACKEND_TAG={backendTag} " +
          f"--build-arg FRONTEND_TAG={frontendTag} .")
