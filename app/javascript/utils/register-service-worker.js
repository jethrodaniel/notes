if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register("/service-worker.js").then(
    (_registration) => {},
    (error) => {
      console.error(`Service worker registration failed: ${error}`)
    }
  )
} else {
  console.error("Service workers are not supported")
}
