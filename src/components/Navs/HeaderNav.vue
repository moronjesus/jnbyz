<template>
  <div class="headernav">
    <b-navbar>
      <b-button class="sidenav-toggler" @click="togglerMenu">
        <i class="sidenav-toggler-line"></i>
        <i class="sidenav-toggler-line"></i>
        <i class="sidenav-toggler-line"></i>
      </b-button>
      <div>
        <b-button>
          <b-icon
          v-b-tooltip.hover.down="this.$store.state.user.usuario"
          icon="person" 
          @click='showUserModal'
          ></b-icon>
        </b-button>
        <b-button>
          <b-icon 
          v-b-tooltip.hover.down="'Cerrar sesión'"
          icon="box-arrow-right" 
          aria-hidden="true" 
          @click='logout'
          ></b-icon>
        </b-button>
      </div>
    </b-navbar>
    <b-modal
			id="userModal"
			title="Datos del usuario en sesión"
			size="m"
      hide-footer
      v-if="this.$store.state.user != null"
			>
      <div class="body row modal-user">
        <div class="col-12">
          <label>Nombre usuario</label>
          <p>{{ this.$store.state.user.usuario }}</p>
        </div>
        <div class="col-12">
          <label>Email</label>
          <p>{{ this.$store.state.user.upn }}</p>
        </div>
      </div>
    
      <b-button class="mt-3 btn-primary" block @click="$bvModal.hide('userModal')">Cerrar ventana</b-button>
    </b-modal>
  </div>
</template>

<script>
export default {
  name: 'HeaderNav', 
  data() {
    return {
    }
  },
  mounted(){
    
  },
  methods: {

    togglerMenu(){
      var body = document.body
      body.classList.toggle('sidenav-pinned')
    },

    logout() {
      sessionStorage.clear();
      this.$store.dispatch('doLogout').then(() => {
        sessionStorage.clear();
        this.$router.push({ name: "Login" });
      })
    },

    showUserModal(){
      this.$root.$emit('bv::show::modal', 'userModal')
    }
  }
}
</script>

<style lang="scss" src="../../assets/scss/components/_headernav.scss"></style>