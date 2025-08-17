export const debounce = (callback, delay) => {
  let timeout = null;

  return (...args) => {
    window.clearTimeout(timeout);

    timeout = window.setTimeout(() => {
      callback.apply(null, args);
    }, delay);
  };
};
