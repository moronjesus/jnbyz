<template>
	<ValidationProvider
	:rules="rules"
	:name="name"
	v-bind="$attrs"
	v-slot="{ errors, valid, invalid, validated }"
	>
	<b-form-group>
		<slot name="label">
		<label v-if="label" :class="labelClasses"> {{ label }}<span v-if="rules" class="text-danger">*</span></label>
		</slot>
		<div
		class="input-group"
		:class="[{ 'has-label': label || $slots.label }, inputGroupClasses]"
		>
		<slot v-bind="slotData">
			<b-form-select
			:value="value"
			:options="options"
			v-on="listeners"
			v-bind="$attrs"
			:required="required"
			:class="[
				{ 'is-valid': valid && validated && successMessage },
				{ 'is-invalid': invalid && validated },
				inputClasses,
			]"
			></b-form-select>
		</slot>

		<slot name="infoBlock"></slot>
		</div>
		<slot name="success">
		<div class="valid-feedback" v-if="valid && validated && successMessage">
			{{ successMessage }}
		</div>
		</slot>
		<slot name="error">
		<div v-if="errors[0]" class="invalid-feedback" style="display: block">
			{{ errors[0] }}
		</div>
		</slot>
	</b-form-group>
	</ValidationProvider>
</template>
<script>
export default {
	inheritAttrs: false,
	name: "SelectBase",
	props: {
	options: {
		type: [Array, Object],
		description: "Options for select",
	},
	required: {
		type: Boolean,
		description: "Whether input is required (adds an asterix *)",
	},
	group: {
		type: Boolean,
		description:
		"Whether input is an input group (manual override in special cases)",
	},
	alternative: {
		type: Boolean,
		description: "Whether input is of alternative layout",
	},
	label: {
		type: String,
		description: "Input label (text before input)",
	},
	error: {
		type: String,
		description: "Input error (below input)",
	},
	successMessage: {
		type: String,
		description: "Input success message",
		default: "",
	},
	labelClasses: {
		type: String,
		description: "Input label css classes",
		default: "form-control-label",
	},
	inputClasses: {
		type: String,
		description: "Input css classes",
	},
	inputGroupClasses: {
		type: String,
		description: "Input group css classes",
	},
	value: {
		type: [String, Number],
		description: "Input value",
		default: null
	},
	type: {
		type: String,
		description: "Input type",
		default: "text",
	},
	rules: {
		type: [String, Array, Object],
		description: "Vee validate validation rules",
		default: "",
	},
	name: {
		type: String,
		description: "Input name (used for validation)",
		default: " ",
	},
	selected: {
		type: String,
		description: "Input name (used for validation)",
		default: null,
	},
	},
	data() {
	return {
		focused: false,
		selectedDefault: null,
	};
	},
	computed: {
		listeners() {
			return {
			...this.$listeners,
			select: this.updateValue,
			focus: this.onFocus,
			blur: this.onBlur,
			};
		},
		slotData() {
			return {
			focused: this.focused,
			error: this.error,
			...this.listeners,
			};
		},
	},
	
	methods: {
	change(val) {
		this.$emit("input", val);
	},

	updateValue(evt) {
		let value = evt.target.value;
		this.$emit("select", value);
	},
	onFocus(evt) {
		this.focused = true;
		this.$emit("focus", evt);
	},
	onBlur(evt) {
		this.focused = false;
		this.$emit("blur", evt);
	},
	},
};
</script>
<style></style>
