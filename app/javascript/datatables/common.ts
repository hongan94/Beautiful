import { KTDataTable } from '../core/components/datatable/datatable';
import { swalSuccess, swalError } from '../utils/alerts';

// Interface for datatable configuration
interface DataTableConfig {
  namespace: string; // 'users' or 'managers'
  tableId: string; // 'users_table' or 'managers_table'
  apiEndpoint: string; // '/admin/users.json' or '/admin/managers.json'
  updateStatusEndpoint: string; // '/admin/users/update_status' or '/admin/managers/update_status'
  editUrl: string; // '/admin/users/{id}/edit' or '/admin/managers/{id}/edit'
  detailUrl?: string; // Optional detail page URL
}

// Common datatable configuration factory
function createDataTableConfig(config: DataTableConfig): any {
  return {
    data: {
      type: 'remote',
      source: {
        read: {
          url: config.apiEndpoint,
          method: 'GET',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json'
          },
          map: function (raw: any) {
            return raw || [];
          }
        }
      },
      serverPaging: true,
      serverFiltering: true,
      serverSorting: true,
    },
    layout: {
      scroll: true,
      footer: false,
    },
    columns: [
      {
        field: 'id',
        render: (_data: any, row: any) =>
          `<input class="checkbox checkbox-sm accent-primary checkbox-row" data-datatable-row-check="true" type="checkbox" value="${row?.id ?? ''}"/>`
      },
      {
        field: 'name',
        render: (_data: any, row: any) => {
          const avatarUrl = row?.avatar_url || 'avatars/blank.png';
          const name = row?.name || '';
          const email = row?.email_address || '';
          const detailLink = config.detailUrl ? config.detailUrl.replace('{id}', row?.id) : '#';
          return `
            <div class="flex items-center gap-3">
              <img src="${avatarUrl}" class="rounded-full size-9 shadow border border-gray-200" alt="${name}'s avatar" />
              <div class="flex flex-col">
                <a class="text-base font-semibold text-gray-900 hover:text-primary transition mb-0.5" href="${detailLink}">
                  ${name}
                </a>
                <a class="text-sm text-gray-600 font-normal hover:text-primary transition" href="mailto:${email}">
                  ${email}
                </a>
              </div>
            </div>
          `;
        }
      },
      {
        field: 'phone_number',
      },
      {
        field: 'gender',
      },
      {
        field: 'address',
      },
      {
        field: 'status',
        render: (_data: any, row: any) => {
          const status = row?.status ?? '';
          const id = row?.id ?? '';
          return `
            <label class="switch switch-sm">
              <input type="checkbox" value="1" data-status-checkbox="true" data-id="${id}" ${status === 'active' ? 'checked' : ''}/>
            </label>
          `;
        }
      },
      {
        field: 'created_at',
      },
      {
        field: 'edit',
        render: (_data: any, row: any) => {
          const editUrl = config.editUrl.replace('{id}', row?.id);
          return `
            <a class="btn btn-sm btn-icon btn-primary btn-clear" href="${editUrl}" title="Edit ${config.namespace.charAt(0).toUpperCase() + config.namespace.slice(1)}">
              <i class="ki-filled ki-notepad-edit"></i>
            </a>
          `;
        }
      },
      {
        field: 'delete',
        render: (_data: any, row: any) => {
          const deleteUrl = config.editUrl.replace('/edit', '').replace('{id}', row?.id);
          return `
            <button type="button" class="btn btn-sm btn-icon btn-clear btn-danger delete-record" data-action="delete-record" data-id="${row?.id}" data-href="${deleteUrl}" title="Delete ${config.namespace.charAt(0).toUpperCase() + config.namespace.slice(1)}">
              <i class="ki-filled ki-trash"></i>
            </button>
          `;
        }
      }
    ]
  };
}

