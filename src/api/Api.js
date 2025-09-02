import axios from "axios";
import store from '@/store'
import router from '@/router'

export async function getSimple(endPoint, params = {}, api= 0) {
  try {
    let app_api = "";
    let header = {};

    switch (api) {
      case "UNNE":
        app_api = process.env.VUE_APP_API_UNNE;
        header = {
          "Authorization": "Bearer " + store.state.token_UNNE
        };
        break;
      case "GRP":
        app_api = process.env.VUE_APP_API_GRP;
        header = {"Authorization": "Bearer " + store.state.token};
        break;
      case "UXXI":
        app_api = process.env.VUE_APP_API_UXXI;
        header = {
          "Authorization": "Bearer " + store.state.token_UXXI
        };
        break;
      default:
        app_api = process.env.VUE_APP_API_UNNE;
        header = {"Authorization": "Bearer " + store.state.token_UNNE};
        break;
    } 
    
    let response = await axios({
      method: "GET",
      url: `${app_api}${endPoint}`,
      params: params,
      headers: {
        ...header
      },
    });

    if (response.data) {
      return response.data;
    }
  } catch (error) {
    console.log('error api:' + error);
    if(error.message != undefined){
      return error
    } 

  }
}

export async function postSimple(endPoint, params = {}, useBody = false) {
  try {
    let response
    if (useBody) {
      response = await axios({
        method: "POST",
        url: `${process.env.VUE_APP_API_GRP}${endPoint}`,
        data: params,
        headers: {
          "Authorization": "Bearer " + store.state.token
        }
      });
    } else {
      response = await axios({
        method: "POST",
        url: `${process.env.VUE_APP_API_GRP}${endPoint}`,
        params: params,
      });
    }

    if (response.data) {
      return response.data;
    }
  } catch (error) {
    console.log('error api:' + error);
    return error
  }
}

export async function putSimple(endPoint, params = {}) {
  try {
    let response = await axios({
      method: "PUT",
      url: `${process.env.VUE_APP_API_GRP}${endPoint}`,
      data: params,
      headers: {
        "Authorization": "Bearer " + store.state.token
      }
    });
    if (response) {
      return response;
    }
  } catch (error) {
    console.log('error api:' + error);
  }
}

export async function deleteSimple(endPoint, params = {}) {
  try {
    let response = await axios({
      method: "DELETE",
      url: `${process.env.VUE_APP_API_GRP}${endPoint}`,
      data: params,
      headers: {
        "Authorization": "Bearer " + store.state.token
      }
    });
    if (response) {
      return response;
    }
  } catch (error) {
    console.log('error api:' + error);
  }
}

// Add a response interceptor
axios.interceptors.response.use( response => {
  return response;
}, error => {
  if(error.response.status == 401){
    store.dispatch("doLogout").then(() => {
      router.push({ name: "Login" });
      error.message = "Es necesario estar logueado para acceder. Vuelva a hacer login."
    })
    
  } else if(error.response.status == 403){
    store.dispatch("doLogout").then(() => {
      router.push({ name: "Login" });
      error.message = "No tiene los permisos necesarios para acceder o loguearse."
    })
    
  } 
  return Promise.reject(error);
});