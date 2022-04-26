# Generated by Django 3.2 on 2022-04-26 12:26

from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='Document',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('description', models.CharField(blank=True, max_length=255, verbose_name='説明')),
                ('document', models.FileField(upload_to='documents/', verbose_name='アップロードファイル')),
                ('uploaded_at', models.DateTimeField(auto_now_add=True, verbose_name='アップロード日時')),
                ('updated', models.DateTimeField(auto_now=True, verbose_name='更新日時')),
                ('created', models.DateTimeField(auto_now_add=True, verbose_name='登録日時')),
            ],
            options={
                'verbose_name_plural': 'ドキュメント',
                'db_table': 'upload_document',
            },
        ),
    ]
