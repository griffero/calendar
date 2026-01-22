<script setup lang="ts">
import { computed } from 'vue'
import { cn } from '@/utils/cn'

interface Props {
  variant?: 'default' | 'primary' | 'secondary' | 'success' | 'warning' | 'danger'
  size?: 'sm' | 'md'
  dot?: boolean
  color?: string
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  variant: 'default',
  size: 'md',
  dot: false
})

const variants = {
  default: 'bg-gray-100 dark:bg-gray-800 text-gray-700 dark:text-gray-300',
  primary: 'bg-primary-100 dark:bg-primary-900/30 text-primary-700 dark:text-primary-300',
  secondary: 'bg-gray-200 dark:bg-gray-700 text-gray-800 dark:text-gray-200',
  success: 'bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-300',
  warning: 'bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-300',
  danger: 'bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-300'
}

const sizes = {
  sm: 'px-1.5 py-0.5 text-2xs',
  md: 'px-2 py-0.5 text-xs'
}

const badgeClass = computed(() =>
  cn(
    'inline-flex items-center gap-1 font-medium rounded-full',
    variants[props.variant],
    sizes[props.size],
    props.class
  )
)

const dotStyle = computed(() => {
  if (props.color) {
    return { backgroundColor: props.color }
  }
  return undefined
})
</script>

<template>
  <span :class="badgeClass">
    <span
      v-if="dot"
      class="w-2 h-2 rounded-full"
      :class="{ 'bg-current': !color }"
      :style="dotStyle"
    />
    <slot />
  </span>
</template>
