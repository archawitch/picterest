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
  <div class="container">
    <a :id="labelName">{{ labelName }}</a>
    <input
      type="text"
      :placeholder="placeHolderText"
      :required="required"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)" />
  </div>
</template>

<style scoped>
input {
  width: 100%;
  padding: 10px;
  border-color: #cecece;
  border-style: solid;
  border-radius: 12px;
  border-width: 1px;
  font-family: var(--font-family);
  font-size: 16px;
}
input:focus {
  outline-width: inherit;
}
.container {
  margin-top: 12px;
}
</style>
