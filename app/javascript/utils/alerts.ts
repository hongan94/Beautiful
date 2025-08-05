// app/javascript/utils/alerts.ts
import Swal from 'sweetalert2';

/**
 * Show a success alert
 */
export function swalSuccess(title: string, text?: string): void {
  Swal.fire({
    icon: 'success',
    title,
    text,
    confirmButtonText: 'OK',
  });
}

/**
 * Show a warning alert
 */
export function swalWarning(title: string, text?: string): void {
  Swal.fire({
    icon: 'warning',
    title,
    text,
    confirmButtonText: 'OK',
  });
}

/**
 * Show an info alert
 */
export function swalInfo(title: string, text?: string): void {
  Swal.fire({
    icon: 'info',
    title,
    text,
    confirmButtonText: 'OK',
  });
}

/**
 * Show an error alert
 */
export function swalError(title: string, text?: string): void {
  Swal.fire({
    icon: 'error',
    title,
    text,
    confirmButtonText: 'OK',
  });
}

/**
 * Confirm dialog with callback
 */
export function swalConfirm(
  title: string,
  onConfirm: () => void,
  text?: string,
  confirmButtonText = 'Yes',
  cancelButtonText = 'Cancel'
): void {
  Swal.fire({
    title,
    text,
    icon: 'question',
    showCancelButton: true,
    confirmButtonText,
    cancelButtonText,
  }).then((result) => {
    if (result.isConfirmed) {
      onConfirm();
    }
  });
}
