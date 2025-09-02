<template>
  <div class="table">
    <div class="d-flex justify-content-between mt-3">
      <div class="mt-1">
        <span>{{ numberResultsText }}</span>
      </div>
      <div>
        <b-form-group
            label="Resultados por página"
            label-for="per-page-select"
            label-align-sm="right"
            label-size="sm"
            label-class="form-control-label mr-2 unne-primary"
            class="w-100 d-flex justify-content-end mb-1"
        >
          <b-form-select class="custom-select"
                         id="per-page-select"
                         v-model="perPage"
                         :options="pageOptions"
                         size="sm"
                         @change="currentPage = 1"
          ></b-form-select>
        </b-form-group>
      </div>
    </div>
    <b-table
      :id="id"
      :reference="reference"
      :items="items"
      :fields="fields"
      :current-page="currentPage"
      :per-page="perPage"
      :sort-by.sync="dataSortBy"
      :sort-desc.sync="dataSortDesc"
      :no-sort-reset=true
      :select-mode="selectMode"
      :selectable="selectable"
      :stacked="staked"
      sort-icon-left
      ref="selectableTable"
      @row-selected="onRowSelected"
      v-bind="$attrs"
      :filter="filter"
      :filter-included-fields="filterOn"
      @filtered="onFiltered"
      :show-empty="!loading"
      :responsive="responsive"
      :sticky-header="stickyHeader"
      :busy="loading"
      :empty-text="emptyText"
      :empty-filtered-text="emptyFilteredText"
    >
      <template #table-busy>
        <div class="text-center text-danger my-2">
          <b-spinner class="align-middle"></b-spinner>
          <strong> Cargando datos...</strong>
        </div>
      </template>

      <template #empty>
        <p class="text-center my-2" >{{emptyText}}</p>
      </template>
      <template #cell(selected)="{ rowSelected }">
        <template v-if="rowSelected">
          <span aria-hidden="true"
            ><b-icon-check-square-fill
              variant="primary"
            ></b-icon-check-square-fill
          ></span>
          <span class="sr-only">Selected</span>
        </template>
        <template v-else>
          <span aria-hidden="true"
            ><b-icon-square variant="secondary"></b-icon-square
          ></span>
          <span class="sr-only">Not selected</span>
        </template>
      </template>

      <template #head(selected)>
        <div
          v-if="selectMode === 'multi'"
          @click="toggleSelected"
          class="no-btn"
        >
          <b-icon-check-square-fill
            v-if="selected.length > 0"
            variant="primary"
          ></b-icon-check-square-fill>
          <b-icon-square v-else variant="secondary"></b-icon-square>
        </div>
      </template>

      <template #cell(actions)="row">
        <VerticalActions v-if="hideActionsState !== row.item.estado_id" 
        :actions="actions" 
        :reference="row.item.id" 
        :currentState="row.item.active" 
        :row="row.item">
        </VerticalActions>
      </template>

      <template #cell(inputnumber)="row">
        <InputBase type="number" v-model="row.item.inputnumber" ></InputBase>
      </template>

      <template #cell(select)="row">
        <Select :options="row.item.options"></Select>
      </template>

      <template #cell(director)="row">
        {{row.item.director == "1" ? "Sí" : "No"}}
      </template>

      <template #cell(active)="row">
        {{row.item.active == "1" ? "Sí" : "No"}}
      </template>

      <template #cell(ambitocodalf)="row">
        {{row.item.ambitocodalf == "F" ? "Centro" : "Plan"}}
      </template>

<!--      <template #cell(cennom)="row">-->
<!--        {{row.item.cencodnum + ' - ' + row.item.cennom}}-->
<!--      </template>-->

      <template #cell(plannom)="row">
        {{row.item.plannom == null ? "Todos" : row.item.plannom}}
      </template>

      <template #cell(buttons)="row">
        <b-button size="sm"
          v-for="btn in buttons"
          :key="btn.text" 
          :variant="btn.variant" 
          @click="btnAction(row.item.id, btn.to, row.item)">
            {{btn.text}}
            <b-icon :icon="btn.icon" v-b-tooltip.hover.left="btn.icontooltip"></b-icon>
        </b-button>
      </template>
      <template #cell(switches)="row">
        <b-button 
          v-for="btn in switches" 
          :key="btn.icon" 
          :variant="btn.variant" 
          :class="btn.view != row.item.activo ? 'd-none' : ''"
          @click="switchAction(btn.emit, row.item)">
            <b-icon :icon="btn.icon" v-b-tooltip.hover.left="btn.icontooltip"></b-icon>
        </b-button>
      </template>
    </b-table>
    <div class="d-flex my-3" v-if="totalRows > perPage">
      <span>{{ numberResultsAndPagesText }}</span>
    </div>
    <div class="d-flex justify-content-center">
        <b-pagination
            class="d-flex justify-content-center mt-3"
            v-model="currentPage"
            :total-rows="totalRows"
            :per-page="perPage"
            :aria-controls="id"
        ></b-pagination>
    </div>
  </div>
</template>

<script>
import VerticalActions from "../components/VerticalActions.vue";
import InputBase from "../components/Forms/Input.vue";
import Select from "../components/Forms/Select.vue";

