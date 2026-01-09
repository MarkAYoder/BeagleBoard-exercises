#!/usr/bin/env python3

# This script shortens tmp101_data.db to keep only the most recent N days of data.
# It deletes all records older than N days from the most recent timestamp.

import sqlite3
import argparse
from datetime import datetime, timedelta

DB_PATH = "tmp101_data.db"

def shorten_database(days=31):
    try:
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        
        # Get the most recent and oldest timestamps
        c.execute("SELECT MAX(timestamp), MIN(timestamp) FROM readings")
        result = c.fetchone()
        
        if result[0] is None or result[1] is None:
            print("No data found in database.")
            conn.close()
            return
        
        most_recent = datetime.fromisoformat(result[0])
        oldest = datetime.fromisoformat(result[1])
        days_saved = (most_recent - oldest).days
        
        cutoff_date = most_recent - timedelta(days=days)
        cutoff_str = cutoff_date.isoformat()
        
        print(f"Oldest timestamp: {oldest.isoformat()}")
        print(f"Most recent timestamp: {most_recent.isoformat()}")
        print(f"Days currently saved: {days_saved}")
        print(f"Cutoff date ({days} days earlier): {cutoff_str}")
        
        # Count records to be deleted
        c.execute("SELECT COUNT(*) FROM readings WHERE timestamp < ?", (cutoff_str,))
        count_to_delete = c.fetchone()[0]
        
        # Count total records
        c.execute("SELECT COUNT(*) FROM readings")
        total_count = c.fetchone()[0]
        
        print(f"Total records: {total_count}")
        print(f"Records to delete: {count_to_delete}")
        print(f"Records to keep: {total_count - count_to_delete}")
        
        if count_to_delete > 0:
            # Delete old records
            c.execute("DELETE FROM readings WHERE timestamp < ?", (cutoff_str,))
            conn.commit()
            print(f"Deleted {count_to_delete} records.")
            
            # Vacuum the database to reclaim space
            print("Vacuuming database to reclaim space...")
            c.execute("VACUUM")
            conn.commit()
            print("Database vacuumed successfully.")
        else:
            print(f"No records to delete. Database already contains only the most recent {days} days.")
        
        conn.close()
        print("Done.")
        
    except sqlite3.Error as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Shorten tmp101_data.db to keep only the most recent N days of data."
    )
    parser.add_argument(
        '--days',
        type=int,
        default=31,
        help='Number of days of data to keep (default: 31)'
    )
    args = parser.parse_args()
    shorten_database(days=args.days)
