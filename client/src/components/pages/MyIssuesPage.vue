<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { cn } from '@/utils/cn'
import Button from '@/components/ui/Button.vue'
import { User, Filter, LayoutList, Columns3 } from 'lucide-vue-next'

const authStore = useAuthStore()
const user = computed(() => authStore.user)

// Placeholder issues
const issues = ref<unknown[]>([])
const loading = ref(false)

const hasIssues = computed(() => issues.value.length > 0)

const tabs = [
  { id: 'assigned', name: 'Assigned to me', active: true },
  { id: 'created', name: 'Created by me', active: false },
  { id: 'subscribed', name: 'Subscribed', active: false },
]
const activeTab = ref('assigned')
const viewMode = ref<'list' | 'board'>('list')
</script>

<template>
  <div class="h-full flex flex-col">
    <!-- Header -->
    <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200 dark:border-gray-800">
      <div class="flex items-center gap-4">
        <h1 class="text-lg font-semibold text-gray-900 dark:text-gray-100">My Issues</h1>
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
        <div class="flex items-center gap-0.5 p-0.5 bg-gray-100 dark:bg-gray-800 rounded-md">
          <button
            @click="viewMode = 'list'"
            :class="cn(
              'p-1.5 rounded',
              viewMode === 'list'
                ? 'bg-white dark:bg-gray-700 shadow-sm'
                : 'hover:bg-gray-200 dark:hover:bg-gray-700'
            )"
          >
            <LayoutList class="h-4 w-4 text-gray-600 dark:text-gray-300" />
          </button>
          <button
            @click="viewMode = 'board'"
            :class="cn(
              'p-1.5 rounded',
              viewMode === 'board'
                ? 'bg-white dark:bg-gray-700 shadow-sm'
                : 'hover:bg-gray-200 dark:hover:bg-gray-700'
            )"
          >
            <Columns3 class="h-4 w-4 text-gray-600 dark:text-gray-300" />
          </button>
        </div>
        <Button variant="ghost" size="sm">
          <Filter class="h-4 w-4" />
          Filter
        </Button>
      </div>
    </div>

    <!-- Content -->
    <div class="flex-1 overflow-auto">
      <div v-if="loading" class="flex items-center justify-center py-16">
        <div class="animate-spin rounded-full h-8 w-8 border-2 border-primary-600 border-t-transparent"></div>
      </div>

      <div v-else-if="!hasIssues" class="flex flex-col items-center justify-center py-16">
        <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
          <User class="h-8 w-8 text-gray-400" />
        </div>
        <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">
          No issues yet
        </h3>
        <p class="text-sm text-gray-500 text-center max-w-sm">
          Issues assigned to you will appear here.
          Get started by creating or being assigned an issue.
        </p>
      </div>

      <div v-else>
        <!-- Issue list/board will go here -->
      </div>
    </div>
  </div>
</template>
