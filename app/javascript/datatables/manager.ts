import { initializeDataTable, DataTableConfig } from './common';

// Configure the managers datatable
const managersConfig: DataTableConfig = {
  namespace: 'managers',
  tableId: 'managers_table',
  apiEndpoint: '/admin/managers.json',
  updateStatusEndpoint: '/admin/managers/update_status',
  editUrl: '/admin/managers/{id}/edit',
  detailUrl: '/admin/managers/{id}' // Managers have detail pages
};

// Initialize the managers datatable
const managersDatatable = initializeDataTable(managersConfig);
