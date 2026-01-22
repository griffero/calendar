import { ref, onMounted, onUnmounted, watch } from 'vue'
import { useAuthStore } from '@/stores/auth'

// ActionCable consumer type
interface CableSubscription {
  unsubscribe: () => void
  perform: (action: string, data?: Record<string, unknown>) => void
}

interface Cable {
  subscriptions: {
    create: (
      channel: string | { channel: string; [key: string]: unknown },
      callbacks: {
        connected?: () => void
        disconnected?: () => void
        received?: (data: unknown) => void
        rejected?: () => void
      }
    ) => CableSubscription
  }
  disconnect: () => void
}

declare global {
  interface Window {
    ActionCable?: {
      createConsumer: (url?: string) => Cable
    }
  }
}

let cable: Cable | null = null
const isConnected = ref(false)
const subscriptions = new Map<string, CableSubscription>()

// Get the WebSocket URL based on environment
function getWebSocketUrl(): string {
  const apiUrl = import.meta.env.VITE_API_URL
  
  if (apiUrl) {
    // Convert HTTP URL to WebSocket URL
    return apiUrl.replace(/^https?:/, (match: string) => 
      match === 'https:' ? 'wss:' : 'ws:'
    ) + '/cable'
  }
  
  // Default to same host
  const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:'
  return `${protocol}//${window.location.host}/cable`
}

// Initialize ActionCable connection
export function initActionCable(): Cable | null {
  if (cable) return cable

  // Check if ActionCable is available (loaded from Rails)
  if (!window.ActionCable) {
    console.warn('ActionCable not available. Loading from CDN...')
    loadActionCableScript()
    return null
  }

  cable = window.ActionCable.createConsumer(getWebSocketUrl())
  isConnected.value = true
  return cable
}

// Load ActionCable script dynamically
function loadActionCableScript(): Promise<void> {
  return new Promise((resolve, reject) => {
    if (window.ActionCable) {
      resolve()
      return
    }

    const script = document.createElement('script')
    script.src = 'https://cdn.jsdelivr.net/npm/@rails/actioncable@7.1.3/app/assets/javascripts/actioncable.esm.js'
    script.type = 'module'
    script.onload = () => {
      // ActionCable is now available
      import('https://cdn.jsdelivr.net/npm/@rails/actioncable@7.1.3/app/assets/javascripts/actioncable.esm.js')
        .then((module) => {
          window.ActionCable = module
          resolve()
        })
        .catch(reject)
    }
    script.onerror = reject
    document.head.appendChild(script)
  })
}

// Disconnect ActionCable
export function disconnectActionCable(): void {
  if (cable) {
    // Unsubscribe from all channels
    subscriptions.forEach((sub) => sub.unsubscribe())
    subscriptions.clear()

    cable.disconnect()
    cable = null
    isConnected.value = false
  }
}

// Subscribe to a channel
export function subscribe(
  channelName: string,
  params: Record<string, unknown> = {},
  callbacks: {
    connected?: () => void
    disconnected?: () => void
    received?: (data: unknown) => void
    rejected?: () => void
  } = {}
): CableSubscription | null {
  if (!cable) {
    initActionCable()
    if (!cable) return null
  }

  const key = JSON.stringify({ channel: channelName, ...params })

  // Check if already subscribed
  if (subscriptions.has(key)) {
    return subscriptions.get(key)!
  }

  const subscription = cable.subscriptions.create(
    { channel: channelName, ...params },
    {
      connected: () => {
        console.log(`Connected to ${channelName}`, params)
        callbacks.connected?.()
      },
      disconnected: () => {
        console.log(`Disconnected from ${channelName}`)
        callbacks.disconnected?.()
      },
      received: (data) => {
        console.log(`Received from ${channelName}:`, data)
        callbacks.received?.(data)
      },
      rejected: () => {
        console.warn(`Rejected from ${channelName}`)
        callbacks.rejected?.()
      },
    }
  )

  subscriptions.set(key, subscription)
  return subscription
}

// Unsubscribe from a channel
export function unsubscribe(channelName: string, params: Record<string, unknown> = {}): void {
  const key = JSON.stringify({ channel: channelName, ...params })
  const subscription = subscriptions.get(key)

  if (subscription) {
    subscription.unsubscribe()
    subscriptions.delete(key)
  }
}

// Composable for team channel (replaces workspace channel for single-tenant)
export function useTeamChannel(teamId: () => string | undefined) {
  const authStore = useAuthStore()

  interface TeamEvent {
    type: string
    [key: string]: unknown
  }

  const lastEvent = ref<TeamEvent | null>(null)
  let currentSubscription: CableSubscription | null = null

  function subscribeToTeam(id: string) {
    if (currentSubscription) {
      currentSubscription.unsubscribe()
    }

    currentSubscription = subscribe('TeamChannel', { team_id: id }, {
      received: (data) => {
        lastEvent.value = data as TeamEvent
      },
    })
  }

  watch(
    () => teamId(),
    (id) => {
      if (id && authStore.isAuthenticated) {
        subscribeToTeam(id)
      }
    },
    { immediate: true }
  )

  onUnmounted(() => {
    if (currentSubscription) {
      currentSubscription.unsubscribe()
    }
  })

  return {
    lastEvent,
    isConnected,
  }
}

// Composable for issue channel
export function useIssueChannel(issueId: () => string | undefined) {
  interface IssueEvent {
    type: string
    [key: string]: unknown
  }

  const lastEvent = ref<IssueEvent | null>(null)
  let currentSubscription: CableSubscription | null = null

  function subscribeToIssue(id: string) {
    if (currentSubscription) {
      currentSubscription.unsubscribe()
    }

    currentSubscription = subscribe('IssueChannel', { issue_id: id }, {
      received: (data) => {
        lastEvent.value = data as IssueEvent
      },
    })
  }

  watch(
    () => issueId(),
    (id) => {
      if (id) {
        subscribeToIssue(id)
      } else if (currentSubscription) {
        currentSubscription.unsubscribe()
        currentSubscription = null
      }
    },
    { immediate: true }
  )

  onUnmounted(() => {
    if (currentSubscription) {
      currentSubscription.unsubscribe()
    }
  })

  return {
    lastEvent,
  }
}

// Composable for notifications channel
export function useNotificationsChannel() {
  const authStore = useAuthStore()

  interface NotificationEvent {
    type: string
    notification?: unknown
    [key: string]: unknown
  }

  const lastEvent = ref<NotificationEvent | null>(null)
  let subscription: CableSubscription | null = null

  onMounted(() => {
    if (authStore.isAuthenticated) {
      subscription = subscribe('NotificationsChannel', {}, {
        received: (data) => {
          lastEvent.value = data as NotificationEvent
        },
      })
    }
  })

  watch(
    () => authStore.isAuthenticated,
    (isAuth) => {
      if (isAuth && !subscription) {
        subscription = subscribe('NotificationsChannel', {}, {
          received: (data) => {
            lastEvent.value = data as NotificationEvent
          },
        })
      } else if (!isAuth && subscription) {
        subscription.unsubscribe()
        subscription = null
      }
    }
  )

  onUnmounted(() => {
    if (subscription) {
      subscription.unsubscribe()
    }
  })

  return {
    lastEvent,
  }
}

export { isConnected }
