<script setup lang="ts">
import { ref, computed } from 'vue'
import { Inbox, Bell, CheckCheck, Archive } from 'lucide-vue-next'
import { cn } from '@/utils/cn'
import Button from '@/components/ui/Button.vue'

// Placeholder notifications
const notifications = ref<unknown[]>([])
const loading = ref(false)

const hasNotifications = computed(() => notifications.value.length > 0)

const tabs = [
  { id: 'all', name: 'All', active: true },
  { id: 'unread', name: 'Unread', active: false },
  { id: 'archived', name: 'Archived', active: false },
]
const activeTab = ref('all')
</script>

<template>
  <div class="h-full flex flex-col">
    <!-- Header -->
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-800">
      <div class="flex items-center gap-4">
        <h1 class="text-lg font-semibold text-gray-900 dark:text-gray-100">Inbox</h1>
        <div class="flex items-center gap-1">
          <button
            v-for="tab in tabs"
            :key="tab.id"
            @click="activeTab = tab.id"
            :class="cn(
              'px-3 py-1.5 text-sm rounded-md transition-colors',
              activeTab === tab.id
                ? 'bg-gray-100 dark:bg-gray-800 text-gray-900 dark:text-gray-100'
                : 'text-gray-500 hover:text-gray-900 dark:hover:text-gray-100'
            )"
          >
            {{ tab.name }}
          </button>
        </div>
      </div>
      <div class="flex items-center gap-2">
        <Button variant="ghost" size="sm">
          <CheckCheck class="h-4 w-4" />
          Mark all read
        </Button>
        <Button variant="ghost" size="sm">
          <Archive class="h-4 w-4" />
          Archive all
        </Button>
      </div>
    </div>

    <!-- Content -->
    <div class="flex-1 overflow-auto">
      <div v-if="loading" class="flex items-center justify-center py-16">
        <div class="animate-spin rounded-full h-8 w-8 border-2 border-primary-600 border-t-transparent"></div>
      </div>

      <div v-else-if="!hasNotifications" class="flex flex-col items-center justify-center py-16">
        <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
          <Inbox class="h-8 w-8 text-gray-400" />
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">
          All caught up!
        </h3>
        <p class="text-sm text-gray-500 text-center max-w-sm">
          You have no notifications. We'll let you know when there's something new.
        </p>
      </div>

      <div v-else class="divide-y divide-gray-200 dark:divide-gray-800">
        <!-- Notification items will go here -->
      </div>
    </div>
  </div>
</template>
