<template>
  <div>
    <div class="d-flex">
      <BackButton />
      <h1>Detalle de persona</h1>
    </div>
    <div class="content detail">
      <div class="header row">
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Documento:</span>
          <p>{{ this.$attrs.data.documento }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Nombre:</span>
          <p>{{ this.$attrs.data.nombre }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Apellido 1:</span>
          <p>{{ this.$attrs.data.apellido1 }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Apellido 2:</span>
          <p>{{ this.$attrs.data.apellido2 }}</p>
        </div>
        <div class="col-lg-8 col-md-6 col-sm-12 mb-3">
          <span>Email:</span>
          <p>{{ this.$attrs.data.email }}</p>
        </div>		
      </div>

      <div class="body mt-4 tab-unne">
        <b-tabs 
        content-class="mt-3" 
        active-nav-item-class="font-weight-bold"
        >
          <!-- Tab mebresias -->
          <b-tab title="Membresías" active>
            <Table v-bind="tableMembresia"></Table>
            <div class="d-flex justify-content-end" v-if="this.tableMembresia.items.length > 0">
              <export-excel
                class="btn btn-outline-secondary"
                :data="tableMembresia.items"
                :fields="fieldsExcelMembresia"
                worksheet="DetallePersona"
                :name="'Membresías - '+this.$attrs.data.nombre+' '+this.$attrs.data.apellido1+' '+this.$attrs.data.apellido2">
                <b-icon-file-earmark-spreadsheet></b-icon-file-earmark-spreadsheet>
                Descargar Excel
              </export-excel>
            </div>

            <p class="strong unne-primary mt-4 mb-2">Añadir membresía</p>
            <ValidationObserver ref="form">
              <div class="row">
                <SelectBase v-bind="centro" v-model="membresia.centro" @change="getPlanes"></SelectBase>
                <SelectBase v-bind="plan" v-model="membresia.plan" :disabled="membresia.centro == null" @change="cambiaPlan"></SelectBase>
              </div>
              <div class="row align-items-center">
                <SelectBase v-bind="rol" v-model="membresia.rol" class="col-lg-6"></SelectBase>
                <div class="col-lg-12 d-flex justify-content-center">
                  <b-button class="btn-primary" 
                  :disabled="membresia.centro == null || membresia.rol == null"
                  @click="addMembresia"
                  >Añadir membresía</b-button>
                </div>
              </div>
            </ValidationObserver>
          </b-tab>

          <!-- Tab Campus -->
          <b-tab title="Campus virtual">
            <Table v-bind="tableCampus"></Table>
            <div class="d-flex justify-content-end" v-if="this.tableCampus.items.length > 0">
              <export-excel
                class="btn btn-outline-secondary"
                :data="tableCampus.items"
                :fields="fieldsExcelCampus"
                worksheet="DetallePersona"
                :name="'Campus Virtuales - '+this.$attrs.data.nombre+' '+this.$attrs.data.apellido1+' '+this.$attrs.data.apellido2">
                <b-icon-file-earmark-spreadsheet></b-icon-file-earmark-spreadsheet>
                Descargar Excel
              </export-excel>
            </div>
          </b-tab>
        </b-tabs>
      </div>
    </div>
  </div>
</template>

<script>
import SelectBase from "@/components/Forms/Select.vue";
import Table from "@/components/Table.vue";
import BackButton from "@/components/Navs/BackButton.vue";
import { getSimple, postSimple } from "@/api/Api.js";

export default {
  name: 'DetallePersona',
  components: {
    SelectBase,
    Table,
    BackButton
  },
  data(){
    return {
      btnOpen: false,
      membresia: {
        centro: null,
        plan: null,
        rol: null,
        },
      centro: {
        name: "centro",
        label: "Selecciona centro/facultad",
        class: "col-lg-12 col-md-12",
        rules: { required: true },
        options: [{value:null, text: "Selecciona centro"}]
        },
      plan: {
        name: "plan",
        label: "Selecciona plan",
        class: "col-lg-12 col-md-12",
        options: [{value:null, text: "Selecciona plan"}]
        },
      rol: {
        name: "rol",
        label: "Selecciona rol",
        class: "col-lg-12 col-md-12",
        rules: { required: true },
        options: [{value:null, text: "Selecciona rol"}]
          },
      tableMembresia: {
        id: "tabla-membresia",
        reference: "table",
        sortBy: "cencodnum",
        sortDesc: false,
        small: true,
        fields: [
          { key: "cencodnum", label: "Código Centro", sortable: true},
          { key: "cennom", label: "Centro/Facultad", sortable: true},
          { key: "ambitocodalf", label: "Ámbito", sortable: true},
          { key: "plancodalf", label: "Código Plan", sortable: true},
          { key: "plannom", label: "Plan de estudios", sortable: true},
          { key: "rolnom", label: "Rol", sortable: true},
          { key: "active", label: "Activo", sortable: true},
          { key: "switches", label: "", class: "centrado derecha" },
        ],
        items: [],
        loading: false,
      },
      tableCampus: {
        id: "tabla-campus",
        reference: "tableCampus",
        sortBy: "descursocv",
        sortDesc: false,
        small: true,
        fields: [
          { key: "origen", label: "Origen", sortable: true},
          { key: "tipo", label: "Tipo", sortable: true},
          { key: "idcursocv", label: "Código", sortable: true},
          { key: "descursocv", label: "Campus Virtual", sortable: true},
          { key: "desgac", label: "Grupo", sortable: true},
          { key: "nomass", label: "Asignatura", sortable: true},
          { key: "rol", label: "Rol", sortable: true},
          { key: "cencodnum", label: "Código Centro", sortable: true},
          { key: "nomcen", label: "Centro", sortable: true},
          { key: "placodalf", label: "Código Plan", sortable: true},
          { key: "nompla", label: "Plan", sortable: true},
        ],
        items: [],
        loading: false,
      },
      fieldsExcelMembresia: {
        "Código Centro":"cencodnum",
        "Centro/Facultad":"cennom",
        "Ámbito":{
          field: 'ambitocodalf',
          callback: (value) => {
              return value == "P" ? "Plan" : "Centro";
            }
          },
        "Código Plan":"plancodalf",
        "Plan de estudios":{
          field: 'plannom',
          callback: (value) => {
            return (value == null || value === "") ? "Todos" : value;
          }
        },
        "Rol":"rolnom",
        "Activo":{
          field: 'active',
          callback: (value) => {
              return value == 1 ? "Sí" : "No";
            }
          }
      },
      fieldsExcelCampus: {
        "Origen":"origen",
        "Tipo":"tipo",
        "Código": "idcursocv",
        "Campus Virtual":"descursocv",
        "Grupo":"desgac",
        "Asignatura":"nomass",
        "Rol":"rol",
        "Código Centro":"cencodnum",
        "Centro":"nomcen",
        "Código Plan":"placodalf",
        "Plan":"nompla",
      }
    }
  },
  mounted() {
    this.getMembresiaUsuario();
    this.getCentros();
    this.getRoles();
    this.getCampus();

  },
  methods: {
    getMembresiaUsuario() {
      this.tableMembresia.loading = true
      let api = "GRP"
      let params = {}
      getSimple(`personas/${this.$attrs.data.id}/membresias`, params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Membresías usuario", response)
        this.tableMembresia.items = response
      })
      .catch(() => {
        this.tableMembresia.items = []
        this.$bus.$emit("lanzar-alert", "danger", 
        "No se han cargado las membresías de" +
        this.$attrs.data.nombre + " " + 
        this.$attrs.data.apellido1 + " " + 
        this.$attrs.data.apellido2);
      }).finally(() => { this.tableMembresia.loading = false });
    },

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
      console.log("Centro", this.membresia.centro)
      this.membresia.plan = null
      this.plan.options = [{value:null, text: "Selecciona plan"}]
      this.director.checked = false
      this.membresia.director = false
      if (this.membresia.centro != null)
      {
        getSimple(`centros/${this.membresia.centro}/planes`, params, api).then((response) => {
          if(response.response) throw "error"
          console.log("Planes", response)
          response.forEach(el => {
            this.plan.options.push({text:el.codPlan + ' - ' + el.nombre, value:el.codPlan})
          })
        })
            .catch(() => {
              this.$bus.$emit("lanzar-alert", "danger", "No se cargaron los planes del selector");
            });
      }
    },

    getRoles(){
      let api = "GRP"
      let params = {}
      getSimple('roles', params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Roles", response)
        response.forEach(el => {
          this.rol.options.push({text:el.nom, value:el.codalf})
        })
      })
      .catch(() => {
        this.$bus.$emit("lanzar-alert", "danger", "No se han cargado los roles del selector");
      });
    },

    cambiaPlan(){
      if(this.membresia.plan == null)
      {
        this.director.checked = false
        this.membresia.director = false
      }
    },

    addMembresia(){
      let api = "GRP"
      let params = [{
        active: 1,
        numempleadorrhh: this.$attrs.data.id, 
        documento: this.$attrs.data.documento,
        tipo: this.$attrs.data.tipo,
        nombre: this.$attrs.data.nombre,
        apellido1: this.$attrs.data.apellido1,
        apellido2: this.$attrs.data.apellido2,
        email: this.$attrs.data.email,
        rolcodalf: this.membresia.rol,
        ambitocodalf: this.membresia.plan == null ? "F" : "P",
        plancodalf: this.membresia.plan,
        plannom: this.searchText("plan"),
        cencodnum: this.membresia.centro,
        cennom: this.searchText("centro"),
        login: this.$attrs.data.login
      }]

      postSimple('membresias', params, api).then((response) => {
        if(response.response) throw response.response
        this.getMembresiaUsuario()
        this.membresia = {
          centro: null,
          plan: null,
          rol: null,
          director: false
        }
        this.$refs.form.reset()
        this.$bus.$emit("lanzar-alert", "success", "Membresía añadida correctamente.");
      })
      .catch((response) => {
        this.$bus.$emit("lanzar-alert", "danger", "No se ha podido añadir la membresía. " + response.data);
      });
    },

    searchText(key){
      let option = this[key].options.find( el => el.value == this.membresia[key])
      return option.text.replace(option.value + ' - ', '')
    },

    getCampus(){
      this.tableCampus.loading = true
			let api = "UNNE"
      let params = {}
      
			getSimple(`cv/persona/${this.$attrs.data.login}`, params, api).then((response) => {
        if(response.response) throw "error"
        console.log("Campus", response)
        this.tableCampus.items = response
      })
      .catch(() => {
        this.tableCampus.items = []
        this.$bus.$emit("lanzar-alert", "danger", "No se cargaron los campus del selector");
      }).finally(() => { this.tableCampus.loading = false });
		},

  }
}
</script>
<style lang="scss">
</style>
