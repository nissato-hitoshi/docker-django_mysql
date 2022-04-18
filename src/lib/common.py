import os
from base.settings import BASE_DIR

class AppUtil():
    def get_sql(appname: str, filename: str)->str:
        """
        SQLをファイルから取得する

        Args:
            appname (str): SQLが配置されているアプリケーション名
            filename (str): SQLファイルの名前

        Returns:
            str: SQLクエリ
        """
        with open(BASE_DIR / (appname + "/sql/" + filename + ".sql"), "r") as f:
            return f.read()
