<template>
  <div class="devis-page pt-24 pb-20">
    <!-- Hero Section -->
    <section class="bg-gradient-to-br from-primary-500 via-primary-400 to-yellow-300 py-20 text-black">
      <div class="container mx-auto px-4 text-center">
        <h1 class="text-5xl md:text-6xl font-display font-bold mb-6">
          Demande de devis gratuit
        </h1>
        <p class="text-xl md:text-2xl max-w-3xl mx-auto mb-8">
          Obtenez une estimation précise et personnalisée pour votre projet de rénovation en quelques minutes
        </p>
        <div class="flex items-center justify-center space-x-2 text-lg">
          <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
          </svg>
          <span class="font-semibold">Réponse sous 24h • Sans engagement</span>
        </div>
      </div>
    </section>

    <!-- Progress bar -->
    <div class="bg-white py-6 sticky top-20 z-40 shadow-sm">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <div class="flex items-center justify-between mb-2">
            <span class="text-sm font-semibold text-gray-600">Étape {{ currentStep }} sur 3</span>
            <span class="text-sm text-gray-600">{{ Math.round((currentStep / 3) * 100) }}% complété</span>
          </div>
          <div class="w-full bg-gray-200 rounded-full h-3">
            <div 
              class="bg-primary-500 h-3 rounded-full transition-all duration-500"
              :style="{ width: `${(currentStep / 3) * 100}%` }"
            ></div>
          </div>
        </div>
      </div>
    </div>

    <!-- Formulaire -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <form @submit.prevent="handleSubmit">
            <!-- Step 1: Type de projet -->
            <div v-show="currentStep === 1" class="card animate-fadeInUp">
              <h2 class="text-3xl font-display font-bold mb-2">Quel est votre projet ?</h2>
              <p class="text-gray-600 mb-8">Sélectionnez le type de rénovation que vous souhaitez réaliser</p>

              <div class="grid md:grid-cols-2 gap-4">
                <label 
                  v-for="type in projectTypes" 
                  :key="type.value"
                  class="relative cursor-pointer"
                >
                  <input 
                    type="radio" 
                    v-model="form.projectType" 
                    :value="type.value"
                    class="peer sr-only"
                  />
                  <div class="card p-6 border-2 border-gray-200 peer-checked:border-primary-500 peer-checked:bg-primary-50 hover:border-primary-300 transition-all">
                    <div class="flex items-start space-x-4">
                      <div class="text-4xl">{{ type.icon }}</div>
                      <div class="flex-1">
                        <h3 class="font-bold text-lg mb-1">{{ type.label }}</h3>
                        <p class="text-sm text-gray-600">{{ type.description }}</p>
                      </div>
                      <div class="peer-checked:block hidden">
                        <svg class="w-6 h-6 text-primary-600" fill="currentColor" viewBox="0 0 20 20">
                          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                        </svg>
                      </div>
                    </div>
                  </div>
                </label>
              </div>

              <div class="mt-8">
                <label class="block text-sm font-semibold text-gray-700 mb-2">
                  Décrivez brièvement votre projet
                </label>
                <textarea 
                  v-model="form.projectDescription"
                  rows="4"
                  class="textarea-field"
                  placeholder="Ex: Je souhaite rénover ma cuisine de 15m² avec changement des meubles, électroménager et peinture..."
                ></textarea>
              </div>

              <div class="flex justify-end mt-8">
                <button 
                  type="button"
                  @click="nextStep"
                  :disabled="!form.projectType"
                  class="btn btn-primary"
                  :class="{ 'opacity-50 cursor-not-allowed': !form.projectType }"
                >
                  Continuer
                  <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Step 2: Détails et budget -->
            <div v-show="currentStep === 2" class="card animate-fadeInUp">
              <h2 class="text-3xl font-display font-bold mb-2">Détails du projet</h2>
              <p class="text-gray-600 mb-8">Aidez-nous à mieux comprendre vos besoins</p>

              <div class="space-y-6">
                <div class="grid md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                      Surface approximative (m²)
                    </label>
                    <input 
                      v-model.number="form.surface"
                      type="number"
                      min="1"
                      class="input-field"
                      placeholder="Ex: 20"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                      Délai souhaité
                    </label>
                    <select v-model="form.deadline" class="input-field">
                      <option value="">Sélectionnez un délai</option>
                      <option value="urgent">Urgent (< 1 mois)</option>
                      <option value="court">Court terme (1-3 mois)</option>
                      <option value="moyen">Moyen terme (3-6 mois)</option>
                      <option value="flexible">Flexible</option>
                    </select>
                  </div>
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Budget estimé
                  </label>
                  <select v-model="form.budget" class="input-field">
                    <option value="">Sélectionnez une fourchette</option>
                    <option value="0-5000">Moins de 5 000€</option>
                    <option value="5000-10000">5 000€ - 10 000€</option>
                    <option value="10000-20000">10 000€ - 20 000€</option>
                    <option value="20000-50000">20 000€ - 50 000€</option>
                    <option value="50000+">Plus de 50 000€</option>
                    <option value="unknown">Je ne sais pas encore</option>
                  </select>
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-3">
                    Services souhaités (plusieurs choix possibles)
                  </label>
                  <div class="grid md:grid-cols-2 gap-3">
                    <label 
                      v-for="service in services"
                      :key="service.value"
                      class="flex items-center space-x-3 p-3 border-2 border-gray-200 rounded-lg hover:border-primary-300 cursor-pointer transition-colors"
                      :class="{ 'border-primary-500 bg-primary-50': form.services.includes(service.value) }"
                    >
                      <input 
                        type="checkbox" 
                        v-model="form.services"
                        :value="service.value"
                        class="w-5 h-5 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                      />
                      <span>{{ service.label }}</span>
                    </label>
                  </div>
                </div>

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Adresse du chantier
                  </label>
                  <input 
                    v-model="form.address"
                    type="text"
                    class="input-field"
                    placeholder="Ville ou code postal"
                  />
                  <p class="text-sm text-gray-500 mt-1">Zone d'intervention principale : Île-de-France</p>
                </div>
              </div>

              <div class="flex justify-between mt-8">
                <button 
                  type="button"
                  @click="prevStep"
                  class="btn btn-outline"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 17l-5-5m0 0l5-5m-5 5h12" />
                  </svg>
                  Retour
                </button>
                <button 
                  type="button"
                  @click="nextStep"
                  class="btn btn-primary"
                >
                  Continuer
                  <svg class="w-5 h-5 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7l5 5m0 0l-5 5m5-5H6" />
                  </svg>
                </button>
              </div>
            </div>

            <!-- Step 3: Coordonnées -->
            <div v-show="currentStep === 3" class="card animate-fadeInUp">
              <h2 class="text-3xl font-display font-bold mb-2">Vos coordonnées</h2>
              <p class="text-gray-600 mb-8">Pour vous envoyer votre devis personnalisé</p>

              <div class="space-y-6">
                <div class="grid md:grid-cols-2 gap-6">
                  <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                      Prénom *
                    </label>
                    <input 
                      v-model="form.firstName"
                      type="text"
                      required
                      class="input-field"
                      placeholder="Jean"
                    />
                  </div>

                  <div>
                    <label class="block text-sm font-semibold text-gray-700 mb-2">
                      Nom *
                    </label>
                    <input 
                      v-model="form.lastName"
                      type="text"
                      required
                      class="input-field"
                      placeholder="Dupont"
                    />
                  </div>
                </div>

                <div class="grid md:grid-cols-2 gap-6">
                  <div>
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

                <div>
                  <label class="block text-sm font-semibold text-gray-700 mb-2">
                    Meilleur moment pour vous contacter
                  </label>
                  <select v-model="form.preferredContact" class="input-field">
                    <option value="">Sélectionnez une plage horaire</option>
                    <option value="matin">Matin (8h-12h)</option>
                    <option value="apres-midi">Après-midi (14h-18h)</option>
                    <option value="soir">Soir (18h-20h)</option>
                    <option value="flexible">Flexible</option>
                  </select>
                </div>

                <div class="bg-primary-50 border-l-4 border-primary-500 p-4 rounded-r-lg">
                  <div class="flex items-start">
                    <svg class="w-6 h-6 text-primary-600 mr-3 mt-1 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    <div>
                      <p class="font-semibold text-gray-900 mb-1">Votre devis personnalisé</p>
                      <p class="text-sm text-gray-700">
                        Nous vous enverrons un devis détaillé sous 24h. Nos équipes prendront également contact avec vous pour affiner votre projet si nécessaire.
                      </p>
                    </div>
                  </div>
                </div>

                <div>
                  <label class="flex items-start">
                    <input 
                      v-model="form.consent"
                      type="checkbox"
                      required
                      class="mt-1 mr-3 w-5 h-5 text-primary-600 border-gray-300 rounded focus:ring-primary-500"
                    />
                    <span class="text-sm text-gray-600">
                      J'accepte que mes données personnelles soient utilisées pour traiter ma demande de devis et être recontacté par Pro Renovation. *
                    </span>
                  </label>
                </div>
              </div>

              <div class="flex justify-between mt-8">
                <button 
                  type="button"
                  @click="prevStep"
                  class="btn btn-outline"
                >
                  <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 17l-5-5m0 0l5-5m-5 5h12" />
                  </svg>
                  Retour
                </button>
                <button 
                  type="submit"
                  class="btn btn-primary text-lg px-8"
                  :disabled="isSubmitting || !form.consent"
                  :class="{ 'opacity-50 cursor-not-allowed': isSubmitting || !form.consent }"
                >
                  <span v-if="!isSubmitting">
                    <svg class="w-6 h-6 inline mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                    Envoyer ma demande
                  </span>
                  <span v-else class="flex items-center">
                    <svg class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    Envoi en cours...
                  </span>
                </button>
              </div>
            </div>

            <!-- Success message -->
            <div v-if="submitSuccess" class="card text-center animate-fadeInUp">
              <div class="w-20 h-20 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
                </svg>
              </div>
              <h2 class="text-3xl font-display font-bold mb-4 text-green-600">Demande envoyée !</h2>
              <p class="text-lg text-gray-700 mb-6">
                Merci pour votre confiance. Nous avons bien reçu votre demande de devis.
              </p>
              <p class="text-gray-600 mb-8">
                Notre équipe va l'étudier et vous recontactera sous <strong>24 heures</strong> avec une proposition personnalisée.
              </p>
              <router-link to="/" class="btn btn-primary">
                Retour à l'accueil
              </router-link>
            </div>
          </form>
        </div>
      </div>
    </section>

    <!-- Garanties -->
    <section v-if="!submitSuccess" class="py-16 bg-white">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <div class="grid md:grid-cols-3 gap-8 text-center">
            <div>
              <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 class="font-bold mb-2">Réponse rapide</h3>
              <p class="text-sm text-gray-600">Devis sous 24h</p>
            </div>

            <div>
              <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 class="font-bold mb-2">Sans engagement</h3>
              <p class="text-sm text-gray-600">Devis gratuit et sans obligation</p>
            </div>

            <div>
              <div class="w-16 h-16 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <svg class="w-8 h-8 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z" />
                </svg>
              </div>
              <h3 class="font-bold mb-2">Données sécurisées</h3>
              <p class="text-sm text-gray-600">Vos informations sont protégées</p>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive } from 'vue'

