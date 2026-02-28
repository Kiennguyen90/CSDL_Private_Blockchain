import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://localhost:8080',
  headers: { 'Content-Type': 'application/json' },
})

export async function createAccount(name) {
  const params = name ? { name } : {}
  const { data } = await api.post('/api/accounts', null, { params })
  return data
}

export async function getAllAccounts() {
  const { data } = await api.get('/api/accounts')
  return data
}

export async function getAccount(address) {
  const { data } = await api.get(`/api/accounts/${address}`)
  return data
}

export async function getBalance(address) {
  const { data } = await api.get(`/api/accounts/${address}/balance`)
  return data
}

export async function sendTransaction(from, to, amount) {
  const { data } = await api.post('/api/transactions', { from, to, amount: parseFloat(amount) })
  return data
}
