import Vue from "vue";
import VueRouter from "vue-router";

import Login from "@/views/Login.vue";

import Dashboard from "@/views/Dashboard.vue";

import Centros from "@/views/Centros.vue";

import Planes from "@/views/Planes.vue";

import Personas from "@/views/Personas.vue";

import AnadirMiembro from "@/views/AnadirMiembro.vue";

import DetallePersona from "@/views/DetallePersona.vue";

import EditarMembresia from "@/views/EditarMembresia.vue";

import Campus from "@/views/Campus.vue";

import e404 from "@/views/e404.vue";

import store from "../store";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Login",
    component: Login,
  },
  {
    path: "/dashboard",
    name: "Dashboard",
    component: Dashboard,
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: "/centros",
    name: "Centros",
    component: Centros,
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: "/planes",
    name: "Planes",
    component: Planes,
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: "/personas",
    name: "Personas",
    component: Personas,
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: "/anadir-miembro",
    name: "AnadirMiembro",
    component: AnadirMiembro,
    meta: {
      requiresAuth: true,
    },
    props: true,
  },
  {
    path: "/personas/detalle",
    name: "DetallePersona",
    component: DetallePersona,
    meta: {
      requiresAuth: true,
    },
    props: true,
  },
  {
    path: "/membresia/editar",
    name: "EditarMembresia",
    component: EditarMembresia,
    meta: {
      requiresAuth: true,
    },
    props: true,
  },
  {
    path: "/campus",
    name: "Campus",
    component: Campus,
    meta: {
      requiresAuth: true,
    },
  },
  {
    path: "*",
    name: "e404",
    component: e404,
    meta: {
      requiresAuth: true,
    },
  }
];

const router = new VueRouter({
  mode: "history",
  base: process.env.VUE_APP_BASE_URL,
  routes,
});

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (store.state.auth) {
      next();
    } else {
      router.push({ name: "Login" });
    }
  } else {
    next();
  }
});

export default router;
