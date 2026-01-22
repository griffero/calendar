<script setup lang="ts">
import { computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useAppStore } from '@/stores/app'
import {
  TrendingUp,
  Users,
  FolderKanban,
  Clock,
  CheckCircle2,
  Circle,
  ArrowUpRight
} from 'lucide-vue-next'

const authStore = useAuthStore()
const appStore = useAppStore()

const teams = computed(() => appStore.teams)
const projects = computed(() => appStore.projects)

const greeting = computed(() => {
  const hour = new Date().getHours()
  if (hour < 12) return 'Good morning'
  if (hour < 18) return 'Good afternoon'
  return 'Good evening'
})

const user = computed(() => authStore.user)
</script>

<template>
  <div class="p-6 max-w-5xl mx-auto">
    <!-- Welcome section -->
    <div class="mb-8">
      <h1 class="text-2xl font-semibold text-gray-900 dark:text-gray-100">
        {{ greeting }}, {{ user?.name?.split(' ')[0] || 'there' }}
      </h1>
      <p class="mt-1 text-gray-600 dark:text-gray-400">
        Here's what's happening today
      </p>
    </div>

    <!-- Quick stats -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
      <div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 p-4">
        <div class="flex items-center gap-3">
          <div class="p-2 bg-blue-100 dark:bg-blue-900/30 rounded-lg">
            <Circle class="h-5 w-5 text-blue-600 dark:text-blue-400" />
          </div>
          <div>
            <p class="text-2xl font-semibold text-gray-900 dark:text-gray-100">0</p>
            <p class="text-sm text-gray-500">Open issues</p>
          </div>
        </div>
      </div>

      <div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 p-4">
        <div class="flex items-center gap-3">
          <div class="p-2 bg-amber-100 dark:bg-amber-900/30 rounded-lg">
            <Clock class="h-5 w-5 text-amber-600 dark:text-amber-400" />
          </div>
          <div>
            <p class="text-2xl font-semibold text-gray-900 dark:text-gray-100">0</p>
            <p class="text-sm text-gray-500">In progress</p>
          </div>
        </div>
      </div>

      <div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 p-4">
        <div class="flex items-center gap-3">
          <div class="p-2 bg-green-100 dark:bg-green-900/30 rounded-lg">
            <CheckCircle2 class="h-5 w-5 text-green-600 dark:text-green-400" />
          </div>
          <div>
            <p class="text-2xl font-semibold text-gray-900 dark:text-gray-100">0</p>
            <p class="text-sm text-gray-500">Completed this week</p>
          </div>
        </div>
      </div>

      <div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800 p-4">
        <div class="flex items-center gap-3">
          <div class="p-2 bg-purple-100 dark:bg-purple-900/30 rounded-lg">
            <TrendingUp class="h-5 w-5 text-purple-600 dark:text-purple-400" />
          </div>
          <div>
            <p class="text-2xl font-semibold text-gray-900 dark:text-gray-100">0</p>
            <p class="text-sm text-gray-500">Assigned to you</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Teams & Projects -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <!-- Teams -->
      <div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800">
        <div class="px-4 py-3 border-b border-gray-200 dark:border-gray-800 flex items-center justify-between">
          <h2 class="font-medium text-gray-900 dark:text-gray-100">Your Teams</h2>
          <router-link
            to="/settings/teams"
            class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400"
          >
            Manage
          </router-link>
        </div>
        <div v-if="teams.length === 0" class="p-8 text-center">
          <Users class="h-10 w-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
          <p class="text-gray-500 dark:text-gray-400 text-sm">No teams yet</p>
          <p class="text-gray-400 dark:text-gray-500 text-xs mt-1">Create a team to organize your work</p>
        </div>
        <div v-else class="divide-y divide-gray-100 dark:divide-gray-800">
          <router-link
            v-for="team in teams"
            :key="team.id"
            :to="`/team/${team.key}`"
            class="flex items-center gap-3 px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
          >
            <div 
              class="w-8 h-8 rounded flex items-center justify-center text-white text-sm font-bold"
              :style="{ backgroundColor: team.color || '#6b7280' }"
            >
              {{ team.key.charAt(0) }}
            </div>
            <div class="flex-1 min-w-0">
              <p class="font-medium text-gray-900 dark:text-gray-100 truncate">{{ team.name }}</p>
              <p class="text-xs text-gray-500 truncate">{{ team.key }}</p>
            </div>
            <ArrowUpRight class="h-4 w-4 text-gray-400" />
          </router-link>
        </div>
      </div>

      <!-- Projects -->
      <div class="bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800">
        <div class="px-4 py-3 border-b border-gray-200 dark:border-gray-800 flex items-center justify-between">
          <h2 class="font-medium text-gray-900 dark:text-gray-100">Projects</h2>
          <router-link
            to="/settings"
            class="text-sm text-primary-600 hover:text-primary-700 dark:text-primary-400"
          >
            Manage
          </router-link>
        </div>
        <div v-if="projects.length === 0" class="p-8 text-center">
          <FolderKanban class="h-10 w-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
          <p class="text-gray-500 dark:text-gray-400 text-sm">No projects yet</p>
          <p class="text-gray-400 dark:text-gray-500 text-xs mt-1">Create a project to track larger initiatives</p>
        </div>
        <div v-else class="divide-y divide-gray-100 dark:divide-gray-800">
          <router-link
            v-for="project in projects"
            :key="project.id"
            :to="`/project/${project.slug}`"
            class="flex items-center gap-3 px-4 py-3 hover:bg-gray-50 dark:hover:bg-gray-800/50 transition-colors"
          >
            <div 
              class="w-8 h-8 rounded flex items-center justify-center"
              :style="{ backgroundColor: project.color || '#6b7280' }"
            >
              <FolderKanban class="h-4 w-4 text-white" />
            </div>
            <div class="flex-1 min-w-0">
              <p class="font-medium text-gray-900 dark:text-gray-100 truncate">{{ project.name }}</p>
              <p class="text-xs text-gray-500 capitalize">{{ project.status?.replace('_', ' ') }}</p>
            </div>
            <ArrowUpRight class="h-4 w-4 text-gray-400" />
          </router-link>
        </div>
      </div>
    </div>

    <!-- Recent activity placeholder -->
    <div class="mt-6 bg-white dark:bg-gray-900 rounded-lg border border-gray-200 dark:border-gray-800">
      <div class="px-4 py-3 border-b border-gray-200 dark:border-gray-800">
        <h2 class="font-medium text-gray-900 dark:text-gray-100">Recent Activity</h2>
      </div>
      <div class="p-8 text-center">
        <Clock class="h-10 w-10 text-gray-300 dark:text-gray-600 mx-auto mb-3" />
        <p class="text-gray-500 dark:text-gray-400 text-sm">No recent activity</p>
        <p class="text-gray-400 dark:text-gray-500 text-xs mt-1">Activity will appear here once you start working</p>
      </div>
    </div>
  </div>
</template>
