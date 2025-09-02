<template>
  <div>
    <h1>Gestión de membresías de campus virtuales</h1>
    <div class="row mt-4">
      
      <div class="col-lg-3 col-md-12 mb-3">
        <router-link class="card-btn" :to="{ name: 'Centros' }">
          <div>
            <b-icon-building class="icono"></b-icon-building>
            <p>Gestión de centros-facultades</p>
          </div>
        </router-link>
      </div>
      <div class="col-lg-3 col-md-12 mb-3">
        <router-link class="card-btn" :to="{ name: 'Planes' }">
          <div>
            <b-icon-journal class="icono"></b-icon-journal>
            <p>Gestión planes de estudio</p>
          </div>
        </router-link>
      </div>
      <div class="col-lg-3 col-md-12 mb-3">
        <router-link class="card-btn" :to="{ name: 'Personas' }">
          <div>
            <b-icon-people class="icono"></b-icon-people>
            <p>Gestión de personas</p>
          </div>
        </router-link>
      </div>
      <div class="col-lg-3 col-md-12 mb-3">
        <router-link class="card-btn" :to="{ name: 'Campus' }">
          <div>
            <b-icon-laptop class="icono"></b-icon-laptop>
            <p>Gestión campus virtual</p>
          </div>
        </router-link>
      </div>

    </div>
    
  </div>
</template>

<script>


export default {
  name: 'Dashboard',
  components: {
    
  },
  data(){
    return{
      

    }
  },
  mounted(){
    
  },
  methods: {
    
    
  }
}
</script>
<style lang="scss">
.card-btn{
  text-decoration: none !important;
  div{
    border-radius: 5px;
    background-color: #C2002F; 
    color: #fff;
    padding: 2rem;
    cursor: pointer;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    &:hover {
      color: #FF9D9D;
    }

    .icono{
      margin-bottom: 12px;
      width: 80px;
      height: auto;
    }
  }
  
}

</style>
