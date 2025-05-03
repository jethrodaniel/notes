// https://developer.mozilla.org/en-US/docs/Web/API/Service_Worker_API/Using_Service_Workers
const registerServiceWorker = async () => {
  if ("serviceWorker" in navigator) {
    try {
      const registration = await navigator.serviceWorker.register(
        "/service-worker.js",
        {scope: "/"}
      )
    } catch (error) {
      console.error(`Service worker registration failed: ${error}`)
    }
  }
}

registerServiceWorker()
