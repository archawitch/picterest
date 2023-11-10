<script setup>
const props = defineProps({
  isRequired: {
    type: Boolean,
    default: false,
  },
  labelName: String,
  inputText: String,
  placeHolderText: String,
  modelValue: String,
});
const emit = defineEmits(["update:modelValue"]);
</script>

<template>
  <label :for="id">{{ labelName }}</label>
  <div>
    <input
      type="text"
      :placeholder="placeHolderText"
      :required="isRequired"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)" />
  </div>
</template>
