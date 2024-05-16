<script setup lang="ts">
import VueSlider from 'vue-slider-component'
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'

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
  }
}
`;

function getQuery(minFlowRate: int, minPower: int, minWeight: int) {
return `
query GetPumps {
  Pumps(where: {Power: {_gte: "${minPower}", _lte: "9999"}, Weight: {_gte: "${minWeight}", _lte: "9999"}, FlowRate: {_gte: "${minFlowRate}", _lte: "9999"}}) {
    ID
    Power
    ProductName
    Weight
    FlowRate
  }
}
`;
}

var minFlowRate = 0;
var minPower = 0;
var minWeight = 0;

const pumps = ref([])

async function getPumps() {
  const { data } = await nhost.graphql.request(getPumpsQuery)
  pumps.value = data.Pumps
}

onMounted(() => {
  getPumps()
})

async function updatePumps() {
  const { data } = await nhost.graphql.request(getQuery(minFlowRate, minPower, minWeight))
  pumps.value = data.Pumps
}

//async function updatePumps(minFlowRate) {
//  console.log("minFlowRate")
//  console.log(minFlowRate)
//
//  //const { data } = await nhost.graphql.request(getQuery(minFlowRate))
//  //pumps.value = data.Pumps
//}

</script>

<template>
   <div>
    <table>
        <tr>
          <td>Minimum flow rate</td>
        </tr>
        <tr>
          <td><vue-slider v-model="minFlowRate" :enable-cross="false" @change="updatePumps"></vue-slider></td>
        </tr>
        <br/>
        <tr>
          <td>Minimum power</td>
        </tr>
        <tr>
          <td><vue-slider v-model="minPower" :enable-cross="false" @change="updatePumps"></vue-slider></td>
        </tr>
        <br/>
        <tr>
          <td>Minimum weight</td>
        </tr>
        <tr>
          <td><vue-slider v-model="minWeight" :enable-cross="false" @change="updatePumps"></vue-slider></td>
        </tr>
    </table>
   </div>
  <p></p>
  <!-- https://nightcatsama.github.io/vue-slider-component/#/basics/simple -->
        <br/>
        <br/>
  
   <div>
    <table>
      <thead>
        <th>Name</th>
        <th>Flow Rate</th>
        <th>Power</th>
        <th>Weight</th>
      </thead>
      <tbody>
        <tr v-for="pump in pumps" :key="pump.id">
          <td>{{ pump.ProductName }}</td>
          <td>{{ pump.FlowRate }}</td>
          <td>{{ pump.Power }}</td>
          <td>{{ pump.Weight }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<style scoped>
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
}

table {
  border: 2px solid rgb(140 140 140);
  font-family: sans-serif;
  font-size: 0.8rem;
  letter-spacing: 1px;
}
</style>
