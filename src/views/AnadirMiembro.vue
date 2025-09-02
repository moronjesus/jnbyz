<template>
  <div>
    <div class="d-flex">
      <BackButton />
      <h1>Añadir membresía</h1>
    </div>
      <div class="content detail">
        <div class="header row">
          <div class="col-lg-6 col-md-12">
            <span>Facultad o centro:</span>
            <p>{{ this.$attrs.centro_id + ' - ' + this.$attrs.centro_nom }}</p>
          </div>
          <div class="col-lg-6 col-md-12" v-if="this.$attrs.plan_id != null">
            <span>Plan de estudios:</span>
            <p>{{ this.$attrs.plan_id + ' - ' + this.$attrs.plan_nom }}</p>
          </div>
        </div>

        <div class="d-flex">
          <h2>Buscador de personas</h2>
        </div>
        <div class="row" @keyup.enter="getPersonas">
          <SelectBase v-model="busqueda.tipo" v-bind="tipo"></SelectBase>
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

        <div class="d-flex mt-3" v-if="table.items.length > 0">
          <h3>Seleccione una persona y el rol que desea asignar</h3>
        </div>
        <div class="body mt-4">
          <Table v-bind="table" @selectormodal="setItem" v-if="table.items.length > 0"></Table>
          <div class="row align-items-center" v-if="table.items.length > 0">
            <SelectBase v-bind="rol" v-model="rol.value" :disabled="table.selected.length < 1"></SelectBase>
          </div>
          <div class="text-center" v-if="table.items.length > 0">
            <b-button 
            class="btn-primary" 
            :disabled="rol.value == null || table.selected.length < 1"
            @click="addMiembro"
            >Añadir membresía
            </b-button>
          </div>
        </div>
      </div>
  </div>
</template>

<script>
import SelectBase from "@/components/Forms/Select.vue";
import InputBase from "@/components/Forms/Input.vue";
import Table from "@/components/Table.vue";
import BackButton from "@/components/Navs/BackButton.vue";
import { getSimple, postSimple } from "@/api/Api.js";
export default {
  name: 'AnadirMiembro',
  components: {
    SelectBase,
    InputBase,
    Table,
    BackButton
  },
  data(){
    return {
      busqueda: {
        tipo: null,
        documento: null,
        email: null,
        nombre: null,
        apellido1: null,
        apellido2: null
      },
      tipo: {
        name: "tipo",
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
        label: "Email"
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
        selectable: true,
        selectMode: "multi",
        small: true,
        fields: [
          { key: "selected", label: "", sortable: false },
          { key: "documento", label: "Documento", sortable: true},
          { key: "nombre", label: "Nombre", sortable: true},
          { key: "apellido1", label: "Apellido 1", sortable: true},
          { key: "apellido2", label: "Apellido 2", sortable: true},
          { key: "email", label: "Email", sortable: true},
        ],
        items: [],
        selected: [],
        loading: false,
      },
      rol: {
        name: "Rol",
        label: "Selecciona un rol",
        class: "col-lg-6 col-md-12 col-sm-12",
        rules: { required: true },
        value: null,
        options: [{value: null, text: "Selecciona un rol"}]
      }
    }
  },
  mounted(){
    this.getRoles()
  },
  methods: {
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
        console.log(response)
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

    filterTable(data){
      console.log(data)
    },

    setItem(data) {
      this.table.selected = data;
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

    addMiembro(){
      let api = "GRP"
      let params = []
      this.table.selected.forEach( item => {
        params.push({
          active: 1,
          numempleadorrhh: item.id,
          documento: item.documento,
          tipo: item.tipo,
          nombre: item.nombre,
          apellido1: item.apellido1,
          apellido2: item.apellido2,
          email: item.email,
          rolcodalf: this.rol.value,
          ambitocodalf: this.$attrs.plan_id == null ? "F"  : "P",
          plancodalf: this.$attrs.plan_id,
          plannom: this.$attrs.plan_nom,
          cencodnum: this.$attrs.centro_id,
          cennom: this.$attrs.centro_nom,
          director: false,
          login: item.login
        })
      })

      console.log("POST", params)
      postSimple('membresias', params, api).then((response) => {
        if(response.response) throw response.response

        //this.$router.push({name:this.$route.params.from, params: this.$route.params})
        this.$bus.$emit("lanzar-alert", "success", "Membresía creada correctamente.");
      })
      .catch((response) => {
        let mensaje = response.status == 406 ? response.data : ""
        this.$bus.$emit("lanzar-alert", "danger", "No se ha podido crear la membresía. " + mensaje);
      });
    },
    
  }
}
</script>
<style lang="scss">
</style>
