<template>
  <div class="contact-page pt-24 pb-20">
    <!-- Hero Section -->
    <!-- <section class="bg-gradient-to-br from-primary-50 to-white py-20"> -->
    <section class="bg-gradient-to-br from-primary-500 to-yellow-400 py-20">
      <div class="container mx-auto px-4 text-center">
        <h1 class="text-5xl md:text-6xl font-display font-bold mb-6">
          Contactez-nous
        </h1>
        <p class="text-xl text-gray-600 max-w-2xl mx-auto">
          Vous avez un projet de rénovation ? Parlons-en ensemble. Choisissez le moyen de contact qui vous convient le mieux.
        </p>
      </div>
    </section>

    <!-- Options de contact -->
    <section class="py-16 bg-white">
      <div class="container mx-auto px-4">
        <div class="grid md:grid-cols-3 gap-8 max-w-5xl mx-auto">
          <!-- Téléphone -->
          <a 
            href="tel:0749908401" 
            class="card text-center hover:shadow-2xl hover:border-primary-500 border-2 border-transparent transition-all duration-300 group"
          >
            <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-primary-500 group-hover:scale-110 transition-all duration-300">
              <svg class="w-10 h-10 text-primary-600 group-hover:text-white transition-colors duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
              </svg>
            </div>
            <h3 class="text-2xl font-bold mb-2">Par téléphone</h3>
            <p class="text-gray-600 mb-4">Appelez-nous directement pour un échange rapide et personnalisé</p>
            <p class="text-2xl font-bold text-primary-600 group-hover:text-primary-700">07 49 90 84 01</p>
          </a>

          <!-- Email -->
          <a 
            href="mailto:prorenovation@gmail.com" 
            class="card text-center hover:shadow-2xl hover:border-primary-500 border-2 border-transparent transition-all duration-300 group"
          >
            <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-primary-500 group-hover:scale-110 transition-all duration-300">
              <svg class="w-10 h-10 text-primary-600 group-hover:text-white transition-colors duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
              </svg>
            </div>
            <h3 class="text-2xl font-bold mb-2">Par email</h3>
            <p class="text-gray-600 mb-4">Envoyez-nous un email avec les détails de votre projet</p>
            <p class="text-lg font-semibold text-primary-600 group-hover:text-primary-700 break-all">
              prorenovation@gmail.com
            </p>
          </a>

          <!-- Formulaire -->
          <div 
            class="card text-center hover:shadow-2xl hover:border-primary-500 border-2 border-transparent transition-all duration-300 cursor-pointer group"
            @click="scrollToForm"
          >
            <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6 group-hover:bg-primary-500 group-hover:scale-110 transition-all duration-300">
              <svg class="w-10 h-10 text-primary-600 group-hover:text-white transition-colors duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h3 class="text-2xl font-bold mb-2">Par formulaire</h3>
            <p class="text-gray-600 mb-4">Remplissez notre formulaire de contact ci-dessous</p>
            <p class="text-primary-600 font-semibold group-hover:text-primary-700">Réponse sous 24h</p>
          </div>
        </div>
      </div>
    </section>

    <!-- Formulaire de contact -->
    <section id="contact-form" class="py-20 bg-gray-50">
      <div class="container mx-auto px-4">
        <div class="max-w-3xl mx-auto">
          <div class="text-center mb-12">
            <h2 class="text-4xl font-display font-bold mb-4">
              Envoyez-nous un message
            </h2>
            <p class="text-gray-600 text-lg">
              Décrivez-nous votre projet et nous vous recontactons rapidement avec un devis personnalisé.
            </p>
          </div>

          <form @submit.prevent="handleSubmit" class="card">
            <div class="grid md:grid-cols-2 gap-6 mb-6">
              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                  Nom complet *
                </label>
                <input 
                  v-model="form.name"
                  type="text" 
                  required
                  class="input-field"
                  placeholder="Jean Dupont"
                />
              </div>

              <div>
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                  Téléphone *
                </label>
                <input 
                  v-model="form.phone"
                  type="tel" 
                  required
                  class="input-field"
                  placeholder="06 12 34 56 78"
                />
              </div>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-semibold text-gray-700 mb-2">
                Email *
              </label>
              <input 
                v-model="form.email"
                type="email" 
                required
                class="input-field"
                placeholder="jean.dupont@email.com"
              />
            </div>

            <div class="mb-6">
              <label class="block text-sm font-semibold text-gray-700 mb-2">
                Type de projet *
              </label>
              <select 
                v-model="form.projectType"
                required
                class="input-field"
              >
                <option value="">Sélectionnez un type de projet</option>
                <option value="cuisine">Rénovation cuisine</option>
                <option value="salle-de-bain">Rénovation salle de bain</option>
                <option value="amenagement">Travaux d'aménagement</option>
                <option value="complete">Rénovation complète</option>
                <option value="autre">Autre</option>
              </select>
            </div>

            <div class="mb-6">
              <label class="block text-sm font-semibold text-gray-700 mb-2">
                Message / Description du projet *
              </label>
              <textarea 
                v-model="form.message"
                required
                rows="6"
                class="textarea-field"
                placeholder="Décrivez-nous votre projet de rénovation..."
              ></textarea>
            </div>

            <div class="mb-6">
              <label class="flex items-start">
                <input 
                  v-model="form.consent"
                  type="checkbox" 
                  required
                  class="mt-1 mr-3 w-5 h-5 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                />
                <span class="text-sm text-gray-600">
                  J'accepte que mes données personnelles soient utilisées pour me recontacter concernant ma demande. *
                </span>
              </label>
            </div>

            <button 
              type="submit"
              class="btn btn-primary w-full text-lg py-4"
              :disabled="isSubmitting"
            >
              <span v-if="!isSubmitting">Envoyer ma demande</span>
              <span v-else class="flex items-center justify-center">
                <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                  <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                  <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                Envoi en cours...
              </span>
            </button>

            <p v-if="submitSuccess" class="mt-4 text-green-600 text-center font-semibold">
              ✓ Message envoyé avec succès ! Nous vous recontactons rapidement.
            </p>
          </form>
        </div>
      </div>
    </section>

    <!-- Informations supplémentaires -->
    <section class="py-16 bg-white">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <div class="grid md:grid-cols-2 gap-8">
            <div class="card">
              <h3 class="text-2xl font-bold mb-4">Horaires d'ouverture</h3>
              <div class="space-y-2 text-gray-600">
                <div class="flex justify-between">
                  <span class="font-semibold">Lundi - Vendredi</span>
                  <span>8h00 - 18h00</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-semibold">Samedi</span>
                  <span>9h00 - 17h00</span>
                </div>
                <div class="flex justify-between">
                  <span class="font-semibold">Dimanche</span>
                  <span>Fermé</span>
                </div>
              </div>
            </div>

            <div class="card">
              <h3 class="text-2xl font-bold mb-4">Zone d'intervention</h3>
              <p class="text-gray-600 mb-4">
                Nous intervenons principalement en <strong>Île-de-France</strong> et ses environs.
              </p>
              <p class="text-gray-600">
                Déplacements possibles dans d'autres régions selon la nature et l'ampleur du projet.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

const form = reactive({
  name: '',
  phone: '',
  email: '',
  projectType: '',
  message: '',
  consent: false
})

const isSubmitting = ref(false)
const submitSuccess = ref(false)

const scrollToForm = () => {
  const formElement = document.getElementById('contact-form')
  if (formElement) {
    formElement.scrollIntoView({ behavior: 'smooth', block: 'start' })
  }
}

const handleSubmit = () => {
  isSubmitting.value = true
  
  // Simulation d'envoi
  setTimeout(() => {
    isSubmitting.value = false
    submitSuccess.value = true
    
    // Reset form
    Object.assign(form, {
      name: '',
      phone: '',
      email: '',
      projectType: '',
      message: '',
      consent: false
    })

    // Reset success message after 5s
    setTimeout(() => {
      submitSuccess.value = false
    }, 5000)
  }, 1500)
}
</script>
