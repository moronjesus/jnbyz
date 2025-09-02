<template>
	<div class="error-page">
		<h1>Página no encontrada</h1>
		<p>No existe ninguna ruta como la requerida: {{ this.$route.path }}</p>
		<router-link :to="{name: 'Dashboard'}">
			<b-button class="mt-4" variant="primary">Volver al Dashboard</b-button>
		</router-link>
	</div>
</template>

<script>

export default {
	name: 'e404',
	components: {},
	data(){
		return {}
		},
	mounted(){},
	methods: {}
}
</script>
<style lang="scss">
.error-page{
	height: 100vh;
	display: flex;
	flex-direction: column;
	align-items:center;
	justify-content: center;
	text-align: center;
}
</style>
