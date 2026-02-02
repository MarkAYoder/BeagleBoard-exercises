#!/usr/bin/env python3
"""
Serve ping failures from SQLite on a web page with a chart.
Usage: python3 serve_failures.py [--db path] [--port 8000]
"""

import argparse
import json
import os
import sqlite3
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from pathlib import Path

DEFAULT_DB_PATH = "ping_failures.db"
DEFAULT_PORT = 5002
SCRIPT_DIR = Path(__file__).resolve().parent


def get_failures(db_path: str) -> list[dict]:
    """Return all failures as list of dicts for JSON."""
    if not os.path.isfile(db_path):
        return []
    with sqlite3.connect(db_path) as conn:
        conn.row_factory = sqlite3.Row
        cur = conn.execute(
            "SELECT id, checked_at, target, reason FROM failures ORDER BY id"
        )
        rows = cur.fetchall()
    return [dict(r) for r in rows]


# Set by main() so the handler can read the DB path
_db_path: str = ""


class FailuresHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/" or self.path == "/index.html":
            self.serve_index()
        elif self.path == "/api/failures":
            self.serve_api_failures()
        else:
            self.send_error(404, "Not found")

    def serve_index(self):
        html_path = SCRIPT_DIR / "index.html"
        if not html_path.is_file():
            self.send_error(500, "index.html not found")
            return
        self.send_response(200)
        self.send_header("Content-Type", "text/html; charset=utf-8")
        self.end_headers()
        self.wfile.write(html_path.read_bytes())

    def serve_api_failures(self):
        data = get_failures(_db_path)
        body = json.dumps(data).encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "application/json; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, format, *args):
        print(format % args)


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Serve ping failures on a web page with a chart."
    )
    parser.add_argument(
        "--db",
        default=os.environ.get("PING_MONITOR_DB", DEFAULT_DB_PATH),
        help="Path to SQLite DB",
    )
    parser.add_argument(
        "--port",
        type=int,
        default=DEFAULT_PORT,
        help=f"Port to listen on (default: {DEFAULT_PORT})",
    )
    args = parser.parse_args()

    db_path = args.db
    if not os.path.isfile(db_path):
        print(f"warning: database not found: {db_path}", file=sys.stderr)
        print("Charts will be empty until data exists.", file=sys.stderr)

    global _db_path
    _db_path = db_path
    server = HTTPServer(("", args.port), FailuresHandler)
    print(f"Serving failures at http://127.0.0.1:{args.port}/ (db: {db_path})")
    print("Ctrl+C to stop.")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
        server.shutdown()


if __name__ == "__main__":
    main()
