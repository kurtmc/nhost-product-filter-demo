<script setup lang="ts">
import VueSlider from 'vue-slider-component'

import { ref, onMounted } from 'vue'
import { nhost } from "./lib/nhost"


const getPumpsQuery = `
query GetPumps {
  Pumps(where: {Power: {_gte: "0", _lte: "9999"}, Weight: {_gte: "0", _lte: "9999"}, FlowRate: {_gte: "0", _lte: "9999"}}) {
    ID
    Power
    ProductName
    Weight
    FlowRate
    submersible
  }
}
`;

function getQuery(flowRate: int[], power: int[], weight: int[], submersible: boolean) {
console.log(submersible)
return `
query GetPumps {
  Pumps(where: {Power: {_gte: "${power[0]}", _lte: "${power[1]}"}, Weight: {_gte: "${weight[0]}", _lte: "${weight[1]}"}, FlowRate: {_gte: "${flowRate[0]}", _lte: "${flowRate[1]}"}, submersible: {_eq: ${submersible}}}) {
    ID
    Power
    ProductName
    Weight
    FlowRate
    submersible
  }
}
`;
}

var flowRate = [0, 1000];
var power = [0, 1000];
var weight = [0, 1000];
var submersible = false;

const pumps = ref([])

async function getPumps() {
  const { data } = await nhost.graphql.request(getPumpsQuery)
  pumps.value = data.Pumps
}

onMounted(() => {
  getPumps()
})

async function updatePumps() {
  console.log(flowRate)
  const { data } = await nhost.graphql.request(getQuery(flowRate, power, weight, submersible))
  pumps.value = data.Pumps
}

function marks(val) {
  return val % 200 === 0
}



</script>

<template>
  <div class="container-fluid" style="width: 100%;">
    <div id="specifications" class="card" style="width: 18rem;">
      <div class="card-header">
        Specifications
      </div>
      <ul class="list-group list-group-flush">
        <li class="list-group-item"><p>Flow rate</p><vue-slider v-model="flowRate" :enable-cross="false" @change="updatePumps" :min="0" :max="1000" :interval="10" :marks="marks" ></vue-slider></li>
        <li class="list-group-item"><p>Power</p><vue-slider v-model="power" :enable-cross="false" @change="updatePumps" :min="0" :max="1000" :interval="10" :marks="marks"></vue-slider></li>
        <li class="list-group-item"><p>Weight</p><vue-slider v-model="weight" :enable-cross="false" @change="updatePumps" :min="0" :max="1000" :interval="10" :marks="marks"></vue-slider></li>
        <li class="list-group-item"><p>Submersible</p><input v-model="submersible" @change="updatePumps" type="checkbox"></li>
      </ul>
    </div>

    <div class="row align-items-start">
      <div class="col-12" style="width: 2000px;">
      </div>
      <div class="col-3 pump-col" v-for="pump in pumps" :key="pump.ID">
        <div class="card" style="width: 18rem;">
          <img src="https://kagi.com/proxy/rLwWxiMnVNSS0wFK78id.jpg?c=DjRpTFMOWGZtpUo5aJA5fHKmHsAjTiteSsH5_h_u0NDAMViUWje_1WrkIo_5mvnI7TCRTROD7ao8Wm-WoG-MAMulZkiLSjd63vshskBq-vMRnsf7cgh_MQutSXqWqn_h" class="card-img-top" alt="...">
          <div class="card-body">
            <h5 class="card-title">{{ pump.ProductName }}</h5>
            <p class="card-text">Flow rate: {{ pump.FlowRate }}</p>
            <p class="card-text">Power: {{ pump.Power }}</p>
            <p class="card-text">Weight: {{ pump.Weight }}</p>
            <p v-if="pump.submersible" class="card-text">Submersible: yes</p>
            <p v-else class="card-text">Submersible: no</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import '../node_modules/bootstrap/dist/css/bootstrap.css';

header {
  line-height: 1.5;
  max-height: 100vh;
}

.logo {
  display: block;
  margin: 0 auto 2rem;
}

nav {
  width: 100%;
  font-size: 12px;
  text-align: center;
  margin-top: 2rem;
}

nav a.router-link-exact-active {
  color: var(--color-text);
}

nav a.router-link-exact-active:hover {
  background-color: transparent;
}

nav a {
  display: inline-block;
  padding: 0 1rem;
  border-left: 1px solid var(--color-border);
}

nav a:first-of-type {
  border: 0;
}

.pump-col {
  width: 100%;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }

  #specifications {
    position: fixed;
    left: 1em;
    top: 1em;
  }
  .pump-col {
    width: 25%;
  }
}

table {
  padding: 16px;
  border: 2px solid rgb(140 140 140);
  font-family: sans-serif;
  font-size: 0.8rem;
  letter-spacing: 1px;
}

.card {
  border: 2px solid rgb(140 140 140);
  border-radius: 10px;
  margin: 20px;
}
.card-img-top {
  border-radius: 8px 8px 0px 0px;
}
</style>
