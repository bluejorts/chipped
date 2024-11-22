import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results", "hiddenInput"]
  
  connect() {
    this.timeout = null
    this.minLength = 2
    this.results = []
  }
  
  search() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value
    
    if (query.length < this.minLength) {
      this.hideResults()
      return
    }
    
    this.timeout = setTimeout(() => {
      fetch(`/species/search?query=${encodeURIComponent(query)}`)
        .then(response => response.json())
        .then(data => {
          this.results = data
          this.showResults()
        })
    }, 300)
  }
  
  showResults() {
    this.resultsTarget.innerHTML = this.results
      .map((species, index) => `
        <div class="species-result" data-action="click->species-search#select" data-index="${index}">
          ${species.name}
        </div>
      `).join('')
    
    this.resultsTarget.classList.remove('hidden')
  }
  
  hideResults() {
    this.resultsTarget.classList.add('hidden')
  }
  
  select(event) {
    const index = event.currentTarget.dataset.index
    const species = this.results[index]
    
    this.inputTarget.value = species.name
    this.hiddenInputTarget.value = species.id
    this.hideResults()
  }
  
  async createNew() {
    const name = this.inputTarget.value.trim()
    if (!name) return
    
    const response = await fetch('/species', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({ name })
    })
    
    const data = await response.json()
    if (response.ok) {
      this.hiddenInputTarget.value = data.id
    }
  }
} 