#!/usr/bin/env python3
"""
Display the contents of ping_failures.db (failures table).
"""

import argparse
import os
import sqlite3
import sys

DEFAULT_DB_PATH = "ping_failures.db"


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Display contents of ping_failures.db."
    )
    parser.add_argument(
        "--db",
        default=os.environ.get("PING_MONITOR_DB", DEFAULT_DB_PATH),
        help="Path to SQLite DB (default: PING_MONITOR_DB env or ./ping_failures.db)",
    )
    args = parser.parse_args()

    if not os.path.isfile(args.db):
        print(f"error: database not found: {args.db}", file=sys.stderr)
        sys.exit(1)

    with sqlite3.connect(args.db) as conn:
        conn.row_factory = sqlite3.Row
        cur = conn.execute(
            "SELECT id, checked_at, target, reason FROM failures ORDER BY id"
        )
        rows = cur.fetchall()

    if not rows:
        print("No failures recorded.")
        return

    # Column widths (min widths for headers)
    col_widths = [4, 22, 16, 12]
    for r in rows:
        col_widths[0] = max(col_widths[0], len(str(r["id"])))
        col_widths[1] = max(col_widths[1], len(r["checked_at"] or ""))
        col_widths[2] = max(col_widths[2], len(r["target"] or ""))
        col_widths[3] = max(col_widths[3], len(r["reason"] or ""))

    fmt = "  ".join(f"{{:<{w}}}" for w in col_widths)
    print(fmt.format("id", "checked_at", "target", "reason"))
    print("-" * (sum(col_widths) + 6))
    for r in rows:
        print(fmt.format(r["id"], r["checked_at"], r["target"], r["reason"] or ""))


if __name__ == "__main__":
    main()
