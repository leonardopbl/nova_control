<script setup lang="ts">
const drawer = defineModel<boolean>({ default: true });
</script>

<template>
  <v-navigation-drawer
    v-model="drawer"
    permanent
    rail
    expand-on-hover
    class="drawer-container"
  >
    <v-list>
      <v-list-item
        prepend-avatar="https://randomuser.me/api/portraits/women/85.jpg"
        subtitle="sandra_a88@gmail.com"
        title="Sandra Adams"
      />
    </v-list>

    <v-divider />

    <v-list density="compact" nav>
      <v-list-item prepend-icon="mdi-view-dashboard-outline" title="Dashboard" />
      <v-list-item prepend-icon="mdi-cash-multiple" title="Despesas" />
      <v-list-item prepend-icon="mdi-file-chart-outline" title="Relatórios" />
    </v-list>
  </v-navigation-drawer>
</template>

<style scoped>
.drawer-container {
  background-color: #939393;
}
</style>
