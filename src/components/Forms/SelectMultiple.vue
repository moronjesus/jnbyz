<template>
  <div :class="selectMultiple.class">
    <b-form-group>
      <ValidationProvider :rules="selectMultiple.rules" :name="selectMultiple.label" v-slot="{errors, validate}" ref="validateSelectMulti">
        <label class="form-control-label"> {{ selectMultiple.label }}: </label>
        <input type="hidden" :value="selectMultiple.values" @input="validate">
        <div class="input-group has-label" v-b-modal="selectMultiple.reference">
          <div id="box-items">
            <span v-for="item in selectMultiple.values " :key="item.id" 
            class="items">
              {{item.description}}
            </span>
          </div>
          <b-button variant="secondary" style="border-radius: 0 0.25rem 0.25rem 0;"
              ><b-icon-list></b-icon-list
            ></b-button>

          <slot name="error">
            <div v-if="errors[0]" class="invalid-feedback" style="display: block;">
              {{ errors[0] }}
            </div>
          </slot>
        </div>
      </ValidationProvider>
    </b-form-group>

    <b-modal
      :id="selectMultiple.reference"
      :title="'Selector de ' + selectMultiple.label"
      size="m"
      class="selector-modal"
      @show="getItems"
    >
      <div class="search">
        <div class="body">
          <Table v-bind="table" @selectormodal="setItem" ref="selectMultipleTable"></Table>
        </div>
      </div>

      <template #modal-footer>
        <div class="w-100">
          <b-button
            variant="primary"
            size="sm"
            class="float-right"
            @click="saveItem"
          >
            Guardar
          </b-button>
        </div>
      </template>
    </b-modal>

    
  </div>
</template>
<script>
import { getSimple } from "@/api/Api.js";

import Table from "../Table.vue";

export default {
  components: { Table },
  inheritAttrs: false,
  name: "SelectMultiple",
  props: {
    selectMultiple: {
      type: [String, Array, Object],
      description: "Vee validate validation rules",
      default: "",
    },
  },
  data() {
    return {
      focused: false,
      table: {
        reference: this.selectMultiple.reference,
        id: this.selectMultiple.reference,
        perPage: 1000,
        sortBy: "created_at",
        sortDesc: true,
        currentPage: 1,
        sortDirection: "asc",
        selectable: true,
        fields: [
          { key: "selected", label: "" },
          { key: this.selectMultiple.field, label: this.selectMultiple.label }
        ],
        items: [],
        loading: false,
        selectedMultiple: [],
      },
    };
  },
  computed: {
    slotData() {
      return {
        focused: this.focused,
        error: this.error,
        ...this.listeners,
      };
    },
  },
  mounted(){

  },
  methods: {
    getItems() {
      
      let params = this.selectMultiple.params
      getSimple(this.selectMultiple.ajaxRoute, params)
      .then((response) => {
        console.log("Select multiple GET", response)
        this.table.items = response
      });
      
      //carga los items seleccionados anteriormente en la tabla
      this.table.selectedMultiple = this.selectMultiple.values
      setTimeout(() =>{
        this.table.selectedMultiple.forEach(itemName => {
          this.table.items.forEach((itemGet, index) => {
            if (itemGet.id === itemName.id) {
              this.$refs.selectMultipleTable.$refs.selectableTable.selectRow(index)
              }
          });
        });
      }, 100)
    },

    setItem(data) {
      this.table.selectedMultiple = data;
    },

    saveItem() {
      if(this.table.selectedMultiple != ""){
        this.$bus.$emit(this.selectMultiple.reference, this.table.selectedMultiple);
        this.$root.$emit("bv::hide::modal", this.selectMultiple.reference);
      }
    },
  },
};
</script>
<style lang="sass">
#box-items
  width: calc(100% - 44px)
  min-height: 40px
  height: auto
  border: 1px solid #ced4da
  border-radius: 0.25rem 0 0 0.25rem
  display: flex
  align-items: center
  flex-wrap: wrap

  .items 
    background-color: #e2e8f0
    padding: 0.25rem 0.5rem
    border-radius: 20px
    margin: 4px
</style>
