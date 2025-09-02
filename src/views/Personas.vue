<template>
  <div>
    <h1>Gestión de personas</h1>
    <div class="content detail">
      <div class="row" @keyup.enter="getPersonas">
        <SelectBase v-bind="tipo" v-model="busqueda.tipo"></SelectBase>
        <InputBase v-model="busqueda.documento" v-bind="documento"></InputBase>
        <InputBase v-model="busqueda.email" v-bind="email"></InputBase>
        <InputBase v-model="busqueda.nombre" v-bind="nombre"></InputBase>
        <InputBase v-model="busqueda.apellido1" v-bind="apellido1"></InputBase>
        <InputBase v-model="busqueda.apellido2" v-bind="apellido2"></InputBase>
      </div>
      <div class="w-100 d-flex justify-content-end">
        <b-button variant="outline-secondary" @click="limpiar">Limpiar</b-button>
        <b-button class="ml-3" @click="getPersonas">Buscar</b-button>
      </div>

      <div class="body mt-4">
        <Table v-bind="table" v-if="table.items.length > 0"></Table>
        <div class="d-flex justify-content-end" v-if="table.items.length > 0">
          <export-excel
            class="btn btn-outline-secondary"
            :data="table.items"
            :fields="fieldsExcel"
            worksheet="Personas"
            name="Personas.xls">
            <b-icon-file-earmark-spreadsheet></b-icon-file-earmark-spreadsheet>
            Descargar Excel
          </export-excel>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import SelectBase from "@/components/Forms/Select.vue";
import InputBase from "@/components/Forms/Input.vue";
import Table from "@/components/Table.vue";
import { getSimple } from "@/api/Api.js";
export default {
  name: 'Personas',
  components: {
    SelectBase,
    InputBase,
    Table,
  },
  data(){
    return{
      busqueda: {
        tipo: null,
        documento: null,
        email: null,
        nombre: null,
        apellido1: null,
        apellido2: null
      },
      tipo: {
        name: "Tipo de documento",
        label: "Tipo de documento",
        class: "col-lg-3 col-md-6 col-sm-12",
        options: [
          {value:null, text: ""},
          {value:"N", text: "N"},
          {value:"C", text: "C"},
          {value:"I", text: "I"}
        ]
      },
      documento: {
        class: "col-lg-3 col-md-6 col-cm-12",
        name: "Numero documento",
        label: "Número de documento",
      },
      email: {
        class: "col-lg-6 col-md-6 col-cm-12",
        name: "Email",
        label: "Email",
      },
      nombre: {
        class: "col-lg-4 col-md-6 col-cm-12",
        name: "Nombre",
        label: "Nombre",
      },
      apellido1: {
        class: "col-lg-4 col-md-6 col-cm-12",
        name: "Apellido1",
        label: "Apellido1",
      },
      apellido2: {
        class: "col-lg-4 col-md-6 col-cm-12",
        name: "Apellido2",
        label: "Apellido2",
      },
      table: {
        id: "tabla-centros",
        reference: "table",
        sortBy: "nombre",
        sortDesc: false,
        currentPage: 1,
        small: true,
        fields: [
          { key: "documento", label: "Documento", sortable: true},
          { key: "nombre", label: "Nombre", sortable: true},
          { key: "apellido1", label: "Apellido 1", sortable: true},
          { key: "apellido2", label: "Apellido 2", sortable: true},
          { key: "email", label: "Email", sortable: true},
          { key: "buttons", label: "", class: "centrado derecha estrecho" },
        ],
        buttons: [
          {
            text: "",
            icon: "arrow-right-circle",
            icontooltip: "Ir al detalle",
            to: "DetallePersona",
            variant: "light"
          }
        ],
        items: [],
        loading: false,
        //totalRows: 1,
      },
      fieldsExcel: {
        "Documento":"documento",
        "Nombre":"nombre",
        "Apellido 1":"apellido1",
        "Apellido 2":"apellido2",
        "Email":"email",
      }

    }
  },
  mounted(){
    
  },
  methods: {
    
    filterTable(data){
      console.log(data)
    },

    getPersonas(){
      this.table.loading = true
      let api = "UNNE"
      let params = {
        tipodocumento: this.busqueda.tipo,
        numdocumento: this.busqueda.documento,
        apellido1: this.busqueda.apellido1,
        apellido2: this.busqueda.apellido2,
        email: this.busqueda.email,
        nombre: this.busqueda.nombre
      }

      getSimple('personas', params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Personas", response)
        if(response.length > 0){
          response.forEach( el => {
            el.id = el.idempleado
          })
          this.table.items = response
        }else{
          this.table.items = []
          this.$bus.$emit("lanzar-alert", "warning", "No se han encontrado coincidencias con los criterios de búsqueda completados");
        }
      })
      .catch(() => {
        this.table.items = []
        this.$bus.$emit("lanzar-alert", "danger", "No se ha podido buscar la persona");
      }).finally(() => { this.table.loading = false });
    },
    
    limpiar(){
      this.busqueda = {
        tipo: null,
        documento: null,
        email: null,
        nombre: null,
        apellido1: null,
        apellido2: null
      }
    },
  }
}
</script>
<style lang="scss">
</style>
