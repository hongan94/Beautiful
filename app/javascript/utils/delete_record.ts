import { swalSuccess, swalError, swalConfirm } from './alerts';

document.addEventListener('click', function(event: Event) {
  const target = event.target as HTMLElement;
  // Check if the clicked element or its parent is a delete-record button
  let deleteBtn: HTMLElement | null = null;

  if (target.matches('.delete-record')) {
    deleteBtn = target;
  } else if (target.closest('.delete-record')) {
    deleteBtn = target.closest('.delete-record');
  }
  if (deleteBtn) {
    event.preventDefault();

    // Show SweetAlert confirmation
    // Fix: Pass the callback as the second argument, and the text as the third argument
    swalConfirm(
      'Are you sure?',
      () => {
        // Proceed with deletion (AJAX or form submission)
        const url = deleteBtn?.getAttribute('data-href');
        if (url) {
          fetch(url, {
            method: 'DELETE',
            headers: {
              'X-CSRF-Token': (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content || '',
              'Accept': 'application/json'
            }
          })
          .then(response => {
            if (response.ok) {
              swalSuccess('Deleted!', 'Manager has been deleted.');
              // Optionally, refresh the table or remove the row
              // For now, reload the page
              setTimeout(() => window.location.reload(), 1000);
            } else {
              return response.json().then(data => {
                throw new Error(data.error || 'Failed to delete manager.');
              });
            }
          })
          .catch(error => {
            swalError('Error', error.message || 'Failed to delete manager.');
          });
        }
      },
      'This will permanently delete the manager.'
    );
  }
}, false);
