import { useEffect, useState } from 'react';
import api from '../api/axios';
import { Container, Row, Col, Card, Table, Badge, Form, Button } from 'react-bootstrap';

export default function Users() {
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchUsers();
    }, []);

    const fetchUsers = async () => {
        try {
            const response = await api.get('/users?role=customer');
            if (response.data.success) {
                setUsers(response.data.users);
            }
        } catch (error) {
            console.error('Error fetching users:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) return <div className="p-4 text-small text-secondary">Loading users...</div>;

    return (
        <Container fluid>
            <div className="mb-4">
                <h4 className="fw-bold text-dark mb-1">Users Management</h4>
                <p className="text-secondary small m-0">Manage customer accounts and user activity</p>
            </div>

            <Row className="mb-4 g-3">
                <Col md={3}><StatCard title="Total Users" value={users.length} icon="bi-people" iconColor="#8b5cf6" iconBg="#f3e8ff" /></Col>
                <Col md={3}><StatCard title="Active Users" value={users.filter(u => u.isActive).length} icon="bi-check-circle" iconColor="#10b981" iconBg="#dcfce7" /></Col>
                <Col md={3}><StatCard title="Total Revenue" value={`₹${users.reduce((sum, u) => sum + (u.totalSpent || 0), 0).toLocaleString()}`} icon="bi-currency-rupee" iconColor="#3b82f6" iconBg="#dbeafe" /></Col>
                <Col md={3}><StatCard title="New This Month" value={users.filter(u => {
                    const userDate = new Date(u.createdAt);
                    const now = new Date();
                    return userDate.getMonth() === now.getMonth() && userDate.getFullYear() === now.getFullYear();
                }).length} icon="bi-plus-circle" iconColor="#ec4899" iconBg="#fce7f3" /></Col>
            </Row>

            <Card className="border-0 shadow-sm rounded-4">
                <Card.Body className="p-0">
                    <div className="p-3 border-bottom d-flex justify-content-between align-items-center">
                        <Form.Control
                            type="text"
                            placeholder="Search users by name, email..."
                            className="bg-light border-0 small"
                            style={{ width: 350, padding: '0.6rem 1rem' }}
                        />
                        <div className="d-flex gap-2">
                            <Button variant="outline-secondary" className="small d-flex align-items-center gap-2">
                                <i className="bi bi-download"></i> Export
                            </Button>
                            <Button className="btn-purple px-3 small fw-medium">+ Add User</Button>
                        </div>
                    </div>

                    <Table responsive hover className="m-0 align-middle">
                        <thead className="bg-light text-secondary text-uppercase small">
                            <tr style={{ fontSize: '0.75rem' }}>
                                <th className="fw-bold ps-4 py-3 border-0">User</th>
                                <th className="fw-bold py-3 border-0">Contact</th>
                                <th className="fw-bold py-3 border-0">Join Date</th>
                                <th className="fw-bold py-3 border-0">Bookings</th>
                                <th className="fw-bold py-3 border-0">Total Spent</th>
                                <th className="fw-bold py-3 border-0">Status</th>
                                <th className="fw-bold py-3 border-0">Last Active</th>
                                <th className="fw-bold text-end pe-4 py-3 border-0">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {users.length === 0 ? (
                                <tr>
                                    <td colSpan="8" className="text-center p-5 text-muted small">No users found. Login with the Customer App to create one!</td>
                                </tr>
                            ) : (
                                users.map((user) => (
                                    <tr key={user._id} style={{ borderBottom: '1px solid #f8f9fa' }}>
                                        <td className="ps-4 py-3">
                                            <div className="d-flex align-items-center gap-3">
                                                <div className="rounded-circle bg-primary text-white d-flex align-items-center justify-content-center fw-bold small" style={{ width: 36, height: 36, backgroundColor: '#3b82f6' }}>
                                                    {user.name?.[0].toUpperCase() || 'U'}
                                                </div>
                                                <span className="fw-semibold text-dark small">{user.name || 'Unnamed User'}</span>
                                            </div>
                                        </td>
                                        <td className="py-3">
                                            <div className="d-flex flex-column small" style={{ fontSize: '0.8rem' }}>
                                                <div className="text-secondary mb-1"><i className="bi bi-envelope me-1"></i> {user.email || 'N/A'}</div>
                                                <div className="text-secondary"><i className="bi bi-telephone me-1"></i> {user.phone}</div>
                                            </div>
                                        </td>
                                        <td className="text-secondary small py-3">{new Date(user.createdAt).toLocaleDateString()}</td>
                                        <td className="py-3">
                                            <Badge
                                                bg="light"
                                                className="text-purple fw-medium px-3 py-1 rounded-pill small"
                                                style={{ backgroundColor: '#f3e8ff' }}
                                            >
                                                {user.bookingsCount || 0}
                                            </Badge>
                                        </td>
                                        <td className="fw-bold text-dark small py-3">₹{user.totalSpent || 0}</td>
                                        <td className="py-3">
                                            <Badge
                                                bg="light"
                                                className={`fw-medium px-3 py-2 rounded-pill small ${user.isActive ? 'text-success' : 'text-secondary'}`}
                                                style={{ backgroundColor: user.isActive ? '#dcfce7' : '#f1f5f9' }}
                                            >
                                                {user.isActive ? 'Active' : 'Inactive'}
                                            </Badge>
                                        </td>
                                        <td className="small text-secondary py-3">{new Date(user.createdAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}</td>
                                        <td className="text-end pe-4 py-3">
                                            <Button variant="link" className="text-secondary p-0">
                                                <i className="bi bi-three-dots-vertical"></i>
                                            </Button>
                                        </td>
                                    </tr>
                                ))
                            )}

                        </tbody>
                    </Table>
                </Card.Body>
            </Card>
        </Container>
    );
}

function StatCard({ title, value, icon, iconColor, iconBg }) {
    return (
        <Card className="border-0 shadow-sm rounded-4">
            <Card.Body className="d-flex justify-content-between align-items-center p-3">
                <div>
                    <div className="text-secondary small mb-1">{title}</div>
                    <div className="h3 fw-bold mb-0 text-dark">{value}</div>
                </div>
                <div
                    className="rounded-circle d-flex align-items-center justify-content-center"
                    style={{ width: 48, height: 48, backgroundColor: iconBg, color: iconColor }}
                >
                    <i className={`bi ${icon} fs-4`}></i>
                </div>
            </Card.Body>
        </Card>
    )
}
