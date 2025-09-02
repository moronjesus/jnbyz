<template>
  <nav
    class="
      sidenav
      navbar navbar-vertical
      fixed-left
      navbar-expand-xs navbar-light
    "
    id="sidenav-main"
  >
    <div class="container-fluid">
      <div class="menu-brand">
        <div class="d-flex justify-content-between align-items-center">
          <router-link class="menu-header" :to="{ name: 'Dashboard' }" @click.native="closeSideNav">
            <img
              src="../../../public/img/logo-UNNE-negativo.png"
              alt="Icono UNNE"
              class="icono-nav"
              />
          </router-link>
          <b-icon-x-circle class="btn-close-menu" @click="closeSideNav"></b-icon-x-circle>
        </div>
        <hr />
      </div>
      <div class="menu-title">
        <div class="d-flex justify-content-between align-items-center">
          <router-link class="menu-header" :to="{ name: 'Dashboard' }" @click.native="closeSideNav">
            <span class="title">Membresías BB</span>
          </router-link>
        </div>
        <hr />
      </div>

      <div class="menu-items">
        <b-navbar-nav> 
          <div class="nav-item d-flex mb-4">
            <router-link :to="{ name: 'Centros' }" class="nav-link" @click.native="closeSideNav"
              ><b-icon-building class="icono-nav"></b-icon-building
              >Centros</router-link
            >
          </div>
        </b-navbar-nav>

        <b-navbar-nav>
          <div class="nav-item d-flex mb-4">
            <router-link :to="{ name: 'Planes' }" class="nav-link" @click.native="closeSideNav"
              ><b-icon-journal class="icono-nav"></b-icon-journal
              >Planes</router-link
            >
          </div>
        </b-navbar-nav>

        <b-navbar-nav>
          <div class="nav-item d-flex mb-4">
            <router-link :to="{ name: 'Personas' }" class="nav-link" @click.native="closeSideNav"
              ><b-icon-people class="icono-nav"></b-icon-people
              >Personas</router-link
            >
          </div>
        </b-navbar-nav>

        <b-navbar-nav>
          <div class="nav-item d-flex mb-4">
            <router-link :to="{ name: 'Campus' }" class="nav-link" @click.native="closeSideNav"
              ><b-icon-laptop class="icono-nav"></b-icon-laptop>Campus</router-link>
          </div>
        </b-navbar-nav>

      </div>
    </div>
  </nav>
</template>

<script>
export default {
  name: "SideNav",
  components: {},
  props: {
  },
  methods: {
    subIsActive(input) {
      const paths = Array.isArray(input) ? input : [input];
      return paths.some((path) => {
        return this.$route.path.indexOf(path) === 0; // current path starts with this path string
      });
    },
    closeSideNav(){
      
      if(screen.width < 768){
        document.body.classList.toggle('sidenav-pinned')
      }
      
    }
    
  },
};
</script>

<style lang="scss" src="../../assets/scss/components/_sidenav.scss"></style>