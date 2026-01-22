<script setup lang="ts">
import { watch } from 'vue'
import { RouterView } from 'vue-router'
import { useUiStore } from '@/stores/ui'
import CommandPalette from '@/components/layout/CommandPalette.vue'
import CreateIssueModal from '@/components/issues/CreateIssueModal.vue'

const uiStore = useUiStore()

// Apply dark mode class to html element
watch(
  () => uiStore.darkMode,
  (isDark) => {
    document.documentElement.classList.toggle('dark', isDark)
  },
  { immediate: true }
)
</script>

<template>
  <RouterView />
  <CommandPalette />
  <CreateIssueModal
    :open="uiStore.createIssueModalOpen"
    @close="uiStore.closeCreateIssueModal()"
    @created="uiStore.closeCreateIssueModal()"
  />
</template>
