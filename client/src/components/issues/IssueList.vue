<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { useIssuesStore, type IssueFilters } from '@/stores/issues'
import IssueListItem from './IssueListItem.vue'
import IssueFiltersComponent from './IssueFilters.vue'
import Button from '@/components/ui/Button.vue'
import { Inbox, Plus, RefreshCw } from 'lucide-vue-next'
import type { Issue } from '@/types'

const props = defineProps<{
  teamId?: string
  projectId?: string
  showFilters?: boolean
  emptyTitle?: string
  emptyDescription?: string
}>()

const emit = defineEmits<{
  (e: 'issueClick', issue: Issue): void
  (e: 'createIssue'): void
}>()

const issuesStore = useIssuesStore()

const filters = ref<IssueFilters>({
  teamId: props.teamId,
  projectId: props.projectId,
  sort: 'created_at',
  direction: 'desc'
})

const loading = computed(() => issuesStore.loading)
const issues = computed(() => issuesStore.issues)

// Fetch issues with current filters
async function fetchIssues() {
  await issuesStore.fetchIssues({
    ...filters.value,
    teamId: props.teamId,
    projectId: props.projectId
  })
}

// Watch for filter changes
watch(
  filters,
  () => fetchIssues(),
  { deep: true }
)

// Watch for team/project prop changes
watch(
  () => [props.teamId, props.projectId],
  () => {
    filters.value.teamId = props.teamId
    filters.value.projectId = props.projectId
    fetchIssues()
  }
)

onMounted(() => {
  fetchIssues()
})

function handleFilterUpdate(newFilters: IssueFilters) {
  filters.value = {
    ...newFilters,
    teamId: props.teamId,
    projectId: props.projectId
  }
}

function handleIssueClick(issue: Issue) {
  emit('issueClick', issue)
}
</script>

<template>
  <div class="h-full flex flex-col">
    <!-- Filters -->
    <div v-if="showFilters !== false" class="px-4 py-3 border-b border-gray-200 dark:border-gray-800">
      <IssueFiltersComponent
        :filters="filters"
        @update:filters="handleFilterUpdate"
      />
    </div>

    <!-- Loading -->
    <div v-if="loading" class="flex items-center justify-center py-16 flex-1">
      <div class="animate-spin rounded-full h-8 w-8 border-2 border-primary-600 border-t-transparent"></div>
    </div>

    <!-- Empty state -->
    <div v-else-if="issues.length === 0" class="flex flex-col items-center justify-center py-16 flex-1">
      <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center mb-4">
        <Inbox class="h-8 w-8 text-gray-400" />
      </div>
      <h3 class="text-lg font-medium text-gray-900 dark:text-gray-100 mb-1">
        {{ emptyTitle || 'No issues found' }}
      </h3>
      <p class="text-sm text-gray-500 text-center max-w-sm mb-4">
        {{ emptyDescription || 'Try adjusting your filters or create a new issue.' }}
      </p>
      <div class="flex items-center gap-2">
        <Button variant="ghost" @click="fetchIssues">
          <RefreshCw class="h-4 w-4" />
          Refresh
        </Button>
        <Button @click="emit('createIssue')">
          <Plus class="h-4 w-4" />
          Create issue
        </Button>
      </div>
    </div>

    <!-- Issue list -->
    <div v-else class="flex-1 overflow-auto">
      <div class="bg-white dark:bg-gray-900 border-b border-gray-200 dark:border-gray-800">
        <!-- Header row -->
        <div class="flex items-center gap-3 px-4 py-2 text-xs font-medium text-gray-500 uppercase tracking-wider border-b border-gray-100 dark:border-gray-800">
          <div class="w-4" />
          <div class="w-4">Status</div>
          <div class="w-16">ID</div>
          <div class="flex-1">Title</div>
          <div class="w-20">Labels</div>
          <div class="w-16">Due</div>
          <div class="w-6">Assignee</div>
        </div>

        <!-- Issue rows -->
        <IssueListItem
          v-for="issue in issues"
          :key="issue.id"
          :issue="issue"
          @click="handleIssueClick(issue)"
        />
      </div>
    </div>
  </div>
</template>
