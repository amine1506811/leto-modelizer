<template>
  <q-form
    class="q-gutter-md create-file-form"
    data-cy="create-file-form"
    @submit="onSubmit"
  >
    <q-input
      v-model="fileName"
      filled
      :label="$t(`page.modelizer.fileExplorer.create.${isFolder ? 'folder' : 'file'}.input`)"
      lazy-rules
      :rules="[
        (v) => notEmpty(t, v),
        (v) => isValidFileLabel($t, v),
        (v) => isUniqueFileLabel($t, file.children, v),
      ]"
      data-cy="name-input"
    />
    <div class="flex row items-center justify-center">
      <q-btn
        icon="fa-solid fa-save"
        :label="$t('actions.default.save')"
        type="submit"
        :loading="submitting"
        color="positive"
        data-cy="submit-button"
      >
        <template #loading>
          <q-spinner-dots />
        </template>
      </q-btn>
    </div>
  </q-form>
</template>

<script setup>
import { Notify } from 'quasar';
import { useI18n } from 'vue-i18n';
import { ref } from 'vue';
import { notEmpty, isValidFileLabel, isUniqueFileLabel } from 'src/composables/QuasarFieldRule';
import { createProjectFolder, writeProjectFile } from 'src/composables/Project';
import { FileInput } from 'leto-modelizer-plugin-core';
import FileEvent from 'src/composables/events/FileEvent';

const props = defineProps({
  projectName: {
    type: String,
    required: true,
  },
  file: {
    type: Object,
    required: true,
  },
  isFolder: {
    type: Boolean,
    default: false,
  },
});

const emit = defineEmits(['file:create']);
const { t } = useI18n();
const fileName = ref('');
const submitting = ref(false);

/**
 * Emit new fileName and send positive toast.
 */
function onSubmit() {
  const parent = props.file.id === props.projectName ? '' : `${props.file.id}/`;
  const createFile = props.isFolder
    ? createProjectFolder(props.projectName, `${parent}${fileName.value}`)
    : writeProjectFile(props.projectName, new FileInput({
      path: `${parent}${fileName.value}`,
      content: ' ',
    }));
  submitting.value = true;
  const type = props.isFolder ? 'folder' : 'file';

  return createFile.then(() => {
    emit('file:create', fileName.value);
    Notify.create({
      type: 'positive',
      message: t(`actions.fileExplorer.${type}.create`),
      html: true,
    });

    FileEvent.CreateFileEvent.next({
      name: fileName.value.substring(fileName.value.lastIndexOf('/') + 1),
      isFolder: props.isFolder,
      path: `${parent}${fileName.value}`,
    });
  }).catch(() => {
    Notify.create({
      type: 'negative',
      message: t(`errors.fileExplorer.default.${type}.create`),
      html: true,
    });
  }).finally(() => {
    submitting.value = false;
  });
}
</script>

<style lang="scss">
.create-file-form {
  min-width: 400px;
}
</style>
