<template>
  <div>
    <h1>Gestión de centros o facultades</h1>
    <div class="content search">
			<div class="row align-items-center">
				<SelectBase v-bind="centro" v-model="centro.value" @change="setTextValueCentro"></SelectBase>
        <router-link class="col-lg-2 col-md-12" :to="{ name: 'AnadirMiembro', params: {from: this.$route.name, centro_id: centro.value, centro_nom: centro.valueText, plan_id: null, plan_nom: null} }">
          <b-button class="btn-primary w-100" :disabled="centro.value == null">
            <b-icon-plus></b-icon-plus>Añadir membresía</b-button>
        </router-link>
			</div>

			<div class="header mt-4" v-if="centro.value != null">
				<Search @search-criteria="filterTable"></Search>
			</div>

			<div class="body" v-if="centro.value != null">
        <Table v-bind="table" ></Table>

        <div class="d-flex justify-content-end" v-if="table.items.length > 0">
          <export-excel
            class="btn btn-outline-secondary"
            :data="table.items"
            :fields="fieldsExcel"
            worksheet="Centros"
            :name="'Membresías - ' + centro.valueText">
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
import Search from "@/components/Search.vue";
import Table from "@/components/Table.vue";
import { getSimple } from "@/api/Api.js";


export default {
  name: 'Centros',
  components: {
    SelectBase,
		Search,
		Table,
  },
  data(){
    return{
      centro: {
				name: "centro",
        label: "Selecciona centro o facultad",
        class: "col-lg-10 col-md-12",
        rules: { required: true },
        value: null,
				valueText: null,
        options: [{value:null, text: "Selecciona centro o facultad"}]
			},
			table: {
        id: "tabla-centros",
        reference: "table",
				sortBy: "nombre",
        sortDesc: false,
        selectable: false,
				small: true,
				filter: "",
        fields: [
          { key: "documento", label: "Documento", sortable: true},
          { key: "nombre", label: "Nombre", sortable: true},
          { key: "apellido1", label: "Apellido 1", sortable: true},
          { key: "apellido2", label: "Apellido 2", sortable: true},
          { key: "email", label: "Email", sortable: true},
          { key: "rolnom", label: "Rol", sortable: true},
					{ key: "active", label: "Activo",
            formatter: (value) => {
              return value == 1 ? 'Sí' : 'No'
            },
            sortable: true,
            filterByFormatted: true},
          { key: "actions", label: "", class: "centrado derecha", sortable: false },
        ],
        filterOn: ["documento","nombre", "apellido1", "apellido2","rolnom", "active"],
        items: [],
        loading: false,
        actions: [
          {
            key: "editar",
            label: "Editar",
            icon: "pencil-square",
            to: "EditarMembresia",
            showInState: "1",
            params: {}
          },
          {
            key: "desactivar",
            label: "Desactivar",
            icon: "x-circle",
            to: "ArticuloGrafica",
            showInState: "1",
						title: "Desactivar membresía",
						text: "¿Está seguro de desactivar esta membresía?"
          },
					{
            key: "activar",
            label: "Activar",
            icon: "check-circle",
            to: "ArticuloGrafica",
            showInState: "0",
						title: "Activar membresía",
						text: "¿Está seguro de activar esta membresía? Se desactivará cualquier otra membresía asociada a esta persona y centro."
          },
        ],
      },
      fieldsExcel: {
        "Documento":"documento",
        "Nombre":"nombre",
        "Apellido 1":"apellido1",
        "Apellido 2":"apellido2",
        "Email":"email",
        "Rol":"rolnom",
        "Activo":{
          field: 'active',
          callback: (value) => {
              return value == 1 ? "Sí" : "No";
          }
        }
      }
    }
  },
  mounted(){
    this.getCentros();

    this.$bus.$on('updateTable', () => {
      this.getMembresias()
    })

    if(Object.keys(this.$route.params).length != 0){
      this.centro.value = this.$route.params.centro_id
      this.centro.valueText = this.$route.params.centro_nom
      this.getMembresias()
    }
    
  },
  methods: {
		getCentros(){
      let api = "UXXI"
      let params = {}
			getSimple('centros', params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Centros", response)
        response.forEach(el => {
          this.centro.options.push({text:el.codCentro + ' - ' + el.nombre, value:el.codCentro})
        })
      })
      .catch(() => {
        this.$bus.$emit("lanzar-alert", "danger", "No se cargaron los centros del selector");
      });
		},
    filterTable(data){
			this.table.filter = data
		},

    setTextValueCentro(id){
			let centroSelected = this.centro.options.filter( el => el.value == id)
			this.centro.valueText = centroSelected[0].text.replace(id + ' - ', '')
			if(this.centro.value != null)
        this.getMembresias()
      else{
        this.filterTable(null)
      }

      this.table.actions[0].params = {
        centro_id: this.centro.value,
        centro_nom: this.centro.valueText,
        plan_id: null,
        plan_nom: null
      }
		},

		getMembresias(){
      this.table.loading = true
			let api = "GRP"
      let params = {}
			getSimple(`centros/${this.centro.value}/membresias`, params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Membresias", response)
        response.forEach( el => {
          el.id = parseInt(el.id)
        })
        this.table.items = response
      })
      .catch(() => {
        this.table.items = []
        this.$bus.$emit("lanzar-alert", "danger", "No se cargaron las membresías correspondientes");
      }).finally(() => { this.table.loading = false });
		},
  },

  beforeDestroy(){
    this.$bus.$off("updateTable")
  }
}
</script>
<style lang="scss">
</style>
