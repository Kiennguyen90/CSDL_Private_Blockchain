import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import Navbar from './components/Navbar'
import AccountsListPage from './pages/AccountsListPage'
import CreateAccountPage from './pages/CreateAccountPage'
import TransactionPage from './pages/TransactionPage'

export default function App() {
  return (
    <BrowserRouter>
      <Navbar />
      <main className="main-content">
        <Routes>
          <Route path="/" element={<AccountsListPage />} />
          <Route path="/create" element={<CreateAccountPage />} />
          <Route path="/transaction" element={<TransactionPage />} />
          <Route path="*" element={<Navigate to="/" replace />} />
        </Routes>
      </main>
    </BrowserRouter>
  )
}
