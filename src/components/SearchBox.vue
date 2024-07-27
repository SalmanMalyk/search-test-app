<script setup>
import { onMounted, ref, watch } from 'vue'
import { MagnifyingGlassIcon } from '@heroicons/vue/20/solid'
import {
  Combobox,
  ComboboxInput,
  ComboboxOptions,
  ComboboxOption,
  Dialog,
  DialogPanel,
  TransitionChild,
  TransitionRoot
} from '@headlessui/vue'
import axios from 'axios'
import _ from 'lodash'

import searchImage from '@/assets/search.png'
import CategoryFilter from '@/components/CategoryFilter.vue'

const showSearchBox = defineModel()

const items = ref([])
const query = ref('')
const category = ref(null)
const isLoading = ref(false)
const hasError = ref(false)

// methods
const fetchItems = async () => {
  const filters = {
    search: query.value,
    'no-throttling': 'true'
  }

  // send filters which have a value
  // eslint-disable-next-line no-unused-vars
  const params = Object.fromEntries(Object.entries(filters).filter(([_, value]) => value))

  isLoading.value = true
  hasError.value = false

  await axios
    .get('https://frontend-test-api.digitalcreative.cn', {
      headers: {
        'Content-Type': 'application/json'
      },
      params
    })
    .then(({ data }) => {
      items.value = data
    })
    .catch((error) => {
      hasError.value = true
      console.error(error)
    })
    .finally(() => (isLoading.value = false))
}

function onSelect(item) {
  if (item) {
    window.location = item.url
  }
}

watch(
  () => [query.value, category.value],
  _.debounce(() => {
    query.value = category.value
    fetchItems()
  }, 500)
)

onMounted(() => {
  fetchItems()
})
</script>

<template>
  <TransitionRoot :show="showSearchBox" as="template" @after-leave="query = ''" appear>
    <Dialog class="relative z-10" @close="showSearchBox = false">
      <TransitionChild
        as="template"
        enter="ease-out duration-300"
        enter-from="opacity-0"
        enter-to="opacity-100"
        leave="ease-in duration-200"
        leave-from="opacity-100"
        leave-to="opacity-0"
      >
        <div class="fixed inset-0 bg-gray-500 bg-opacity-25 transition-opacity" />
      </TransitionChild>

      <div class="fixed inset-0 z-10 w-screen overflow-y-auto p-4 sm:p-6 md:p-20">
        <TransitionChild
          as="template"
          enter="ease-out duration-300"
          enter-from="opacity-0 scale-95"
          enter-to="opacity-100 scale-100"
          leave="ease-in duration-200"
          leave-from="opacity-100 scale-100"
          leave-to="opacity-0 scale-95"
        >
          <DialogPanel
            class="mx-auto max-w-xl transform divide-y divide-gray-100 overflow-hidden rounded-xl bg-white shadow-2xl ring-1 ring-black ring-opacity-5 transition-all p-3"
          >
            <Combobox v-model="query" @update:modelValue="onSelect">
              <!-- input -->
              <div class="relative">
                <MagnifyingGlassIcon
                  class="pointer-events-none absolute left-4 top-3.5 h-5 w-5 text-gray-900"
                  aria-hidden="true"
                />
                <ComboboxInput
                  class="h-12 w-full font-semibold border-0 bg-transparent pl-11 pr-4 text-gray-900 placeholder:text-gray-700 sm:text-sm !outline-none focus:ring-2 focus:ring-indigo-500 rounded"
                  placeholder="Search technologies we use at DC"
                  @change="query = $event.target.value"
                  :value="category"
                  autocomplete="off"
                />
              </div>

              <!-- Categories -->
              <CategoryFilter v-model="category" />

              <!-- items -->
              <ComboboxOptions
                v-if="items.length > 0 && !isLoading"
                static
                class="max-h-96 transform-gpu scroll-py-3 overflow-y-auto p-3"
              >
                <ComboboxOption
                  v-for="item in items"
                  :key="item.id"
                  :value="item"
                  as="template"
                  v-slot="{ active }"
                >
                  <li
                    :class="[
                      'flex select-none rounded-xl p-3 transition-all cursor-pointer',
                      active && 'bg-gray-200 shadow rounded'
                    ]"
                  >
                    <div
                      :class="['flex h-10 w-10 flex-none items-center justify-center rounded-lg']"
                    >
                      <img :src="item.image" class="object-contain" :alt="item.title" />
                    </div>
                    <div class="ml-4 flex-auto">
                      <p :class="['text-sm font-bold', active ? 'text-gray-900' : 'text-gray-700']">
                        {{ item.title }}
                      </p>
                      <p :class="['text-sm', active ? 'text-gray-700' : 'text-gray-500']">
                        {{ item.description }}
                      </p>
                    </div>
                  </li>
                </ComboboxOption>
              </ComboboxOptions>

              <!-- searching -->
              <div class="flex justify-center items-center min-h-96" v-if="isLoading">
                <svg class="h-20 w-20" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 300 150">
                  <path
                    fill="none"
                    stroke="#6366F1"
                    stroke-width="15"
                    stroke-linecap="round"
                    stroke-dasharray="300 385"
                    stroke-dashoffset="0"
                    d="M275 75c0 31-27 50-50 50-58 0-92-100-150-100-28 0-50 22-50 50s23 50 50 50c58 0 92-100 150-100 24 0 50 19 50 50Z"
                  >
                    <animate
                      attributeName="stroke-dashoffset"
                      calcMode="spline"
                      dur="2"
                      values="685;-685"
                      keySplines="0 0 1 1"
                      repeatCount="indefinite"
                    ></animate>
                  </path>
                </svg>
              </div>

              <!-- Placeholder image -->
              <div
                class="min-h-96 flex flex-col justify-center items-center"
                v-if="items.length === 0 && !isLoading"
              >
                <img :src="searchImage" class="w-60 h-60 object-contain" />

                <p v-if="query !== ''">
                  No results found for <span class="font-semibold">"{{ query }}"</span>
                </p>
              </div>
            </Combobox>

            <!-- footer -->
            <div class="flex justify-start pt-6">
              <p class="text-gray-400 text-sm" v-if="isLoading">Searching...</p>

              <p class="text-red-400 text-sm" v-else-if="hasError">
                Something wrong happened but this is not your fault :)
              </p>

              <p class="text-gray-400 text-sm" v-else-if="items.length === 0">No results</p>

              <p class="text-gray-400 text-sm" v-else>
                Showing <span class="font-semibold">{{ items.length }}</span> results
              </p>
            </div>
          </DialogPanel>
        </TransitionChild>
      </div>
    </Dialog>
  </TransitionRoot>
</template>
