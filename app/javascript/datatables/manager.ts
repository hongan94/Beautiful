// managers_table.ts
import { KTDataTable } from '../core/components/datatable/datatable';
import { swalSuccess, swalError } from '../utils/alerts';

// Beautifully configure the managers datatable
const managersTableConfig = {
  data: {
    type: 'remote',
    source: {
      read: {
        url: '/admin/managers.json',
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        }
      }
    },
    serverPaging: true,
    serverFiltering: true,
    serverSorting: true,
  },
  layout: {
    scroll: true,
    footer: false
  },
  columns: [
    {
      field: 'id',
      render: (_data: any, row: any) =>
        `<input class="checkbox checkbox-sm accent-primary" data-datatable-row-check="true" type="checkbox" value="${row?.id ?? ''}"/>`
    },
    {
      field: 'name',
      render: (_data: any, row: any) => {
        const avatarUrl = row?.avatar_url || 'avatars/300-3.png';
        const name = row?.name || '';
        const email = row?.email_address || '';
        return `
          <div class="flex items-center gap-3">
            <img src="${avatarUrl}" class="rounded-full size-9 shadow border border-gray-200" alt="${name}'s avatar" />
            <div class="flex flex-col">
              <a class="text-base font-semibold text-gray-900 hover:text-primary transition mb-0.5" href="/admin/managers/${row?.id}">
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
        // Add a data attribute for event binding
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
        return `
          <a class="btn btn-sm btn-icon btn-primary btn-clear" href="/admin/managers/${row?.id}/edit" title="Edit Manager">
            <i class="ki-filled ki-notepad-edit"></i>
          </a>
        `;
      }
    },
    {
      field: 'delete',
      render: (_data: any, row: any) => {
        return `
          <button type="button" class="btn btn-sm btn-icon btn-clear btn-danger delete-record" data-action="delete-record" data-id="${row?.id}" data-href="/admin/managers/${row?.id}" title="Delete Manager">
            <i class="ki-filled ki-trash"></i>
          </button>
        `;
      }
    }
  ],
};

const tableElement = document.querySelector('#managers_table');
let datatable: KTDataTable | undefined = undefined;
if (tableElement instanceof HTMLElement) {
  // Example: use other datatable functions after initialization
  datatable = new KTDataTable(tableElement, managersTableConfig);

  // Example: reload the table data
  // datatable.reload();

  // Example: go to page 2
  // datatable.goPage(2);

  // Example: set page size to 20
  // datatable.setPageSize(20);

  // Example: sort by 'name' column
  // datatable.sort('name');

  // Example: show spinner
  // datatable.showSpinner();

  // Example: hide spinner
  // datatable.hideSpinner();

  // Example: set a filter (replace 'status' and 'active' as needed)
  // datatable.setFilter({ column: 'status', value: 'active' });

  // Example: search
  // datatable.search('John Doe');
}

// Function to handle status checkbox change events (TypeScript)
function handleStatusCheckboxChange(event: Event): void {
  const target = event.target as HTMLInputElement;
  if (
    target &&
    target.dataset.statusCheckbox === "true"
  ) {
    const id: string | undefined = target.dataset.id;
    const checked: boolean = target.checked;

    fetch(`/admin/managers/update_status`, {
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
        swalSuccess('Status updated', `Manager status is now: ${data.status}`);
      } else {
        swalError('Failed to update status', data?.error || (data?.errors ? data.errors.join(', ') : 'Unknown error'));
      }
    })
    .catch((error: any) => {
      // Optionally handle error
      swalError('Error updating status', error?.message || 'An unexpected error occurred');
      // Optionally revert checkbox if error
      target.checked = !checked;
    });
  }
}
// Delegate event for dynamically rendered checkboxes
// Add change event listener to #managers_table
document.addEventListener('DOMContentLoaded', () => {
  const managersTable = document.getElementById('managers_table');
  if (managersTable) {
    managersTable.addEventListener('change', (event: Event) => {
      handleStatusCheckboxChange(event);
    });
  }
});


// Handle search and filter events for managers table

// Helper function to get current search/filter/sort values
function getManagerTableFilters() {
  const statusSelect = document.querySelector('.search-status') as HTMLSelectElement | null;
  const sortBySelect = document.querySelector('.sort-by') as HTMLSelectElement | null;

  return {
    status: statusSelect?.value || '',
    sort_by: sortBySelect?.value 
  };
}

// Function to reload datatable with filters
function reloadManagersTableWithFilters() {
  const filters = getManagerTableFilters();
  if (datatable) {
    // Set status filter (if supported by KTDataTable)
    if (typeof (datatable as any).setFilter === 'function') {
      if (filters.status) {
        (datatable as any).setFilter({ column: 'status', value: filters.status });
      }
      if (filters.sort_by) {
        (datatable as any).setFilter({ column: 'sort_by', value: filters.sort_by });
      }
    }
    // Reload the table (fetches new data from server)
    datatable.reload();
  }
}

// Save config to window for access in reload function
// @ts-ignore
window.managersTableConfig = managersTableConfig;

// Add event listeners for search, status, and sort
document.addEventListener('DOMContentLoaded', () => {
  const statusSelect = document.querySelector('.search-status') as HTMLSelectElement | null;
  const sortBySelect = document.querySelector('.sort-by') as HTMLSelectElement | null;

  if (statusSelect) {
    statusSelect.addEventListener('change', () => {
      reloadManagersTableWithFilters();
    });
  }

  if (sortBySelect) {
    sortBySelect.addEventListener('change', () => {
      reloadManagersTableWithFilters();
    });
  }
});
