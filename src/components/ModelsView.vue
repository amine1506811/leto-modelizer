<template>
  <div class="fit row justify-center">
    <div class="col-md-8">
      <div class="row items-center">
        <h4>
          {{ $t('page.models.name') }}
        </h4>
        <q-btn
          outline
          no-caps
          class="q-ml-xl"
          color="primary"
          icon="fa-solid fa-plus"
          :label="$t('actions.models.create.button.name')"
          :title="$t('actions.models.create.button.title')"
          data-cy="create-model-button"
          @click="DialogEvent.next({
            type: 'open',
            key: 'CreateModel',
          })"
        />
      </div>
      <div
        v-if="data.models?.length === 0"
        class="row text-center text-h6 text-grey empty-grid"
      >
        {{ $t('page.models.empty') }}
      </div>
      <div
        v-else
        class="q-pa-md row items-start q-gutter-md"
      >
        <model-card
          v-for="model in data.models"
          :key="`${model.plugin}/${model.name}`"
          :model="model"
          @click="onModelCardClick(model)"
        />
      </div>
      <template-grid
        class="col-md-8"
        :templates="templates"
        @add:template="openImportModelTemplateDialog"
      >
        <template #header>
          <h4>
            {{ $t('page.models.template.create') }}
          </h4>
        </template>
      </template-grid>
    </div>
  </div>
</template>

<script setup>
import {
  onMounted,
  onUnmounted,
  reactive,
  ref,
  watch,
  computed,
} from 'vue';
import { getAllModels } from 'src/composables/Project';
import { getTemplatesByType } from 'src/composables/TemplateManager';
import ModelCard from 'src/components/card/ModelCard.vue';
import DialogEvent from 'src/composables/events/DialogEvent';
import UpdateModelEvent from 'src/composables/events/ModelEvent';
import TemplateGrid from 'src/components/grid/TemplateGrid';
import { useRoute, useRouter } from 'vue-router';

const route = useRoute();
const router = useRouter();
const props = defineProps({
  projectName: {
    type: String,
    required: true,
  },
});

const data = reactive({
  models: [],
});
const templates = ref([]);
const viewType = computed(() => route.params.viewType);

let updateModelSubscription;

/**
 * Redirect to ModelizerDrawView corresponding to the given model.
 * @param {Object} model - Model to open.
 */
function onModelCardClick(model) {
  router.push({
    name: 'modelizer',
    params: {
      viewType: 'draw',
      projectName: props.projectName,
    },
    query: {
      path: `${model.plugin}/${model.name}`,
    },
  });
}

/**
 * Update models list.
 * @return {Promise<void>} Promise with nothing on success otherwise an error.
 */
async function updateModels() {
  data.models = await getAllModels(props.projectName);
}

/**
 * Open ImportModelTemplate dialog.
 * @param {Object} template - Selected project template.
 */
async function openImportModelTemplateDialog(template) {
  DialogEvent.next({
    type: 'open',
    key: 'ImportModelTemplate',
    template,
  });
}

watch(() => viewType.value, () => {
  if (viewType.value === 'models') {
    updateModels();
  }
});

onMounted(async () => {
  updateModels();
  templates.value = await getTemplatesByType('model');
  updateModelSubscription = UpdateModelEvent.subscribe(updateModels);
});

onUnmounted(() => {
  updateModelSubscription.unsubscribe();
});
</script>
