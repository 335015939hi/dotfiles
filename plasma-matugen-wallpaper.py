#!/usr/bin/python3

# first attempt at python!!!

import argparse
import os
import subprocess
import random

from pathlib import Path
from typing import Final

DATA_PATH: Final = (
    os.environ.get("XDG_CACHE_HOME", os.environ.get("HOME", "") + "/.cache")
    + "/plasma-mutagen-wallpaper-py/"
)
INDEX_FILE: Final = DATA_PATH + "last_index"
LAST_DIR_FILE: Final = DATA_PATH + "last_dir"
DIRLIST_FILE: Final = DATA_PATH + "list"


def get_image(path_str, reset, jump, autoshuffle):
    path = Path(path_str)

    if path.is_file():
        return path

    if not path.is_dir():
        raise FileNotFoundError(path)

    if (
        not reset
        and Path(LAST_DIR_FILE).is_file()
        and Path(INDEX_FILE).is_file()
        and Path(DIRLIST_FILE).is_file()
    ):
        with open(LAST_DIR_FILE, "r") as last_dir:
            if last_dir.read() == path_str:
                print("reusing path")
                with open(DIRLIST_FILE, "r") as dirlist:
                    filelist = []
                    for line in dirlist:
                        filelist.append(line.rstrip("\n"))
                    with open(INDEX_FILE, "r") as indexfile:
                        index = int(indexfile.read())
                        index = index + jump
                        if index >= len(filelist) or index < 0:
                            index = index % len(filelist)
                            if autoshuffle:
                                random.shuffle(filelist)
                                with open(DIRLIST_FILE, "w") as dirlist:
                                    for line in filelist:
                                        dirlist.write(str(line) + "\n")
                    with open(INDEX_FILE, "w") as indexfile:
                        indexfile.write(str(index))
                return filelist[index]

    filelist = []
    for p in path.iterdir():
        if p.is_file() and p.suffix.lower() in {
            ".jpg",
            ".jpeg",
            ".png",
            ".webp",
            ".jxl",
        }:
            filelist.append(str(p))
    if len(filelist) == 0:
        raise FileNotFoundError("No images found in '" + path_str + "'")

    with open(LAST_DIR_FILE, "w") as last_dir:
        last_dir.write(path_str)

    random.shuffle(filelist)

    with open(DIRLIST_FILE, "w") as dirlist:
        for line in filelist:
            dirlist.write(str(line) + "\n")
    with open(INDEX_FILE, "w") as indexfile:
        indexfile.write("0")

    return filelist[0]


def run_matugen(image, scheme, mode):
    status = subprocess.run(
        ["matugen", "--show-source-colors", "image", image],
        capture_output=True,
        text=True,
    )
    if status.returncode != 0:
        return status.returncode
    colors = len(status.stdout.strip().splitlines())
    command = ["matugen", "--type", scheme, "--mode", mode]
    command.append("--source-color-index")
    command.append(str(random.randint(0,colors-1)))
    command.append("image")
    command.append(image)
    status = subprocess.run(command)
    return status.returncode


def main():
    parser = argparse.ArgumentParser(
        description="set KDE Plasma wallpaper and call matugen"
    )
    parser.add_argument("file", type=str, help="Path to the image or directory")
    parser.add_argument("-m", "--mode", type=str, default="dark", help="matugen mode")
    parser.add_argument("-r", "--reset", action="store_true", help="resets cache")
    parser.add_argument(
        "-j",
        "--jump",
        type=int,
        default=None,
        help="jump a specified amount (for reusing directory)",
    )
    parser.add_argument(
        "-t", "--type", type=str, default="scheme-smart", help="matugen color scheme"
    )

    args = parser.parse_args()
    autoshuffle = False
    if args.jump is None:
        args.jump = 1
        autoshuffle = True

    Path(DATA_PATH).mkdir(parents=True, exist_ok=True)

    image = get_image(
        path_str=args.file, reset=args.reset, jump=args.jump, autoshuffle=autoshuffle
    )

    matugen = run_matugen(image=image, scheme=args.type, mode=args.mode)
    if matugen != 0:
        print("matugen failed:", matugen)
        return matugen
    plasmawall = subprocess.run(["plasma-apply-wallpaperimage", image])
    if plasmawall.returncode != 0:
        print("failed to apply wallpaper", plasmawall.returncode)
        return plasmawall.returncode


if __name__ == "__main__":
    raise SystemExit(main())
