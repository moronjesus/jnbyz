<template>
  <div class="login">
    <div class="d-flex flex-column align-items-center mb-3">
      <b-img src="/img/logo-UNNE-negativo.png" fluid alt="Logo UNNE"></b-img>
      <h1 class="mb-0 strong text-white">Gestión de membresías de campus virtuales</h1>
      <b-button v-if="token == null" variant="secondary" class="mt-4" @click="irLogin">
        No está logueado, acceda a la plataforma de Login
      </b-button>
      <small class="mt-4 text-white">@Version 22-01-24</small>
    </div>
  </div>
</template>

<script>
import { getSimple } from "@/api/Api.js";

export default {
  name: 'Login',
  components: {},
  data(){
    return{
      error: null,
      token: null,
      token_UNNE : null,
      token_UXXI: null
    }
  },
  created() {
    if (this.$store.state.token != null && this.$store.state.token_UNNE != null
        && this.$store.state.token_UXXI != null && this.$store.state.auth === true) {
      this.$router.push({ name: "Dashboard" });
    }
  },

  mounted(){
    document.querySelector('body').className += "bg-red"
    console.log("ENV: ", process.env.VUE_APP_API_GRP)
    if(window.location.href != process.env.VUE_APP_LOGIN){
      this.scope = new URLSearchParams(window.location.hash.substring(1)).get('scope');
      if (this.scope === process.env.VUE_APP_SCOPE_UNNE_BACK)
      {
        this.id_token_UNNE = new URLSearchParams(window.location.hash.substring(1)).get('id_token');
        this.token_UNNE = new URLSearchParams(window.location.hash.substring(1)).get('access_token');
        this.error_UNNE = new URLSearchParams(window.location.hash.substring(1)).get('error');
        this.error_description_UNNE = new URLSearchParams(window.location.hash.substring(1)).get('error_description');
      }
      if (this.scope === process.env.VUE_APP_SCOPE_UXXI_BACK)
      {
        this.id_token_UXXI = new URLSearchParams(window.location.hash.substring(1)).get('id_token');
        this.token_UXXI = new URLSearchParams(window.location.hash.substring(1)).get('access_token');
        this.error_UXXI = new URLSearchParams(window.location.hash.substring(1)).get('error');
        this.error_description_UXXI = new URLSearchParams(window.location.hash.substring(1)).get('error_description');
      }

      if (this.scope === process.env.VUE_APP_SCOPE_BACK) {
        this.id_token = new URLSearchParams(window.location.hash.substring(1)).get('id_token');
        this.token = new URLSearchParams(window.location.hash.substring(1)).get('access_token');
        this.error = new URLSearchParams(window.location.hash.substring(1)).get('error');
        this.error_description = new URLSearchParams(window.location.hash.substring(1)).get('error_description');
      }

      console.log("scope: ", this.scope)
      console.log("id_token: ", this.id_token)
      console.log("token: ", this.token)
      console.log("error: ", this.error)
      console.log("error_description: ", this.error_description)

      console.log("id_token_UNNE: ", this.id_token_UNNE)
      console.log("token_UNNE: ", this.token_UNNE)
      console.log("error_UNNE: ", this.error_UNNE)
      console.log("error_description_UNNE: ", this.error_description_UNNE)

      console.log("id_token_UXXI: ", this.id_token_UXXI)
      console.log("token_UXXI: ", this.token_UXXI)
      console.log("error_UXXI: ", this.error_UXXI)
      console.log("error_description_UXXI: ", this.error_description_UXXI)


      if(this.token == null && this.error != null){
        setTimeout(() => {
          this.$bus.$emit("lanzar-alert", "danger", "No se puede acceder a la aplicación porque este usuario no tiene los permisos necesarios para ello.");
        }, 1000);
      }
    }
    let dataLogin = { token: this.token }
    let dataLogin_UNNE = { token_UNNE: this.token_UNNE }
    let dataLogin_UXXI = { token_UXXI: this.token_UXXI }
    if(this.$store.state.token == null && this.token != null) this.$store.dispatch("doLogin", dataLogin)
    if(this.$store.state.token_UNNE == null && this.token_UNNE != null) this.$store.dispatch("doLoginUNNE", dataLogin_UNNE)
    if(this.$store.state.token_UXXI == null && this.token_UXXI != null) this.$store.dispatch("doLoginUXXI", dataLogin_UXXI)

    console.log("store.state.token: ", this.$store.state.token)
    console.log("store.state.token_UNNE: ", this.$store.state.token_UNNE)
    console.log("store.state.token_UXXI: ", this.$store.state.token_UXXI)

    if(this.$store.state.token != null && this.$store.state.token_UNNE == null)
    {
      console.log("redirigiendo a LoginUNNE")
      this.irLoginUNNE()
    }
    if(this.$store.state.token != null && this.$store.state.token_UNNE != null && this.$store.state.token_UXXI == null)
    {
      console.log("redirigiendo a LoginUXXI")
      this.irLoginUXXI()
    }
    if(this.$store.state.token != null && this.$store.state.token_UNNE != null && this.$store.state.token_UXXI != null)
    {
      console.log("recuperando usuario")
      this.getUser()
    }
  },
  methods: {
    getUser(){
      let api = "GRP"
      getSimple( `usuario`, {}, api) 
        .then((response) => {
          if(response.message) throw response
          console.log("Usuario:",response)
          let dataUser = {
            user: response
          } 
          this.$store.dispatch("doUser", dataUser).then(() => {
            this.$router.push({ name: "Dashboard" })
          })
        })
        .catch((error) => {
          console.log("En login",error)
          if(error.message.includes('Cannot read properties')) {
            this.$bus.$emit("lanzar-alert", "danger", "No se puede acceder al servicio por algún motivo de configuración. Contacte con el encargado del Sistema.");
          } else {
            this.$bus.$emit("lanzar-alert", "danger", error.message);
          }
          
        })
    },

    irLogin(){
      window.location.replace(process.env.VUE_APP_LOGIN)
    },

    irLoginUNNE(){
      window.location.replace(process.env.VUE_APP_LOGIN_UNNE)
    },

    irLoginUXXI(){
      window.location.replace(process.env.VUE_APP_LOGIN_UXXI)
    }
  },
  beforeDestroy(){
    document.querySelector('body').className = ""
  }
}
</script>
<style lang="sass">
.login
  display: flex
  flex-direction: column
  justify-content: center
  align-items: center
  height: 100vh

  .content
    width: 100%
    max-width: 400px

  .icono-unne-blanco
    width: 250px
    height: 250px
</style>