import os
import math
import requests
import redis
from celery import Celery

JS_IP_ADDRESS = os.getenv("JS_IP_ADDRESS", "redis")
REDIS_PORT = os.getenv("REDIS_PORT", 6379)
REDIS_USERNAME = os.getenv("REDIS_USERNAME", "")
REDIS_PASSWORD = os.getenv("REDIS_PASSWORD", "")

celery = Celery(
    "tasks",
    broker=os.getenv("CELERY_BROKER_URL"),
    backend=os.getenv("CELERY_RESULT_BACKEND")
)

redis_client = redis.Redis(
    host=JS_IP_ADDRESS,
    port=int(REDIS_PORT),
    username=REDIS_USERNAME or None,
    password=REDIS_PASSWORD or None,
    decode_responses=True
)

celery.conf.beat_schedule = {
    "check_driver_locations_every_second": {
        "task": "check_all_drivers",
        "schedule": 1.0,
    },
}
celery.conf.timezone = "Asia/Manila"

POINTS = [
    {
        "name": "Caltex - Dagupan City",
        "lat": 16.038356,
        "lng": 120.333618,
    },
    {
        "name": "University of Luzon",
        "lat": 16.039257,
        "lng": 120.335644,
    },
    {
        "name": "Zamora Street",
        "lat": 16.039600,
        "lng": 120.336417,
    },
    {
        "name": "Galvan Street",
        "lat": 16.039978,
        "lng": 120.337329,
    },
    {
        "name": "St. Joseph Drug Store - Rizal Street, Dagupan City",
        "lat": 16.040897,
        "lng": 120.339501,
    },
    {
        "name": "Pangasinan Merchant Marine Academy(PAMMA)",
        "lat": 16.041865,
        "lng": 120.341745,
    },
    {
        "name": "Victory Liner - Dagupan City",
        "lat": 16.042736,
        "lng": 120.343764,
    },
    {
        "name": "Development Bank of the Philippines - Dagupan City",
        "lat": 16.043811,
        "lng": 120.344205,
    },
    {
        "name": "SM Hypermarket Dagupan",
        "lat": 16.045222,
        "lng": 120.343445,
    },
    {
        "name": "Chowking - AB Fernandez, Dagupan City",
        "lat": 16.045691,
        "lng": 120.342337,
    },
    {
        "name": "City Deluxe Restaurant Downtown",
        "lat": 16.044224,
        "lng": 120.338344,
    },
    {
        "name": "Newstar Shopping Mall - Dagupan",
        "lat": 16.044145,
        "lng": 120.336959,
    },
    {
        "name": "Dagupan City Hall",
        "lat": 16.043928,
        "lng": 120.335211,
    },
    {
        "name": "West Central Elementary School",
        "lat": 16.042923,
        "lng": 120.333472,
    },
    {
        "name": "Cuison Hospital Incorporated",
        "lat": 16.040893,
        "lng": 120.334269,
    },
    {
        "name": "KOREAN PALACE (KUNG JEON RESTAURANT) - Dagupan City",
        "lat": 16.038357,
        "lng": 120.333202,
    },
    {
        "name": "Dagupan City National High School",
        "lat": 16.037269,
        "lng": 120.332636,
    },
    {
        "name": "Astrodome",
        "lat": 16.036140,
        "lng": 120.332153,
    },
    {
        "name": "Lyceum-Northwestern University",
        "lat": 16.034859,
        "lng": 120.331570,
    },
    {
        "name": "Malta",
        "lat": 16.033534,
        "lng": 120.330883,
    },
    {
        "name": "La Marea Academy",
        "lat": 16.032154,
        "lng": 120.330211,
    },
    {
        "name": "Los Pedritos - Tapuac",
        "lat": 16.029187,
        "lng": 120.328743,
    },
    {
        "name": "Meshroom Cafe - Tapuac",
        "lat": 16.029187,
        "lng": 120.328743,
    },
    {
        "name": "DSWD Dagupan",
        "lat": 16.027026,
        "lng": 120.327623,
    },
    {
        "name": "Lavarias",
        "lat": 16.024932,
        "lng": 120.326576,
    },
    {
        "name": "CSI Lucao",
        "lat": 16.021238,
        "lng": 120.324135,
    },
    {
        "name": "Angels Pizza - Lucao",
        "lat": 16.020270,
        "lng": 120.322248,
    },
    {
        "name": "Dunkin' - Lucao",
        "lat": 16.019067,
        "lng": 120.319937,
    },
    {
        "name": "Lucao United Methodist Church",
        "lat": 16.017412,
        "lng": 120.316626,
    },
    {
        "name": "Prime Brilliant Minds Academy",
        "lat": 16.016556,
        "lng": 120.314625,
    },
    {
        "name": "Marker Binmaley (Boundary)",
        "lat": 16.015575,
        "lng": 120.312421,
    },
    {
        "name": "Rufina Square",
        "lat": 16.014550,
        "lng": 120.309931,
    },
    {
        "name": "Gayaman, Binmaley",
        "lat": 16.013938,
        "lng": 120.308429,
    },
    {
        "name": "Gayaman, Binmaley",
        "lat": 16.012721,
        "lng": 120.305597,
    },
    {
        "name": "San Jose, Binmaley",
        "lat": 16.012002,
        "lng": 120.304030,
    },
    {
        "name": "Naguilayan, Binmaley",
        "lat": 16.010785, 
        "lng": 120.301223,
    },
    {
        "name": "Naguilayan, Binmaley",
        "lat": 16.010028,
        "lng": 120.299344,
    },
    {
        "name": "Centrum - Naguilayan, Binmaley",
        "lat": 16.009052,
        "lng": 120.295036,
    },
    {
        "name": "Central Pangasinan Hospital and Medical Center",
        "lat": 16.009445,
        "lng": 120.291720,
    },
    {
        "name": "Kahluts - Binmaley",
        "lat": 16.009495,
        "lng": 120.291260,
    },
    {
        "name": "Caltex Triangle Bus Stop - Binmaley",
        "lat": 16.009807,
        "lng": 120.288683,
    },
    {
        "name": "Caltex Triangle Bus Stop - Binmaley",
        "lat": 16.010331,
        "lng": 120.285906,
    },
    {
        "name": "Manat Bridge - Binmaley",
        "lat": 16.013035,
        "lng": 120.282323,
    },
    {
        "name": "Linoc - Binmaley",
        "lat": 16.014260,
        "lng": 120.281769,
    },
    {
        "name": "Binmaley Talipapa",
        "lat": 16.016326,
        "lng": 120.280870,
    },
    {
        "name": "Kingdom Hall of Jehovah's Witnesses - Binmaley",
        "lat": 16.019599,
        "lng": 120.279408,
    },
    {
        "name": "Nansangaan - Binmaley",
        "lat": 16.022855,
        "lng": 120.276433,
    },
    {
        "name": "Bo's Coffee - Binmaley",
        "lat": 16.024128,
        "lng": 120.274724,
    },
    {
        "name": "Yamaha - Binmaley",
        "lat": 16.026711, 
        "lng": 120.271233,
    },
    {
        "name": "Binmaley Public Market",
        "lat": 16.027963,
        "lng": 120.269639,
    },
    {
        "name": "Binmaley Triangle (ESTASYON)",
        "lat": 16.029056,
        "lng": 120.268714,
    },
    {
        "name": "Total - Binmaley",
        "lat": 16.028800,
        "lng": 120.265768,
    },
    {
        "name": "Manaois Furniture",
        "lat": 16.027752,
        "lng": 120.262536,
    },
    {
        "name": "7-Eleven Malindog - Binmaley",
        "lat": 16.027057,
        "lng": 120.260226,
    },
    {
        "name": "MYK Motorparts and Accessories Shop",
        "lat": 16.026146,
        "lng": 120.257238,
    },
    {
        "name": "Boundary Marker Lingayen",
        "lat": 16.025179,
        "lng": 120.253171,
    },
    {
        "name": "Tonton",
        "lat": 16.026609,
        "lng": 120.251118,
    },
    {
        "name": "Tonton",
        "lat": 16.026143, 
        "lng": 120.248316,
    },
    {
        "name": "Tonton",
        "lat": 16.025582, 
        "lng": 120.246704,
    },
    {
        "name": "Tonton",
        "lat": 16.024738,
        "lng": 120.243783,
    },
    {
        "name": "Avenida Rizal",
        "lat": 16.024280, 
        "lng": 120.240912,
    },
    {
        "name": "Savewise Supermarket - Lingayen",
        "lat": 16.022626,
        "lng": 120.236803,
    },
    {
        "name": "PNB - Lingayen",
        "lat": 16.0223609,
        "lng": 120.2359898,
    },
    {
        "name": "Harvent School - Lingayen",
        "lat": 16.0259072,
        "lng": 120.2345061,
    },
    {
        "name": "Kingdom Hall of Jehovah's Witnesses - Lingayen",
        "lat": 16.0292683,
        "lng": 120.23325,
    },
    {
        "name": "Golden Mami House - Lingayen",
        "lat": 16.0308944,
        "lng": 120.2326433,
    },
    {
        "name": "Pangasinan State University",
        "lat": 16.030899,
        "lng": 120.230123,
    },
    {
        "name": "Bo's Coffee - Lingayen",
        "lat": 16.0303872,
        "lng": 120.2285407,
    },
    {
        "name": "7-Eleven - Lingayen",
        "lat": 16.0303872,
        "lng": 120.2285407,
    },
    {
        "name": "YamiTeys Snack House",
        "lat": 16.0285073,
        "lng": 120.2279688,
    },
    {
        "name": "P. Morgan",
        "lat": 16.0270937,
        "lng": 120.2282478,
    },
    {
        "name": "Uson Pigar Pigar - Lingayen",
        "lat": 16.0259742,
        "lng": 120.2284627,
    },
    {
        "name": "Total - Lingayen",
        "lat": 16.0251403,
        "lng": 120.2286114,
    },
    {
        "name": "JK Raider Enterprises",
        "lat": 16.0246013,
        "lng": 120.2287145,
    },
    {
        "name": "PCWORKS - Lingayen",
        "lat": 16.0225447,
        "lng": 120.2291036,
    },
    {
        "name": "Jetti Artacho - Lingayen",
        "lat": 16.0213224,
        "lng": 120.2293242,
    },
    {
        "name": "Amigo - Lingayen",
        "lat": 16.020829,
        "lng": 120.2281878,
    },
    {
        "name": "Mesa de Amor",
        "lat": 16.020694,
        "lng": 120.2274517,
    },
    {
        "name": "UPS Driving School - Lingayen",
        "lat": 16.0202634,
        "lng": 120.2267805,
    },
    {
        "name": "Lingayen Tricycle Terminal",
        "lat": 16.018769,
        "lng": 120.227551,
    },
    {
        "name": "Civil Service Commision Director II Office",
        "lat": 16.0185148,
        "lng": 120.2280105,
    },
    {
        "name": "Lingayen Municipal Fish Port",
        "lat": 16.0174397,
        "lng": 120.228884,
    },
    {
        "name": "Lingayen Common Bus Terminal",
        "lat": 16.0178851,
        "lng": 120.230678,
    },
    {
        "name": "McDonald's - Lingayen",
        "lat": 16.0188837,
        "lng": 120.2314203,
    },
    {
        "name": "Lingayen Municipal Hall",
        "lat": 16.020103,
        "lng": 120.230726,
    },
    {
        "name": "The Co-Cathedral Parish of the Epiphany of our Lord",
        "lat": 16.0211435,
        "lng": 120.2322544,
    },
    {
        "name": "BHF Bank - Lingayen",
        "lat": 16.0217193,
        "lng": 120.2333481,
    }
]


