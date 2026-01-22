<script setup lang="ts">
import { computed, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import Button from '@/components/ui/Button.vue'
import { Eye, Plus, Filter, Inbox } from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()

const viewId = computed(() => route.params.viewId as string)

// Placeholder view data
const view = ref<{
  id: string
  name: string
  description?: string
  filters: Record<string, unknown>
} | null>({
  id: viewId.value,
  name: 'Custom View',
  description: 'A custom filtered view of issues',
  filters: {},
})

const issues = ref<unknown[]>([])
const loading = ref(false)
</script>

<template>
  <div v-if="view" class="flex flex-col h-full">
    <!-- View header -->
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-800">
      <div class="flex items-center gap-3">
        <div class="w-8 h-8 rounded-lg bg-primary-100 dark:bg-primary-900/30 flex items-center justify-center">
          <Eye class="h-4 w-4 text-primary-600 dark:text-primary-400" />
        </div>
        <div>
          <h1 class="text-lg font-semibold text-gray-900 dark:text-gray-100">
            {{ view.name }}
          </h1>
          <p v-if="view.description" class="text-sm text-gray-500">
            {{ view.description }}
          </p>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <Button variant="ghost" size="sm">
          <Filter class="h-4 w-4" />
          Edit filters
        </Button>
        <Button size="sm">
          <Plus class="h-4 w-4" />
          Add issue
        </Button>
      </div>
    </div>

    <!-- Content -->
    <div class="flex-1 overflow-auto p-6">
      <div v-if="loading" class="flex items-center justify-center py-16">
        <div class="animate-spin rounded-full h-8 w-8 border-2 border-primary-600 border-t-transparent"></div>
      </div>

      <div v-else-if="issues.length === 0" class="flex flex-col items-center justify-center py-16">
        <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
          <Inbox class="h-8 w-8 text-gray-400" />
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">
          No issues match this view
        </h3>
        <p class="text-sm text-gray-500 text-center max-w-sm mb-4">
          Try adjusting your filters or create new issues that match this view's criteria.
        </p>
        <Button variant="ghost">
          <Filter class="h-4 w-4" />
          Edit filters
        </Button>
      </div>

      <div v-else>
        <!-- Issue list will go here -->
      </div>
    </div>
  </div>

  <div v-else class="flex items-center justify-center h-full">
    <div class="text-center">
      <p class="text-gray-500">View not found</p>
      <Button variant="ghost" class="mt-4" @click="router.push('/')">
        Go back home
      </Button>
    </div>
  </div>
</template>
