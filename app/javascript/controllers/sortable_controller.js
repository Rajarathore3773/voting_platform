import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sortable"
export default class extends Controller {
  static targets = ["list"]

  connect() {
    console.log('Sortable controller connected')
    this.initializeSortable()
  }

  async initializeSortable() {
    try {
      // Try to import from importmap first
      let Sortable
      try {
        const sortableModule = await import("sortablejs")
        Sortable = sortableModule.default
        console.log('Sortable imported from importmap')
      } catch (importError) {
        console.log('Importmap failed, trying CDN')
        // Fallback to CDN
        Sortable = await this.loadSortableFromCDN()
      }
      
      if (Sortable) {
        this.createSortable(Sortable)
      } else {
        throw new Error('Could not load Sortable.js')
      }
    } catch (error) {
      console.error('Error initializing Sortable:', error)
      this.createManualFallback()
    }
  }

  loadSortableFromCDN() {
    return new Promise((resolve) => {
      if (window.Sortable) {
        resolve(window.Sortable)
        return
      }

      const script = document.createElement('script')
      script.src = 'https://cdn.jsdelivr.net/npm/sortablejs@1.15.0/Sortable.min.js'
      script.onload = () => {
        console.log('Sortable loaded from CDN')
        resolve(window.Sortable)
      }
      script.onerror = () => {
        console.error('Failed to load Sortable from CDN')
        resolve(null)
      }
      document.head.appendChild(script)
    })
  }

  createSortable(Sortable) {
    try {
      console.log('Creating Sortable instance')
      this.sortable = Sortable.create(this.listTarget, {
        animation: 150,
        ghostClass: 'sortable-ghost',
        chosenClass: 'sortable-chosen',
        dragClass: 'sortable-drag',
        onStart: this.onDragStart.bind(this),
        onEnd: this.onDragEnd.bind(this)
      })
      console.log('Sortable instance created successfully')
    } catch (error) {
      console.error('Error creating Sortable instance:', error)
      this.createManualFallback()
    }
  }

  createManualFallback() {
    console.log('Creating manual fallback')
    // Create a simple manual reordering fallback
    const items = this.listTarget.querySelectorAll('.candidate-item')
    items.forEach((item, index) => {
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
    console.log('Drag started')
    evt.item.classList.add('dragging')
  }

  onDragEnd(evt) {
    console.log('Drag ended')
    evt.item.classList.remove('dragging')
    this.updateInputs()
  }

  updateInputs() {
    console.log('Updating form inputs')
    const items = this.listTarget.querySelectorAll("li[data-id]");
    const form = this.listTarget.closest('form');
    
    if (!form) {
      console.error('No form found')
      return
    }
    
    // Remove all existing ranking inputs
    form.querySelectorAll('input[name="rankings[]"]').forEach(input => input.remove());
    
    // Add new inputs in the correct order
    items.forEach((item, index) => {
      const candidateId = item.getAttribute('data-id');
      const input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'rankings[]';
      input.value = candidateId;
      form.appendChild(input);
      console.log(`Added input for candidate ${candidateId} at position ${index + 1}`)
    });
  }
} 