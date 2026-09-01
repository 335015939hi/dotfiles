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
    + "/plasma-matugen-wallpaper-py/"
)
INDEX_FILE: Final = DATA_PATH + "last_index"
LAST_DIR_FILE: Final = DATA_PATH + "last_dir"
DIRLIST_FILE: Final = DATA_PATH + "list"


def get_last_index():
    with open(INDEX_FILE, "r") as indexfile:
        return int(indexfile.read())


def set_last_index(index):
    with open(INDEX_FILE, "w") as indexfile:
        indexfile.write(str(index))


def get_last_dir():
    with open(LAST_DIR_FILE, "r") as dirfile:
        return dirfile.read()


def set_last_dir(path):
    with open(LAST_DIR_FILE, "w") as dirfile:
        dirfile.write(path)


def get_dirlist():
    list = []
    with open(DIRLIST_FILE, "r") as listfile:
        for line in listfile:
            list.append(line.rstrip("\n"))
        return list


def set_dirlist(list):
    with open(DIRLIST_FILE, "w") as listfile:
        for file in list:
            listfile.write(str(file) + "\n")


def find_images_in_path(path_str):
    path = Path(path_str)
    if not path.is_dir():
        raise NotADirectoryError(path)
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
        elif p.is_dir():
            filelist += find_images_in_path(str(p))
    return filelist


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
        if get_last_dir() == path_str:
            print("reusing path")
            filelist = get_dirlist()
            index = get_last_index()
            index = index + jump
            if index >= len(filelist) or index < 0:
                index = index % len(filelist)
                if autoshuffle:
                    random.shuffle(filelist)
                    set_dirlist(filelist)
            set_last_index(index)
            return filelist[index]

    filelist = find_images_in_path(path_str)
    if len(filelist) == 0:
        raise FileNotFoundError("No images found in '" + path_str + "'")
    set_last_dir(path_str)
    random.shuffle(filelist)
    set_dirlist(filelist)
    set_last_index(0)
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
    command.append(str(random.randint(0, colors - 1)))
    command.append("image")
    command.append(image)
    status = subprocess.run(command)
    return status.returncode


def main():
    parser = argparse.ArgumentParser(
        description="set KDE Plasma wallpaper and call matugen"
    )
    parser.add_argument(
        "file", type=str, nargs="?", default=None, help="Path to the image or directory"
    )
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
    if args.file is None:
        try:
            args.file = get_last_dir()
        except FileNotFoundError:
            print("No last directory found. you must specify an image or directory")
            return 2

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
