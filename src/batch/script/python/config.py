# .env ファイルをロードして環境変数へ反映
from os.path import join, dirname
from dotenv import load_dotenv
import os

load_dotenv(verbose=True)

dotenv_path = join(dirname(__file__), '.env')
load_dotenv(dotenv_path)

LOG_PATH=os.environ.get('LOG_PATH')
ZISSEKI_PATH=os.environ.get('ZISSEKI_PATH')
OUTPUT_PATH=os.environ.get('OUTPUT_PATH')

YOSAN_PATH=os.environ.get('YOSAN_PATH')

MYSQL_USER=os.environ.get('MYSQL_USER')
MYSQL_PORT=os.environ.get('MYSQL_PORT')
MYSQL_PW=os.environ.get('MYSQL_PW')
MYSQL_HOST=os.environ.get('MYSQL_HOST')
MYSQL_DB=os.environ.get('MYSQL_DB')