<template>
    <span class="go-back">
        <b-icon-arrow-left-circle @click="goBack"></b-icon-arrow-left-circle>
    </span>
</template>

<script>
export default {
    mounted(){
        console.log("BAck", this.$route)
    },
    methods: {
        goBack(){
            this.$router.push({name:this.$route.params.from, params: this.$route.params})
        }
    }
}
</script>

<style lang="scss">
    .go-back{
        margin-top: 4px;
        margin-right: 8px;
        svg{
            font-size: 1.7rem;
            cursor: pointer;
            color: #404040;
        }
    }

</style>