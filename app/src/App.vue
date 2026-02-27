<script setup lang="ts">
import { ref } from "vue";
import DrawerMenu from "./components/DrawerMenu.vue";

const year = ref("2026");
const month = ref("01");
const drawer = ref(true);
const years = [
  { label: "2026", value: "2026" },
  { label: "2027", value: "2027" },
  { label: "2028", value: "2028" },
  { label: "2029", value: "2029" },
  { label: "2030", value: "2030" },
  { label: "2031", value: "2031" },
  { label: "2032", value: "2032" },
];
const months = [
  { label: "January", value: "01" },
  { label: "February", value: "02" },
  { label: "March", value: "03" },
  { label: "April", value: "04" },
  { label: "May", value: "05" },
  { label: "June", value: "06" },
  { label: "July", value: "07" },
  { label: "August", value: "08" },
  { label: "September", value: "09" },
  { label: "October", value: "10" },
  { label: "November", value: "11" },
  { label: "December", value: "12" },
];

const tableHeaders = [
  { title: "Despesa", key: "name" },
  { title: "Vencimento", key: "dueDate" },
  { title: "Categoria", key: "category" },
  { title: "Valor", key: "value", align: "end" as const },
];

const expenses = ref([
  { name: "Aluguel", dueDate: "05/01/2026", category: "Moradia", value: 2200 },
  { name: "Energia", dueDate: "10/01/2026", category: "Utilidades", value: 340 },
  { name: "Internet", dueDate: "12/01/2026", category: "Utilidades", value: 129 },
  {
    name: "Supermercado",
    dueDate: "15/01/2026",
    category: "Alimentação",
    value: 860,
  },
]);

const formatCurrency = (value: number) =>
  new Intl.NumberFormat("pt-BR", { style: "currency", currency: "BRL" }).format(
    value
  );
</script>

<template>
  <v-app class="app">
    <v-layout class="app-layout">
      <DrawerMenu v-model="drawer" />
      <v-main class="main-content">
        <v-container fluid class="tabs-container">
          <v-tabs
            v-model="year"
            class="tabs font-black rounded mb-4"
            align-tabs="center"
            bg-color="white"
            center-active
          >
            <v-tab
              v-for="(year, index) in years"
              :value="year.value"
              :key="index"
            >
              {{ year.label }}
            </v-tab>
          </v-tabs>
          <v-tabs-window v-model="year">
            <v-tabs-window-item
              v-for="year in years"
              :key="year.value"
              :value="year.value"
            >
              <!-- CONTEUDO DO ANO -->
              <v-tabs
                v-model="month"
                class="tabs rounded-t"
                bg-color="white"
                center-active
              >
                <v-tab
                  v-for="month in months"
                  :key="month.value"
                  :value="month.value"
                >
                  {{ month.label }}
                </v-tab>
              </v-tabs>
              <v-tabs-window v-model="month">
                <v-tabs-window-item
                  v-for="month in months"
                  :key="month.value"
                  :value="month.value"
                >
                  <!-- CONTEUDO DO MES -->
                  <v-card class="content pa-4 bg-white rounded-t-0">
                    <v-data-table
                      :headers="tableHeaders"
                      :items="expenses"
                      class="expenses-table"
                      hide-default-footer
                    >
                      <template #item.value="{ item }">
                        {{ formatCurrency(item.value) }}
                      </template>
                    </v-data-table>
                  </v-card>
                </v-tabs-window-item>
              </v-tabs-window>
            </v-tabs-window-item>
          </v-tabs-window>
        </v-container>
      </v-main>
    </v-layout>
  </v-app>
</template>

<style scoped>
.tabs-container {
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  padding-top: 24px;
  max-width: 1280px;
}

.tabs {
  gap: 20px;
  width: 100%;
}

.content {
  width: 100%;
}

.app {
  background-color: #939393;
}

.app-layout {
  min-height: 100vh;
}

.main-content {
  background-color: #939393;
}

.expenses-table {
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  overflow: hidden;
}
</style>
