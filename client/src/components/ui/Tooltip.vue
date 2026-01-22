<script setup lang="ts">
import { ref, computed } from 'vue'
import { cn } from '@/utils/cn'

interface Props {
  content: string
  position?: 'top' | 'bottom' | 'left' | 'right'
  delay?: number
  class?: string
}

const props = withDefaults(defineProps<Props>(), {
  position: 'top',
  delay: 300
})

const visible = ref(false)
let timeout: ReturnType<typeof setTimeout> | null = null

const positionClasses = {
  top: 'bottom-full left-1/2 -translate-x-1/2 mb-2',
  bottom: 'top-full left-1/2 -translate-x-1/2 mt-2',
  left: 'right-full top-1/2 -translate-y-1/2 mr-2',
  right: 'left-full top-1/2 -translate-y-1/2 ml-2'
}

const tooltipClass = computed(() =>
  cn(
    'absolute z-50 px-2 py-1 text-xs font-medium rounded whitespace-nowrap',
    'bg-gray-900 dark:bg-gray-100 text-white dark:text-gray-900',
    'shadow-lg',
    positionClasses[props.position],
    props.class
  )
)

function show() {
  timeout = setTimeout(() => {
    visible.value = true
  }, props.delay)
}

function hide() {
  if (timeout) {
    clearTimeout(timeout)
    timeout = null
  }
  visible.value = false
}
</script>

<template>
  <div
    class="relative inline-flex"
    @mouseenter="show"
    @mouseleave="hide"
    @focus="show"
    @blur="hide"
  >
    <slot />
    <Transition
      enter-active-class="transition duration-100 ease-out"
      enter-from-class="opacity-0 scale-95"
      enter-to-class="opacity-100 scale-100"
      leave-active-class="transition duration-75 ease-in"
      leave-from-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-95"
    >
      <div v-if="visible" :class="tooltipClass">
        {{ content }}
      </div>
    </Transition>
  </div>
</template>
