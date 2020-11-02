import Vue from 'vue/dist/vue.esm'

// import MaterialForm from '../components/material/form'
import BootstrapVue from 'bootstrap-vue'

import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#materialForm',
    data() {
      return {
        form: {
          email: ''
        }
      }
    }
    // components: { MaterialForm }
  })
})