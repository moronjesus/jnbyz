<template>
  <div>
    <div class="d-flex">
      <BackButton />
      <h1>Editar membresía</h1>
    </div>
    <div class="content detail">
      <div class="header row">
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Documento:</span>
          <p>{{ this.$attrs.row.documento}}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Nombre:</span>
          <p>{{ this.$attrs.row.nombre }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Apellido 1:</span>
          <p>{{ this.$attrs.row.apellido1 }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Apellido 2:</span>
          <p>{{ this.$attrs.row.apellido2 }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Email:</span>
          <p>{{ this.$attrs.row.email }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Rol:</span>
          <p>{{ this.$attrs.row.rolnom }}</p>
        </div>
        <div class="col-lg-4 col-md-6 col-sm-12 mb-3">
          <span>Centro:</span>
          <p>{{ this.$attrs.row.cennom }}</p>
        </div>
        <div class="col-lg-8 col-md-6 col-sm-12 mb-3" v-if="this.$attrs.row.plannom != null">
          <span>Plan:</span>
          <p>{{ this.$attrs.row.plannom }}</p>
        </div>
      </div>

      <div class="body mt-4">
        <div class="row align-items-center">
          <SelectBase
            v-bind="rol"
            v-model="rol.value"
            @change="cambiaRol"
          ></SelectBase>
          <b-form-checkbox v-if="this.$attrs.row.plannom != null"
              v-bind="director"
              v-model="director.checked"
              switch
              @change="cambiaRol"
          >
            Director de Programa
          </b-form-checkbox>
        </div>
        <div class="text-center">
          <b-button 
          class="btn-primary" 
          :disabled="!rolCambia"
          @click="editarMembresia"
          >Modificar membresía
          </b-button>
        </div>
      </div>
    </div>

  </div>
</template>

<script>
import SelectBase from "@/components/Forms/Select.vue";
import BackButton from "@/components/Navs/BackButton.vue";
import { getSimple, postSimple } from "@/api/Api.js";
export default {
  name: "EditarMembresia",
  components: {
    SelectBase,
    BackButton,
  },
  data() {
    return {
      rolCambia: false,
      rol: {
        name: "rol",
        label: "Selecciona rol",
        class: "col-lg-6 col-md-12",
        rules: { required: true },
        value: null,
        options: [
            { value: null, text: "Selecciona rol" },

        ],
      },
      director: {
        name: "Director de Programa",
        checked: false,
        class: "col-lg-6 col-md-12 col-sm-12 pl-3",
      }
    }
  },
  mounted() {
    this.getRoles()
  },
  methods: {
    getRoles(){
      console.log("this.$attrs.row.director", this.$attrs.row.director)
      if (this.$attrs.row.director == 1) this.director.checked = true;
      console.log("director", this.director.checked)
      this.rol.value = this.$attrs.row.rolcodalf
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

    
    cambiaRol(){
      if(this.rol.value != null
          && (this.$attrs.row.rolcodalf != this.rol.value || this.$attrs.row.director != this.director.checked))
        this.rolCambia = true
      else
        this.rolCambia = false
    },

    editarMembresia(){
      let api = "GRP"
      let params = {
        active: 1,
        id: this.$attrs.row.id,
        numempleadorrhh: this.$attrs.row.numempleadorrhh,
        documento: this.$attrs.row.documento,
        tipo: this.$attrs.row.tipo,
        nombre: this.$attrs.row.nombre,
        apellido1: this.$attrs.row.apellido1,
        apellido2: this.$attrs.row.apellido2,
        email: this.$attrs.row.email,
        rolcodalf: this.rol.value,
        ambitocodalf: this.$attrs.row.plannom == null ? "F"  : "P",
        plancodalf: this.$attrs.row.plancodalf,
        plannom: this.$attrs.row.plannom,
        cencodnum: this.$attrs.row.cencodnum,
        cennom: this.$attrs.row.cennom,
        director: this.director.checked,
        login: this.$attrs.row.login
      }

      console.log("POST", params)
      postSimple(`membresias/${this.$attrs.row.id}`, params, api).then((response) => {
        if(response.response) throw response.response

        this.$router.push({name:this.$route.params.from, params: this.$route.params})
        this.$bus.$emit("lanzar-alert", "success", "Membresía actualizada.");
      })
      .catch((response) => {
        let mensaje = response.status == 406 ? response.data : ""
        this.$bus.$emit("lanzar-alert", "danger", "No se ha podido actualizar la membresía. " + mensaje
        );
      });
    }
  },
};
</script>
<style lang="scss">
</style>
