import os
import sys

name = os.environ.get("NAME", default="")
tag = os.environ.get("TAG", default="")
#
backendTag = os.environ.get("", default="")
frontendTag = os.environ.get("NAME", default="")


def hasPrefix(s: str, prefix: str) -> bool:
    if len(s) < len(prefix):
        return False

    for i in range(len(prefix)):
        if s[i] != prefix[i]:
            return False

    return True


try:
    for arg in sys.argv[1:]:
        # name
        if hasPrefix(arg, "--name") or hasPrefix(arg, "-n"):
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            name = temp[0]
        # tag
        elif hasPrefix(arg, "--tag") or hasPrefix(arg, "-t"):
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            tag = temp[0]
        # backend tag
        elif hasPrefix(arg, "--backend-tag") or hasPrefix(arg, "-b"):
            temp = arg.split("=")[1:]
            if len(temp) == 0:
                raise Exception("bad syntax")

            backendTag = temp[0]
        # frontend tag
        elif hasPrefix(arg, "--frontend-tag") or hasPrefix(arg, "-f"):
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

os.system(f"docker build -t {name}:{tag} --no-cache " +
          f"--build-arg BACKEND_TAG={backendTag} " +
          f"--build-arg FRONTEND_TAG={frontendTag} .")
