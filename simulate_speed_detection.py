import json
import time
import random

def simulate_speed_detection():
    speed_limits = [20, 30, 40, 50, 60, 80, 100, 120]
    while True:
        # Simuler la détection d'une nouvelle vitesse limite toutes les 5 secondes
        new_speed_limit = random.choice(speed_limits)
        data = {
            "vitesse_limite": new_speed_limit,
            "timestamp": time.strftime("%Y-%m-%d %H:%M:%S")
        }
        with open("vitesse_limite.json", "w") as json_file:
            json.dump(data, json_file)
        print(f"Simulated speed limit: {new_speed_limit} km/h")
        time.sleep(5)

if __name__ == "__main__":
    simulate_speed_detection()