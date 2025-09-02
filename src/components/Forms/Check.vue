<template>
  <ValidationProvider v-bind="$attrs">
    <label class="lcontainer">
      <input
        v-bind="$attrs"
        class="input"
        type="checkbox"
        v-on="listeners"
        :checked="checked"
        @change="$emit('update:checked', $event.target.checked)"
      />
      <span class="switch"></span>
      <span class="label">{{ label }}</span>
    </label>
  </ValidationProvider>
</template>


<script>
export default {
  inheritAttrs: false,
  name: "CheckBase",
  props: {
    label: {
      type: String,
      description: "Input label (text before input)",
    },
    checked: {
      type: Boolean,
      required: true,
    },
  },
  data() {
    return {
      focused: false,
    };
  },
  computed: {
    listeners() {
      return {
        ...this.$listeners,
        input: this.updateValue,
        focus: this.onFocus,
        //blur: this.onBlur,
      };
    },
  },
  methods: {
    updateValue(evt) {
      let value = evt.target.checked;
      this.$emit("input", value);
    },
    onFocus(evt) {
      this.focused = true;
      this.$emit("focus", evt);
    },
  },
};
</script>

<style scoped>
.lcontainer {
  cursor: pointer;
  display: flex;
  align-items: center;
}
.label {
  margin-left: 12px;
  color: #1a202c;
}
.input {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
.switch {
  --switch-container-width: 50px;
  --switch-size: calc(var(--switch-container-width) / 2);
  /* Vertically center the inner circle */
  display: flex;
  align-items: center;
  position: relative;
  height: var(--switch-size);
  flex-basis: var(--switch-container-width);
  /* Make the container element rounded */
  border-radius: var(--switch-size);
  background-color: #e2e8f0;
}
.switch::before {
  content: "";
  position: absolute;
  /* Move a little bit the inner circle to the right */
  left: 1px;
  height: calc(var(--switch-size) - 4px);
  width: calc(var(--switch-size) - 4px);
  /* Make the inner circle fully rounded */
  border-radius: 9999px;
  background-color: white;
}
.input:checked + .switch {
  /* Teal background */
  background-color: #123d8c;
}
.input:checked + .switch::before {
  border-color: #123d8c;
  /* Move the inner circle to the right */
  transform: translateX(
    calc(var(--switch-container-width) - var(--switch-size))
  );
}
</style>