export default {
  components: { VerticalActions, InputBase, Select },
  name: "Table",
  props: {
    id: {
      type: String,
      description: "Id de la tabla",
      default: "",
    },
    fields: {
      type: [String, Array, Object],
      description: "Campos en la tabla",
      default: "",
    },
    selectMode: {
      type: String,
      description: "Tipo de seleccion de items, single o multi",
      default: "multi",
    },
    items: {
      type: Array,
      description: "Items",
      default: Array,
    },
    sortBy: {
      type: String,
      description: "Ordenar por...",
      default: "",
    },
    sortDesc: {
      type: Boolean,
      description: "Ordenar por orden descendente",
      default: true,
    },
    loading: {
      type: Boolean,
      description: "Cargando datos",
      default: false,
    },
    reference: {
      type: String,
      description: "Reference name for table",
      default: "",
    },
    actions: {
      type: [String, Array, Object],
      description: "Acciones que se realizan en los botones verticales",
    },
    buttons: {
      type: [String, Array, Object],
      description: "Botones para realizar acciones",
    },
    switches: {
      type: [String, Array, Object],
      description: "Botones para realizar acciones",
    },
    selectable: {
      type: Boolean,
      description: "If the table is selectable",
      default: false,
    },
    selectAllDefault: {
      type: Boolean,
      description: "Poner todos los items en seleccionados",
    },
    staked: {
      type: String,
      description: "Size for responsive table",
      default: "md",
    },
    emptyText: {
      type: String,
      description: "Texto que aparece cuando no hay items",
      default: "No hay datos que mostrar",
    },
    hideActionsState: {
      type: Number,
      description: "Id del estado en que no quieres que se vea el vertical actions",
      default: null
    },
    filter: {
      type: String,
      description: "Texto para filtrar",
      default: null,
    },
    responsive: {
      type: Boolean,
      description: "Responsive de la tabla",
    },
    stickyHeader: {
      type: Boolean,
      description: "Fijar la cabecera",
    },
    emptyFilteredText: {
      type: String,
      description: "Texto que aparece cuando no hay items que coincidan con el criterio de búsqueda",
      default: "No hay datos que coincidan con el criterio de búsqueda",
    },
    filterOn: {
      type: Array,
      description: "Items",
      default: Array,
    },
  },
  data() {
    return {
      dataSortBy: '',
      dataSortDesc: true,
      currentPage: 1,
      perPage: 20,
      pageOptions: [10, 20, 50, 100],
      totalRows: 1,
      selected: [],
      input: "",
    };
  },
  computed: {
    totalPages(){
      return Math.ceil(this.totalRows / this.perPage)
    },
    firstRowIndexInPage(){
      return (this.perPage * this.currentPage - this.perPage + 1)
    },
    lastRowIndexInPage(){
      return this.perPage * this.currentPage > this.totalRows ? this.totalRows : (this.perPage * this.currentPage)
    },
    numberResultsAndPagesText() {
      return 'Página ' + this.currentPage + ' de ' + this.totalPages.toLocaleString('ca-Es') +
          '. Mostrando los resultados del ' + this.firstRowIndexInPage.toLocaleString('ca-Es') +
          ' al ' + this.lastRowIndexInPage.toLocaleString('ca-Es') +
          ' de un total de ' + this.totalRows.toLocaleString('ca-Es') + '.'
    },
    numberResultsText(){
      if (this.totalRows === 1) return 'Se ha encontrado 1 resultado.';
      if (this.totalRows > 1) return 'Se han encontrado ' + this.totalRows.toLocaleString('ca-Es') + ' resultados.'
      else return '';
    },
  },
  updated(){
    if(this.selectAllDefault){
      this.selectAllRows()
    }
    if (this.filter == null || this.filter === "")
      this.totalRows = this.items.length
  },
  mounted(){
    this.totalRows = this.items.length
    this.dataSortBy = this.sortBy
    this.dataSortDesc = this.sortDesc

    if(this.selectAllDefault){
      this.selectAllRows()
    }
  },
  created() {

  },
  methods: {
    onRowSelected(items) {
      this.selected = items;
      this.$emit('selectormodal', this.selected);
      this.$bus.$emit('selectedItems', this.selected)
    },
    selectAllRows() {
      this.$refs.selectableTable.selectAllRows();
    },
    clearSelected() {
      this.$refs.selectableTable.clearSelected();
    },
    toggleSelected() {
      if (this.selected.length > 0) {
        this.clearSelected();
      } else {
        this.selectAllRows();
      }
    },
    onFiltered(filteredItems) {
      this.totalRows = filteredItems.length
      this.currentPage = 1
    },

    //acciones de los botones directos
    btnAction(id, to, data){
      this.$router.push({ name: to, params: { id: id, from: this.$route.name, data: data ,search: this.$route.search} });
    },

    switchAction(emit, data){
      this.$bus.$emit(emit, data)
    }
  },
  beforeDestroy() {
    this.$bus.$off('changeState')
    this.$bus.$off('deleteTableItem')
  }
};
</script>

<style lang="scss" src="../assets/scss/components/_table.scss"></style>