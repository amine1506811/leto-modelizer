<template>
  <q-layout view="lHh Lpr lff">
    <default-navigation-bar v-if="showHeader" />
    <q-page-container>
      <router-view />
    </q-page-container>
    <q-footer
      v-if="showFooter"
      class="bg-primary col"
    >
      <q-toolbar class="row justify-center footer">
        <router-link
          :to="{ name: 'About' }"
          class="about-page-link text-white q-mr-md"
        >
          {{ $t('footer.about') }}
        </router-link>
        |
        <a
          :href="$sanitize(`https://github.com/ditrit/leto-modelizer/releases/tag/${version}`)"
          class="text-white q-ml-md"
          target="_blank"
        >
          {{ $t('footer.version', { version }) }}
        </a>
      </q-toolbar>
    </q-footer>
  </q-layout>
</template>

<script setup>
import {
  ref,
  computed,
} from 'vue';
import { useRoute } from 'vue-router';
import DefaultNavigationBar from 'components/DefaultNavigationBar.vue';

const route = useRoute();
const version = ref(process.env.VERSION);
const viewType = computed(() => route.params.viewType);
const showFooter = computed(() => (viewType.value !== 'text' && viewType.value !== 'draw'));
const showHeader = computed(() => route.path === '/');
</script>
