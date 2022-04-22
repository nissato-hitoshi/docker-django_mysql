@echo off

@rem 環境関連変数
SET BAT_ROOT_PATH=C:\workspace\docker-django_mysql\src\batch\
SET BAT_PATH=bat\
SET SCRIPT_PATH=script\vbs\
SET INPUT_PATH=input\01.予算\
SET OUTPUT_PATH=output\
SET SQL_PATH=sql\vbs\
SET SQL_FILE_NAME=sales_achievement.sql

@rem コンテナ内用環境変数
SET CONTAINER_LOAD_FILE_PATH=/workspace/output/
SET CONTAINER_SQL_FILE=/workspace/sql/vbs/%SQL_FILE_NAME%

@rem DB接続情報
SET DB_SERVER=localhost
SET DB_NAME=django_app
SET DB_USER=root
SET DB_PASSWORD=jcsadmin
SET DB_PORT=3307

@rem 売上実績CSVデータ作成
@rem %1 ･･･ 会計期
@rem %2 ･･･ 対象年月（yyyymm形式）
cscript %BAT_ROOT_PATH%%SCRIPT_PATH%sales_achievement.vbs %1 %2

@rem 売上実績CSVインポート
docker-compose exec db mysql -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "source %CONTAINER_SQL_FILE%"
