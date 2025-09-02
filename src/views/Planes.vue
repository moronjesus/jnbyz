<template>
  <div>
    <h1>Gestión planes de estudio</h1>
    <div class="content search">
			<div class="row align-items-center">
				<SelectBase v-bind="centro" v-model="centro.value" @change="setTextValueCentro"></SelectBase> 
				<SelectBase v-bind="plan" v-model="plan.value" @change="setTextValuePlan" :disabled="centro.value == null"></SelectBase>
        <router-link class="col-lg-2 col-md-12" 
          :to="{ 
            name: 'AnadirMiembro', 
            params: {
              from: this.$route.name, 
              centro_id: centro.value, 
              centro_nom: centro.valueText, 
              plan_id: plan.value, 
              plan_nom: plan.valueText 
            }
          }">
            <b-button class="btn-primary w-100" :disabled="centro.value == null || plan.value == null">
              <b-icon-plus></b-icon-plus>Añadir membresía</b-button>
          </router-link>
			</div>
			<div class="header mt-4" v-if="centro.value != null && plan.value != null">
				<Search @search-criteria="filterTable"></Search>
			</div>

			<div class="body" v-if="centro.value != null && plan.value != null">
        <Table v-bind="table"></Table>

        <div class="d-flex justify-content-end" v-if="this.table.items.length > 0">
          <export-excel
            class="btn btn-outline-secondary"
            :data="table.items"
            :fields="fieldsExcel"
            worksheet="Planes"
            :name="'Membresías - ' + centro.valueText + ' - '  + plan.valueText">
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
  name: 'Planes',
  components: {
    SelectBase,
		Search,
		Table
  },
  data(){
    return{
      centro: {
				name: "centro",
        label: "Selecciona centro o facultad",
        class: "col-lg-12 col-md-12",
        rules: { required: true },
        value: null,
				valueText: null,
        options: [{value:null, text: "Selecciona centro o facultad"}]
			},
			plan: {
				name: "plan de estudios",
        label: "Selecciona plan de estudios",
        class: "col-lg-10 col-md-12",
        rules: { required: true },
        value: null,
				valueText: null,
        options: [{value:null, text: "Selecciona plan"}]
			},
      
			table: {
        id: "tabla-planes",
        reference: "table",
				sortBy: "nombre",
        sortDesc: false,
        selectable: false,
				small: true,
				filter: "",
        loading: false,
        fields: [
          { key: "documento", label: "Documento", sortable: true},
          { key: "nombre", label: "Nombre", sortable: true},
          { key: "apellido1", label: "Apellido 1", sortable: true},
          { key: "apellido2", label: "Apellido 2", sortable: true},
          { key: "email", label: "Email", sortable: true},
          { key: "rolnom", label: "Rol", sortable: true},
          { key: "director", label: "Director",
            formatter: (value) => {
              return value == 1 ? 'Sí' : 'No'
            },
            sortable: true,
            filterByFormatted: true
          },
					{ key: "active", label: "Activo",
            formatter: (value) => {
              return value == 1 ? 'Sí' : 'No'
            },
            sortable: true,
            filterByFormatted: true
          },
          { key: "actions", label: "", class: "centrado derecha" },
        ],
        filterOn: ["documento","nombre", "apellido1", "apellido2","rolnom", "director", "active"],
        items: [],
        actions: [
          {
            key: "editar",
            label: "Editar",
            icon: "pencil-square",
            to: "EditarMembresia",
            showInState: "1",
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
						text: "¿Está seguro de activar esta membresía? Se desactivará cualquier otra membresía asociada a esta persona, centro y plan."
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
      this.plan.value = this.$route.params.plan_id
      this.plan.valueText = this.$route.params.plan_nom
      this.getPlanes()
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

    getPlanes(){
			let api = "UXXI"
      let params = {}
      this.plan.options = [{value:null, text: "Selecciona plan"}]
			getSimple(`centros/${this.centro.value}/planes`, params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Planes", response)
        response.forEach(el => {
          this.plan.options.push({text:el.codPlan + ' - ' + el.nombre, value:el.codPlan})
        })
      })
      .catch(() => {
        this.$bus.$emit("lanzar-alert", "danger", "No se cargaron los planes del selector");
      });
		},

    filterTable(data){
			this.table.filter = data
		},

		setTextValueCentro(id){
			let centroSelected = this.centro.options.filter( el => el.value == id)
			this.centro.valueText = centroSelected[0].text.replace(id + ' - ', '')
			if(this.centro.value != null) {
        this.plan.options = [{value:null, text: "Selecciona centro o facultad"}]
        this.getPlanes()
        this.plan.value = null
      }

		},

		setTextValuePlan(id){
			let planSelected = this.plan.options.filter( el => el.value == id)
			this.plan.valueText = planSelected[0].text.replace(id + ' - ', '')
			if(this.plan.value != null) this.getMembresias()
      this.table.actions[0].params = {
        centro_id: this.centro.value, 
        centro_nom: this.centro.valueText, 
        plan_id: this.plan.value, 
        plan_nom: this.plan.valueText
      }
		},

		getMembresias(){
      this.table.loading = true
      let api = "GRP"
      let params = {}
			getSimple(`centros/${this.centro.value}/planes/${this.plan.value}/membresias`, params, api).then((response) => {
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
		}
  },
  beforeDestroy(){
    this.$bus.$off("updateTable")
  }
}
</script>
<style lang="scss">
</style>
