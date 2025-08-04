// managers_table.ts
import { KTDataTable } from '../core/components/datatable/datatable';

// Beautifully configure the users datatable
const usersTableConfig = {
  data: {
    type: 'remote',
    source: {
      read: {
        url: '/admin/users.json',
        method: 'GET',
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json'
        },
        map: function (raw: any) {
            // Trả về mảng data thôi
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
              <a class="text-base font-semibold text-gray-900 hover:text-primary transition mb-0.5" href="#">
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
        return `
          <label class="switch switch-sm">
            <input type="checkbox" value="1" ${status === 'active' ? 'checked' : ''}/>
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
          <a class="btn btn-sm btn-icon btn-clear btn-light" href="#">
            <i class="ki-filled ki-notepad-edit"></i>
          </a>
        `;
      }
    },
    {
      field: 'delete',
      render: (_data: any, row: any) => {
        return `
          <a class="btn btn-sm btn-icon btn-clear btn-light" href="#">
            <i class="ki-filled ki-trash"></i>
          </a>
        `;
      }
    }
  ]
};

const tableElement = document.querySelector('#users_table');
if (tableElement instanceof HTMLElement) {
  new KTDataTable(tableElement, usersTableConfig);
}

// Initialize the beautiful managers datatable
// KTDataTable.createInstances(managersTableConfig);
