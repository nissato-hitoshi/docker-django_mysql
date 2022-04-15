# Create your views here.
from django.shortcuts import render
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView, FormView
from django.urls import reverse_lazy
from django.utils import timezone
from django.contrib.auth.mixins import LoginRequiredMixin

# Create your views here.
from django.http import HttpResponse

from .models import SalesBudget, VersionControl, SalesAchievement
from .forms import SalesBudgetForm, VersionControlForm, SalesAchievementForm

class SalesBudgetListView(LoginRequiredMixin,ListView):
    template_name = 'app/sales_budget/index.html'
    model = SalesBudget
    paginate_by = 10
    context_object_name = 'sales_budgets'

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