// Common status checkbox change handler
function handleStatusCheckboxChange(event: Event, config: DataTableConfig): void {
  const target = event.target as HTMLInputElement;
  if (target && target.dataset.statusCheckbox === "true") {
    const id: string | undefined = target.dataset.id;
    const checked: boolean = target.checked;
    
    fetch(config.updateStatusEndpoint, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content || ''
      },
      body: JSON.stringify({ status: checked ? 'active' : 'inactive', id: id })
    })
    .then((response: Response) => response.json())
    .then((data: any) => {
      if (data && data.success) {
        const entityName = config.namespace.charAt(0).toUpperCase() + config.namespace.slice(1);
        swalSuccess('Status updated', `${entityName} status is now: ${data.status}`);
      } else {
        swalError('Failed to update status', data?.error || (data?.errors ? data.errors.join(', ') : 'Unknown error'));
      }
    })
    .catch((error: any) => {
      swalError('Error updating status', error?.message || 'An unexpected error occurred');
      // Optionally revert checkbox if error
      target.checked = !checked;
    });
  }
}

// Common filter helper function
function getTableFilters() {
  const statusSelect = document.querySelector('.search-status') as HTMLSelectElement | null;
  const sortBySelect = document.querySelector('.sort-by') as HTMLSelectElement | null;

  return {
    status: statusSelect?.value || '',
    sort_by: sortBySelect?.value 
  };
}

// Common reload function
function reloadTableWithFilters(datatable: any) {
  const filters = getTableFilters();
  if (datatable) {
    // Set status filter (if supported by KTDataTable)
    if (typeof datatable.setFilter === 'function') {
      if (filters.status) {
        datatable.setFilter({ column: 'status', value: filters.status });
      }
      if (filters.sort_by) {
        datatable.setFilter({ column: 'sort_by', value: filters.sort_by });
      }
    }
    // Reload the table (fetches new data from server)
    datatable.reload();
  }
}

// Main function to initialize a datatable
function initializeDataTable(config: DataTableConfig): any {
  const tableElement = document.querySelector(`#${config.tableId}`);
  let datatable: any = undefined;
  
  if (tableElement instanceof HTMLElement) {
    const tableConfig = createDataTableConfig(config);
    datatable = new KTDataTable(tableElement, tableConfig);

    // Save config to window for access in reload function
    // @ts-ignore
    window[`${config.namespace}TableConfig`] = tableConfig;

    // Add event listeners for status checkbox changes
    tableElement.addEventListener('change', (event: Event) => {
      handleStatusCheckboxChange(event, config);
    });

    // Add event listeners for search, status, and sort
    document.addEventListener('DOMContentLoaded', () => {
      const statusSelect = document.querySelector('.search-status') as HTMLSelectElement | null;
      const sortBySelect = document.querySelector('.sort-by') as HTMLSelectElement | null;

      if (statusSelect) {
        statusSelect.addEventListener('change', () => {
          reloadTableWithFilters(datatable);
        });
      }

      if (sortBySelect) {
        sortBySelect.addEventListener('change', () => {
          reloadTableWithFilters(datatable);
        });
      }
    });
  }

  return datatable;
}

document.addEventListener("DOMContentLoaded", function() {
  const exportBtn = document.getElementById("export-excel-btn");
  if (exportBtn) {
    exportBtn.addEventListener("click", function(e) {
      e.preventDefault();
      // Collect checked checkboxes with class 'checkbox-row'
      const checked = Array.from(document.querySelectorAll<HTMLInputElement>('.checkbox-row:checked')).map(cb => cb.value);
      // NOTE: You must set this URL server-side, e.g. via a data attribute or global JS variable
      const url = (exportBtn as HTMLElement).getAttribute('data-export-url')
      if (checked.length > 0) {
        // Send selected IDs as params
        const params = new URLSearchParams();
        checked.forEach(id => params.append('ids[]', id));
        window.location.href = url + "?" + params.toString();
      } else {
        // No selection, export all
        window.location.href = url;
      }
    });
  }
});


// Export the main function and types
export { initializeDataTable, DataTableConfig }; 