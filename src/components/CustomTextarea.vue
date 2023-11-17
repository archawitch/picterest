<script setup>
const props = defineProps({
  labelName: String,
  placeHolderText: String,
  modelValue: String,
  rows: Number,
  required: Boolean,
});
const emit = defineEmits(["update:modelValue"]);
</script>

<template>
  <div class="mt-3">
    <div class="pb-1 pl-1">
      <a :id="labelName">{{ labelName }}</a>
    </div>
    <textarea
      class="w-full resize-none rounded-xl border border-solid border-[#cecece] px-4 py-3 transition duration-300 focus:border focus:border-[#888] focus:outline-none"
      :placeholder="placeHolderText"
      :required="required"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
      :rows="rows"
    ></textarea>
  </div>
</template>
