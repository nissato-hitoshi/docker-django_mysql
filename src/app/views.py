# Create your views here.
from django.shortcuts import render
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView, FormView
from django.urls import reverse_lazy
from django.utils import timezone
from django.contrib.auth.mixins import LoginRequiredMixin
from django.db.models import Q

# Create your views here.
from django.http import HttpResponse

from .models import SalesBudget, VersionControl, SalesAchievement
from .forms import SalesBudgetForm, VersionControlForm, SalesAchievementForm, SearchBudgetForm

class SalesBudgetListView(LoginRequiredMixin,ListView):
    template_name = 'app/sales_budget/index.html'
    model = SalesBudget
    paginate_by = 10
    context_object_name = 'sales_budgets'

    def post(self, request, *args, **kwargs):
        # セッションに検索値を設定
        form_value = [
            self.request.POST.get('search_accounting_period', None),
            self.request.POST.get('search_client_name', None),
            self.request.POST.get('search_accounting_month', None),
        ]
        request.session['form_value'] = form_value

        # 検索時にページネーションに関連したエラーを防ぐ
        self.request.GET = self.request.GET.copy()
        self.request.GET.clear()
        return self.get(request, *args, **kwargs)

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)

        # sessionに値がある場合、その値をセットする。（ページングしてもform値が変わらないように）
        if 'form_value' in self.request.session:
            form_value = self.request.session['form_value']

            default_data = {
                'search_accounting_period': form_value[0], 
                'search_client_name': form_value[1],
                'search_accounting_month': form_value[2],
            }
        else:
            default_data = {
                'search_accounting_period': '43', 
                'search_client_name': '',
                'search_accounting_month': '',
            }
        
        context['search_form'] = SearchBudgetForm(initial=default_data)

        return context

    def get_queryset(self):
        # sessionに値がある場合、その値でクエリ発行する。
        if 'form_value' in self.request.session:
            form_value = self.request.session['form_value']

            # 検索条件
            condition1 = Q()
            condition2 = Q()
            condition3 = Q()

            if len(form_value[0]) != 0:
                condition1 = Q(accounting_period__icontains=form_value[0])

            if len(form_value[1]) != 0:
                condition2 = Q(client_name__contains=form_value[1])

            if len(form_value[2]) != 0:
                condition3 = Q(accounting_month__contains=form_value[2])

            return SalesBudget.objects.select_related().filter(condition1 & condition2 & condition3)
        else:
            # 何も返さない
            return SalesBudget.objects.all()

class SalesBudgetCreateView(LoginRequiredMixin,CreateView):
    template_name = 'app/sales_budget/create.html'
    model = SalesBudget
    form_class = SalesBudgetForm
    success_url = reverse_lazy('app:sales_budget.index')

class SalesBudgetUpdateView(LoginRequiredMixin,UpdateView):
    template_name = 'app/sales_budget/update.html'
    model = SalesBudget
    form_class = SalesBudgetForm
    success_url = reverse_lazy('app:sales_budget.index')
    context_object_name = 'sales_budget'

    def form_valid(self, form):
        SalesBudget = form.save(commit=False)
        SalesBudget.updated = timezone.now()
        SalesBudget.save()
        return super().form_valid(form)

class SalesBudgetDeleteView(LoginRequiredMixin,DeleteView):
    template_name = 'app/sales_budget/delete.html'
    model = SalesBudget
    success_url = reverse_lazy('app:sales_budget.index')
    context_object_name = 'sales_budget'

class VersionControlListView(LoginRequiredMixin,ListView):
    template_name = 'app/version_control/index.html'
    model = VersionControl
    paginate_by = 10
    context_object_name = 'version_controls'

class VersionControlCreateView(LoginRequiredMixin,CreateView):
    template_name = 'app/version_control/create.html'
    model = VersionControl
    form_class = VersionControlForm
    success_url = reverse_lazy('app:version_control.index')

class VersionControlUpdateView(LoginRequiredMixin,UpdateView):
    template_name = 'app/version_control/update.html'
    model = VersionControl
    form_class = VersionControlForm
    success_url = reverse_lazy('app:version_control.index')
    context_object_name = 'version_control'

    def form_valid(self, form):
        SalesBudget = form.save(commit=False)
        SalesBudget.updated = timezone.now()
        SalesBudget.save()
        return super().form_valid(form)

class VersionControlDeleteView(LoginRequiredMixin,DeleteView):
    template_name = 'app/version_control/delete.html'
    model = VersionControl
    success_url = reverse_lazy('app:version_control.index')
    context_object_name = 'version_control'

class SalesAchievementListView(LoginRequiredMixin,ListView):
    template_name = 'app/sales_achievement/index.html'
    model = SalesAchievement
    paginate_by = 10
    context_object_name = 'sales_achievements'

class SalesAchievementCreateView(LoginRequiredMixin,CreateView):
    template_name = 'app/sales_achievement/create.html'
    model = SalesAchievement
    form_class = SalesAchievementForm
    success_url = reverse_lazy('app:sales_achievement.index')

class SalesAchievementUpdateView(LoginRequiredMixin,UpdateView):
    template_name = 'app/sales_achievement/update.html'
    model = SalesAchievement
    form_class = SalesAchievementForm
    success_url = reverse_lazy('app:sales_achievement.index')
    context_object_name = 'sales_achievement'

    def form_valid(self, form):
        SalesBudget = form.save(commit=False)
        SalesBudget.updated = timezone.now()
        SalesBudget.save()
        return super().form_valid(form)

class SalesAchievementDeleteView(LoginRequiredMixin,DeleteView):
    template_name = 'app/sales_achievement/delete.html'
    model = SalesAchievement
    success_url = reverse_lazy('app:sales_achievement.index')
    context_object_name = 'sales_achievement'
