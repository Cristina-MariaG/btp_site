import { createRouter, createWebHistory } from 'vue-router'
import Home from '@/views/Home.vue'
import Contact from '@/views/Contact.vue'
import Devis from '@/views/Devis.vue'
import Services from '@/views/Services.vue'
import Realisations from '@/views/Realisations.vue'
import About from '@/views/About.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: Home
    },
    {
      path: '/contact',
      name: 'contact',
      component: Contact
    },
    {
      path: '/devis',
      name: 'devis',
      component: Devis
    },
    {
      path: '/services',
      name: 'services',
      component: Services
    },
    {
      path: '/realisations',
      name: 'realisations',
      component: Realisations
    },
    {
      path: '/a-propos',
      name: 'about',
      component: About
    }
  ],
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else if (to.hash) {
      return {
        el: to.hash,
        behavior: 'smooth'
      }
    } else {
      return { top: 0, behavior: 'smooth' }
    }
  }
})

export default router
