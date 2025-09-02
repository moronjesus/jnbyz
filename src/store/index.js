import Vue from 'vue'
import Vuex from 'vuex'
import createPersistedState from 'vuex-persistedstate'

Vue.use(Vuex)

const state = {
    user: null,
    auth: false,
    token: null,
    token_UNNE: null,
    token_UXXI: null
}

const getters = {
    user: state => state.user,
    auth: state => state.auth,
    token: state => state.token,
    token_UNNE : state => state.token_UNNE,
    token_UXXI : state => state.token_UXXI
}

const mutations = {
    doLogin(state, data) {
        state.token = data.token
    },
    doLoginUNNE(state, data) {
        state.token_UNNE = data.token_UNNE
    },
    doLoginUXXI(state, data) {
        state.token_UXXI = data.token_UXXI
    },
    doUser(state, data){
        state.auth = true;
        state.user = data.user
    },
    doLogout(state) {
        state.auth = false;
        state.user = null;
        state.token = null;
        state.token_UNNE = null;
        state.token_UXXI = null;
    }
}

const actions = {
    doLogin({ commit }, data) {
        commit("doLogin", data);
    },
    doLoginUNNE({ commit }, data) {
        commit("doLoginUNNE", data);
    },
    doLoginUXXI({ commit }, data) {
        commit("doLoginUXXI", data);
    },
    doLogout({ commit }) {
        commit("doLogout");
    },
    doUser({ commit }, data) {
        commit("doUser", data);
    }
}



const store = new Vuex.Store({
    plugins: [createPersistedState({
      storage: window.sessionStorage,
    })],
 state,
 getters,
 mutations,
 actions
})

export default store