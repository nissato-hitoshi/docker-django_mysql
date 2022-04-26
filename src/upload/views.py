from django.shortcuts import render
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView, FormView
from django.urls import reverse_lazy
from django.utils import timezone
from django.contrib.auth.mixins import LoginRequiredMixin

from .models import Document
from .forms import DocumentForm

class DocumentListView(LoginRequiredMixin, ListView):
    template_name = 'upload/doc/index.html'
    model = Document
    paginate_by = 5
    context_object_name = 'docs'

class DocumentCreateView(LoginRequiredMixin, CreateView):
    template_name = 'upload/doc/create.html'
    model = Document
    form_class = DocumentForm
    success_url = reverse_lazy('upload:doc.index')

class DocumentUpdateView(LoginRequiredMixin, UpdateView):
    template_name = 'upload/doc/update.html'
    model = Document
    form_class = DocumentForm
    success_url = reverse_lazy('upload:doc.index')
    context_object_name = 'doc'

class DocumentDeleteView(LoginRequiredMixin, DeleteView):
    template_name = 'upload/doc/delete.html'
    model = Document
    form_class = DocumentForm
    success_url = reverse_lazy('app:doc.index')
    context_object_name = 'doc'
