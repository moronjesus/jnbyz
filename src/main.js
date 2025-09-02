import Vue from 'vue'
import App from './App.vue'
import './registerServiceWorker'
import router from '@/router/index.js'

import store from '@/store'

import { BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import '@/assets/scss/main.scss';


Vue.use(BootstrapVue)
Vue.use(BootstrapVueIcons)

import excel from 'vue-excel-export'
Vue.use(excel)

import { ValidationProvider, ValidationObserver, extend, localize } from 'vee-validate/dist/vee-validate';
import es from 'vee-validate/dist/locale/es.json';
import * as rules from 'vee-validate/dist/rules';

// install rules and localization
Object.keys(rules).forEach(rule => {
  extend(rule, rules[rule]);
});

localize('es', es);
Vue.component('ValidationObserver', ValidationObserver);
Vue.component('ValidationProvider', ValidationProvider);

Vue.config.productionTip = false

// global bus
const EventBus = new Vue()
Vue.prototype.$bus = EventBus

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')