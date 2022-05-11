from django.views.generic import TemplateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import connection

from lib.common import AppUtil

class HomeView(LoginRequiredMixin, TemplateView):
    template_name = 'home.html'

    # パラメータによってテンプレートを変更する
    def get_template_names(self):

        # アプリケーション名取得
        if "app_name" in self.request.GET:
            app_name = self.request.GET.get("app_name")
        else:
            app_name = "base"

        # テンプレート名取得
        if "template_name" in self.request.GET:
            template_name = app_name + "/" + self.request.GET.get("template_name") + ".html"
        else:
            template_name = "home.html"
 
        return [template_name]

    @staticmethod
    def dictfetchall(cursor):
        columns = [col[0] for col in cursor.description]
        return [
            dict(zip(columns, row))
            for row in cursor.fetchall()
        ]

    #変数を渡す
    def get_context_data(self,**kwargs):
        context = super().get_context_data(**kwargs)

        # アプリケーション名取得
        if "app_name" in self.request.GET:
            app_name = self.request.GET.get("app_name")
        else:
            app_name = "base"

        # テンプレート名取得
        if "template_name" in self.request.GET:
            template_name = self.request.GET.get("template_name")
        else:
            template_name = "home"

        # パラメータで指定されたSQLを実行し結果を取得する
        with connection.cursor() as cursor:
            sql = AppUtil.get_sql(app_name, template_name)
            cursor.execute(sql)
            items = HomeView.dictfetchall(cursor)
 
        context["items"] = items

        return context
