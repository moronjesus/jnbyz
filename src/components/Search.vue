<template>
    <b-input-group size="md">
      <b-form-input
        id="filter-input"
        v-model="filter"
        type="search"
        placeholder="Buscar"
        @update="onSearch"
      ></b-form-input>

      <b-input-group-append>
        <b-input-group-text><b-icon-search></b-icon-search></b-input-group-text>
      </b-input-group-append>
    </b-input-group>
</template>
<script>

export default {
  components: { },
  name: 'Search',
  mounted() {},

  data() {
    return {
      filter: ""
    }
  },

  methods: {
    onSearch(){
      this.$emit("search-criteria", this.filter)
    },
  }

}
</script>

<style lang="scss" src="../assets/scss/components/_search.scss"></style>