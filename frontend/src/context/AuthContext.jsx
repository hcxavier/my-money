import React, { createContext, useContext, useState, useEffect } from "react";
import { api, setToken, clearToken } from "../services/api";

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchProfile = async () => {
    try {
      const userData = await api.users.me();
      setUser(userData);
    } catch (err) {
      console.error("Failed to fetch profile", err);
      logout();
    }
  };

  useEffect(() => {
    const initializeAuth = async () => {
      const token = localStorage.getItem("my-money-token");
      if (!token) {
        setLoading(false);
        return;
      }
      try {
        const isValid = await api.auth.validate();
        if (isValid) {
          await fetchProfile();
          setLoading(false);
          return;
        }
        logout();
      } catch (err) {
        console.error("Token validation error", err);
        logout();
      }
      setLoading(false);
    };

    initializeAuth();
  }, []);

  const login = async (email, password) => {
    try {
      const response = await api.auth.login(email, password);
      setToken(response.token);
      await fetchProfile();
      return true;
    } catch (err) {
      throw err;
    }
  };

  const register = async (name, email, password) => {
    try {
      const response = await api.auth.register(name, email, password);
      setToken(response.token);
      await fetchProfile();
      return true;
    } catch (err) {
      throw err;
    }
  };

  const logout = () => {
    clearToken();
    setUser(null);
  };

  const refreshUser = async () => {
    await fetchProfile();
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        loading,
        isAuthenticated: !!user,
        login,
        register,
        logout,
        refreshUser,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
