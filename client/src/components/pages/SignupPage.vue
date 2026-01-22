<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Button from '@/components/ui/Button.vue'
import Input from '@/components/ui/Input.vue'

const router = useRouter()
const authStore = useAuthStore()

const name = ref('')
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
    await authStore.signup({
      name: name.value,
      email: email.value,
      password: password.value,
    })
    router.push('/')
  } catch (err) {
    error.value = err instanceof Error ? err.message : 'Signup failed'
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
          Create your account
        </h1>
        <p class="mt-2 text-sm text-gray-600 dark:text-gray-400">
          Start building your product with Linear Clone
        </p>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleSubmit" class="space-y-4">
        <div v-if="error" class="p-3 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg text-sm text-red-600 dark:text-red-400">
          {{ error }}
        </div>

        <div>
          <label for="name" class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
            Full name
          </label>
          <Input
            id="name"
            v-model="name"
            type="text"
            placeholder="John Doe"
            required
            autocomplete="name"
          />
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
            minlength="8"
            autocomplete="new-password"
          />
          <p class="mt-1 text-xs text-gray-500">Minimum 8 characters</p>
        </div>

        <Button type="submit" :loading="loading" class="w-full">
          Create account
        </Button>
      </form>

      <!-- Footer -->
      <p class="mt-6 text-center text-sm text-gray-600 dark:text-gray-400">
        Already have an account?
        <router-link to="/login" class="font-medium text-violet-600 dark:text-violet-400 hover:underline">
          Sign in
        </router-link>
      </p>
    </div>
  </div>
</template>
