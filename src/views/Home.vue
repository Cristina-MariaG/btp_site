<template>
  <div class="home">
    <!-- Hero Section -->
    <section
      class="relative min-h-[100vh] flex items-center justify-center overflow-hidden"
    >
      <!-- Background Image avec overlay -->
      <div class="absolute inset-0 z-0">
        <div class="absolute inset-0 bg-black/40 z-10"></div>
        <img
          src="https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=1920"
          alt="Rénovation"
          class="w-full h-full object-cover"
        />
      </div>

      <!-- Content -->
      <div class="container mx-auto px-4 relative z-20 text-center">
        <div class="max-w-4xl mx-auto space-y-6 animate-fadeInUp">
          <div
            class="inline-block bg-primary-500 text-black px-6 py-2 rounded-full font-semibold text-sm mb-4"
          >
            Donnez une nouvelle vie à votre habitat
          </div>
          <h1
            class="text-5xl md:text-7xl font-display font-bold text-white leading-tight"
          >
            Pro Renovation
          </h1>
          <p class="text-2xl md:text-3xl text-white/90 font-light">
            Rénovation intérieure & extérieure
          </p>
          <p class="text-lg md:text-xl text-white/80 max-w-2xl mx-auto">
            Un accompagnement sérieux, des finitions impeccables et le respect
            total de votre cadre de vie.
          </p>
          <div class="flex flex-col sm:flex-row gap-4 justify-center mt-8">
            <router-link
              to="/contact"
              class="btn btn-primary text-lg px-8 py-4"
            >
              Contactez-nous
            </router-link>
            <router-link
              to="/devis"
              class="btn btn-secondary text-lg px-8 py-4"
            >
              Demander un devis gratuit
            </router-link>
          </div>
        </div>
      </div>

      <!-- Scroll indicator -->
      <a
        href="#next-section"
        class="absolute bottom-8 left-1/2 transform -translate-x-1/2 z-20 animate-bounce"
      >
        <svg
          class="w-6 h-6 text-white"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M19 14l-7 7m0 0l-7-7m7 7V3"
          />
        </svg>
      </a>
    </section>

    <!-- Section Redonnez vie -->
    <section id="next-section" class="py-5 bg-white">
      <div class="container mx-auto ps-15 space-y-12">
        <!-- Section principale -->
        <div class="grid md:grid-cols-3 gap-4 items-center">
          <!-- Texte -->
          <div class="col-span-2 space-y-2 order-2 md:order-1 ps-10">
            <!-- <h2 class="section-title text-3xl md:text-4xl font-bold"> -->
            <h2 class="section-title text-center mb-12">
              Redonnez <span class="text-primary-500">vie</span> à votre maison.
            </h2>
            <p class="text-lg text-gray-600 leading-relaxed">
              Avec le temps, votre maison perd de son éclat ou ne correspond
              plus à vos envies : peinture défraîchie, agencement dépassé,
              façade prisonnière...
            </p>
            <p class="text-lg text-gray-600 leading-relaxed">
              Chez Pro Renovation, nous transformons votre intérieur comme votre
              extérieur. Nos équipes maîtrisent plus de 20 métiers
              complémentaires pour un résultat harmonieux, professionnel et
              durable.
            </p>
            <div
              class="bg-primary-50 border-l-4 border-primary-500 p-6 py-20 mt-10 rounded-r-lg"
            >
              <p class="text-gray-800 font-medium">
                Peinture intérieure et extérieure, plâtrerie, parquet,
                électricité, installation de sanitaires, carrelage, revêtement
                de sol – chaque service est réalisé avec soin pour créer
                l'espace de vos rêves.
              </p>
            </div>
          </div>

          <!-- Image -->
          <div class="col-span-1 flex justify-center order-1 md:order-2">
            <div>
              <img
                src="https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800"
                alt="Escalier rénové"
                class="rounded-2xl shadow-lg h-64 md:h-80 w-64 md:w-80 object-cover py-2"
              />
              <img
                src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800"
                alt="Salon moderne"
                class="rounded-2xl shadow-lg h-64 md:h-80 w-64 md:w-80 object-cover"
              />
            </div>
          </div>
        </div>

        <!-- Images supplémentaires -->
        <!-- <div class="flex flex-wrap justify-center gap-8">
          <img
            src="https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?w=800"
            alt="Escalier rénové"
            class="rounded-2xl shadow-lg h-64 md:h-80 w-64 md:w-80 object-cover"
          />
          <img
            src="https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800"
            alt="Salon moderne"
            class="rounded-2xl shadow-lg h-64 md:h-80 w-64 md:w-80 object-cover"
          />
        </div> -->
      </div>
    </section>

    <!-- Section À propos -->
    <section class="py-10 bg-gray-50">
      <div class="container mx-auto px-4 col-span-2 flex justify-center">
        <img
          src="https://images.unsplash.com/photo-1581858726788-75bc0f6a952d?w=800"
          alt="Rénovation intérieure"
          class="rounded-2xl shadow-2xl w-15 md:w-60 h-auto pe-2"
        />
        <div class="max-w-4xl mx-auto">
          <h2 class="section-title text-center mb-12">
            A propos de <span class="text-primary-500">nous</span>
          </h2>

          <div class="space-y-6 text-lg text-gray-700 leading-relaxed">
            <p>
              Pro Renovation bénéficie d'une équipe possédant plus de 20 ans
              d'expérience dans le domaine de la rénovation intérieure et
              extérieure. Nous sommes spécialisés dans des travaux de qualité,
              réalisés avec soin et professionnalisme.
            </p>
            <p>
              Nous intervenons principalement en Île-de-France, mais aussi
              au-delà de la région, sur demande. Avec notre savoir-faire et
              notre engagement envers la qualité, nous garantissons des
              interventions rapides et soignées.
            </p>
            <p class="font-semibold text-gray-900">
              Faites-nous confiance pour un projet réalisé avec passion et
              professionnalisme, et profitez d'un résultat à la hauteur de vos
              attentes !
            </p>
            <p class="text-primary-600 font-semibold">
              N'hésitez pas à nous contacter pour un devis gratuit et détaillé !
            </p>
          </div>

          <div class="mt-12 flex justify-center">
            <router-link to="/a-propos" class="btn btn-outline">
              En savoir plus sur nous
            </router-link>
          </div>
        </div>
      </div>
    </section>

    <!-- Section Services -->
    <section class="py-10 bg-white">
      <div class="container mx-auto px-4">
        <h2 class="section-title text-center mb-4">
          <span class="text-primary-500">Nos</span> services
        </h2>
        <p class="text-center text-gray-600 text-lg mb-12 max-w-2xl mx-auto">
          Des solutions complètes pour tous vos projets de rénovation
        </p>

        <div class="grid md:grid-cols-3 gap-8">
          <!-- Service 1: Cuisine -->
          <div class="card group hover:-translate-y-2">
            <div class="overflow-hidden rounded-lg mb-4">
              <img
                src="https://images.unsplash.com/photo-1617228069096-4638a7ffc906?q=80&w=1171&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D?w=600"
                alt="Cuisine"
                class="w-full h-64 object-cover group-hover:scale-110 transition-transform duration-500"
              />
            </div>
            <h3 class="text-2xl font-bold mb-3">Cuisine</h3>
            <ul class="space-y-2 text-gray-600">
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Aménagement et agencement
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Carrelage mural et sol
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Électricité
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Électroménager
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Peinture
              </li>
            </ul>
          </div>

          <!-- Service 2: Salle de bain -->
          <div class="card group hover:-translate-y-2">
            <div class="overflow-hidden rounded-lg mb-4">
              <img
                src="https://images.unsplash.com/photo-1620626011761-996317b8d101?w=600"
                alt="Salle de bain"
                class="w-full h-64 object-cover group-hover:scale-110 transition-transform duration-500"
              />
            </div>
            <h3 class="text-2xl font-bold mb-3">Salle de bain</h3>
            <ul class="space-y-2 text-gray-600">
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Sanitaires (douche, baignoire, WC, ...)
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Plomberie
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Carrelage
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Électricité
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Peinture
              </li>
            </ul>
          </div>

          <!-- Service 3: Travaux d'aménagement -->
          <div class="card group hover:-translate-y-2">
            <div class="overflow-hidden rounded-lg mb-4">
              <img
                src="https://images.unsplash.com/photo-1484154218962-a197022b5858?w=600"
                alt="Travaux d'aménagement"
                class="w-full h-64 object-cover group-hover:scale-110 transition-transform duration-500"
              />
            </div>
            <h3 class="text-2xl font-bold mb-3">Travaux d'aménagement</h3>
            <ul class="space-y-2 text-gray-600">
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Peinture
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Enduit
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Cloisons et cloisonnement
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Doublage
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Parquet
              </li>
              <li class="flex items-start">
                <svg
                  class="w-5 h-5 text-primary-500 mt-1 mr-2 flex-shrink-0"
                  fill="currentColor"
                  viewBox="0 0 20 20"
                >
                  <path
                    fill-rule="evenodd"
                    d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                    clip-rule="evenodd"
                  />
                </svg>
                Pose parquet
              </li>
            </ul>
          </div>
        </div>

        <div class="text-center mt-12">
          <router-link to="/services" class="btn btn-primary">
            Découvrir tous nos services
          </router-link>
        </div>
      </div>
    </section>

    <!-- Section Réalisations -->
    <section class="py-10 bg-gray-50">
      <div class="container mx-auto px-4">
        <h2 class="section-title text-center mb-12">Quelques réalisations</h2>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
          <div
            v-for="i in 6"
            :key="i"
            class="relative group overflow-hidden rounded-xl aspect-square bg-gray-200"
          >
            <img
              :src="`https://images.unsplash.com/photo-${['1600585154340-be6161a56a0c', '1600210492486-724fe5c67fb0', '1600566753086-00f18fb6b3ea', '1600607687920-4e2a09cf159d', '1600607687939-ce8a6c25118c', '1632829882891-5047ccc421bc?q=80&w=1332&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'][i - 1]}?w=600`"
              alt="Réalisation"
              class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500"
            />

            <div
              class="absolute inset-0 bg-gradient-to-t from-black/70 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300 flex items-end p-6"
            >
              <div class="text-white">
                <p class="text-2xl font-bold text-primary-500">★★★</p>
              </div>
            </div>
          </div>
        </div>

        <div class="text-center mt-12">
          <router-link to="/realisations" class="btn btn-outline">
            Voir toutes nos réalisations
          </router-link>
        </div>
      </div>
    </section>

    <!-- Section Comment ça marche -->
    <section class="py-10 bg-white">
      <div class="container mx-auto px-4">
        <h2 class="section-title text-center mb-4">
          Comment se déroule
          <span class="text-primary-500">votre</span> chantier ?
        </h2>
        <p class="text-center text-gray-600 text-lg mb-16 max-w-2xl mx-auto">
          Un processus simple et transparent pour votre tranquillité
        </p>

        <div class="grid md:grid-cols-3 gap-12">
          <div class="text-center space-y-4">
            <div
              class="w-24 h-24 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6"
            >
              <svg
                class="w-12 h-12 text-primary-600"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
                />
              </svg>
            </div>
            <h3 class="text-2xl font-bold">Contactez-nous</h3>
            <p class="text-gray-600">
              Par téléphone, email ou formulaire de contact. Nous sommes à votre
              écoute pour comprendre votre projet.
            </p>
          </div>

          <div class="text-center space-y-4">
            <div
              class="w-24 h-24 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6"
            >
              <svg
                class="w-12 h-12 text-primary-600"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                />
              </svg>
            </div>
            <h3 class="text-2xl font-bold">
              Recevez votre devis gratuit et détaillé
            </h3>
            <p class="text-gray-600">
              Après une visite sur place ou un échange détaillé, nous vous
              proposons un devis clair et personnalisé.
            </p>
          </div>

          <div class="text-center space-y-4">
            <div
              class="w-24 h-24 bg-primary-100 rounded-full flex items-center justify-center mx-auto mb-6"
            >
              <svg
                class="w-12 h-12 text-primary-600"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"
                />
              </svg>
            </div>
            <h3 class="text-2xl font-bold">Intervention rapide et soignée</h3>
            <p class="text-gray-600">
              Nos équipes interviennent rapidement avec professionnalisme pour
              transformer votre espace selon vos souhaits.
            </p>
          </div>
        </div>
      </div>
    </section>

    <!-- Section CTA finale avec Contactez-nous -->
    <section class="py-10 bg-primary-500">
      <div class="container mx-auto px-4 text-center">
        <h2 class="text-4xl md:text-5xl font-display font-bold text-black mb-6">
          Contactez-nous
        </h2>
        <p class="text-xl text-black/80 mb-12 max-w-2xl mx-auto">
          Prêt à transformer votre espace ? Notre équipe est là pour vous
          accompagner.
        </p>

        <div class="flex flex-col sm:flex-row gap-6 justify-center mb-12">
          <a
            href="tel:0749908401"
            class="btn bg-black text-white hover:bg-gray-900 text-lg px-8 py-4"
          >
            <svg
              class="w-6 h-6 mr-2"
              fill="none"
              stroke="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"
              />
            </svg>
            
          </a>
          <router-link
            to="/devis"
            class="btn bg-white text-black hover:bg-gray-100 text-lg px-8 py-4"
          >
            Demander un devis
          </router-link>
        </div>

        <p class="text-black/70">
          <a
            href="mailto:prorenovation@gmail.com"
            class="underline hover:text-black transition-colors"
          >
            prorenovation@gmail.com
          </a>
        </p>
      </div>
    </section>
  </div>
</template>

<script setup lang="ts"></script>
