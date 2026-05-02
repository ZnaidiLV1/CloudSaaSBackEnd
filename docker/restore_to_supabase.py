#!/usr/bin/env python3
import psycopg2
import subprocess
import sys

# Configuration
SUPABASE_CONFIG = {
    'host': 'aws-1-eu-central-1.pooler.supabase.com',
    'port': 5432,
    'database': 'postgres',
    'user': 'postgres.kdpaebdlspqevipivkql',
    'password': 'C8jvy7O88M1kvQS6',
    'sslmode': 'disable',  # Changed to disable SSL
    'connect_timeout': 30
}

DUMP_DIR = './db_dump_new'

def main():
    print("📦 Connecting to Supabase...")
    
    try:
        conn = psycopg2.connect(**SUPABASE_CONFIG)
        print("✅ Connected!")
        
        print(f"📂 Reading dump from {DUMP_DIR}...")
        result = subprocess.run(
            ['pg_restore', '--format=directory', DUMP_DIR],
            capture_output=True,
            text=True
        )
        
        if result.returncode != 0:
            print(f"❌ Error reading dump: {result.stderr}")
            sys.exit(1)
        
        sql = result.stdout
        print(f"📊 SQL size: {len(sql):,} characters")
        
        print("🔄 Restoring database...")
        with conn.cursor() as cur:
            cur.execute(sql)
            conn.commit()
        
        print("✅ Restore completed!")
        
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM vms;")
            count = cur.fetchone()[0]
            print(f"📊 Verification: {count} rows in vms table")
        
        conn.close()
        
    except psycopg2.Error as e:
        print(f"❌ Database error: {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
