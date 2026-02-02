# Ping monitor with DB logging

Pings a target (default: Google) in a loop and writes a row to a SQLite database whenever a ping fails (no response). Runs until you stop it with Ctrl+C.

## Run

```bash
python ping_monitor.py
```

Options:

- `--target HOST` — Host or IP to ping (default: `google.com`)
- `--interval N` — Seconds between pings (default: `15`)
- `--db PATH` — Path to SQLite database file (default: `./ping_failures.db`)

Example: ping every 30 seconds and use a custom DB path:

```bash
python ping_monitor.py --interval 30 --db /var/log/ping_failures.db
```

You can also set the DB path via the `PING_MONITOR_DB` environment variable.

## Inspect the database

Failures are stored in the `failures` table: `id`, `checked_at` (ISO UTC), `target`, `reason`.

```bash
sqlite3 ping_failures.db "SELECT * FROM failures;"
```

Or open the file in any SQLite client.

## Requirements

Python 3.9+. No extra packages; uses only the standard library.
