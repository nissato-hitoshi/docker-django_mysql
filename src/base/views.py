from django.views.generic import TemplateView
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db import connection

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

        with connection.cursor() as cursor:

            # 売上予算を主管部門別に集計
            sql = "select " \
                        " v1.accounting_period" \
                        ",v1.accounting_month" \
                        ",v1.budget_total " \
                        ",IFNULL(v2.achievement_total, 0) achievement_total " \
                        ",IFNULL(v2.achievement_total, 0) - v1.budget_total diff_total " \
                    "from (" \
                        "select "\
                            " accounting_period" \
                            ",accounting_month" \
                            ",sum(sales_budget.sales_budget) budget_total " \
                        "from sales_budget " \
                        "where version = 1 " \
                        "group by accounting_period, accounting_month" \
                    ") v1 " \
                    "left outer join (" \
                        "select " \
                            " accounting_period " \
                            ",accounting_month " \
                            ",sum(sales_achievement.amount_of_sales) achievement_total "\
                        "from sales_achievement " \
                        "group by accounting_period, accounting_month" \
                    ") v2 on " \
                        "v1.accounting_period = v2.accounting_period and "\
                        "v1.accounting_month = v2.accounting_month " \
                    "order by v1.accounting_period, v1.accounting_month "

            cursor.execute(sql)
            items = HomeView.dictfetchall(cursor)

        context["items"] = items

        with connection.cursor() as cursor:

            # 売上予算・実績を会計期毎に集計
            sql = "select " \
                        " v1.accounting_period" \
                        ",'－' accounting_month" \
                        ",v1.budget_total " \
                        ",IFNULL(v2.achievement_total, 0) achievement_total " \
                        ",IFNULL(v2.achievement_total, 0) - v1.budget_total diff_total " \
                    "from (" \
                        "select "\
                            " accounting_period " \
                            ",sum(sales_budget.sales_budget) budget_total " \
                        "from sales_budget " \
                        "where version = 1 " \
                        "group by accounting_period" \
                    ") v1 " \
                    "left outer join (" \
                        "select " \
                            " accounting_period " \
                            ",sum(sales_achievement.amount_of_sales) achievement_total "\
                        "from sales_achievement " \
                        "group by accounting_period" \
                    ") v2 on " \
                        "v1.accounting_period = v2.accounting_period "

            cursor.execute(sql)
            total = HomeView.dictfetchall(cursor)

        context["total"] = total

        return context
