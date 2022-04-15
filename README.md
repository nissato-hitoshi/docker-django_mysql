# docker-django

### ローカル環境
- docker 20.10.11
- docker-compose 2.2.1
- git 2.32.0

### 作成する環境
- Python 3.9.10
- MySQL 8.0

### コンテナの起動
```
$ docker-compose up
```

### Djangoプロジェクト作成コマンド（初回）
```
$ docker-compose exec app django-admin.py startproject [プロジェクト名（任意）] .
```

### Django アプリケーション追加 コマンド
```
$ docker-compose exec app python manage.py startapp [アプリケーション名（任意）]
```

### モデルを元にデータベースにテーブルを作成するスクリプトの作成
```
$ docker-compose exec app python manage.py makemigrations
```

### モデルを元にデータベースにテーブルを作成する
```
$ docker-compose exec app python manage.py migrate
```

### Webサーバ起動する
```
$ docker-compose exec app python manage.py runserver 0:8000
```

### Pythonバッチ処理を実行
```
$ docker-compose exec app python batch/script/python/csv_zisseki_02.py 43 202202
```