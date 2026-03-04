<template>
  <div class="realisations-page pt-24">
    <!-- Hero -->
    <section class="bg-gradient-to-br from-primary-500 to-yellow-400 py-20 text-black">
      <div class="container mx-auto px-4 text-center">
        <h1 class="text-5xl md:text-6xl font-display font-bold mb-6">
          Nos Réalisations
        </h1>
        <p class="text-xl max-w-3xl mx-auto">
          Découvrez quelques-uns de nos projets réussis et laissez-vous inspirer pour votre future rénovation
        </p>
      </div>
    </section>

    <!-- Filtres -->
    <section class="py-8 bg-white sticky top-20 z-40 shadow-sm">
      <div class="container mx-auto px-4">
        <div class="flex flex-wrap justify-center gap-3">
          <button 
            v-for="category in categories"
            :key="category.value"
            @click="selectedCategory = category.value"
            class="px-6 py-2 rounded-full font-semibold transition-all duration-300"
            :class="selectedCategory === category.value 
              ? 'bg-primary-500 text-black' 
              : 'bg-gray-100 text-gray-700 hover:bg-gray-200'"
          >
            {{ category.label }}
          </button>
        </div>
      </div>
    </section>

    <!-- Galerie de réalisations -->
    <section class="py-16 bg-gray-50">
      <div class="container mx-auto px-4">
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          <div 
            v-for="(project, index) in filteredProjects" 
            :key="index"
            class="group relative overflow-hidden rounded-xl aspect-square bg-gray-200 cursor-pointer"
            @click="openModal(project)"
          >
            <img 
              :src="project.image"
              :alt="project.title" 
              class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
            />
            <div class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/40 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex flex-col justify-end p-6">
              <h3 class="text-white text-2xl font-bold mb-2">{{ project.title }}</h3>
              <p class="text-white/90 text-sm mb-3">{{ project.description }}</p>
              <div class="flex items-center space-x-2">
                <span class="text-xs bg-primary-500 text-black px-3 py-1 rounded-full font-semibold">
                  {{ project.category }}
                </span>
                <span class="text-xs bg-white/20 text-white px-3 py-1 rounded-full">
                  {{ project.duration }}
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Témoignages -->
    <section class="py-20 bg-white">
      <div class="container mx-auto px-4">
        <h2 class="text-4xl font-display font-bold text-center mb-12">
          Ce que disent nos clients
        </h2>
        <div class="grid md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          <div class="card">
            <div class="flex items-center mb-4">
              <div class="flex text-primary-500 text-xl">
                ★★★★★
              </div>
            </div>
            <p class="text-gray-700 mb-4 italic">
              "Équipe très professionnelle et à l'écoute. Notre cuisine a été transformée en seulement 3 semaines. Le résultat dépasse nos attentes !"
            </p>
            <div class="flex items-center">
              <div class="w-12 h-12 bg-primary-100 rounded-full flex items-center justify-center font-bold text-primary-600 mr-3">
                MR
              </div>
              <div>
                <p class="font-semibold">Marie R.</p>
                <p class="text-sm text-gray-500">Paris 15ème</p>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="flex items-center mb-4">
              <div class="flex text-primary-500 text-xl">
                ★★★★★
              </div>
            </div>
            <p class="text-gray-700 mb-4 italic">
              "Rénovation complète de notre salle de bain. Travaux propres, dans les délais et le budget annoncé. Je recommande vivement !"
            </p>
            <div class="flex items-center">
              <div class="w-12 h-12 bg-primary-100 rounded-full flex items-center justify-center font-bold text-primary-600 mr-3">
                PD
              </div>
              <div>
                <p class="font-semibold">Pierre D.</p>
                <p class="text-sm text-gray-500">Vincennes</p>
              </div>
            </div>
          </div>

          <div class="card">
            <div class="flex items-center mb-4">
              <div class="flex text-primary-500 text-xl">
                ★★★★★
              </div>
            </div>
            <p class="text-gray-700 mb-4 italic">
              "Excellent travail sur l'aménagement de notre appartement. Finitions parfaites et conseils précieux tout au long du projet."
            </p>
            <div class="flex items-center">
              <div class="w-12 h-12 bg-primary-100 rounded-full flex items-center justify-center font-bold text-primary-600 mr-3">
                SL
              </div>
              <div>
                <p class="font-semibold">Sophie L.</p>
                <p class="text-sm text-gray-500">Montreuil</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-20 bg-gray-900 text-white">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-4xl md:text-5xl font-display font-bold mb-6">
          Prêt à démarrer votre projet ?
        </h2>
        <p class="text-xl text-gray-300 mb-8 max-w-2xl mx-auto">
          Rejoignez nos clients satisfaits et transformez votre espace
        </p>
        <router-link to="/devis" class="btn btn-secondary text-lg px-8 py-4">
          Demander un devis gratuit
        </router-link>
      </div>
      <div class="border-t border-gray-800 mt-40 pt-8"></div>
    </section>

    <!-- Modal (optionnel pour voir les détails) -->
    <teleport to="body">
      <div 
        v-if="selectedProject"
        class="fixed inset-0 bg-black/80 z-50 flex items-center justify-center p-4"
        @click="closeModal"
      >
        <div 
          class="bg-white rounded-2xl max-w-4xl w-full max-h-[90vh] overflow-auto"
          @click.stop
        >
          <div class="relative">
            <img 
              :src="selectedProject.image"
              :alt="selectedProject.title" 
              class="w-full h-96 object-cover rounded-t-2xl"
            />
            <button 
              @click="closeModal"
              class="absolute top-4 right-4 w-10 h-10 bg-black/50 hover:bg-black/70 rounded-full flex items-center justify-center text-white transition-colors"
            >
              <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>
          </div>
          <div class="p-8">
            <div class="flex items-center space-x-3 mb-4">
              <span class="text-sm bg-primary-500 text-black px-4 py-1 rounded-full font-semibold">
                {{ selectedProject.category }}
              </span>
              <span class="text-sm text-gray-600">{{ selectedProject.duration }}</span>
            </div>
            <h3 class="text-3xl font-display font-bold mb-4">{{ selectedProject.title }}</h3>
            <p class="text-lg text-gray-700 mb-6">{{ selectedProject.description }}</p>
            <div class="border-t pt-6">
              <h4 class="font-bold mb-3">Détails du projet :</h4>
              <ul class="space-y-2 text-gray-700">
                <li class="flex items-start">
                  <svg class="w-5 h-5 text-primary-500 mr-2 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  Durée : {{ selectedProject.duration }}
                </li>
                <li class="flex items-start">
                  <svg class="w-5 h-5 text-primary-500 mr-2 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  Type : {{ selectedProject.category }}
                </li>
                <li class="flex items-start">
                  <svg class="w-5 h-5 text-primary-500 mr-2 mt-0.5" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  Satisfaction client : ★★★★★
                </li>
              </ul>
            </div>
          </div>
        </div>
    
      </div>
    </teleport>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

