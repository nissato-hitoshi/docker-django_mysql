from django.db import models

# Create your models here.
# 営業部署名    
sales_department_choice = [
    ('1:第一','1:第一'),
    ('2:第二','2:第二'),
    ('3:ＢＳ','3:ＢＳ'),
    ('4:ＳＩ','4:ＳＩ'),
]

# Create your models here.
# 営業部署名（実績）    
sales_department_achi_choice = [
    ('第一営業部','第一営業部'),
    ('第二営業部','第二営業部'),
    ('BS営業部','BS営業部'),
    ('SI営業部','SI営業部'),
]

# 分類
business_sector_choice = [
    ('SD','SD事業部'),
    ('SD1','SD1部'),
    ('SD2','SD2部'),
    ('SD3','SD3部'),
    ('SD4','SD4部'),
    ('IS','IS事業部'),
    ('IS1','IS1部'),
    ('IS2','IS2部'),
    ('IS3','IS3部'),
    ('PA','PA事業部'),
    ('PA1','PA1部'),
    ('PA2','PA2部'),
    ('LCM','LCM事業部'),
    ('R&D','R&D事業部'),
    ('ZZ','事業統括本部'),
]

# 主管部門
supervising_department_choice = [
    ('SD','SD事業部'),
    ('IS','IS事業部'),
    ('PA','PA事業部'),
    ('LCM','LCM事業部'),
    ('R&D','R&D事業部'),
    ('ZZ','事業統括本部'),
]

# 分類
classification_choice = [
    ('1:社員','1:社員'),
    ('2:外注','2:外注'),
    ('3:物販','3:物販'),
]

# 半期
half_period_choice = [
    ('1:上期', '1:上期(10月~03月)'),
    ('2:下期', '2:下期(04月~09月)'),
]

# 四半期
quarter_choice = [
    ('1Q', '第1Q(10月~12月'),
    ('2Q', '第2Q(01月~03月'),
    ('3Q', '第3Q(04月~06月'),
    ('4Q', '第4Q(07月~09月'),
]

# 確度
accuracy_choice = [
    ('A', 'A：確度高'),
    ('B', 'B：確度中'),
    ('C', 'C：確度低'),
    ('D', 'D：削除'),
]

# 契約形態
type_of_contract_choice = [
    ('委任', '委任'),
    ('派遣', '派遣'),
    ('請負', '請負'),
]

# 種別
kinds_choice = [
    ('その他', 'その他'),
    ('外注', '外注'),
]

# 共通のベースモデル（更新日時、登録日時項目）
class TimeStampedModel(models.Model):
    updated = models.DateTimeField(verbose_name="更新日時", auto_now=True)
    created = models.DateTimeField(verbose_name="登録日時", auto_now_add=True)

    class Meta:
        abstract = True

# バージョン管理テーブル
class VersionControl(TimeStampedModel):
    accounting_period = models.PositiveSmallIntegerField(verbose_name="会計期",)
    current_version = models.PositiveIntegerField(verbose_name="カレントバージョン",)
    first_half_version = models.PositiveIntegerField(verbose_name="期首予算確定バージョン",)
    second_half_version = models.PositiveIntegerField(verbose_name="下期予算確定バージョン",)

    def __str__(self):
        return self.id

    class Meta:
        db_table = 'version_control'
        verbose_name_plural = 'バージョン管理テーブル'

# 売上実績テーブル
class SalesAchievement(TimeStampedModel):
    accounting_period = models.PositiveSmallIntegerField(verbose_name="会計期",)
    project_code = models.CharField(verbose_name="プロジェクトコード", max_length=11)
    project_name = models.CharField(verbose_name="プロジェクト名", max_length=100)
    client_name = models.CharField(verbose_name="取引先", max_length=100)
    accounting_month = models.CharField(verbose_name="計上月", max_length=6)
    sales_department = models.CharField(verbose_name="営業部門", max_length=10, choices=sales_department_achi_choice)
    business_sector = models.CharField(verbose_name="事業部", max_length=10, choices=business_sector_choice)
    supervising_department = models.CharField(verbose_name="主管部門", max_length=10, choices=supervising_department_choice)
    amount_of_sales =  models.DecimalField(verbose_name="売上高", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    material_cost =  models.DecimalField(verbose_name="材料費", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    labor_cost =  models.DecimalField(verbose_name="労務費", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    outsourcing_cost =  models.DecimalField(verbose_name="外注費", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    expenses =  models.DecimalField(verbose_name="経費", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    cost_total =  models.DecimalField(verbose_name="原価計", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    gross_profit =  models.DecimalField(verbose_name="粗利額", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    gross_profit_margin =  models.DecimalField(verbose_name="粗利率", max_digits=5, decimal_places=2, blank=True, null=True, default=0,)
    type_of_contract = models.CharField(verbose_name="契約形態", max_length=10,choices=type_of_contract_choice)
    kinds = models.CharField(verbose_name="種別", max_length=10,choices=kinds_choice)
    project_parent_code = models.CharField(verbose_name="プロジェクト親番", max_length=8)
    project_parent_name = models.CharField(verbose_name="プロジェクト親番名", max_length=100)

    def __str__(self):
        return self.id

    class Meta:
        db_table = 'sales_achievement'
        verbose_name_plural = '売上実績'

# 売上予算テーブル
class SalesBudget(TimeStampedModel):
    accounting_period = models.PositiveSmallIntegerField(verbose_name="会計期",)
    version = models.PositiveIntegerField(verbose_name="Version",)
    sales_department = models.CharField(verbose_name="営業部門", max_length=10, choices=sales_department_choice)
    classification = models.CharField(verbose_name="分類", max_length=10, choices=classification_choice)
    sales_representative = models.CharField(verbose_name="営業担当者", max_length=20)
    supervising_department = models.CharField(verbose_name="主管部門", max_length=10, choices=business_sector_choice)
    client_name = models.CharField(verbose_name="取引先", max_length=100)
    project_name = models.CharField(verbose_name="プロジェクト名", max_length=100)
    operator = models.CharField(verbose_name="担当者", max_length=100)
    accounting_month = models.CharField(verbose_name="年月", max_length=6)
    sales_budget =  models.DecimalField(verbose_name="売上予算", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    sales_expected = models.DecimalField(verbose_name="売上見込", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    sales_achievement = models.DecimalField(verbose_name="売上実績", max_digits=13, decimal_places=0, blank=True, null=True, default=0,)
    half_period = models.CharField(verbose_name="半期", max_length=10, choices=half_period_choice)
    quarter = models.CharField(verbose_name="四半期", max_length=2, choices=quarter_choice)
    accuracy = models.CharField(verbose_name="確度", max_length=2, choices=accuracy_choice)

    def __str__(self):
        return self.id

    class Meta:
        db_table = 'sales_budget'
        verbose_name_plural = '売上予算'