const currentStep = ref(1)
const isSubmitting = ref(false)
const submitSuccess = ref(false)

const projectTypes = [
  { value: 'cuisine', label: 'Cuisine', icon: '🍳', description: 'Rénovation complète ou partielle' },
  { value: 'salle-de-bain', label: 'Salle de bain', icon: '🚿', description: 'Douche, baignoire, sanitaires' },
  { value: 'amenagement', label: 'Aménagement', icon: '🏠', description: 'Cloisons, peinture, sols' },
  { value: 'complete', label: 'Rénovation complète', icon: '🔨', description: 'Projet global multi-pièces' },
  { value: 'exterieur', label: 'Extérieur', icon: '🏡', description: 'Façade, terrasse, jardin' },
  { value: 'autre', label: 'Autre projet', icon: '💡', description: 'Projet personnalisé' }
]

const services = [
  { value: 'peinture', label: 'Peinture' },
  { value: 'carrelage', label: 'Carrelage' },
  { value: 'electricite', label: 'Électricité' },
  { value: 'plomberie', label: 'Plomberie' },
  { value: 'menuiserie', label: 'Menuiserie' },
  { value: 'parquet', label: 'Parquet' }
]

const form = reactive({
  projectType: '',
  projectDescription: '',
  surface: null,
  deadline: '',
  budget: '',
  services: [] as string[],
  address: '',
  firstName: '',
  lastName: '',
  email: '',
  phone: '',
  preferredContact: '',
  consent: false
})

const nextStep = () => {
  if (currentStep.value < 3) {
    currentStep.value++
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

const prevStep = () => {
  if (currentStep.value > 1) {
    currentStep.value--
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

const handleSubmit = () => {
  isSubmitting.value = true
  
  setTimeout(() => {
    isSubmitting.value = false
    submitSuccess.value = true
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }, 1500)
}
</script>
