'use strict';

export class ConfirmDialog {
    constructor(element) {
        this.element = element;
        this.confirmButton = element.querySelector('.confirm-button');
        this.cancelButton = element.querySelector('.cancel-button');

        dialogPolyfill.registerDialog(element);
    }

    show() {
        return new Promise((resolve, reject) => {
            this.element.showModal();
            const that = this;

            function confirmListener() {
                resolve();
                cleanup();
            }
            function cancelListener() {
                reject();
                cleanup();
            }
            function cleanup() {
                that.confirmButton.removeEventListener('click', confirmListener);
                that.cancelButton.removeEventListener('click', cancelListener);
                that.element.close();
            }
            this.confirmButton.addEventListener('click', confirmListener);
            this.cancelButton.addEventListener('click', cancelListener);
        })
    }
}