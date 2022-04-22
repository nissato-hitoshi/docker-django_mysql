@echo off

@rem ���֘A�ϐ�
SET BAT_ROOT_PATH=C:\workspace\docker-django_mysql\src\batch\
SET BAT_PATH=bat\
SET SCRIPT_PATH=script\vbs\
SET INPUT_PATH=input\01.�\�Z\
SET OUTPUT_PATH=output\
SET SQL_PATH=sql\vbs\
SET SQL_FILE_NAME=sales_budget.sql

@rem �R���e�i���p���ϐ�
SET CONTAINER_LOAD_FILE_PATH=/workspace/output/
SET CONTAINER_SQL_FILE=/workspace/sql/vbs/%SQL_FILE_NAME%

@rem DB�ڑ����
SET DB_SERVER=localhost
SET DB_NAME=django_app
SET DB_USER=root
SET DB_PASSWORD=jcsadmin
SET DB_PORT=3307

@rem ����\�ZCSV�f�[�^�쐬
@rem %1 ��� ��v��
@rem %2 ��� 1:�ʏ프��\�Z�捞�@2:�����\�Z�捞
cscript %BAT_ROOT_PATH%%SCRIPT_PATH%sales_budget.vbs %1 %2

@rem ����\�ZCSV�C���|�[�g
docker-compose exec db mysql -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "source %CONTAINER_SQL_FILE%"
