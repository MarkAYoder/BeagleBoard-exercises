#!/usr/bin/env python3

# This script shortens tmp101_data.db to keep only the most recent 31 days of data.
# It deletes all records older than 31 days from the most recent timestamp.

import sqlite3
from datetime import datetime, timedelta

DB_PATH = "tmp101_data.db"

def shorten_database():
    try:
        conn = sqlite3.connect(DB_PATH)
        c = conn.cursor()
        
        # Get the most recent timestamp
        c.execute("SELECT MAX(timestamp) FROM readings")
        result = c.fetchone()
        
        if result[0] is None:
            print("No data found in database.")
            conn.close()
            return
        
        most_recent = datetime.fromisoformat(result[0])
        cutoff_date = most_recent - timedelta(days=31)
        cutoff_str = cutoff_date.isoformat()
        
        print(f"Most recent timestamp: {most_recent.isoformat()}")
        print(f"Cutoff date (31 days earlier): {cutoff_str}")
        
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
            print("No records to delete. Database already contains only the most recent 31 days.")
        
        conn.close()
        print("Done.")
        
    except sqlite3.Error as e:
        print(f"Database error: {e}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    shorten_database()
