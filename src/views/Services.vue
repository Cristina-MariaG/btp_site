<template>
  <div class="services-page pt-24 ">
    <!-- Hero -->
    <section class="bg-gradient-to-br from-gray-900 to-gray-800 text-white py-20">
      <div class="container mx-auto px-4 text-center">
        <h1 class="text-5xl md:text-6xl font-display font-bold mb-6">
          Nos Services
        </h1>
        <p class="text-xl max-w-3xl mx-auto text-gray-300">
          Des prestations complètes pour tous vos projets de rénovation intérieure et extérieure
        </p>
      </div>
    </section>

    <!-- Services détaillés -->
    <section class="py-20 bg-white">
      <div class="container mx-auto px-4">
        <!-- Service 1: Cuisine -->
        <div class="mb-20">
          <div class="grid md:grid-cols-2 gap-12 items-center">
            <div class="order-2 md:order-1">
              <img 
                src="https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800" 
                alt="Cuisine moderne" 
                class="rounded-2xl shadow-2xl"
              />
            </div>
            <div class="order-1 md:order-2">
              <div class="inline-block bg-primary-500 text-black px-4 py-1 rounded-full text-sm font-semibold mb-4">
                Rénovation Cuisine
              </div>
              <h2 class="text-4xl font-display font-bold mb-6">
                Cuisine sur mesure
              </h2>
              <p class="text-lg text-gray-600 mb-6 leading-relaxed">
                Transformez votre cuisine en un espace moderne et fonctionnel. Notre équipe prend en charge l'ensemble des travaux pour créer la cuisine de vos rêves.
              </p>
              <div class="space-y-3 mb-8">
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Aménagement et agencement</p>
                    <p class="text-gray-600 text-sm">Optimisation de l'espace et ergonomie</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Carrelage mural et sol</p>
                    <p class="text-gray-600 text-sm">Pose de carrelage, faïence, crédence</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Électricité</p>
                    <p class="text-gray-600 text-sm">Installation électrique aux normes, prises, éclairage</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Plomberie et électroménager</p>
                    <p class="text-gray-600 text-sm">Raccordement eau, gaz, installation appareils</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Peinture et finitions</p>
                    <p class="text-gray-600 text-sm">Mise en peinture soignée, finitions impeccables</p>
                  </div>
                </div>
              </div>
              <router-link to="/devis" class="btn btn-primary">
                Demander un devis
              </router-link>
            </div>
          </div>
        </div>

        <!-- Service 2: Salle de bain -->
        <div class="mb-20 bg-gray-50 -mx-4 px-4 py-16 md:-mx-0 md:px-0 md:py-0 md:bg-transparent">
          <div class="grid md:grid-cols-2 gap-12 items-center">
            <div>
              <div class="inline-block bg-primary-500 text-black px-4 py-1 rounded-full text-sm font-semibold mb-4">
                Rénovation Salle de bain
              </div>
              <h2 class="text-4xl font-display font-bold mb-6">
                Salle de bain moderne
              </h2>
              <p class="text-lg text-gray-600 mb-6 leading-relaxed">
                Créez un espace de bien-être avec une salle de bain rénovée selon vos goûts : douche à l'italienne, baignoire, double vasque...
              </p>
              <div class="space-y-3 mb-8">
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Sanitaires (douche, baignoire, WC)</p>
                    <p class="text-gray-600 text-sm">Installation et remplacement</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Plomberie complète</p>
                    <p class="text-gray-600 text-sm">Évacuation, alimentation, robinetterie</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Carrelage et faïence</p>
                    <p class="text-gray-600 text-sm">Revêtements muraux et au sol</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Électricité et ventilation</p>
                    <p class="text-gray-600 text-sm">VMC, éclairage, prises étanches</p>
                  </div>
                </div>
              </div>
              <router-link to="/devis" class="btn btn-primary">
                Demander un devis
              </router-link>
            </div>
            <div>
              <img 
                src="https://images.unsplash.com/photo-1620626011761-996317b8d101?w=800" 
                alt="Salle de bain" 
                class="rounded-2xl shadow-2xl"
              />
            </div>
          </div>
        </div>

        <!-- Service 3: Travaux d'aménagement -->
        <div>
          <div class="grid md:grid-cols-2 gap-12 items-center">
            <div class="order-2 md:order-1">
              <img 
                src="https://images.unsplash.com/photo-1484154218962-a197022b5858?w=800" 
                alt="Aménagement intérieur" 
                class="rounded-2xl shadow-2xl"
              />
            </div>
            <div class="order-1 md:order-2">
              <div class="inline-block bg-primary-500 text-black px-4 py-1 rounded-full text-sm font-semibold mb-4">
                Travaux d'aménagement
              </div>
              <h2 class="text-4xl font-display font-bold mb-6">
                Aménagement intérieur
              </h2>
              <p class="text-lg text-gray-600 mb-6 leading-relaxed">
                Transformez vos espaces de vie avec nos solutions d'aménagement : peinture, cloisons, sols, isolation... pour un intérieur à votre image.
              </p>
              <div class="space-y-3 mb-8">
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Peinture intérieure</p>
                    <p class="text-gray-600 text-sm">Murs, plafonds, boiseries</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Cloisons et cloisonnement</p>
                    <p class="text-gray-600 text-sm">Création ou suppression d'espaces</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Parquet et revêtements de sol</p>
                    <p class="text-gray-600 text-sm">Pose, rénovation, vitrification</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Doublage et isolation</p>
                    <p class="text-gray-600 text-sm">Amélioration thermique et phonique</p>
                  </div>
                </div>
                <div class="flex items-start">
                  <svg class="w-6 h-6 text-primary-500 mr-3 mt-1 flex-shrink-0" fill="currentColor" viewBox="0 0 20 20">
                    <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd" />
                  </svg>
                  <div>
                    <p class="font-semibold">Enduit et plâtrerie</p>
                    <p class="text-gray-600 text-sm">Préparation et finitions parfaites</p>
                  </div>
                </div>
              </div>
              <router-link to="/devis" class="btn btn-primary">
                Demander un devis
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="py-20 bg-primary-500">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-4xl md:text-5xl font-display font-bold text-black mb-6">
          Un projet en tête ?
        </h2>
        <p class="text-xl text-black/80 mb-8 max-w-2xl mx-auto">
          Parlons-en ensemble et obtenez un devis gratuit personnalisé
        </p>
        <div class="flex flex-col sm:flex-row gap-4 justify-center">
          <router-link to="/devis" class="btn bg-black text-white hover:bg-gray-900 text-lg px-8 py-4">
            Demander un devis gratuit
          </router-link>
          <router-link to="/contact" class="btn bg-white text-black hover:bg-gray-100 text-lg px-8 py-4">
            Nous contacter
          </router-link>
        </div>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts">
</script>