const selectedCategory = ref('tous')
const selectedProject = ref<any>(null)

const categories = [
  { value: 'tous', label: 'Tous les projets' },
  { value: 'Cuisine', label: 'Cuisine' },
  { value: 'Salle de bain', label: 'Salle de bain' },
  { value: 'Aménagement', label: 'Aménagement' },
  { value: 'Rénovation complète', label: 'Rénovation complète' }
]

const projects = [
  {
    title: 'Cuisine moderne',
    description: 'Rénovation complète avec îlot central',
    category: 'Cuisine',
    duration: '3 semaines',
    image: 'https://plus.unsplash.com/premium_photo-1671269942050-df7e96b3e4ac?q=80&w=1025&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=800'
  },
  {
    title: 'Salle de bain zen',
    description: 'Douche à l\'italienne et double vasque',
    category: 'Salle de bain',
    duration: '2 semaines',
    image: 'https://images.unsplash.com/photo-1620626011761-996317b8d101?w=800'
  },
  {
    title: 'Salon lumineux',
    description: 'Peinture, parquet et cloisons',
    category: 'Aménagement',
    duration: '1 semaine',
    image: 'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800'
  },
  {
    title: 'Appartement parisien',
    description: 'Rénovation totale 3 pièces',
    category: 'Rénovation complète',
    duration: '6 semaines',
    image: 'https://images.unsplash.com/photo-1515263487990-61b07816b324?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=800'
  },
  {
    title: 'Cuisine ouverte',
    description: 'Ouverture sur salon et aménagement',
    category: 'Cuisine',
    duration: '4 semaines',
    image: 'https://images.unsplash.com/photo-1484154218962-a197022b5858?q=80&w=1174&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=800'
  },
  {
    title: 'Salle de bain familiale',
    description: 'Baignoire et meuble sur mesure',
    category: 'Salle de bain',
    duration: '2 semaines',
    image: 'https://images.unsplash.com/photo-1631889993959-41b4e9c6e3c5?q=80&w=774&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=800'
  },
  {
    title: 'Chambre parentale',
    description: 'Peinture, dressing et parquet',
    category: 'Aménagement',
    duration: '1 semaine',
    image: 'https://images.unsplash.com/photo-1595526051245-4506e0005bd0?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=800'
  },
  {
    title: 'Studio rénové',
    description: 'Rénovation complète studio 25m²',
    category: 'Rénovation complète',
    duration: '4 semaines',
    image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?w=800'
  },
  {
    title: 'Cuisine',
    description: 'Design épuré et fonctionnel',
    category: 'Cuisine',
    duration: '3 semaines',
    image: 'https://plus.unsplash.com/premium_photo-1676321688609-bb955a90c8c5?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=800'
  }
]

const filteredProjects = computed(() => {
  if (selectedCategory.value === 'tous') {
    return projects
  }
  return projects.filter(p => p.category === selectedCategory.value)
})

const openModal = (project: any) => {
  selectedProject.value = project
  document.body.style.overflow = 'hidden'
}

const closeModal = () => {
  selectedProject.value = null
  document.body.style.overflow = ''
}
</script>
