<template >
    <div>
        <label for="example-input"> {{ label }}:</label>
        <b-input-group>
            <b-form-input
                :id="id"
                v-model="valueDate"
                type="text"
                placeholder="YYYY-MM-DD"
                autocomplete="off"
            ></b-form-input>
            <b-input-group-append>
                <b-form-datepicker
                v-model="valueDate"
                button-only
                right
                locale="es"
                aria-controls="example-input"
                ></b-form-datepicker>
            </b-input-group-append>
        </b-input-group>
    </div>
</template>

<script>

    export default {
        name: "DatePicker",
        props: {
            label: {
                type: String,
                description: 'Label for datepicker',
            },
            id: {
                type: String,
                description: 'id for datepicker',
            }

        },
        data() {
            return {
                valueDate: ''
            };
        },
        mounted(){
            
        },
        
        methods: {
           
        }
    };
</script>

<style></style>