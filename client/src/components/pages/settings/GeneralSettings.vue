<script setup lang="ts">
import { ref, computed } from 'vue'
import { useAuthStore } from '@/stores/auth'
import Button from '@/components/ui/Button.vue'
import Input from '@/components/ui/Input.vue'

const authStore = useAuthStore()
const isAdmin = computed(() => authStore.isAdmin)
const user = computed(() => authStore.user)

const appName = ref('Linear Clone')
const saving = ref(false)
const error = ref('')
const success = ref('')

async function handleSave() {
  if (!isAdmin.value) return
  
  saving.value = true
  error.value = ''
  success.value = ''

  try {
    // TODO: Implement settings update API
    success.value = 'Settings saved successfully'
    setTimeout(() => { success.value = '' }, 3000)
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Failed to save settings'
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="p-6 max-w-2xl">
    <h1 class="text-xl font-semibold text-gray-900 dark:text-gray-100 mb-1">
      General
    </h1>
    <p class="text-sm text-gray-500 mb-6">
      Manage your application settings and preferences
    </p>

    <form @submit.prevent="handleSave" class="space-y-6">
      <div v-if="error" class="p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-sm text-red-600 dark:text-red-400">
        {{ error }}
      </div>

      <div v-if="success" class="p-3 bg-green-50 dark:bg-green-900/20 border border-green-200 dark:border-green-800 rounded-lg text-sm text-green-600 dark:text-green-400">
        {{ success }}
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Application name
        </label>
        <Input
          v-model="appName"
          type="text"
          placeholder="Linear Clone"
          :disabled="!isAdmin"
        />
        <p class="mt-1 text-xs text-gray-500">
          This is the display name of your application
        </p>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
          Your role
        </label>
        <p class="text-sm text-gray-900 dark:text-gray-100 capitalize">
          {{ user?.role || 'Member' }}
        </p>
        <p class="mt-1 text-xs text-gray-500">
          Your role determines what actions you can perform
        </p>
      </div>

      <div class="pt-4 border-t border-gray-200 dark:border-gray-800">
        <Button type="submit" :loading="saving" :disabled="!isAdmin">
          Save changes
        </Button>
      </div>
    </form>

    <!-- Danger zone -->
    <div class="mt-12 pt-6 border-t border-gray-200 dark:border-gray-800" v-if="authStore.isOwner">
      <h2 class="text-lg font-medium text-red-600 dark:text-red-400 mb-4">
        Danger Zone
      </h2>
      <div class="p-4 bg-red-50 dark:bg-red-900/10 border border-red-200 dark:border-red-800 rounded-lg">
        <h3 class="text-sm font-medium text-red-800 dark:text-red-200 mb-1">
          Reset application
        </h3>
        <p class="text-sm text-red-600 dark:text-red-400 mb-3">
          This will delete all data. This action cannot be undone.
        </p>
        <Button variant="danger" size="sm">
          Reset application
        </Button>
      </div>
    </div>
  </div>
</template>
