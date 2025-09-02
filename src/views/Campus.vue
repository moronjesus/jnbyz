<template>
  <div>
    <h1>Gestión de campus virtual</h1>
    <div class="content search">
      <div class="row">
        <SelectBase
          v-bind="centro"
          v-model="centro.value"
          @change="setTextValueCentro"
        ></SelectBase>
        <SelectBase
          v-bind="plan"
          v-model="plan.value"
          @change="setTextValuePlan"
          :disabled="centro.value == null"
        ></SelectBase>

        <SelectBase
          v-bind="campus"
          v-model="campus.value"
          @change="setTextValueCampus"
          :disabled="plan.value == null"
        ></SelectBase>
      </div>
      <div class="header mt-4" v-if="this.campus.value != null && centro.value != null && plan.value != null">
        <Search @search-criteria="filterTable" class="w-100"></Search>
      </div>

      <div class="body" v-if="this.campus.value != null">
        <Table v-bind="table"></Table>

        <div class="d-flex justify-content-end" v-if="this.table.items.length > 0">
          <export-excel
            class="btn btn-outline-secondary"
            :data="table.items"
            :fields="fieldsExcel"
            worksheet="My Worksheet"
            :name="'Membresías - ' + centro.valueText + ' - ' + campus.valueText">
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
  name: "Campus",
  components: {
    SelectBase,
    Search,
    Table,
  },
  data() {
    return {
      centro: {
        name: "centro",
        label: "Selecciona centro o facultad",
        class: "col-lg-12 col-md-12",
        rules: { required: true },
        value: null,
        valueText: null,
        options: [{ value: null, text: "Selecciona centro o facultad" }],
      },
      plan: {
        name: "plan de estudios",
        label: "Selecciona plan de estudios",
        class: "col-lg-12 col-md-12",
        rules: { required: true },
        value: null,
        valueText: null,
        options: [{ value: null, text: "Selecciona plan" }],
        },
      campus: {
        name: "campus virtual",
        label: "Selecciona campus virtual",
        class: "col-lg-12 col-md-12",
        rules: { required: true },
        value: null,
        valueText: null,
        options: [{ value: null, text: "Selecciona campus" }],
      },
      table: {
        id: "tabla-planes",
        reference: "table",
        sortBy: "nombre",
        sortDesc: false,
        currentPage: 1,
        selectable: false,
        small: true,
        filter: "",
        fields: [
          { key: "documento", label: "Documento", sortable: true},
          { key: "nombre", label: "Nombre", sortable: true},
          { key: "apellido1", label: "Apellido 1", sortable: true},
          { key: "apellido2", label: "Apellido 2", sortable: true},
          { key: "email", label: "Email", sortable: true}, 
          { key: "rol", label: "Rol", sortable: true},
        ],
        filterOn: ["documento","nombre", "apellido1", "apellido2","email", "rol"],
        items: [],
        loading: false,
      },
      fieldsExcel: {
        "Documento":"documento",
        "Nombre":"nombre",
        "Apellido 1":"apellido1",
        "Apellido 2":"apellido2",
        "Email":"email",
        "Rol":"rol",
      }
    };
  },
  mounted() {
    this.getCentros();
  },
  methods: {
    getCentros(){
			let api = "UXXI"
      let params = {}
      this.plan.options = [{value:null, text: "Selecciona plan"}]
      this.campus.options = [{value:null, text: "Selecciona campus"}]
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
      this.campus.options = [{value:null, text: "Selecciona campus"}]
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

    getCampus(){
			let api = "UXXI"
      let params = {}
      this.campus.options = [{value:null, text: "Selecciona campus"}]
      let url = `cv/planes/${this.plan.value}`

			getSimple(url, params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Campus", response)
        response.forEach(el => {
          this.campus.options.push({text:el.idcursocv + ' - ' + el.descursocv, value:el.idcursocv})
        })
      })
      .catch(() => {
        this.$bus.$emit("lanzar-alert", "danger", "No se cargaron los campus del selector");
      });
		},

    filterTable(data){
			this.table.filter = data
		},

		setTextValueCentro(id){
			let centroSelected = this.centro.options.filter( el => el.value == id)
			this.centro.valueText = centroSelected[0].text
      this.plan.value = null
      this.campus.value = null
			if(this.centro.value != null) {
        this.plan.options = [{value:null, text: "Selecciona plan"}]
        this.campus.options = [{value:null, text: "Selecciona campus"}]
        this.getPlanes()
      }
		},

		setTextValuePlan(id){
			let planSelected = this.plan.options.filter( el => el.value == id)
      this.campus.value = null
			this.plan.valueText = planSelected[0].text
      if(this.plan.value != null) {
        this.campus.options = [{value:null, text: "Selecciona campus"}]
        this.getCampus()
      }
		},

    setTextValueCampus(id) {
      let campusSelected = this.campus.options.filter((el) => el.value == id);
      this.campus.valueText = campusSelected[0].text;
      if (this.campus.value != null)this.getMembresias();
    },

		getMembresias(){
      this.table.loading = true
			let api = "UNNE"
      let params = {}
			getSimple(`personas/cv/${this.campus.value}`, params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Membresias", response)
        response.forEach( el => {
          el.id = el.idempleado
        })
        this.table.items = response
      })
      .catch(() => {
        this.table.items = []
        this.$bus.$emit("lanzar-alert", "danger", "No se cargaron las membresías correspondientes");
      }).finally(() => { this.table.loading = false });
		}
    
  },
};
</script>
<style lang="scss">
</style>
