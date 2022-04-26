from django.db import models

# Create your models here.
class Document(models.Model):
    description = models.CharField(verbose_name="説明", max_length=255, blank=True)
    document = models.FileField(verbose_name="アップロードファイル", upload_to='documents/')
    uploaded_at = models.DateTimeField(verbose_name="アップロード日時", auto_now_add=True)
    updated = models.DateTimeField(verbose_name="更新日時", auto_now=True)
    created = models.DateTimeField(verbose_name="登録日時", auto_now_add=True)

    class Meta:
        db_table = 'upload_document'
        verbose_name_plural = 'ドキュメント'
