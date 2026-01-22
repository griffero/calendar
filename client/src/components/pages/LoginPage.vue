<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Button from '@/components/ui/Button.vue'
import Input from '@/components/ui/Input.vue'

const router = useRouter()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const error = ref('')
const loading = ref(false)

onMounted(async () => {
  // Check if already logged in
  if (!authStore.initialized) {
    await authStore.fetchCurrentUser()
  }
  if (authStore.isAuthenticated) {
    router.replace('/')
  }
})

async function handleSubmit() {
  error.value = ''
  loading.value = true

  try {
    await authStore.login(email.value, password.value)
    router.push('/')
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Login failed'
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="min-h-screen bg-gray-50 dark:bg-gray-950 flex items-center justify-center px-4">
    <div class="w-full max-w-sm">
      <!-- Logo / Header -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-12 h-12 rounded-lg bg-gradient-to-br from-violet-500 to-purple-700 text-white text-xl font-bold mb-4">
          L
        </div>
        <h1 class="text-2xl font-semibold text-gray-900 dark:text-gray-100">
          Welcome back
        </h1>
        <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
          Sign in to your account to continue
        </p>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div v-if="error" class="p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-sm text-red-600 dark:text-red-400">
          {{ error }}
        </div>

        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Email
          </label>
          <Input
            id="email"
            v-model="email"
            type="email"
            placeholder="you@example.com"
            required
            autocomplete="email"
          />
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Password
          </label>
          <Input
            id="password"
            v-model="password"
            type="password"
            placeholder="••••••••"
            required
            autocomplete="current-password"
          />
        </div>

        <Button type="submit" :loading="loading" class="w-full">
          Sign in
        </Button>
      </form>

      <!-- Footer -->
      <p class="mt-6 text-center text-sm text-gray-600 dark:text-gray-400">
        Don't have an account?
        <router-link to="/signup" class="font-medium text-violet-600 dark:text-violet-400 hover:underline">
          Sign up
        </router-link>
      </p>
    </div>
  </div>
</template>
