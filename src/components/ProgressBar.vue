<template >
    <div class="stock-progress" >
        <div v-for="item in slowStock" :key="item.key">
            <div class="text">
                <span> {{ item.label }}</span>
                <div class="stock">
                    <span class="current text-danger">{{ item.currentstock }}</span>
                    <span class="total"> / {{ item.totalstock }}</span>
                </div>
            </div>
            <b-progress class="mb-3" :variant="item.variant" :value="item.value"></b-progress>
        </div>
    </div>
</template>
<script>

export default {
  name: 'ProgressBar',
  components: {

  },
  props:{
      slowStock: {
          type: [String, Array, Object],
          description: 'values for bars'
      }
  },
  data(){
    return{
  
    }
  }
}
</script>
<style lang="scss" src="../assets/scss/components/_progressbar.scss"></style>
