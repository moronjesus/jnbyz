<template>
  <div :class="selectModal.class">
      <b-form-group>
  
          <label class="form-control-label">
            {{selectModal.label}}:
          </label>
        <ValidationProvider :rules="selectModal.rules" :name="selectModal.name" v-bind="$attrs" v-slot="{errors, valid, invalid, validated}">
          <div class="input-group has-label">
          
            <b-form-input
              :value="selectModal.value"
              :id="selectModal.id"
              :class="[{'is-invalid': invalid && validated}, inputClasses]"
              readonly
              :valid="valid"
              v-b-modal="selectModal.reference"
              :placeholder="selectModal.placeholder"
              ></b-form-input>

            <b-input-group-append>
                <b-button variant="secondary" v-b-modal="selectModal.reference"><b-icon-list></b-icon-list></b-button>
            </b-input-group-append>

            <slot name="error">
              <div v-if="errors[0]" class="invalid-feedback" style="display: block;">
                {{ errors[0] }}
              </div>
            </slot>
          
          </div>
        </ValidationProvider>
      </b-form-group>
      <b-modal
        :id="selectModal.reference"
        :title="'Selector de ' + selectModal.label"
        size="l"
        class="selector-modal"
        @show="getItems"
        scrollable
      >
        <div class="search">
          <div class="header">
            <!-- <Search v-on:search-criteria="getItems"></Search> -->
            <InputBase
            class="w-100"
            name="buscar"
            placeholder="Criterio de búsqueda"
            type="search"
            v-model="table.filter"
          ></InputBase>
          </div>
          <div>{{this.notFound}}</div>
          <div class="body">
            <Table v-bind="table" @selectormodal="setItem" v-if="table.items.length > 0"></Table>
          </div>
        </div>

        <template #modal-footer>
          <div class="w-100">
            <b-button
              variant="primary"
              size="sm"
              class="float-right"
              @click="addItem"
            >
              Añadir {{ label }}
            </b-button>
          </div>
        </template>
      </b-modal>
  </div>
</template>

<script>
import InputBase from "./Input.vue";
import Table from "../Table.vue";
import { getSimple } from "@/api/Api.js";

export default {
  components: { InputBase, Table },
  name: "SelectorModal",
  props: {
    label: String,
    reference: String,
    ajaxRoute: String,
    validationContext: {
      type: [Array, Object],
    },
    filters: {
      type: [Array, Object],
    },
    multiselect:{
      type: String,
      default: 'single',
    },
    itemsCriteria: {
      type: String,
      description: "item type in BBDD",
    },
     selectModal: {
      type: [String, Array, Object],
      description: "Vee validate validation rules",
      default: "",
    }
  },
  data() {
    return {
      show: false,
      inputClasses: "form-control",
      table: {
        reference: this.selectModal.reference,
        perPage: 1000,
        sortBy: "created_at",
        sortDesc: true,
        sortDirection: "asc",
        selectable: true,
        selectMode: "single",
        fields: [
          { key: "selected", label: "" },
          { key: this.selectModal.field, label: this.selectModal.label, sortable: true },
        ],
        items: [],
        loading: false,
        selected: "",
      },
      notFound: '',
      idModal: this.selectModal.id
    };
  },
  created(){},
  mounted() {},
 
  methods: {
    getValidationState({ dirty, validated, valid = null }) {
      return dirty || validated ? valid : null;
    },
    getItems() {
      
      getSimple(this.selectModal.ajaxRoute)
      .then((response) => {
        //console.log("Pojects", response)
        this.table.items = response
      });
    },

    setItem(data) {
      this.table.selected = data; 
    },

    addItem() {
      this.$bus.$emit(this.table.reference, this.table.selected[0]);
      this.$root.$emit("bv::hide::modal", this.table.reference);
    },
  },
};
</script>

<style lang="scss"></style>