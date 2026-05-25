
const getToken = () => localStorage.getItem("my-money-token");

export const setToken = (token) => {
  if (token) {
    localStorage.setItem("my-money-token", token);
    return;
  }
  localStorage.removeItem("my-money-token");
};

export const clearToken = () => {
  localStorage.removeItem("my-money-token");
};

async function request(url, options = {}) {
  const token = getToken();
  const headers = {
    ...options.headers,
  };

  if (token) {
    headers["Authorization"] = `Bearer ${token}`;
  }

  if (!(options.body instanceof FormData)) {
    headers["Content-Type"] = "application/json";
  }

  const response = await fetch(url, {
    ...options,
    headers,
  });

  if (response.status === 204) {
    return null;
  }

  const data = await response.json().catch(() => null);

  if (!response.ok) {

    const errorMessage = data?.error?.message || "Ocorreu um erro inesperado.";
    const errorDetails = data?.error?.details || data || null;
    const error = new Error(errorMessage);
    error.status = response.status;
    error.details = errorDetails;
    throw error;
  }

  return data;
}

export const api = {
  auth: {
    login: (email, password) =>
      request("/auth/login", {
        method: "POST",
        body: JSON.stringify({ email, password }),
      }),
    register: (name, email, password) =>
      request("/auth/register", {
        method: "POST",
        body: JSON.stringify({ name, email, password }),
      }),
    validate: () => request("/auth/validate"),
  },
  users: {
    me: () => request("/users/me"),
    dataMin: () => request("/users/data-min"),
    profileImage: () => request("/users/profile-image"),
    uploadProfileImage: (file) => {
      const formData = new FormData();
      formData.append("file", file);
      return request("/users/upload-profile-image", {
        method: "POST",
        body: formData,
      });
    },
    deleteAccount: () =>
      request("/users", {
        method: "DELETE",
      }),
  },
  transactions: {
    list: (params = {}) => {
      const query = new URLSearchParams();
      if (params.startDate) query.append("startDate", params.startDate);
      if (params.endDate) query.append("endDate", params.endDate);
      if (params.categoryIds) {
        const addCategories = (ids) => {
          if (Array.isArray(ids)) {
            ids.forEach((id) => query.append("categoryIds", id));
            return;
          }
          query.append("categoryIds", ids);
        };
        addCategories(params.categoryIds);
      }
      if (params.type) query.append("type", params.type);
      if (params.search) query.append("search", params.search);

      const queryString = query.toString();
      return request(`/transactions${queryString ? `?${queryString}` : ""}`);
    },
    create: (transaction) =>
      request("/transactions", {
        method: "POST",
        body: JSON.stringify(transaction),
      }),
    update: (id, transaction) =>
      request(`/transactions/${id}`, {
        method: "PUT",
        body: JSON.stringify(transaction),
      }),
    delete: (id) =>
      request(`/transactions/${id}`, {
        method: "DELETE",
      }),
  },
  categories: {
    list: () => request("/transactions/categories"),
    create: (name) =>
      request("/transactions/categories", {
        method: "POST",
        body: JSON.stringify({ name }),
      }),
    delete: (id) =>
      request(`/transactions/categories/${id}`, {
        method: "DELETE",
      }),
  },
  metrics: {
    get: () => request("/metrics"),
  },
};
