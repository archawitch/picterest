<script setup>
const props = defineProps({
  labelName: String,
  inputText: String,
  placeHolderText: String,
  modelValue: String,
  required: Boolean,
});
const emit = defineEmits(["update:modelValue"]);
</script>

<template>
  <label>{{ labelName }}</label>
  <div>
    <input
      type="text"
      :placeholder="placeHolderText"
      :required="required"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)" />
  </div>
</template>