def haversine(lat1, lon1, lat2, lon2):
    R = 6371_000
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlambda = math.radians(lon2 - lon1)
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlambda / 2) ** 2
    return 2 * R * math.atan2(math.sqrt(a), math.sqrt(1 - a))

@celery.task(name="check_all_drivers")
def check_all_drivers():
    """Check all drivers' speeds and route from Redis and alert if exceeding 80 km/h."""
    call_js = False
    try:
        keys = redis_client.keys("driver:*:location")

        for key in keys:
            loc_data = redis_client.hgetall(key)
            if not loc_data:
                continue

            bus_id = key.split(":")[1]
            speed = float(loc_data.get("speed", 0))
            lat = float(loc_data.get("lat", 0))
            lng = float(loc_data.get("lng", 0))

            overspeed_key = f"overspeed:{bus_id}"
            offroute_key = f"offroute:{bus_id}"

            if speed > 80:
                if not redis_client.exists(overspeed_key):
                    redis_client.set(overspeed_key, 1, ex=300)
                    call_js = True
            else:
                if redis_client.exists(overspeed_key):
                    redis_client.delete(overspeed_key)

            min_distance = float("inf")
            for point in POINTS:
                dist = haversine(lat, lng, point["lat"], point["lng"])
                if dist < min_distance:
                    min_distance = dist

            if min_distance > 500: 
                if not redis_client.exists(offroute_key):
                    redis_client.set(offroute_key, 1, ex=300)
                    call_js = True
            else:
                if redis_client.exists(offroute_key):
                    redis_client.delete(offroute_key)
                    
        if call_js:
            try:
                js_api_url = f"http://{JS_IP_ADDRESS}/report/update-admin"
                response = requests.post(js_api_url, timeout=5)
                print(f"Triggered JS API: {response.status_code} {response.text}")
            except Exception as e:
                print(f"Failed to call JS API: {e}")
        
    except Exception as e:
        print(f"Error: {e}")