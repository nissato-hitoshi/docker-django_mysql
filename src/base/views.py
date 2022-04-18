from django.views.generic import TemplateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import connection

from lib.common import AppUtil

class HomeView(LoginRequiredMixin, TemplateView):
    template_name = 'home.html'

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

        # 売上予算を主管部門別に集計
        with connection.cursor() as cursor:
            sql = AppUtil.get_sql('base', 'home.001')
            cursor.execute(sql)
            items = HomeView.dictfetchall(cursor)
        context["items"] = items

        # 売上予算・実績を会計期毎に集計
        with connection.cursor() as cursor:
            sql = AppUtil.get_sql('base', 'home.002')
            cursor.execute(sql)
            total = HomeView.dictfetchall(cursor)
        context["total"] = total
        
        return context
