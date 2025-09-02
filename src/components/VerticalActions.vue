<template>
  <div>
    <b-dropdown
      class="v-actions"
      size="sm"
      variant="light"
      toggle-class="text-decoration-none"
      dropleft
      no-caret
    >
      <template #button-content>
        <b-icon-three-dots-vertical></b-icon-three-dots-vertical>
      </template>
      <div>
        <b-dropdown-item
          v-for="action in actions.filter(
            (e) => e.showInState == currentState || e.showInState === 'all'
          )"
          :key="action.key"
          @click="
            goAction(
              reference,
              action.key,
              action.to,
              action.title,
              action.text,
              row,
              action.params
            )
          "
          v-b-tooltip.hover.left="action.label"
          ><b-icon :icon="action.icon"></b-icon>
        </b-dropdown-item>
      </div>
    </b-dropdown>
  </div>
</template>

<script>
import { putSimple } from "@/api/Api.js";

export default {
  name: "VerticalActions",
  props: {
    actions: {
      type: [String, Array, Object],
      description: "Actions for item",
    },
    row: {
      type: [String, Array, Object],
      description: "Actions for item",
    },
    reference: {
      type: Number,
      description: "Reference ID for item to actions",
    },
    currentState: {
      type: String,
      description: "Current state for this item",
    },
  },
  data() {
    return {
      title: "",
      text: "",
    };
  },
  mounted() {},
  methods: {
    goAction(id, key, to, title, text, row, params) {
      if (key === "ver") {
        this.$router.push({ name: to, params: { id: id } });
      } else if (key === "editar") {
        this.$router.push({ name: to, params: {from: this.$route.name, row, ...params } });
      } else if (key === "activar") {
        this.activate(id, title, text)
      }else if (key === "desactivar") {
        this.desactivate(id, title, text)
      }else {
        this.$bus.$emit(key, id);
      }
    },

    desactivate(id, title, text){
      this.$bvModal
        .msgBoxConfirm(text, {
          title: title,
          size: "md",
          buttonSize: "md",
          okVariant: "success",
          okTitle: "SI",
          cancelTitle: "NO",
          footerClass: "p-2",
          hideHeaderClose: false,
          centered: true,
        })
        .then((value) => {
          if (value) {
            putSimple(`membresias/${id}/deactivate`) //pendiente corrección en endpoint
              .then((response) => {
                if (!response) throw 'error'
                this.$bus.$emit("updateTable");
              })
              .catch(() => {
                this.$bvModal.msgBoxOk(
                  `No se pudo desactivar la membresía. Inténtelo más tarde.`,
                  {
                    title: "Error al desactivar",
                    size: "md",
                    buttonSize: "md",
                    okVariant: "danger",
                    headerClass: "p-2 border-bottom-0",
                    footerClass: "p-2 border-top-0",
                    centered: true,
                  }
                );
              });
          }
        });
    },

    activate(id, title, text){
      this.$bvModal
        .msgBoxConfirm(text, {
          title: title,
          size: "md",
          buttonSize: "md",
          okVariant: "success",
          okTitle: "SI",
          cancelTitle: "NO",
          footerClass: "p-2",
          hideHeaderClose: false,
          centered: true,
        })
        .then((value) => {
          if (value) {
            putSimple(`membresias/${id}/activate`)
              .then((response) => {
                if (!response) throw 'error'
                this.$bus.$emit("updateTable");
              })
              .catch(() => {
                this.$bvModal.msgBoxOk(
                  `No se pudo activar la membresía. Inténtelo más tarde.`,
                  {
                    title: "Error al activar",
                    size: "md",
                    buttonSize: "md",
                    okVariant: "danger",
                    headerClass: "p-2 border-bottom-0",
                    footerClass: "p-2 border-top-0",
                    centered: true,
                  }
                );
              });
          }
        });
    },

    
    
  },
};
</script>
<style
  lang="scss"
  src="../assets/scss/components/_verticalActions.scss"
></style>
