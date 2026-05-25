import React, { useState } from "react";
import { AuthProvider, useAuth } from "./context/AuthContext";
import Login from "./components/Login";
import Register from "./components/Register";
import Dashboard from "./components/Dashboard";
import Settings from "./components/Settings";
import { Loader2, TrendingUp } from "lucide-react";

function NavigationCoordinator() {
  const { isAuthenticated, loading } = useAuth();
  const [authView, setAuthView] = useState("login");
  const [activeTab, setActiveTab] = useState("dashboard");

  if (loading) {
    return (
      <div className="min-h-screen bg-slate-950 flex flex-col items-center justify-center gap-4">
        <div className="w-12 h-12 bg-gradient-to-tr from-indigo-500 to-emerald-500 rounded-xl flex items-center justify-center shadow-lg shadow-indigo-500/20 animate-pulse">
          <TrendingUp className="w-6 h-6 text-white" />
        </div>
        <div className="flex items-center gap-2 text-indigo-400">
          <Loader2 className="w-5 h-5 animate-spin" />
          <span className="text-sm font-semibold tracking-wide uppercase">Carregando aplicativo...</span>
        </div>
      </div>
    );
  }

  if (!isAuthenticated) {
    if (authView === "register") {
      return <Register onToggleLogin={() => setAuthView("login")} />;
    }
    return <Login onToggleRegister={() => setAuthView("register")} />;
  }

  if (activeTab === "settings") {
    return <Settings onBack={() => setActiveTab("dashboard")} />;
  }

  return <Dashboard onGoToSettings={() => setActiveTab("settings")} />;
}

export default function App() {
  return (
    <AuthProvider>
      <NavigationCoordinator />
    </AuthProvider>
  );
}
