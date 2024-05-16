import './assets/main.css'

import VueSlider from 'vue-slider-component'
import 'vue-slider-component/theme/default.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

const app = createApp(App)

//app.component('VueSlider', VueSlider)

app.use(router)

app.mount('#app')
