import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    change(event) {
        const selectedAccountId = event.target.value

        if (selectedAccountId) {
            const url = `/bank_accounts/${selectedAccountId}`
            fetch(url, {
                headers: {
                    "Accept": "text/vnd.turbo-stream.html"
                }
            })
                .then(response => response.text())
                .then(html => Turbo.renderStreamMessage(html))
                .catch(error => console.error("Error fetching bank account data:", error))
        }
    }
}
