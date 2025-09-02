<template>
  <div id="app" class="wrapper">
    <div :class="{'main-content': this.$route.name !== 'Login'}">
      <HeaderNav v-if="this.$route.name !== 'Login'"/>
      <b-container fluid="xl">
        <b-alert class="fade-enter" :variant="variantAlert" :show="throwAlert" dismissible fade> {{ alertText }}</b-alert>
        <div id="transition-router-view">
          <transition name="fade" mode="out-in">
            <router-view class="mt-3"/>
          </transition>
        </div>
      </b-container>
    </div>
    <SideNav v-if="this.$route.name !== 'Login'" />
  </div>
</template>

<script>
import SideNav from "@/components/Navs/SideNav.vue";
import HeaderNav from "@/components/Navs/HeaderNav.vue";

export default {
  components: {
    SideNav,
    HeaderNav,
  },
  mounted() {
    // Sirve para lanzar un Alert desde cualquier parte del código
    // Ejemplo: this.$bus.$emit("lanzar-alert", 'success', 'Texto del alert', 1000)
    this.$bus.$on("lanzar-alert", (tipo, texto, tiempo = 10000) => {
      this.variantAlert = tipo;
      this.alertText = texto;
      this.throwAlert = true;

      setTimeout(() => {
        this.throwAlert = false;
      }, tiempo);
    });
  },
  data() {
    return {
      variantAlert: "",
      throwAlert: false,
      alertText: "",
    };
  },
  beforeDestroy() {
    this.$bus.$off("lanzar-alert");
  },
};
</script>

<style lang="sass">
.alert
  position: fixed !important
  top: 3em
  right: 2em
  z-index: 5

#transition-router-view
  .fade-enter-active,
  .fade-leave-active
    transition-duration: 0.3s
    transition-property: opacity
    transition-timing-function: ease
  .fade-enter,
  .fade-leave-active
    opacity: 0
</style>
