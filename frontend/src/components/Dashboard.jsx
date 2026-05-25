import React, { useState, useEffect } from "react";
import { useAuth } from "../context/AuthContext";
import { api } from "../services/api";
import {
  TrendingUp,
  ArrowUpRight,
  ArrowDownRight,
  DollarSign,
  Plus,
  Search,
  Filter,
  Trash2,
  Edit2,
  FolderOpen,
  Calendar,
  LogOut,
  User,
  Settings,
  X,
  PlusCircle,
  Briefcase,
  AlertCircle
} from "lucide-react";

export default function Dashboard({ onGoToSettings }) {
  const { user, logout } = useAuth();
  const [metrics, setMetrics] = useState(null);
  const [transactions, setTransactions] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);

  const [search, setSearch] = useState("");
  const [typeFilter, setTypeFilter] = useState("");
  const [selectedCats, setSelectedCats] = useState([]);
  const [dateStart, setDateStart] = useState("");
  const [dateEnd, setDateEnd] = useState("");

  const [isTxModalOpen, setIsTxModalOpen] = useState(false);
  const [isCatModalOpen, setIsCatModalOpen] = useState(false);
  const [editingTx, setEditingTx] = useState(null);

  const [txTitle, setTxTitle] = useState("");
  const [txAmount, setTxAmount] = useState("");
  const [txType, setTxType] = useState("income");
  const [txCategory, setTxCategory] = useState("");
  const [newCatName, setNewCatName] = useState("");

  const [formError, setFormError] = useState("");
  const [txLoading, setTxLoading] = useState(false);
  const [catLoading, setCatLoading] = useState(false);

  const fetchData = async () => {
    try {
      setLoading(true);
      const metricsData = await api.metrics.get();
      setMetrics(metricsData);

      const catsData = await api.categories.list();
      setCategories(catsData);

      const txsData = await api.transactions.list({
        search,
        type: typeFilter,
        categoryIds: selectedCats,
        startDate: dateStart,
        endDate: dateEnd
      });
      setTransactions(txsData);
    } catch (err) {
      console.error("Error fetching data", err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    const delayDebounceFn = setTimeout(() => {
      fetchTransactionsOnly();
    }, 400);

    return () => clearTimeout(delayDebounceFn);
  }, [search, typeFilter, selectedCats, dateStart, dateEnd]);

  useEffect(() => {
    fetchData();
  }, []);

  const fetchTransactionsOnly = async () => {
    try {
      const txsData = await api.transactions.list({
        search,
        type: typeFilter,
        categoryIds: selectedCats,
        startDate: dateStart,
        endDate: dateEnd
      });
      setTransactions(txsData);

      const metricsData = await api.metrics.get();
      setMetrics(metricsData);
    } catch (err) {
      console.error(err);
    }
  };

  const handleOpenAddTx = () => {
    setEditingTx(null);
    setTxTitle("");
    setTxAmount("");
    setTxType("income");
    setTxCategory(categories[0]?.id || "");
    setFormError("");
    setIsTxModalOpen(true);
  };

  const handleOpenEditTx = (tx) => {
    setEditingTx(tx);
    setTxTitle(tx.title);
    setTxAmount(tx.amount.toString());
    setTxType(tx.type);
    setTxCategory(tx.categoryId);
    setFormError("");
    setIsTxModalOpen(true);
  };

  const handleSaveTransaction = async (e) => {
    e.preventDefault();
    setFormError("");
    setTxLoading(true);

    if (!txCategory) {
      setFormError("Selecione uma categoria. Se não houver, crie uma primeiro.");
      setTxLoading(false);
      return;
    }

    const payload = {
      title: txTitle,
      amount: parseFloat(txAmount),
      type: txType,
      categoryId: txCategory
    };

    try {
      if (editingTx) {
        await api.transactions.update(editingTx.id, payload);
        setIsTxModalOpen(false);
        fetchData();
        return;
      }
      await api.transactions.create(payload);
      setIsTxModalOpen(false);
      fetchData();
    } catch (err) {
      setFormError(err.message || "Erro ao salvar transação.");
    } finally {
      setTxLoading(false);
    }
  };

  const handleDeleteTransaction = async (id) => {
    if (!window.confirm("Deseja realmente excluir esta transação?")) return;
    try {
      await api.transactions.delete(id);
      fetchData();
    } catch (err) {
      alert(err.message || "Erro ao excluir transação.");
    }
  };

  const handleAddCategory = async (e) => {
    e.preventDefault();
    setFormError("");
    setCatLoading(true);

    if (!newCatName.trim()) {
      setFormError("O nome da categoria é obrigatório.");
      setCatLoading(false);
      return;
    }

    try {
      await api.categories.create(newCatName);
      setNewCatName("");
      const catsData = await api.categories.list();
      setCategories(catsData);

      if (catsData.length > 0 && !txCategory) {
        setTxCategory(catsData[catsData.length - 1].id);
      }
    } catch (err) {
      setFormError(err.message || "Erro ao criar categoria.");
    } finally {
      setCatLoading(false);
    }
  };

  const handleDeleteCategory = async (id) => {
    if (!window.confirm("Deseja excluir esta categoria? As transações associadas impedirão a exclusão devido a integridade de dados.")) return;
    try {
      await api.categories.delete(id);
      const catsData = await api.categories.list();
      setCategories(catsData);
    } catch (err) {
      alert(err.message || "Não foi possível excluir a categoria.");
    }
  };

  const toggleCategoryFilter = (id) => {
    if (selectedCats.includes(id)) {
      setSelectedCats(selectedCats.filter((c) => c !== id));
      return;
    }
    setSelectedCats([...selectedCats, id]);
  };

  const clearFilters = () => {
    setSearch("");
    setTypeFilter("");
    setSelectedCats([]);
    setDateStart("");
    setDateEnd("");
  };

  const formatCurrency = (val) => {
    return new Intl.NumberFormat("pt-BR", {
      style: "currency",
      currency: "BRL"
    }).format(val || 0);
  };

  const formatDate = (dateStr) => {
    if (!dateStr) return "N/A";
    const date = new Date(dateStr);
    return date.toLocaleDateString("pt-BR", {
      day: "2-digit",
      month: "2-digit",
      year: "numeric",
      hour: "2-digit",
      minute: "2-digit"
    });
  };

  return (
    <div className="min-h-screen bg-slate-950 text-slate-100 flex flex-col">

      <header className="border-b border-slate-900 bg-slate-900/30 backdrop-blur-md sticky top-0 z-40">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-gradient-to-tr from-indigo-500 to-emerald-500 rounded-xl flex items-center justify-center shadow-md shadow-indigo-500/10">
              <TrendingUp className="w-5 h-5 text-white" />
            </div>
            <span className="text-xl font-bold tracking-tight bg-gradient-to-r from-white to-slate-400 bg-clip-text text-transparent">
              My Money
            </span>
          </div>

          <div className="flex items-center gap-4">
            <div
              onClick={onGoToSettings}
              className="flex items-center gap-2 cursor-pointer hover:bg-slate-900 p-2 rounded-xl transition-all duration-200"
            >
              {user?.imageUrl ? (
                <img
                  src={user.imageUrl}
                  alt={user.name}
                  className="w-8 h-8 rounded-full border border-slate-700 object-cover"
                />
              ) : (
                <div className="w-8 h-8 rounded-full bg-indigo-500/20 text-indigo-300 flex items-center justify-center font-bold text-sm">
                  {user?.name?.charAt(0).toUpperCase() || <User className="w-4 h-4" />}
                </div>
              )}
              <span className="hidden sm:inline text-sm font-medium text-slate-300">
                {user?.name}
              </span>
            </div>

            <button
              onClick={onGoToSettings}
              className="p-2 text-slate-400 hover:text-white hover:bg-slate-900 rounded-xl transition-colors"
              title="Configurações"
            >
              <Settings className="w-5 h-5" />
            </button>

            <button
              onClick={logout}
              className="p-2 text-slate-400 hover:text-rose-400 hover:bg-rose-500/10 rounded-xl transition-all duration-200"
              title="Sair"
            >
              <LogOut className="w-5 h-5" />
            </button>
          </div>
        </div>
      </header>

      <main className="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">

        <section className="grid grid-cols-1 md:grid-cols-3 gap-6">

          <div className="bg-slate-900/40 border border-slate-900 rounded-2xl p-6 relative overflow-hidden group shadow-lg">
            <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            <div className="flex items-center justify-between mb-4">
              <span className="text-sm font-medium text-slate-400 uppercase tracking-wider">
                Entradas
              </span>
              <div className="w-10 h-10 bg-emerald-500/10 rounded-xl flex items-center justify-center text-emerald-400">
                <ArrowUpRight className="w-5 h-5" />
              </div>
            </div>
            <div className="text-3xl font-bold text-white tracking-tight">
              {metrics ? formatCurrency(metrics.income.total) : "..."}
            </div>
            <p className="text-xs text-slate-500 mt-2 flex items-center gap-1">
              <Calendar className="w-3.5 h-3.5" />
              Última: {metrics?.income?.lastDate ? formatDate(metrics.income.lastDate) : "Sem dados"}
            </p>
          </div>

          <div className="bg-slate-900/40 border border-slate-900 rounded-2xl p-6 relative overflow-hidden group shadow-lg">
            <div className="absolute inset-0 bg-gradient-to-br from-rose-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            <div className="flex items-center justify-between mb-4">
              <span className="text-sm font-medium text-slate-400 uppercase tracking-wider">
                Saídas
              </span>
              <div className="w-10 h-10 bg-rose-500/10 rounded-xl flex items-center justify-center text-rose-400">
                <ArrowDownRight className="w-5 h-5" />
              </div>
            </div>
            <div className="text-3xl font-bold text-white tracking-tight">
              {metrics ? formatCurrency(metrics.expenses.total) : "..."}
            </div>
            <p className="text-xs text-slate-500 mt-2 flex items-center gap-1">
              <Calendar className="w-3.5 h-3.5" />
              Última: {metrics?.expenses?.lastDate ? formatDate(metrics.expenses.lastDate) : "Sem dados"}
            </p>
          </div>

          <div className="bg-slate-900/40 border border-slate-900 rounded-2xl p-6 relative overflow-hidden group shadow-lg">
            <div className="absolute inset-0 bg-gradient-to-br from-indigo-500/5 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            <div className="flex items-center justify-between mb-4">
              <span className="text-sm font-medium text-slate-400 uppercase tracking-wider">
                Saldo Líquido
              </span>
              <div className={`w-10 h-10 rounded-xl flex items-center justify-center ${
                (metrics?.total?.saldoLiquido || 0) >= 0 ? "bg-indigo-500/10 text-indigo-400" : "bg-amber-500/10 text-amber-400"
              }`}>
                <DollarSign className="w-5 h-5" />
              </div>
            </div>
            <div className={`text-3xl font-bold tracking-tight ${
              (metrics?.total?.netBalance || 0) >= 0 ? "text-emerald-400" : "text-rose-400"
            }`}>
              {metrics ? formatCurrency(metrics.total.netBalance) : "..."}
            </div>
            <p className="text-xs text-slate-500 mt-2 flex items-center gap-1">
              <Calendar className="w-3.5 h-3.5" />
              Período: {metrics?.total?.firstDate ? new Date(metrics.total.firstDate).toLocaleDateString("pt-BR") : "Início"} - {metrics?.total?.lastDate ? new Date(metrics.total.lastDate).toLocaleDateString("pt-BR") : "Fim"}
            </p>
          </div>
        </section>

        <section className="flex flex-col sm:flex-row gap-4 justify-between items-start sm:items-center">
          <h2 className="text-xl font-bold text-white flex items-center gap-2">
            <Briefcase className="w-5 h-5 text-indigo-400" />
            Transações
          </h2>

          <div className="flex flex-wrap gap-3 w-full sm:w-auto">
            <button
              onClick={handleOpenAddTx}
              className="flex-1 sm:flex-initial py-2.5 px-4 bg-indigo-600 hover:bg-indigo-500 active:scale-[0.98] text-white font-medium rounded-xl flex items-center justify-center gap-2 shadow-lg shadow-indigo-500/10 transition-all duration-200 text-sm"
            >
              <Plus className="w-4 h-4" /> Nova Transação
            </button>

            <button
              onClick={() => setIsCatModalOpen(true)}
              className="flex-1 sm:flex-initial py-2.5 px-4 bg-slate-900 border border-slate-800 hover:border-slate-700 text-slate-300 hover:text-white rounded-xl flex items-center justify-center gap-2 transition-colors text-sm"
            >
              <FolderOpen className="w-4 h-4" /> Categorias
            </button>
          </div>
        </section>

        <section className="grid grid-cols-1 lg:grid-cols-4 gap-8">

          <div className="bg-slate-900/20 border border-slate-900 rounded-2xl p-6 space-y-6 h-fit">
            <div className="flex items-center justify-between pb-2 border-b border-slate-900">
              <span className="font-semibold text-slate-200 flex items-center gap-2 text-sm uppercase tracking-wider">
                <Filter className="w-4 h-4 text-indigo-400" /> Filtros
              </span>
              <button
                onClick={clearFilters}
                className="text-xs text-slate-500 hover:text-indigo-400 transition-colors"
              >
                Limpar tudo
              </button>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                Buscar por título
              </label>
              <div className="relative">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-500" />
                <input
                  type="text"
                  value={search}
                  onChange={(e) => setSearch(e.target.value)}
                  placeholder="Pesquisar..."
                  className="w-full pl-9 pr-3 py-2 bg-slate-950/60 border border-slate-900 rounded-xl text-sm placeholder-slate-600 focus:outline-none focus:border-indigo-500 transition-colors"
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                Tipo
              </label>
              <select
                value={typeFilter}
                onChange={(e) => setTypeFilter(e.target.value)}
                className="w-full px-3 py-2 bg-slate-950/60 border border-slate-900 rounded-xl text-sm text-slate-300 focus:outline-none focus:border-indigo-500 transition-colors"
              >
                <option value="">Todos</option>
                <option value="income">Entradas</option>
                <option value="expense">Saídas</option>
              </select>
            </div>

            <div className="space-y-3">
              <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                Período
              </label>
              <div className="space-y-2">
                <input
                  type="date"
                  value={dateStart}
                  onChange={(e) => setDateStart(e.target.value)}
                  className="w-full px-3 py-2 bg-slate-950/60 border border-slate-900 rounded-xl text-sm text-slate-400 focus:outline-none focus:border-indigo-500 transition-colors"
                  placeholder="Início"
                />
                <input
                  type="date"
                  value={dateEnd}
                  onChange={(e) => setDateEnd(e.target.value)}
                  className="w-full px-3 py-2 bg-slate-950/60 border border-slate-900 rounded-xl text-sm text-slate-400 focus:outline-none focus:border-indigo-500 transition-colors"
                  placeholder="Fim"
                />
              </div>
            </div>

            <div className="space-y-2">
              <label className="text-xs font-semibold text-slate-400 uppercase tracking-wider">
                Categorias
              </label>
              <div className="max-h-48 overflow-y-auto space-y-1.5 pr-2 custom-scrollbar">
                {categories.length === 0 ? (
                  <p className="text-xs text-slate-600">Nenhuma categoria criada.</p>
                ) : (
                  categories.map((cat) => (
                    <label
                      key={cat.id}
                      className="flex items-center gap-2.5 text-sm text-slate-400 hover:text-slate-200 cursor-pointer py-1"
                    >
                      <input
                        type="checkbox"
                        checked={selectedCats.includes(cat.id)}
                        onChange={() => toggleCategoryFilter(cat.id)}
                        className="rounded border-slate-800 bg-slate-950/50 text-indigo-600 focus:ring-indigo-500 focus:ring-offset-slate-950"
                      />
                      <span>{cat.name}</span>
                    </label>
                  ))
                )}
              </div>
            </div>
          </div>

          <div className="lg:col-span-3 bg-slate-900/10 border border-slate-900 rounded-2xl overflow-hidden min-h-[400px] flex flex-col">
            {loading ? (
              <div className="flex-1 flex flex-col items-center justify-center gap-3 py-16">
                <div className="w-8 h-8 border-2 border-indigo-500/20 border-t-indigo-500 rounded-full animate-spin" />
                <span className="text-sm text-slate-500">Carregando transações...</span>
              </div>
            ) : transactions.length === 0 ? (
              <div className="flex-1 flex flex-col items-center justify-center text-center p-8 py-16">
                <FolderOpen className="w-12 h-12 text-slate-700 mb-3" />
                <h3 className="text-lg font-semibold text-slate-300">Nenhuma transação encontrada</h3>
                <p className="text-sm text-slate-500 max-w-sm mt-1">
                  Adicione uma nova transação ou altere seus filtros de busca para visualizar os registros.
                </p>
                {(search || typeFilter || selectedCats.length > 0 || dateStart || dateEnd) && (
                  <button
                    onClick={clearFilters}
                    className="mt-4 px-4 py-2 bg-slate-900 border border-slate-800 text-indigo-400 hover:text-indigo-300 rounded-xl text-sm font-medium transition-all duration-200"
                  >
                    Remover filtros
                  </button>
                )}
              </div>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-left border-collapse">
                  <thead>
                    <tr className="border-b border-slate-900/60 bg-slate-900/20">
                      <th className="p-4 text-xs font-semibold text-slate-400 uppercase tracking-wider">Título</th>
                      <th className="p-4 text-xs font-semibold text-slate-400 uppercase tracking-wider">Categoria</th>
                      <th className="p-4 text-xs font-semibold text-slate-400 uppercase tracking-wider">Data</th>
                      <th className="p-4 text-xs font-semibold text-slate-400 uppercase tracking-wider text-right">Valor</th>
                      <th className="p-4 text-xs font-semibold text-slate-400 uppercase tracking-wider text-center">Ações</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-slate-900/40">
                    {transactions.map((tx) => (
                      <tr key={tx.id} className="hover:bg-slate-900/20 group transition-colors">
                        <td className="p-4 font-medium text-slate-200">{tx.title}</td>
                        <td className="p-4">
                          <span className="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-500/10 text-indigo-300 border border-indigo-500/10">
                            {tx.categoryName}
                          </span>
                        </td>
                        <td className="p-4 text-sm text-slate-400">{formatDate(tx.createdAt)}</td>
                        <td className={`p-4 font-bold text-right ${
                          tx.type === "income" ? "text-emerald-400" : "text-rose-400"
                        }`}>
                          {tx.type === "income" ? "+" : "-"} {formatCurrency(tx.amount)}
                        </td>
                        <td className="p-4">
                          <div className="flex items-center justify-center gap-2.5">
                            <button
                              onClick={() => handleOpenEditTx(tx)}
                              className="p-1.5 text-slate-500 hover:text-indigo-400 hover:bg-indigo-500/10 rounded-lg transition-colors"
                              title="Editar"
                            >
                              <Edit2 className="w-4 h-4" />
                            </button>
                            <button
                              onClick={() => handleDeleteTransaction(tx.id)}
                              className="p-1.5 text-slate-500 hover:text-rose-400 hover:bg-rose-500/10 rounded-lg transition-colors"
                              title="Excluir"
                            >
                              <Trash2 className="w-4 h-4" />
                            </button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        </section>
      </main>

      {isTxModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm animate-fadeIn">
          <div className="relative w-full max-w-lg bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-2xl space-y-6">
            <div className="flex items-center justify-between pb-3 border-b border-slate-800">
              <h3 className="text-lg font-bold text-white">
                {editingTx ? "Editar Transação" : "Nova Transação"}
              </h3>
              <button
                onClick={() => setIsTxModalOpen(false)}
                className="p-1.5 hover:bg-slate-800 rounded-lg transition-colors text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            {formError && (
              <div className="flex items-start gap-3 bg-rose-500/10 border border-rose-500/20 text-rose-300 p-4 rounded-xl text-sm">
                <AlertCircle className="w-5 h-5 shrink-0 text-rose-400" />
                <p>{formError}</p>
              </div>
            )}

            <form onSubmit={handleSaveTransaction} className="space-y-4">

              <div className="grid grid-cols-2 gap-3 bg-slate-950/60 p-1 rounded-xl border border-slate-800/80">
                <button
                  type="button"
                  onClick={() => setTxType("income")}
                  className={`py-2 px-4 rounded-lg font-medium text-sm transition-all duration-200 ${
                    txType === "income"
                      ? "bg-emerald-600 text-white shadow-md"
                      : "text-slate-400 hover:text-white"
                  }`}
                >
                  Entrada
                </button>
                <button
                  type="button"
                  onClick={() => setTxType("expense")}
                  className={`py-2 px-4 rounded-lg font-medium text-sm transition-all duration-200 ${
                    txType === "expense"
                      ? "bg-rose-600 text-white shadow-md"
                      : "text-slate-400 hover:text-white"
                  }`}
                >
                  Saída
                </button>
              </div>

              <div className="space-y-1">
                <label className="text-xs font-semibold text-slate-300 uppercase tracking-wider">
                  Título
                </label>
                <input
                  type="text"
                  required
                  value={txTitle}
                  onChange={(e) => setTxTitle(e.target.value)}
                  placeholder="Ex: Salário, Supermercado"
                  className="w-full px-4 py-2.5 bg-slate-950/40 border border-slate-800 rounded-xl text-slate-200 focus:outline-none focus:border-indigo-500 transition-colors"
                />
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-slate-300 uppercase tracking-wider">
                    Valor (R$)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    min="0.01"
                    required
                    value={txAmount}
                    onChange={(e) => setTxAmount(e.target.value)}
                    placeholder="0,00"
                    className="w-full px-4 py-2.5 bg-slate-950/40 border border-slate-800 rounded-xl text-slate-200 focus:outline-none focus:border-indigo-500 transition-colors"
                  />
                </div>

                <div className="space-y-1">
                  <label className="text-xs font-semibold text-slate-300 uppercase tracking-wider">
                    Categoria
                  </label>
                  <select
                    required
                    value={txCategory}
                    onChange={(e) => setTxCategory(e.target.value)}
                    className="w-full px-4 py-2.5 bg-slate-950/40 border border-slate-800 rounded-xl text-slate-300 focus:outline-none focus:border-indigo-500 transition-colors"
                  >
                    <option value="" disabled>Selecione...</option>
                    {categories.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div className="pt-4 flex justify-end gap-3">
                <button
                  type="button"
                  onClick={() => setIsTxModalOpen(false)}
                  className="py-2.5 px-4 bg-slate-800 hover:bg-slate-700 text-slate-300 rounded-xl font-medium text-sm transition-colors"
                >
                  Cancelar
                </button>
                <button
                  type="submit"
                  disabled={txLoading}
                  className="py-2.5 px-6 bg-indigo-600 hover:bg-indigo-500 text-white rounded-xl font-medium text-sm flex items-center justify-center gap-2 shadow-lg shadow-indigo-500/10 active:scale-[0.98] transition-all"
                >
                  {txLoading ? "Salvando..." : "Salvar"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {isCatModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/80 backdrop-blur-sm animate-fadeIn">
          <div className="relative w-full max-w-md bg-slate-900 border border-slate-800 rounded-2xl p-6 shadow-2xl space-y-6">
            <div className="flex items-center justify-between pb-3 border-b border-slate-800">
              <h3 className="text-lg font-bold text-white flex items-center gap-2">
                <FolderOpen className="w-5 h-5 text-indigo-400" /> Gerenciar Categorias
              </h3>
              <button
                onClick={() => setIsCatModalOpen(false)}
                className="p-1.5 hover:bg-slate-800 rounded-lg transition-colors text-slate-400 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            </div>

            <form onSubmit={handleAddCategory} className="space-y-3">
              <label className="text-xs font-semibold text-slate-300 uppercase tracking-wider block">
                Nova Categoria
              </label>
              <div className="flex gap-2">
                <input
                  type="text"
                  required
                  value={newCatName}
                  onChange={(e) => setNewCatName(e.target.value)}
                  placeholder="Ex: Alimentação, Transporte"
                  className="flex-1 px-3 py-2 bg-slate-950/40 border border-slate-800 rounded-xl text-slate-200 placeholder-slate-600 focus:outline-none focus:border-indigo-500 transition-colors text-sm"
                />
                <button
                  type="submit"
                  disabled={catLoading}
                  className="px-3 bg-indigo-600 hover:bg-indigo-505 hover:bg-indigo-500 text-white rounded-xl font-medium text-sm transition-colors flex items-center justify-center"
                >
                  {catLoading ? "..." : <PlusCircle className="w-5 h-5" />}
                </button>
              </div>
            </form>

            <div className="space-y-2">
              <span className="text-xs font-semibold text-slate-400 uppercase tracking-wider block">
                Categorias Existentes
              </span>
              <div className="max-h-60 overflow-y-auto space-y-2 pr-2 custom-scrollbar">
                {categories.length === 0 ? (
                  <p className="text-sm text-slate-600 text-center py-4">Nenhuma categoria criada.</p>
                ) : (
                  categories.map((cat) => (
                    <div
                      key={cat.id}
                      className="flex items-center justify-between p-3 bg-slate-950/40 rounded-xl border border-slate-900 group"
                    >
                      <span className="text-slate-300 text-sm font-medium">{cat.name}</span>
                      <button
                        onClick={() => handleDeleteCategory(cat.id)}
                        className="p-1 text-slate-600 hover:text-rose-400 rounded-lg hover:bg-rose-500/10 transition-colors opacity-0 group-hover:opacity-100 focus:opacity-100"
                        title="Remover Categoria"
                      >
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  ))
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
