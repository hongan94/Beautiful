// managers_table.ts
import { KTDataTable } from '../core/components/datatable/datatable';

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
          <a class="btn btn-sm btn-icon btn-clear btn-danger" href="/admin/managers/${row?.id}" data-method="delete" data-confirm="Are you sure you want to delete this manager?" rel="nofollow" title="Delete Manager">
            <i class="ki-filled ki-trash"></i>
          </a>
        `;
      }
    }
  ],
};

const tableElement = document.querySelector('#managers_table');
if (tableElement instanceof HTMLElement) {
  const datatable = new KTDataTable(tableElement, managersTableConfig);
}

// Function to handle status checkbox change events (TypeScript)
function handleStatusCheckboxChange(event: Event): void {
  const target = event.target as HTMLInputElement;
  if (target && target.dataset.statusCheckbox === "true") {
    const id: string | undefined = target.dataset.id;
    const checked: boolean = target.checked;
    // You can replace this with an AJAX call to update status on the server
    // For now, just log the change
    console.log(`Manager ID: ${id}, New Status: ${checked ? 'active' : 'inactive'}`);

    // Example: send a fetch request to update status (uncomment and adjust URL as needed)
    /*
    fetch(`/admin/managers/${id}/update_status`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content || ''
      },
      body: JSON.stringify({ status: checked ? 'active' : 'inactive' })
    })
    .then((response: Response) => response.json())
    .then((data: any) => {
      // Optionally handle response
      console.log('Status updated:', data);
    })
    .catch((error: any) => {
      // Optionally handle error
      console.error('Error updating status:', error);
      // Optionally revert checkbox if error
      target.checked = !checked;
    });
    */
  }
}

// Delegate event for dynamically rendered checkboxes
document.addEventListener('change', handleStatusCheckboxChange, false);


