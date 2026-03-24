<template>
  <header 
    class="fixed top-0 left-0 right-0 z-50 transition-all duration-300"
    :class="scrolled ? 'bg-white shadow-md' : 'bg-white/95 backdrop-blur-sm'"
  >
    <nav class="container mx-auto px-4 py-4">
      <div class="flex items-center justify-between">
        <!-- Logo -->
        <router-link to="/" class="flex items-center space-x-2">
          <div class="w-14 h-10 bg-primary-500 rounded-lg flex items-center justify-center">
            <span class="text-lg font-bold text-black">NCG</span>
          </div>
          <span class="text-xl font-bold text-black">Nova Construct General</span>
        </router-link>

        <!-- Desktop Menu -->
        <div class="hidden md:flex items-center space-x-8">
          <router-link 
            to="/" 
            class="nav-link"
            :class="{ 'active': $route.path === '/' }"
          >
            Accueil
          </router-link>
          <router-link 
            to="/services" 
            class="nav-link"
            :class="{ 'active': $route.path === '/services' }"
          >
            Services
          </router-link>
          <router-link 
            to="/realisations" 
            class="nav-link"
            :class="{ 'active': $route.path === '/realisations' }"
          >
            Réalisations
          </router-link>
          <router-link 
            to="/a-propos" 
            class="nav-link"
            :class="{ 'active': $route.path === '/a-propos' }"
          >
            Qui sommes-nous ?
          </router-link>
          <router-link 
            to="/contact" 
            class="nav-link"
            :class="{ 'active': $route.path === '/contact' }"
          >
            Contact
          </router-link>
          <router-link 
            to="/devis" 
            class="btn btn-primary"
          >
            Devis Gratuit
          </router-link>
        </div>

        <!-- Mobile Menu Button -->
        <button 
          @click="mobileMenuOpen = !mobileMenuOpen"
          class="md:hidden p-2 rounded-lg hover:bg-gray-100"
        >
          <svg 
            v-if="!mobileMenuOpen" 
            class="w-6 h-6" 
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          </svg>
          <svg 
            v-else 
            class="w-6 h-6" 
            fill="none" 
            stroke="currentColor" 
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          </svg>
        </button>
      </div>

      <!-- Mobile Menu -->
      <transition
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 -translate-y-4"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 -translate-y-4"
      >
        <div 
          v-if="mobileMenuOpen" 
          class="md:hidden mt-4 py-4 border-t border-gray-200"
        >
          <div class="flex flex-col space-y-3">
            <router-link 
              to="/" 
              class="nav-link-mobile"
              @click="mobileMenuOpen = false"
            >
              Accueil
            </router-link>
            <router-link 
              to="/services" 
              class="nav-link-mobile"
              @click="mobileMenuOpen = false"
            >
              Services
            </router-link>
            <router-link 
              to="/realisations" 
              class="nav-link-mobile"
              @click="mobileMenuOpen = false"
            >
              Réalisations
            </router-link>
            <router-link 
              to="/a-propos" 
              class="nav-link-mobile"
              @click="mobileMenuOpen = false"
            >
              Qui sommes-nous ?
            </router-link>
            <router-link 
              to="/contact" 
              class="nav-link-mobile"
              @click="mobileMenuOpen = false"
            >
              Contact
            </router-link>
            <router-link 
              to="/devis" 
              class="btn btn-primary mt-2"
              @click="mobileMenuOpen = false"
            >
              Devis Gratuit
            </router-link>
          </div>
        </div>
      </transition>
    </nav>
  </header>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const scrolled = ref(false)
const mobileMenuOpen = ref(false)

const handleScroll = () => {
  scrolled.value = window.scrollY > 20
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
.nav-link {
  @apply text-gray-700 hover:text-primary-600 font-medium transition-colors duration-200 relative;
}

.nav-link.active {
  @apply text-primary-600;
}

.nav-link.active::after {
  content: '';
  @apply absolute bottom-0 left-0 right-0 h-0.5 bg-primary-500;
}

.nav-link-mobile {
  @apply text-gray-700 hover:text-primary-600 font-medium transition-colors duration-200 py-2 px-4 rounded-lg hover:bg-gray-50;
}
</style>
