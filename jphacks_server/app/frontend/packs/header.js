import Vue from 'vue/dist/vue.esm'

import HeaderNav from '../components/shared/header'
import BootstrapVue from 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#header',
     data: {
      message: "Can you say hello?"
    },
    components: { HeaderNav }
  })
})