import { useEffect, useState } from 'react';
import api from '../api/axios';
import { Container, Row, Col, Card, Table, Badge, Form, Button } from 'react-bootstrap';

export default function Bookings() {
    const [bookings, setBookings] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchBookings();
    }, []);

    const fetchBookings = async () => {
        try {
            const response = await api.get('/dashboard/bookings');
            if (response.data.success) {
                setBookings(response.data.bookings);
            }
        } catch (error) {
            console.error('Error fetching bookings:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) return <div className="p-4 text-small text-secondary">Loading bookings...</div>;

    return (
        <Container fluid>
            <div className="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h4 className="fw-bold text-dark mb-1">Bookings Management</h4>
                    <p className="text-secondary small m-0">Track and manage all service bookings</p>
                </div>
                <div>
                    <div className="d-flex gap-3">
                        <div className="bg-white p-2 rounded shadow-sm d-flex gap-3 align-items-center px-4">
                            <div className="text-center">
                                <div className="small text-muted">Total Bookings</div>
                                <div className="fw-bold">{bookings.length}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <Card className="border-0 shadow-sm rounded-4">
                <Card.Body className="p-0">
                    {/* Toolbar */}
                    <div className="p-3 border-bottom d-flex justify-content-between align-items-center">
                        <Form.Control
                            type="text"
                            placeholder="Search by customer, booking ID..."
                            className="bg-light border-0 small"
                            style={{ width: 350, padding: '0.6rem 1rem' }}
                        />
                        <div className="d-flex gap-2">
                            <Button variant="outline-secondary" className="d-flex align-items-center gap-2 small fw-medium">
                                <i className="bi bi-funnel"></i> All Status
                            </Button>
                            <Button variant="outline-secondary" className="d-flex align-items-center gap-2 small fw-medium">
                                <i className="bi bi-download"></i> Export
                            </Button>
                        </div>
                    </div>

                    {/* Table */}
                    <Table responsive hover className="m-0 align-middle">
                        <thead className="bg-light text-secondary text-uppercase small">
                            <tr style={{ fontSize: '0.75rem' }}>
                                <th className="fw-bold ps-4 py-3 border-0">Booking ID</th>
                                <th className="fw-bold py-3 border-0">Customer</th>
                                <th className="fw-bold py-3 border-0">Service Provider</th>
                                <th className="fw-bold py-3 border-0">Service</th>
                                <th className="fw-bold py-3 border-0">Date & Time</th>
                                <th className="fw-bold py-3 border-0">Amount</th>
                                <th className="fw-bold py-3 border-0">Status</th>
                                <th className="fw-bold text-end pe-4 py-3 border-0">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {bookings.length === 0 ? (
                                <tr>
                                    <td colSpan="8" className="text-center p-5 text-muted small">No bookings found</td>
                                </tr>
                            ) : (
                                bookings.map((booking) => (
                                    <tr key={booking._id} style={{ borderBottom: '1px solid #f8f9fa' }}>
                                        <td className="ps-4 py-3 fw-bold text-purple small">{booking.bookingId}</td>
                                        <td className="py-3">
                                            <div className="d-flex align-items-center gap-2">
                                                <div className="rounded-circle bg-primary d-flex align-items-center justify-content-center text-white fw-bold small" style={{ width: 28, height: 28, fontSize: '0.7rem' }}>
                                                    {booking.customer?.name?.[0].toUpperCase() || 'C'}
                                                </div>
                                                <span className="fw-medium text-dark small">{booking.customer?.name || 'Unknown'}</span>
                                            </div>
                                        </td>
                                        <td className="py-3">
                                            <div className="d-flex align-items-center gap-2">
                                                <div className="rounded-circle bg-purple d-flex align-items-center justify-content-center text-white fw-bold small" style={{ width: 28, height: 28, fontSize: '0.7rem', backgroundColor: '#8b5cf6' }}>
                                                    {booking.provider?.name?.[0].toUpperCase() || 'P'}
                                                </div>
                                                <span className="small text-secondary">{booking.provider?.name || 'Unassigned'}</span>
                                            </div>
                                        </td>
                                        <td className="small text-secondary py-3">{booking.serviceName}</td>
                                        <td className="py-3">
                                            <div className="small fw-medium text-dark">{new Date(booking.date).toLocaleDateString()}</div>
                                            <div className="small text-secondary" style={{ fontSize: '0.7rem' }}>{booking.time}</div>
                                        </td>
                                        <td className="fw-bold small py-3">₹{booking.amount}</td>
                                        <td className="py-3">
                                            <span
                                                className="px-3 py-1 rounded-pill small fw-medium"
                                                style={{
                                                    backgroundColor: getStatusStyle(booking.status).bg,
                                                    color: getStatusStyle(booking.status).text,
                                                    fontSize: '0.75rem'
                                                }}
                                            >
                                                {booking.status}
                                            </span>
                                        </td>
                                        <td className="text-end pe-4 py-3">
                                            <Button variant="link" className="text-muted p-0">
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

function getStatusStyle(status) {
    if (status === 'Confirmed') return { bg: '#dbeafe', text: '#2563eb' }; // blue
    if (status === 'Completed') return { bg: '#dcfce7', text: '#16a34a' }; // green
    if (status === 'Pending') return { bg: '#ffedd5', text: '#ea580c' }; // orange
    if (status === 'Cancelled') return { bg: '#fee2e2', text: '#ef4444' }; // red
    if (status === 'In Progress') return { bg: '#f3e8ff', text: '#9333ea' }; // purple
    return { bg: '#f1f5f9', text: '#64748b' };
}
