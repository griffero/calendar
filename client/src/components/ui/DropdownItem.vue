<script setup lang="ts">
import { computed } from 'vue'
import { cn } from '@/utils/cn'

interface Props {
  disabled?: boolean
  danger?: boolean
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  disabled: false,
  danger: false
})

const emit = defineEmits<{
  (e: 'click'): void
}>()

const itemClass = computed(() =>
  cn(
    'w-full px-3 py-2 text-left text-sm flex items-center gap-2 transition-colors',
    props.disabled
      ? 'opacity-50 cursor-not-allowed'
      : 'cursor-pointer',
    props.danger
      ? 'text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-950/30'
      : 'text-gray-700 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-800',
    props.class
  )
)

function handleClick() {
  if (!props.disabled) {
    emit('click')
  }
}
</script>

<template>
  <button :class="itemClass" @click="handleClick">
    <slot />
  </button>
</template>
