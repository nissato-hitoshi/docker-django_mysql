@echo off

@rem Â«ÖAÏ
SET BAT_ROOT_PATH=C:\Users\arasawa_m\Desktop\app.test\src\batch\
SET BAT_PATH=bat\
SET SCRIPT_PATH=script\vbs\
SET INPUT_PATH=input\01.\Z\
SET OUTPUT_PATH=output\
SET SQL_PATH=sql\vbs\
SET SQL_FILE_NAME=sales_budget.sql

@rem ReiàpÂ«Ï
SET CONTAINER_LOAD_FILE_PATH=/workspace/output/
SET CONTAINER_SQL_FILE=/workspace/sql/vbs/%SQL_FILE_NAME%

@rem DBÚ±îñ
SET DB_SERVER=localhost
SET DB_NAME=django_app
SET DB_USER=root
SET DB_PASSWORD=jcsadmin
SET DB_PORT=3307

@rem ã\ZCSVf[^ì¬
@rem %1 ¥¥¥ ïvú
@rem %2 ¥¥¥ 1:Êíã\Zæ@2:ºú\Zæ
cscript %BAT_ROOT_PATH%%SCRIPT_PATH%sales_budget.vbs %1 %2

@rem ã\ZCSVC|[g
docker-compose exec db mysql -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "source %CONTAINER_SQL_FILE%"
