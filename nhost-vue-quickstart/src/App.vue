<script setup lang="ts">
import VueSlider from 'vue-slider-component'

import { ref, onMounted } from 'vue'
import { nhost } from "./lib/nhost"


//const getPumpsQuery = `
//query GetPumps {
//  Pumps(where: {Power: {_gte: "0", _lte: "9999"}, Weight: {_gte: "0", _lte: "9999"}, FlowRate: {_gte: "0", _lte: "9999"}}) {
//    ID
//    Power
//    ProductName
//    Weight
//    FlowRate
//    submersible
//  }
//}
//`;
const getPumpsQueryV2 = `
query GetPumps {
  Pumps_v2(limit: 10, where: {PRESSURE_BAR: {_gte: "0", _lte: "100"}}) {
    CC_STROKE
    FLOAT_SWITCH
    FLOW_L_H
    HEAD_O_RING_EP
    HEAD_O_RING_FP
    HEAD_PP_SEAL_EP
    HEAD_PVDF_SEAL_EP
    HEAD_PVDF_SEAL_FP
    INPUT
    INPUT_TYPE
    PRESSURE_BAR
    PUMP_HEAD_CODE
    PUMP_SERIES
    STROKE_LENGTH_ADJ
    STROKE_SPEED_ADJ
    TUBE_SIZE_ID_X_OD
    diaphragm
    model
  }
  files {
    id
    name
  }
}
`;

function getQuery(pressureBar: int[]) {
return `
query GetPumps {
  Pumps_v2(limit: 10, where: {PRESSURE_BAR: {_gte: "${pressureBar[0]}", _lte: "${pressureBar[1]}"}}) {
    CC_STROKE
    FLOAT_SWITCH
    FLOW_L_H
    HEAD_O_RING_EP
    HEAD_O_RING_FP
    HEAD_PP_SEAL_EP
    HEAD_PVDF_SEAL_EP
    HEAD_PVDF_SEAL_FP
    INPUT
    INPUT_TYPE
    PRESSURE_BAR
    PUMP_HEAD_CODE
    PUMP_SERIES
    STROKE_LENGTH_ADJ
    STROKE_SPEED_ADJ
    TUBE_SIZE_ID_X_OD
    diaphragm
    model
  }
  files {
    id
    name
  }
}
`;
}

var flowRate = [0, 1000];
var pressureBar = [0, 100];
var power = [0, 1000];
var weight = [0, 1000];
var submersible = false;

const pumps = ref([])

function appendPublicUrl(data) {
  for (var pump of data.Pumps_v2) {
    if (data.files != null) {
      for (var file of data.files) {
        if (pump.PUMP_SERIES + ".png" === file.name) {
          pump.PublicUrl = "https://wkpurnuzgmelrnnrljvu.storage.ap-southeast-1.nhost.run/v1/files/" + file.id
        }
      }
    }
  }
}

async function getPumps() {
  const { data } = await nhost.graphql.request(getPumpsQueryV2)
  appendPublicUrl(data)
  pumps.value = data.Pumps_v2
}

onMounted(() => {
  getPumps()
})

async function updatePumps() {
  const { data } = await nhost.graphql.request(getQuery(pressureBar))
  appendPublicUrl(data)
  pumps.value = data.Pumps_v2
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
        <li class="list-group-item"><p>Pressure BAR</p><vue-slider v-model="pressureBar" :enable-cross="false" @change="updatePumps" :min="0" :max="100" :interval="1"  ></vue-slider></li>
        <!--<li class="list-group-item"><p>Flow rate</p><vue-slider v-model="flowRate" :enable-cross="false" @change="updatePumps" :min="0" :max="1000" :interval="10" :marks="marks" ></vue-slider></li>
        <li class="list-group-item"><p>Power</p><vue-slider v-model="power" :enable-cross="false" @change="updatePumps" :min="0" :max="1000" :interval="10" :marks="marks"></vue-slider></li>
        <li class="list-group-item"><p>Weight</p><vue-slider v-model="weight" :enable-cross="false" @change="updatePumps" :min="0" :max="1000" :interval="10" :marks="marks"></vue-slider></li>
        <li class="list-group-item"><p>Submersible</p><input v-model="submersible" @change="updatePumps" type="checkbox"></li>-->
      </ul>
    </div>

    <div class="row align-items-start">
      <div class="col-12" style="width: 2000px;">
      </div>
      <div class="col-3 pump-col" v-for="pump in pumps" :key="pump.ID">
        <div class="card" style="width: 18rem;">
          <img v-bind:src="pump.PublicUrl" class="card-img-top" alt="...">
          <div class="card-body">
            <h5 class="card-title">{{ pump.PUMP_SERIES }} {{ pump.model }}</h5>

              <p class="card-text">CC_STROKE: {{ pump.CC_STROKE }}</p>
              <p v-if="pump.FLOAT_SWITCH" class="card-text">FLOAT_SWITCH: {{ pump.FLOAT_SWITCH }}</p>
              <p class="card-text">FLOW_L_H: {{ pump.FLOW_L_H }}</p>
              <p class="card-text">HEAD_O_RING_EP: {{ pump.HEAD_O_RING_EP }}</p>
              <p class="card-text">HEAD_O_RING_FP: {{ pump.HEAD_O_RING_FP }}</p>
              <p class="card-text">HEAD_PP_SEAL_EP: {{ pump.HEAD_PP_SEAL_EP }}</p>
              <p class="card-text">HEAD_PVDF_SEAL_EP: {{ pump.HEAD_PVDF_SEAL_EP }}</p>
              <p class="card-text">HEAD_PVDF_SEAL_FP: {{ pump.HEAD_PVDF_SEAL_FP }}</p>
              <p v-if="pump.INPUT" class="card-text">INPUT: {{ pump.INPUT }}</p>
              <p v-if="pump.INPUT_TYPE" class="card-text">INPUT_TYPE: {{ pump.INPUT_TYPE }}</p>
              <p class="card-text">PRESSURE_BAR: {{ pump.PRESSURE_BAR }}</p>
              <p class="card-text">PUMP_HEAD_CODE: {{ pump.PUMP_HEAD_CODE }}</p>
              <p v-if="pump.STROKE_LENGTH_ADJ" class="card-text">STROKE_LENGTH_ADJ: {{ pump.STROKE_LENGTH_ADJ }}</p>
              <p class="card-text">STROKE_SPEED_ADJ: {{ pump.STROKE_SPEED_ADJ }}</p>
              <p class="card-text">TUBE_SIZE_ID_X_OD: {{ pump.TUBE_SIZE_ID_X_OD }}</p>
              <p class="card-text">diaphragm: {{ pump.diaphragm }}</p>

            <!--<p class="card-text">Flow rate: {{ pump.FlowRate }}</p>
            <p class="card-text">Power: {{ pump.Power }}</p>
            <p class="card-text">Weight: {{ pump.Weight }}</p>
            <p v-if="pump.submersible" class="card-text">Submersible: yes</p>
            <p v-else class="card-text">Submersible: no</p>-->
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
