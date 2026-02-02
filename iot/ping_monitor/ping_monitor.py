#!/usr/bin/env python3
"""
Ping a target in a loop; log to SQLite when ping does not return.
"""

import argparse
import os
import platform
import sqlite3
import subprocess
import sys
import time
from datetime import datetime, timezone


DEFAULT_TARGET = "google.com"
DEFAULT_INTERVAL =15
DEFAULT_DB_PATH = "ping_failures.db"
PING_TIMEOUT_SEC = 5


def get_ping_args(target: str) -> list[str]:
    """Return OS-appropriate ping command args (target only; no 'ping')."""
    system = platform.system()
    if system == "Windows":
        return ["ping", "-n", "1", "-w", "3000", target]
    # Linux, Darwin (macOS), and others
    return ["ping", "-c", "1", "-W", "3", target]


def ping(target: str) -> tuple[bool, str]:
    """
    Run one ping to target. Return (success, reason).
    reason is empty on success, or a short string on failure (e.g. 'timeout', 'unreachable').
    """
    args = get_ping_args(target)
    try:
        result = subprocess.run(
            args,
            capture_output=True,
            timeout=PING_TIMEOUT_SEC,
        )
    except subprocess.TimeoutExpired:
        return False, "timeout"
    except FileNotFoundError:
        return False, "ping_not_found"
    except OSError as e:
        return False, f"error: {e!s}"

    if result.returncode != 0:
        return False, "unreachable"
    return True, ""


def init_db(db_path: str) -> None:
    """Ensure the failures table exists."""
    with sqlite3.connect(db_path) as conn:
        conn.execute(
            """
            CREATE TABLE IF NOT EXISTS failures (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                checked_at TEXT NOT NULL,
                target TEXT NOT NULL,
                reason TEXT
            )
            """
        )


def log_failure(db_path: str, target: str, reason: str) -> None:
    """Insert one failure row."""
    now = datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ")
    with sqlite3.connect(db_path) as conn:
        conn.execute(
            "INSERT INTO failures (checked_at, target, reason) VALUES (?, ?, ?)",
            (now, target, reason or "unknown"),
        )


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Ping a target in a loop and log failures to SQLite."
    )
    parser.add_argument(
        "--target",
        default=DEFAULT_TARGET,
        help=f"Host or IP to ping (default: {DEFAULT_TARGET})",
    )
    parser.add_argument(
        "--interval",
        type=int,
        default=DEFAULT_INTERVAL,
        help=f"Seconds between pings (default: {DEFAULT_INTERVAL})",
    )
    parser.add_argument(
        "--db",
        default=os.environ.get("PING_MONITOR_DB", DEFAULT_DB_PATH),
        help="Path to SQLite DB (default: PING_MONITOR_DB env or ./ping_failures.db)",
    )
    args = parser.parse_args()

    if args.interval < 1:
        print("error: --interval must be >= 1", file=sys.stderr)
        sys.exit(1)

    db_path = args.db
    init_db(db_path)

    print(f"Pinging {args.target} every {args.interval}s; failures -> {db_path}")
    print("Ctrl+C to stop.")

    try:
        while True:
            ok, reason = ping(args.target)
            if not ok:
                log_failure(db_path, args.target, reason)
                print(f"[{datetime.now().isoformat()}] ping failed: {reason}")
            time.sleep(args.interval)
    except KeyboardInterrupt:
        print("\nStopped.")


if __name__ == "__main__":
    main()
