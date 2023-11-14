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
  <div class="container">
    <div style="padding-bottom: 4px">
      <a :id="labelName">{{ labelName }}</a>
    </div>
    <input
      :type="inputType"
      :placeholder="placeHolderText"
      :required="required"
      :value="modelValue"
      @input="$emit('update:modelValue', $event.target.value)" />
  </div>
</template>

<style scoped>
input {
  width: 100%;
  padding: 10px 15px;
  border-color: #cecece;
  border-style: solid;
  border-radius: 12px;
  border-width: 1px;
  font-family: var(--font-family);
  font-size: 16px;
  transition: border-color 0.2s ease-in-out;
}
input:focus {
  outline: none;
  border-color: #888;
  border-width: 1px;
}
.container {
  margin-top: 12px;
}
</style>
