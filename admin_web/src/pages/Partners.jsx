import { useEffect, useState } from 'react';
import api from '../api/axios';
import { Container, Card, Table, Badge, Form, Button } from 'react-bootstrap';

export default function Partners() {
    const [partners, setPartners] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchPartners();
    }, []);

    const fetchPartners = async () => {
        try {
            // Fetch actual partners from database
            const response = await api.get('/users?role=partner');
            if (response.data.success) {
                setPartners(response.data.users);
            }
        } catch (error) {
            console.error('Error fetching partners:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) return <div className="p-4 text-small text-secondary">Loading partners...</div>;

    return (
        <Container fluid>
            <div className="mb-4">
                <h4 className="fw-bold text-dark mb-1">Service Partners</h4>
                <p className="text-secondary small m-0">Manage and verify service providers</p>
            </div>

            <Card className="border-0 shadow-sm rounded-4">
                <Card.Body className="p-0">
                    <div className="p-3 border-bottom d-flex justify-content-between align-items-center">
                        <Form.Control
                            type="text"
                            placeholder="Search partners..."
                            className="bg-light border-0 small"
                            style={{ width: 350, padding: '0.6rem 1rem' }}
                        />
                        <Button className="btn-purple px-4 fw-semibold small">+ Add Partner</Button>
                    </div>

                    <Table responsive hover className="m-0 align-middle">
                        <thead className="bg-light text-secondary text-uppercase small">
                            <tr style={{ fontSize: '0.75rem' }}>
                                <th className="fw-bold ps-4 py-3 border-0">Provider Name</th>
                                <th className="fw-bold py-3 border-0">Service Category</th>
                                <th className="fw-bold py-3 border-0">Status</th>
                                <th className="fw-bold py-3 border-0">Phone Number</th>
                                <th className="fw-bold text-end pe-4 py-3 border-0">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            {partners.length === 0 ? (
                                <tr>
                                    <td colSpan="5" className="text-center p-5 text-muted small">No partners found</td>
                                </tr>
                            ) : (
                                partners.map((partner) => (
                                    <tr key={partner._id} style={{ borderBottom: '1px solid #f8f9fa' }}>
                                        <td className="ps-4 py-3">
                                            <div className="d-flex align-items-center gap-3">
                                                <div
                                                    className="rounded-circle d-flex align-items-center justify-content-center text-white fw-bold shadow-sm"
                                                    style={{ width: 36, height: 36, backgroundColor: getAvatarColor(partner.name), fontSize: '0.85rem' }}
                                                >
                                                    {partner.name?.substring(0, 2).toUpperCase() || 'P'}
                                                </div>
                                                <span className="fw-semibold text-dark small">{partner.name || 'Unnamed Partner'}</span>
                                            </div>
                                        </td>
                                        <td className="py-3">
                                            <Badge
                                                bg="light"
                                                className="text-primary fw-medium px-3 py-2 rounded-pill small"
                                                style={{ backgroundColor: '#e0f2fe', color: '#0ea5e9' }}
                                            >
                                                {partner.serviceCategory || 'General'}
                                            </Badge>
                                        </td>
                                        <td className="py-3">
                                            <Badge
                                                bg="light"
                                                className={`fw-medium px-3 py-2 rounded-pill small ${partner.isActive ? 'text-success' : 'text-danger'}`}
                                                style={{
                                                    backgroundColor: partner.isActive ? '#dcfce7' : '#fee2e2',
                                                    color: partner.isActive ? '#16a34a' : '#ef4444'
                                                }}
                                            >
                                                {partner.isActive ? 'Active' : 'Pending'}
                                            </Badge>
                                        </td>
                                        <td className="text-secondary small py-3">{partner.phone}</td>
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

function getAvatarColor(name) {
    const letters = name ? name[0].toUpperCase() : 'A';
    if (letters < 'G') return '#8b5cf6'; // purple
    if (letters < 'M') return '#ec4899'; // pink
    if (letters < 'S') return '#06b6d4'; // cyan
    return '#f59e0b'; // amber
}
