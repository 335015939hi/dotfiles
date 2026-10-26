#!/usr/bin/python3

import argparse
import os
import random
import subprocess
from pathlib import Path
from typing import Final
from urllib.parse import unquote, urlparse

CACHE_DIR: Final = Path(
    os.environ.get("XDG_CACHE_HOME") or (Path.home() / ".cache")
) / "plasma-matugen-wallpaper-py"
LAST_DIR_FILE: Final = CACHE_DIR / "last_dir"
IMAGE_EXTENSIONS: Final = {".jpg", ".jpeg", ".png", ".webp", ".jxl"}


def get_last_dir() -> str:
    return LAST_DIR_FILE.read_text()


def set_last_dir(path: str) -> None:
    LAST_DIR_FILE.write_text(path)


def get_current_wallpaper() -> Path | None:
    """Return the current Plasma wallpaper image path, if it can be queried."""
    try:
        result = subprocess.run(
            [
                "qdbus6",
                "org.kde.plasmashell",
                "/PlasmaShell",
                "org.kde.PlasmaShell.wallpaper",
                "0",
            ],
            capture_output=True,
            text=True,
            check=False,
        )
    except OSError:
        return None

    if result.returncode != 0:
        return None

    for line in result.stdout.splitlines():
        if not line.startswith("Image: "):
            continue

        value = line[len("Image: "):].strip()
        if value.startswith("file://"):
            uri = urlparse(value)
            if uri.netloc not in ("", "localhost"):
                return None
            value = unquote(uri.path)
        elif not value.startswith("/"):
            return None

        return Path(value).resolve()

    return None


def get_cached_candidates() -> list[Path]:
    """Read the numbered cache symlinks in numeric order."""
    numbered_entries = [
        entry
        for entry in CACHE_DIR.iterdir()
        if entry.stem.isdecimal() and (entry.is_symlink() or entry.is_file())
    ]
    candidates = sorted(
        (entry for entry in numbered_entries if entry.is_symlink()),
        key=lambda entry: int(entry.stem),
    )

    # Require contiguous numbering and a suffix that matches each link target.
    # This also invalidates caches created by the older suffix-less naming scheme.
    if len(candidates) != len(numbered_entries):
        return []
    if [int(entry.stem) for entry in candidates] != list(
        range(1, len(candidates) + 1)
    ):
        return []
    if any(
        not entry.is_file()
        or not entry.suffix
        or entry.suffix != entry.resolve().suffix
        for entry in candidates
    ):
        return []

    return candidates


def set_cached_candidates(images: list[Path]) -> list[Path]:
    """Replace numbered symlinks with the supplied image order."""
    for entry in CACHE_DIR.iterdir():
        if entry.stem.isdecimal() and (entry.is_symlink() or entry.is_file()):
            entry.unlink()

    for index, image in enumerate(images, start=1):
        image = Path(image).resolve()
        (CACHE_DIR / f"{index}{image.suffix}").symlink_to(image)

    return get_cached_candidates()


def find_images_in_path(path_str: str) -> list[Path]:
    path = Path(path_str)
    if not path.is_dir():
        raise NotADirectoryError(path)

    filelist: list[Path] = []
    for entry in path.iterdir():
        if entry.is_file() and entry.suffix.lower() in IMAGE_EXTENSIONS:
            filelist.append(entry.resolve())
        elif entry.is_dir():
            filelist.extend(find_images_in_path(str(entry)))
    return filelist


