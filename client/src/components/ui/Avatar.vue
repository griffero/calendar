<script setup lang="ts">
import { computed } from 'vue'
import { cn } from '@/utils/cn'

interface Props {
  src?: string | null
  name?: string
  size?: 'xs' | 'sm' | 'md' | 'lg' | 'xl'
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  size: 'md'
})

const sizes = {
  xs: 'h-5 w-5 text-2xs',
  sm: 'h-6 w-6 text-xs',
  md: 'h-8 w-8 text-sm',
  lg: 'h-10 w-10 text-base',
  xl: 'h-12 w-12 text-lg'
}

const avatarClass = computed(() =>
  cn(
    'inline-flex items-center justify-center rounded-full font-medium',
    'bg-gray-200 dark:bg-gray-700 text-gray-600 dark:text-gray-300',
    sizes[props.size],
    props.class
  )
)

const initials = computed(() => {
  if (!props.name) return '?'
  return props.name
    .split(' ')
    .map(n => n[0])
    .slice(0, 2)
    .join('')
    .toUpperCase()
})

// Generate consistent color from name
const bgColor = computed(() => {
  if (!props.name) return undefined
  const colors = [
    'bg-red-500', 'bg-orange-500', 'bg-amber-500', 'bg-yellow-500',
    'bg-lime-500', 'bg-green-500', 'bg-emerald-500', 'bg-teal-500',
    'bg-cyan-500', 'bg-sky-500', 'bg-blue-500', 'bg-indigo-500',
    'bg-violet-500', 'bg-purple-500', 'bg-fuchsia-500', 'bg-pink-500'
  ]
  let hash = 0
  for (let i = 0; i < props.name.length; i++) {
    hash = props.name.charCodeAt(i) + ((hash << 5) - hash)
  }
  return colors[Math.abs(hash) % colors.length]
})
</script>

<template>
  <div :class="avatarClass">
    <img
      v-if="src"
      :src="src"
      :alt="name"
      class="h-full w-full rounded-full object-cover"
    />
    <span
      v-else
      :class="[bgColor, 'h-full w-full rounded-full flex items-center justify-center text-white']"
    >
      {{ initials }}
    </span>
  </div>
</template>
