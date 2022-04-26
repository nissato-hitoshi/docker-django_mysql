from django.urls import path
from . import views

app_name= 'upload'

urlpatterns = [
    path('upload/doc/index/', views.DocumentListView.as_view(), name='doc.index'),
    path('upload/doc/create/', views.DocumentCreateView.as_view(), name='doc.create'),
    path('upload/doc/update/<int:pk>/', views.DocumentUpdateView.as_view(), name='doc.update'),
    path('upload/doc/delete/<int:pk>/', views.DocumentDeleteView.as_view(), name='doc.delete'),
]
