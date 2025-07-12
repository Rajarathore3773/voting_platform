import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sortable"
export default class extends Controller {
  static targets = ["list"]

  connect() {
    this.initializeSortable()
  }

  async initializeSortable() {
    try {
      // Try to import Sortable from importmap
      const { default: Sortable } = await import("sortablejs")
      
      if (Sortable) {
        this.createSortable(Sortable)
      } else {
        this.createManualFallback()
      }
    } catch (error) {
      // Fallback to CDN if importmap fails
      this.loadSortableFromCDN()
    }
  }

  loadSortableFromCDN() {
    if (window.Sortable) {
      this.createSortable(window.Sortable)
      return
    }

    const script = document.createElement('script')
    script.src = 'https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js'
    script.onload = () => {
      this.createSortable(window.Sortable)
    }
    script.onerror = () => {
      this.createManualFallback()
    }
    document.head.appendChild(script)
  }

  createSortable(Sortable) {
    try {
      this.sortable = Sortable.create(this.listTarget, {
        animation: 150,
        ghostClass: 'sortable-ghost',
        chosenClass: 'sortable-chosen',
        dragClass: 'sortable-drag',
        onStart: this.onDragStart.bind(this),
        onEnd: this.onDragEnd.bind(this)
      })
    } catch (error) {
      this.createManualFallback()
    }
  }

  createManualFallback() {
    // Create a simple manual reordering fallback
    const items = this.listTarget.querySelectorAll('.candidate-item')
    items.forEach((item) => {
      item.style.cursor = 'pointer'
      item.addEventListener('click', () => this.moveItemToTop(item))
    })
  }

  moveItemToTop(clickedItem) {
    const list = this.listTarget
    const firstItem = list.querySelector('.candidate-item')
    if (firstItem !== clickedItem) {
      list.insertBefore(clickedItem, firstItem)
      this.updateInputs()
    }
  }

  onDragStart(evt) {
    evt.item.classList.add('dragging')
  }

  onDragEnd(evt) {
    evt.item.classList.remove('dragging')
    this.updateInputs()
  }

  updateInputs() {
    const items = this.listTarget.querySelectorAll("li[data-id]");
    const form = this.listTarget.closest('form');
    
    if (!form) return
    
    // Remove all existing ranking inputs
    form.querySelectorAll('input[name="rankings[]"]').forEach(input => input.remove());
    
    // Add new inputs in the correct order
    items.forEach((item) => {
      const candidateId = item.getAttribute('data-id');
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'rankings[]';
      input.value = candidateId;
      form.appendChild(input);
    });
  }
} 