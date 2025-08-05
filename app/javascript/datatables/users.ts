import { initializeDataTable, DataTableConfig } from './common';

// Configure the users datatable
const usersConfig: DataTableConfig = {
  namespace: 'users',
  tableId: 'users_table',
  apiEndpoint: '/admin/users.json',
  updateStatusEndpoint: '/admin/users/update_status',
  editUrl: '/admin/users/{id}/edit',
  detailUrl: '#' // Users don't have detail pages, so use #
};

// Initialize the users datatable
const usersDatatable = initializeDataTable(usersConfig);
