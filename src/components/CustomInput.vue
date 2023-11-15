<script setup>
const props = defineProps({
  labelName: String,
  inputText: String,
  inputType: String,
  placeHolderText: String,
  modelValue: String,
  required: Boolean,
});
const emit = defineEmits(["update:modelValue"]);
</script>

<template>
  <div class="mt-3">
    <div class="pb-1 pl-1">
      <a :id="labelName">{{ labelName }}</a>
    </div>
    <input
      class="w-full rounded-xl border border-solid border-[#cecece] px-2.5 py-3 transition duration-300 focus:border focus:border-[#888] focus:outline-none"
      :type="inputType"
      :placeholder="placeHolderText"
      :required="required"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)"
    />
  </div>
</template>
