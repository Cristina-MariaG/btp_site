<template>
  <div class="about-page pt-24 pb-20">
    <!-- Hero -->
    <section class="bg-gradient-to-br from-gray-900 to-gray-800 text-white py-20">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto text-center">
          <h1 class="text-5xl md:text-6xl font-display font-bold mb-6">
            Qui sommes-nous ?
          </h1>
          <p class="text-xl text-gray-300">
            Plus de 20 ans d'expertise au service de votre habitat
          </p>
        </div>
      </div>
    </section>

    <!-- Notre histoire -->
    <section class="py-20 bg-white">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <div class="grid md:grid-cols-2 gap-12 items-center mb-16">
            <div>
              <h2 class="text-4xl font-display font-bold mb-6">Notre histoire</h2>
              <p class="text-lg text-gray-700 leading-relaxed mb-4">
                Pro Renovation bénéficie d'une équipe possédant plus de <strong>20 ans d'expérience</strong> dans le domaine de la rénovation intérieure et extérieure.
              </p>
              <p class="text-lg text-gray-700 leading-relaxed mb-4">
                Nous sommes spécialisés dans des travaux de qualité, réalisés avec soin et professionnalisme. Notre passion pour la rénovation et notre engagement envers l'excellence nous ont permis de construire une réputation solide auprès de nos clients.
              </p>
            </div>
            <div>
              <img 
                src="https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=800" 
                alt="Équipe Pro Renovation" 
                class="rounded-2xl shadow-2xl"
              />
            </div>
          </div>

          <div class="bg-primary-50 border-l-4 border-primary-500 p-8 rounded-r-2xl mb-12">
            <p class="text-lg text-gray-800 font-medium leading-relaxed">
              Nous intervenons principalement en <strong>Île-de-France</strong>, mais aussi <strong>au-delà de la région, sur demande</strong>. Avec notre savoir-faire et notre engagement envers la qualité, nous garantissons des interventions rapides et soignées.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Nos valeurs -->
    <section class="py-20 bg-gray-50">
      <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
          <h2 class="text-4xl font-display font-bold text-center mb-4">Nos valeurs</h2>
          <p class="text-center text-gray-600 text-lg mb-16 max-w-2xl mx-auto">
            Ce qui nous guide au quotidien dans tous nos projets
          </p>

          <div class="grid md:grid-cols-3 gap-8">
            <div class="card text-center">
              <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 class="text-2xl font-bold mb-3">Qualité</h3>
              <p class="text-gray-600">
                Des travaux réalisés avec soin et professionnalisme, des finitions impeccables qui durent dans le temps.
              </p>
            </div>

            <div class="card text-center">
              <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
              </div>
              <h3 class="text-2xl font-bold mb-3">Réactivité</h3>
              <p class="text-gray-600">
                Nous garantissons des interventions rapides et respectons les délais convenus pour votre tranquillité.
              </p>
            </div>

            <div class="card text-center">
              <div class="w-20 h-20 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg class="w-10 h-10 text-primary-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                </svg>
              </div>
              <h3 class="text-2xl font-bold mb-3">Écoute</h3>
              <p class="text-gray-600">
                Votre satisfaction est notre priorité. Nous sommes à l'écoute de vos besoins et de vos envies.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Notre expertise -->
    <section class="py-20 bg-white">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto">
          <h2 class="text-4xl font-display font-bold text-center mb-12">Notre expertise</h2>
          
          <div class="space-y-6">
            <div class="flex items-start space-x-4">
              <div class="w-12 h-12 bg-primary-500 rounded-lg flex items-center justify-center flex-shrink-0">
                <span class="text-2xl font-bold text-black">20+</span>
              </div>
              <div>
                <h3 class="text-xl font-bold mb-2">Années d'expérience</h3>
                <p class="text-gray-600">
                  Plus de deux décennies de savoir-faire dans la rénovation intérieure et extérieure
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-12 h-12 bg-primary-500 rounded-lg flex items-center justify-center flex-shrink-0">
                <span class="text-2xl font-bold text-black">20+</span>
              </div>
              <div>
                <h3 class="text-xl font-bold mb-2">Métiers maîtrisés</h3>
                <p class="text-gray-600">
                  Peinture, plâtrerie, électricité, plomberie, carrelage, parquet... Une équipe polyvalente pour tous vos besoins
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-12 h-12 bg-primary-500 rounded-lg flex items-center justify-center flex-shrink-0">
                <span class="text-2xl">🏆</span>
              </div>
              <div>
                <h3 class="text-xl font-bold mb-2">Clients satisfaits</h3>
                <p class="text-gray-600">
                  Des centaines de projets réussis et des clients qui nous recommandent
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <div class="w-12 h-12 bg-primary-500 rounded-lg flex items-center justify-center flex-shrink-0">
                <span class="text-2xl">📍</span>
              </div>
              <div>
                <h3 class="text-xl font-bold mb-2">Zone d'intervention</h3>
                <p class="text-gray-600">
                  Île-de-France et régions limitrophes, déplacements possibles sur demande
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Notre engagement -->
    <section class="py-20 bg-gradient-to-br from-primary-500 to-yellow-400">
      <div class="container mx-auto px-4">
        <div class="max-w-4xl mx-auto text-center">
          <h2 class="text-4xl md:text-5xl font-display font-bold text-black mb-6">
            Notre engagement
          </h2>
          <p class="text-xl text-black/90 mb-8 leading-relaxed">
            Faites-nous confiance pour un projet réalisé avec passion et professionnalisme, et profitez d'un résultat à la hauteur de vos attentes !
          </p>
          <p class="text-2xl font-bold text-black mb-8">
            N'hésitez pas à nous contacter pour un devis gratuit et détaillé !
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center">
            <router-link to="/devis" class="btn bg-black text-white hover:bg-gray-900 text-lg px-8 py-4">
              Demander un devis
            </router-link>
            <router-link to="/contact" class="btn bg-white text-black hover:bg-gray-100 text-lg px-8 py-4">
              Nous contacter
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Pourquoi nous choisir -->
    <section class="py-20 bg-white">
      <div class="container mx-auto px-4">
        <div class="max-w-6xl mx-auto">
          <h2 class="text-4xl font-display font-bold text-center mb-16">Pourquoi nous choisir ?</h2>
          
          <div class="grid md:grid-cols-2 gap-8">
            <div class="flex items-start space-x-4">
              <svg class="w-8 h-8 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <div>
                <h3 class="text-xl font-bold mb-2">Équipe expérimentée</h3>
                <p class="text-gray-600">
                  Plus de 20 ans d'expérience dans tous les corps de métiers du bâtiment
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <svg class="w-8 h-8 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <div>
                <h3 class="text-xl font-bold mb-2">Devis gratuit et détaillé</h3>
                <p class="text-gray-600">
                  Transparence totale sur les coûts, sans surprise ni frais cachés
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <svg class="w-8 h-8 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <div>
                <h3 class="text-xl font-bold mb-2">Respect des délais</h3>
                <p class="text-gray-600">
                  Planification rigoureuse et interventions dans les temps convenus
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <svg class="w-8 h-8 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <div>
                <h3 class="text-xl font-bold mb-2">Chantiers propres</h3>
                <p class="text-gray-600">
                  Protection de votre habitat et nettoyage quotidien du chantier
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <svg class="w-8 h-8 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <div>
                <h3 class="text-xl font-bold mb-2">Garantie décennale</h3>
                <p class="text-gray-600">
                  Assurance et garanties pour votre sécurité et votre tranquillité
                </p>
              </div>
            </div>

            <div class="flex items-start space-x-4">
              <svg class="w-8 h-8 text-primary-600 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
              </svg>
              <div>
                <h3 class="text-xl font-bold mb-2">Conseils personnalisés</h3>
                <p class="text-gray-600">
                  Accompagnement et recommandations adaptés à votre projet
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
</script>
