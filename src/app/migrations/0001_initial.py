# Generated by Django 3.2 on 2022-04-09 08:06

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='SalesAchievement',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('updated', models.DateTimeField(auto_now=True, verbose_name='更新日時')),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='登録日時')),
                ('accounting_period', models.PositiveSmallIntegerField(verbose_name='会計期')),
                ('project_code', models.CharField(max_length=11, verbose_name='プロジェクトコード')),
                ('project_name', models.CharField(max_length=100, verbose_name='プロジェクト名')),
                ('client_name', models.CharField(max_length=100, verbose_name='取引先')),
                ('accounting_month', models.CharField(max_length=6, verbose_name='計上月')),
                ('sales_department', models.CharField(choices=[('1:第一', '1:第一'), ('2:第二', '2:第二'), ('3:ＢＳ', '3:ＢＳ'), ('4:ＳＩ', '4:ＳＩ')], max_length=10, verbose_name='営業部門')),
                ('business_sector', models.CharField(max_length=10, verbose_name='事業部')),
                ('supervising_department', models.CharField(max_length=10, verbose_name='主管部門')),
                ('amount_of_sales', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='売上高')),
                ('material_cost', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='材料費')),
                ('labor_cost', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='労務費')),
                ('outsourcing_cost', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='外注費')),
                ('expenses', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='経費')),
                ('cost_total', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='原価計')),
                ('gross_profit', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='粗利額')),
                ('gross_profit_margin', models.DecimalField(blank=True, decimal_places=2, default=0, max_digits=5, null=True, verbose_name='粗利率')),
                ('type_of_contract', models.CharField(max_length=10, verbose_name='契約形態')),
                ('kinds', models.CharField(max_length=10, verbose_name='種別')),
                ('project_parent_code', models.CharField(max_length=8, verbose_name='プロジェクト親番')),
                ('project_parent_name', models.CharField(max_length=100, verbose_name='プロジェクト親番名')),
            ],
            options={
                'verbose_name_plural': '売上実績',
                'db_table': 'sales_achievement',
            },
        ),
        migrations.CreateModel(
            name='SalesBudget',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('updated', models.DateTimeField(auto_now=True, verbose_name='更新日時')),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='登録日時')),
                ('accounting_period', models.PositiveSmallIntegerField(verbose_name='会計期')),
                ('version', models.PositiveIntegerField(verbose_name='Version')),
                ('sales_department', models.CharField(choices=[('1:第一', '1:第一'), ('2:第二', '2:第二'), ('3:ＢＳ', '3:ＢＳ'), ('4:ＳＩ', '4:ＳＩ')], max_length=10, verbose_name='営業部門')),
                ('classification', models.CharField(choices=[('1:社員', '1:社員'), ('2:外注', '2:外注'), ('3:物販', '3:物販')], max_length=10, verbose_name='分類')),
                ('sales_representative', models.CharField(max_length=20, verbose_name='営業担当者')),
                ('supervising_department', models.CharField(max_length=10, verbose_name='主管部門')),
                ('client_name', models.CharField(max_length=100, verbose_name='取引先')),
                ('project_name', models.CharField(max_length=100, verbose_name='プロジェクト名')),
                ('operator', models.CharField(max_length=100, verbose_name='担当者')),
                ('accounting_month', models.CharField(max_length=6, verbose_name='年月')),
                ('sales_budget', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='売上予算')),
                ('sales_expected', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='売上見込')),
                ('sales_achievement', models.DecimalField(blank=True, decimal_places=0, default=0, max_digits=13, null=True, verbose_name='売上実績')),
                ('half_period', models.CharField(choices=[('1:上期', '1:上期(10月~03月)'), ('2:下期', '2:下期(04月~09月)')], max_length=10, verbose_name='半期')),
                ('quarter', models.CharField(choices=[('1Q', '第1Q(10月~12月'), ('2Q', '第2Q(01月~03月'), ('3Q', '第3Q(04月~06月'), ('4Q', '第4Q(07月~09月')], max_length=2, verbose_name='四半期')),
                ('accuracy', models.CharField(choices=[('A', 'A：確度高'), ('B', 'B：確度中'), ('C', 'C：確度低'), ('D', 'D：削除')], max_length=2, verbose_name='確度')),
            ],
            options={
                'verbose_name_plural': '売上予算',
                'db_table': 'sales_budget',
            },
        ),
        migrations.CreateModel(
            name='VersionControl',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('updated', models.DateTimeField(auto_now=True, verbose_name='更新日時')),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='登録日時')),
                ('accounting_period', models.PositiveSmallIntegerField(verbose_name='会計期')),
                ('current_version', models.PositiveIntegerField(verbose_name='カレントバージョン')),
                ('first_half_version', models.PositiveIntegerField(verbose_name='期首予算確定バージョン')),
                ('second_half_version', models.PositiveIntegerField(verbose_name='下期予算確定バージョン')),
            ],
            options={
                'verbose_name_plural': 'バージョン管理テーブル',
                'db_table': 'version_control',
            },
        ),
    ]
