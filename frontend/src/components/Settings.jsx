import React, { useState, useRef } from "react";
import { useAuth } from "../context/AuthContext";
import { api } from "../services/api";
import {
  ArrowLeft,
  User,
  Mail,
  Calendar,
  Upload,
  Trash2,
  AlertTriangle,
  Loader2,
  CheckCircle,
  AlertCircle
} from "lucide-react";

export default function Settings({ onBack }) {
  const { user, refreshUser, logout } = useAuth();
  const [uploading, setUploading] = useState(false);
  const [deleting, setDeleting] = useState(false);
  const [message, setMessage] = useState({ text: "", type: "" });
  const fileInputRef = useRef(null);

  const handleFileChange = async (e) => {
    const file = e.target.files[0];
    if (!file) return;

    if (file.size > 16 * 1024 * 1024) {
      setMessage({
        text: "O arquivo excede o limite máximo de 16MB.",
        type: "error"
      });
      return;
    }

    setMessage({ text: "", type: "" });
    setUploading(true);

    try {
      await api.users.uploadProfileImage(file);
      await refreshUser();
      setMessage({
        text: "Foto de perfil atualizada com sucesso!",
        type: "success"
      });
    } catch (err) {
      setMessage({
        text: err.message || "Erro ao fazer upload da imagem.",
        type: "error"
      });
    } finally {
      setUploading(false);
    }
  };

  const handleUploadClick = () => {
    fileInputRef.current?.click();
  };

  const handleDeleteAccount = async () => {
    const confirmed = window.confirm(
      "ATENÇÃO: Você tem certeza que deseja excluir sua conta permanentemente? Esta ação é irreversível e todos os seus dados e transações serão apagados."
    );

    if (!confirmed) return;

    setMessage({ text: "", type: "" });
    setDeleting(true);

    try {
      await api.users.deleteAccount();
      logout();
    } catch (err) {
      setMessage({
        text: err.message || "Erro ao deletar conta.",
        type: "error"
      });
      setDeleting(false);
    }
  };

  const formatDate = (dateStr) => {
    if (!dateStr) return "";
    const date = new Date(dateStr);
    return date.toLocaleDateString("pt-BR", {
      day: "2-digit",
      month: "long",
      year: "numeric"
    });
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col relative">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_-10%,rgba(99,102,241,0.05),transparent_50%)] pointer-events-none" />

      <header className="border-b border-slate-900 bg-slate-900/20 backdrop-blur-md sticky top-0 z-40">
        <div className="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
          <button
            onClick={onBack}
            className="flex items-center gap-2 text-slate-400 hover:text-white transition-colors py-1.5 px-3 hover:bg-slate-900 rounded-xl"
          >
            <ArrowLeft className="w-4 h-4" /> Voltar ao Painel
          </button>
          <span className="text-md font-semibold text-slate-300">Minha Conta</span>
        </div>
      </header>

      <main className="flex-1 max-w-2xl w-full mx-auto px-4 py-12 space-y-8 relative">
        <h1 className="text-2xl font-bold text-white">Configurações</h1>

        {message.text && (
          <div
            className={`flex items-start gap-3 p-4 rounded-xl border text-sm ${
              message.type === "success"
                ? "bg-emerald-500/10 border-emerald-500/20 text-emerald-300"
                : "bg-rose-500/10 border-rose-500/20 text-rose-300"
            }`}
          >
            {message.type === "success" ? (
              <CheckCircle className="w-5 h-5 shrink-0 text-emerald-400" />
            ) : (
              <AlertCircle className="w-5 h-5 shrink-0 text-rose-400" />
            )}
            <p>{message.text}</p>
          </div>
        )}

        <section className="bg-slate-900/40 border border-slate-900 rounded-2xl p-6 md:p-8 space-y-6 shadow-xl">
          <div className="flex flex-col sm:flex-row items-center gap-6 pb-6 border-b border-slate-800">

            <div className="relative group">
              {user?.imageUrl ? (
                <img
                  src={user.imageUrl}
                  alt={user.name}
                  className="w-24 h-24 rounded-full object-cover border border-slate-700 shadow-md"
                />
              ) : (
                <div className="w-24 h-24 rounded-full bg-indigo-500/20 text-indigo-300 flex items-center justify-center font-bold text-3xl border border-slate-700">
                  {user?.name?.charAt(0).toUpperCase()}
                </div>
              )}

              <button
                onClick={handleUploadClick}
                disabled={uploading}
                className="absolute inset-0 bg-slate-950/70 rounded-full flex flex-col items-center justify-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity duration-200 cursor-pointer disabled:pointer-events-none"
              >
                {uploading ? (
                  <Loader2 className="w-5 h-5 text-indigo-400 animate-spin" />
                ) : (
                  <>
                    <Upload className="w-5 h-5 text-white" />
                    <span className="text-[10px] text-slate-300 font-semibold uppercase">Alterar</span>
                  </>
                )}
              </button>
            </div>

            <div className="flex-1 text-center sm:text-left space-y-1">
              <h2 className="text-xl font-bold text-white">{user?.name}</h2>
              <p className="text-sm text-slate-400">{user?.email}</p>
              <p className="text-xs text-slate-500 flex items-center justify-center sm:justify-start gap-1">
                <Calendar className="w-3.5 h-3.5" />
                Membro desde {formatDate(user?.createdAt)}
              </p>
            </div>

            <input
              type="file"
              ref={fileInputRef}
              onChange={handleFileChange}
              accept="image/*"
              className="hidden"
            />
          </div>

          <div className="space-y-4">
            <h3 className="text-xs font-bold text-slate-400 uppercase tracking-wider">
              Detalhes da Conta
            </h3>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="bg-slate-950/40 p-4 rounded-xl border border-slate-900/60 flex items-center gap-3">
                <User className="w-5 h-5 text-slate-500" />
                <div>
                  <p className="text-[10px] text-slate-500 uppercase font-semibold">Nome</p>
                  <p className="text-sm text-slate-200 font-medium">{user?.name}</p>
                </div>
              </div>

              <div className="bg-slate-950/40 p-4 rounded-xl border border-slate-900/60 flex items-center gap-3">
                <Mail className="w-5 h-5 text-slate-500" />
                <div>
                  <p className="text-[10px] text-slate-500 uppercase font-semibold">E-mail</p>
                  <p className="text-sm text-slate-200 font-medium">{user?.email}</p>
                </div>
              </div>
            </div>
          </div>
        </section>

        <section className="bg-rose-500/5 border border-rose-500/10 rounded-2xl p-6 md:p-8 space-y-6">
          <div className="flex items-start gap-3.5">
            <AlertTriangle className="w-6 h-6 text-rose-400 shrink-0 mt-0.5" />
            <div className="space-y-1">
              <h3 className="text-md font-bold text-rose-200">Zona de Perigo</h3>
              <p className="text-sm text-rose-400/80">
                A exclusão da conta apagará todas as suas transações e dados de forma definitiva.
              </p>
            </div>
          </div>

          <div className="flex justify-end pt-2">
            <button
              onClick={handleDeleteAccount}
              disabled={deleting}
              className="py-2.5 px-4 bg-rose-500/10 hover:bg-rose-500 hover:text-white border border-rose-500/20 text-rose-200 rounded-xl font-medium text-sm flex items-center gap-2 shadow-lg shadow-rose-500/5 transition-all duration-200 disabled:opacity-50 disabled:pointer-events-none"
            >
              {deleting ? (
                <>
                  <Loader2 className="w-4 h-4 animate-spin" /> Excluindo...
                </>
              ) : (
                <>
                  <Trash2 className="w-4 h-4" /> Excluir Conta Permanentemente
                </>
              )}
            </button>
          </div>
        </section>
      </main>
    </div>
  );
}
