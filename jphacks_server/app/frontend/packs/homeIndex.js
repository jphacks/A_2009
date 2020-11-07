import Vue from 'vue/dist/vue.esm'

import homeIndex from '../components/home/index'
import BootstrapVue from 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#homeIndex',
    data() {
      return {
        form: {
          email: ''
        }
      }
    },
    components: { homeIndex }
  })
})