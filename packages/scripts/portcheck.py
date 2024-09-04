#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python310Packages.rich
import socket
from sys import argv, exit
from rich import print


def main():
    if len(argv) != 3:
        print(f"[magenta]Correct usage: {argv[0]} <host> <port>[/magenta]")
        exit()

    host = argv[1]
    port = int(argv[2])
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    result = sock.connect_ex((host, port))

    if result == 0:
        print(f"[green]Port {port} is reachable/working @ {host}[/green]")
    else:
        print(f"[red]Port {port} NOT reachable/working @ {host} [/red]")
    sock.close()
