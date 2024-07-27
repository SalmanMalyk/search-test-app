<script setup>
import { ref } from 'vue'

import SearchBox from '@/components/SearchBox.vue'
import { MagnifyingGlassIcon } from '@heroicons/vue/20/solid'

const showSearchBox = ref(false)
</script>

<template>
  <div class="flex justify-center items-center h-100vh w-full mt-5">
    <button
      type="button"
      class="flex items-center justify-center gap-1 rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
      @click="showSearchBox = true"
    >
      <MagnifyingGlassIcon class="w-5 h-5" />
      Search Technologies
    </button>
  </div>

  <SearchBox v-model="showSearchBox" />
</template>
