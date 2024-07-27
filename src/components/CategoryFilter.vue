<script setup>
import { RadioGroup, RadioGroupOption } from '@headlessui/vue'
import { XMarkIcon } from '@heroicons/vue/20/solid'
import { TagIcon } from '@heroicons/vue/24/outline'

const model = defineModel()
const memoryOptions = ['Languages', 'Design', 'Build', 'Cloud']

const clearCategory = () => {
    model.value = null;
}
</script>

<template>
  <fieldset aria-label="Choose a memory option">
    <RadioGroup v-model="model" class="mt-4 flex justify-start">
      <RadioGroupOption
        as="template"
        v-for="option in memoryOptions"
        :key="option.name"
        :value="option"
        v-slot="{ active, checked }"
      >
        <div
          :class="[
            'cursor-pointer focus:outline-none gap-2',
            checked
              ? 'bg-indigo-600 text-white hover:bg-indigo-500'
              : 'bg-white text-indigo-700 hover:bg-gray-50',
            'flex items-center justify-center rounded-full px-3 py-1 text-xs font-bold uppercase'
          ]"
        >
          <TagIcon class="w-4 h-4" />
          {{ option }}

          <XMarkIcon class="w-4 h-4 hover:border hover:rounded-full" v-if="checked" @click.prevent="clearCategory" />
        </div>
      </RadioGroupOption>
    </RadioGroup>
  </fieldset>
</template>
