import os
import sys
from pathlib import Path

import tweepy
from dotenv import load_dotenv  # pip install python-dotenv

script_dir = Path(__file__).parent
load_dotenv(script_dir / ".env")

API_KEY = os.getenv("API_KEY")
API_SECRET = os.getenv("API_SECRET")
ACCESS_TOKEN = os.getenv("ACCESS_TOKEN")
ACCESS_SECRET = os.getenv("ACCESS_SECRET")


def post_tweet(text):
    if not all([API_KEY, API_SECRET, ACCESS_TOKEN, ACCESS_SECRET]):
        print("Error: API Keys are missing in .env file.")
        return

    client = tweepy.Client(
        consumer_key=API_KEY,
        consumer_secret=API_SECRET,
        access_token=ACCESS_TOKEN,
        access_token_secret=ACCESS_SECRET,
    )
    try:
        response = client.create_tweet(text=text)
        print(f"Tweeted successfully! ID: {response.data['id']}")
    except Exception as e:
        print(f"Error: {e}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python tweet.py 'Text to tweet'")
        sys.exit(1)

    tweet_text = " ".join(sys.argv[1:])
    post_tweet(tweet_text)
