from django.urls import path
from . import views

app_name= 'app'

urlpatterns = [
    # 売上予算関連
    path('app/', views.SalesBudgetListView.as_view(), name='sales_budget.index'),
    path('app/sales_budget', views.SalesBudgetListView.as_view(), name='sales_budget.index'),
    path('app/sales_budget/create', views.SalesBudgetCreateView.as_view(), name='sales_budget.create'),
    path('app/sales_budget/update/<int:pk>/', views.SalesBudgetUpdateView.as_view(), name='sales_budget.update'),
    path('app/sales_budget/delete/<int:pk>/', views.SalesBudgetDeleteView.as_view(), name='sales_budget.delete'),
    # 売上実績関連
    path('app/sales_achievement', views.SalesAchievementListView.as_view(), name='sales_achievement.index'),
    path('app/sales_achievement/create', views.SalesAchievementCreateView.as_view(), name='sales_achievement.create'),
    path('app/sales_achievement/update/<int:pk>/', views.SalesAchievementUpdateView.as_view(), name='sales_achievement.update'),
    path('app/sales_achievement/delete/<int:pk>/', views.SalesAchievementDeleteView.as_view(), name='sales_achievement.delete'),
    # バージョン管理関連
    path('app/version_control', views.VersionControlListView.as_view(), name='version_control.index'),
    path('app/version_control/create', views.VersionControlCreateView.as_view(), name='version_control.create'),
    path('app/version_control/update/<int:pk>/', views.VersionControlUpdateView.as_view(), name='version_control.update'),
    path('app/version_control/delete/<int:pk>/', views.VersionControlDeleteView.as_view(), name='version_control.delete'),
]
