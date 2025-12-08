import { Routes, Route, Navigate } from 'react-router-dom';
import Login from './pages/Login';
import Users from './pages/Users';
import Partners from './pages/Partners';
import Bookings from './pages/Bookings'; // New Import
import DashboardLayout from './components/DashboardLayout';
import DashboardHome from './pages/DashboardHome'; // New Import

function App() {
  return (
    <Routes>
      <Route path="/login" element={<Login />} />
      <Route path="/" element={<DashboardLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<DashboardHome />} />
        <Route path="users" element={<Users />} />
        <Route path="partners" element={<Partners />} />
        <Route path="bookings" element={<Bookings />} />
      </Route>
    </Routes>
  );
}

export default App;
