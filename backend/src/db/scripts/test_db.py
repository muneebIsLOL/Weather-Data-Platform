from src.db.connection import get_engine
import sys, time

def verify_connection():
        print("Checking Database Connection...")

        for attempt in range(1, 6):
            try:
                engine = get_engine("/app/src/db/global-bundle.pem")
                with engine.connect() as conn:
                    print("Database connection verified successfully.")
                    sys.exit(0)
            except Exception as e:
                print(f"Attempt {attempt}/5 failed: Database not ready yet. {e}")
                time.sleep(3)
        print("Error: Could not connect to the database after 5 attempts.")
        sys.exit(1)

if __name__ == "__main__":
     verify_connection()