def get_image(path_str: str, reset: bool, jump: int, autoshuffle: bool) -> Path:
    path = Path(path_str)

    if path.is_file():
        return path.resolve()

    if not path.is_dir():
        raise FileNotFoundError(path)

    if not reset and LAST_DIR_FILE.is_file() and get_last_dir() == path_str:
        candidates = get_cached_candidates()
        if candidates:
            current_wallpaper = get_current_wallpaper()
            current_index = None
            if current_wallpaper is not None:
                for index, candidate in enumerate(candidates):
                    if candidate.resolve() == current_wallpaper:
                        current_index = index
                        break

            if current_index is not None:
                index = current_index + jump
                if index >= len(candidates) or index < 0:
                    index %= len(candidates)
                    if autoshuffle:
                        images = [candidate.resolve()
                                  for candidate in candidates]
                        random.shuffle(images)
                        candidates = set_cached_candidates(images)
                return candidates[index].resolve()

            # The current wallpaper is not in this directory's cached set.
            # Start from the first candidate instead of relying on stale state.
            return candidates[0].resolve()

    images = find_images_in_path(path_str)
    if not images:
        raise FileNotFoundError("No images found in '" + path_str + "'")

    random.shuffle(images)
    set_last_dir(path_str)
    candidates = set_cached_candidates(images)
    return candidates[0].resolve()


def run_matugen(image: Path, scheme: str, mode: str) -> int:
    try:
        with open(str(image) + ".matugenoverride") as override:
            print("found matugenoverride color file")
            color = override.read().strip()
            status = subprocess.run(
                ["matugen", "--type", scheme, "--mode", mode, "color", "hex", color]
            )
            if status.returncode != 0:
                print("matugen set override color failed")
                raise RuntimeError
            return 0
    except FileNotFoundError:
        pass
    except RuntimeError:
        pass

    status = subprocess.run(
        ["matugen", "--show-source-colors", "image", str(image)],
        capture_output=True,
        text=True,
    )
    if status.returncode != 0:
        return status.returncode

    colors = len(status.stdout.strip().splitlines())
    if colors == 0:
        print("matugen returned no source colors")
        return 1

    command = ["matugen", "--type", scheme, "--mode", mode]
    command.extend(
        ["--source-color-index", str(random.randint(0, colors - 1))])
    command.extend(["image", str(image)])
    status = subprocess.run(command)
    return status.returncode


def main() -> int:
    parser = argparse.ArgumentParser(
        description="set KDE Plasma wallpaper and call matugen"
    )
    parser.add_argument(
        "file", type=str, nargs="?", default=None, help="Path to the image or directory"
    )
    parser.add_argument("-m", "--mode", type=str,
                        default="dark", help="matugen mode")
    parser.add_argument(
        "-r", "--reset", action="store_true", help="resets cache")
    parser.add_argument(
        "-j",
        "--jump",
        type=int,
        default=None,
        help="jump a specified amount (for reusing directory)",
    )
    parser.add_argument(
        "-t", "--type", type=str, default="scheme-rainbow", help="matugen color scheme"
    )

    args = parser.parse_args()
    autoshuffle = args.jump is None
    if args.jump is None:
        args.jump = 1

    if args.file is None:
        try:
            args.file = get_last_dir()
        except FileNotFoundError:
            print("No last directory found. You must specify an image or directory")
            return 2

    CACHE_DIR.mkdir(parents=True, exist_ok=True)
    # Remove state files from older versions; selection now follows Plasma's wallpaper.
    for legacy_file in (CACHE_DIR / "last_index", CACHE_DIR / "list"):
        legacy_file.unlink(missing_ok=True)

    image = get_image(
        path_str=args.file,
        reset=args.reset,
        jump=args.jump,
        autoshuffle=autoshuffle,
    )

    gchromewall = subprocess.run(["chrome-wallpaper.sh", "update", str(image)])
    if gchromewall.returncode != 0:
        print("failed to apply google chrome wallpaper", gchromewall.returncode)
        return gchromewall.returncode

    matugen = run_matugen(image=image, scheme=args.type, mode=args.mode)
    if matugen != 0:
        print("matugen failed:", matugen)
        return matugen

    plasmawall = subprocess.run(["plasma-apply-wallpaperimage", str(image)])
    if plasmawall.returncode != 0:
        print("failed to apply wallpaper", plasmawall.returncode)
        return plasmawall.returncode

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
