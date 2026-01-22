<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useAppStore } from '@/stores/app'
import Button from '@/components/ui/Button.vue'
import { Clock, Plus } from 'lucide-vue-next'

const route = useRoute()
const appStore = useAppStore()

const teams = computed(() => appStore.teams)
const currentTeam = computed(() => {
  const teamKey = route.params.teamKey as string
  return teams.value.find(t => t.key === teamKey)
})

// Placeholder - will be replaced with actual cycles
const cycles = computed(() => [])
</script>

<template>
  <div class="p-4">
    <div v-if="cycles.length === 0" class="flex flex-col items-center justify-center py-16">
      <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
        <Clock class="h-8 w-8 text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">
        No cycles yet
      </h3>
      <p class="text-sm text-gray-500 text-center max-w-sm mb-4">
        Cycles help you organize work into time-boxed sprints.
        Create a cycle to start planning.
      </p>
      <Button>
        <Plus class="h-4 w-4" />
        Create cycle
      </Button>
    </div>

    <div v-else>
      <!-- Cycles list will go here -->
    </div>
  </div>
</template>
