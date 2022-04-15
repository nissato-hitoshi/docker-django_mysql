from django import forms

from .models import SalesBudget, VersionControl, SalesAchievement

class SalesAchievementForm(forms.ModelForm):
    class Meta:
        model = SalesAchievement
        fields = (
            'accounting_period',
            'project_code',
            'project_name',
            'client_name',
            'accounting_month',
            'sales_department',
            'business_sector',
            'supervising_department',
            'amount_of_sales',
            'material_cost',
            'labor_cost',
            'outsourcing_cost',
            'expenses',
            'cost_total',
            'gross_profit',
            'gross_profit_margin',
            'type_of_contract',
            'kinds',
            'project_parent_code',
            'project_parent_name',
        )

class VersionControlForm(forms.ModelForm):
    class Meta:
        model = VersionControl
        fields = (
            'accounting_period',
            'current_version',
            'first_half_version',
            'second_half_version',
        )

class SalesBudgetForm(forms.ModelForm):
    class Meta:
        model = SalesBudget
        fields = (
            'accounting_period',
            'version',
            'sales_department',
            'classification',
            'sales_representative',
            'supervising_department',
            'client_name',
            'project_name',
            'operator',
            'accounting_month',
            'sales_budget',
            'sales_expected',
            'sales_achievement',
            'half_period',
            'quarter',
            'accuracy'
        )
