<script setup lang="ts">
import { RouterLink, RouterView } from 'vue-router'
import HelloWorld from './components/HelloWorld.vue'

import { ref, onMounted } from 'vue'
import { nhost } from "./lib/nhost"


const getPumpsQuery = `
query GetPumps {
  Pumps(where: {Power: {_gte: "0", _lte: "9999"}, Weight: {_gte: "0", _lte: "9999"}}) {
    FlowRate
    ID
    Power
    ProductName
    Weight
  }
}

`;

const pumps = ref([])
async function getPumps() {
  const { data } = await nhost.graphql.request(getPumpsQuery)
  pumps.value = data.pumps
}

onMounted(() => {
  getPumps()
})

</script>

<template>


   <div>
    <table>
      <tbody>
        <tr v-for="pump in pumps" :key="pump.id">
          <td>{{ pump.ProductName }}</td>
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
</style>
