import { useEffect, useState } from 'react';
import api from '../api/axios';
import { Container, Row, Col, Card } from 'react-bootstrap';

export default function DashboardHome() {
    const [stats, setStats] = useState({
        totalRevenue: 0,
        activePartners: 0,
        pendingBookings: 0,
        completedToday: 0
    });
    const [activities, setActivities] = useState([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        fetchStats();
    }, []);

    const fetchStats = async () => {
        try {
            const response = await api.get('/dashboard/stats');
            if (response.data.success) {
                setStats(response.data.stats);
                setActivities(response.data.recentActivity || []);
            }
        } catch (error) {
            console.error('Error fetching dashboard stats:', error);
        } finally {
            setLoading(false);
        }
    };

    if (loading) return <div className="p-4 text-secondary">Loading dashboard...</div>;

    return (
        <Container fluid>
            <div className="mb-4">
                <h4 className="fw-bold text-dark mb-1">Dashboard Overview</h4>
                <p className="text-secondary small">Welcome back! Here's what's happening today.</p>
            </div>

            {/* Stats Cards - Matching Screenshot Layout & Colors */}
            <Row className="mb-4 g-3">
                <Col md={3}>
                    <StatCard
                        title="Total Revenue"
                        value={`₹${stats.totalRevenue.toLocaleString()}`}
                        icon="bi-currency-rupee"
                        trend="+12.5%"
                        iconColor="#8b5cf6"
                        iconBg="#f3e8ff"
                    />
                </Col>
                <Col md={3}>
                    <StatCard
                        title="Active Partners"
                        value={stats.activePartners}
                        icon="bi-people"
                        trend="+8.2%"
                        iconColor="#8b5cf6"
                        iconBg="#f3e8ff"
                    />
                </Col>
                <Col md={3}>
                    <StatCard
                        title="Pending Bookings"
                        value={stats.pendingBookings}
                        icon="bi-clock"
                        trend="-4.1%"
                        isNegative
                        iconColor="#f59e0b"
                        iconBg="#fef3c7"
                    />
                </Col>
                <Col md={3}>
                    <StatCard
                        title="Completed Today"
                        value={stats.completedToday}
                        icon="bi-check-circle"
                        trend="+15.3%"
                        iconColor="#10b981"
                        iconBg="#d1fae5"
                    />
                </Col>
            </Row>

            {/* Recent Activity */}
            <Card className="border-0 shadow-sm rounded-4">
                <Card.Body className="p-4">
                    <Card.Title className="fw-bold mb-4 fs-6">Recent Activity</Card.Title>
                    <div className="d-flex flex-column gap-3">
                        {activities.length === 0 ? (
                            <div className="text-center text-muted py-3 small">No recent activity</div>
                        ) : (
                            activities.map((activity, index) => (
                                <div key={index} className="d-flex align-items-center gap-3 pb-3 border-bottom-last-0" style={{ borderBottom: index < activities.length - 1 ? '1px solid #f1f5f9' : 'none' }}>
                                    <div
                                        className="rounded-circle d-flex align-items-center justify-content-center"
                                        style={{
                                            width: 40,
                                            height: 40,
                                            backgroundColor: getIconBg(activity.icon),
                                            color: getIconColor(activity.icon)
                                        }}
                                    >
                                        <i className={`bi ${getBootstrapIcon(activity.icon)} fs-5`}></i>
                                    </div>
                                    <div className="flex-grow-1">
                                        <div className="fw-semibold text-dark" style={{ fontSize: '0.9rem' }}>{activity.type.replace('_', ' ').replace(/(^\w|\s\w)/g, m => m.toUpperCase())}</div>
                                        <div className="text-secondary small">{activity.text}</div>
                                    </div>
                                    <div className="text-muted small text-nowrap" style={{ fontSize: '0.75rem' }}>{activity.time}</div>
                                </div>
                            ))
                        )}
                    </div>
                </Card.Body>
            </Card>
        </Container>
    );
}

function StatCard({ title, value, icon, trend, isNegative, iconColor, iconBg }) {
    return (
        <Card className="border-0 shadow-sm h-100 rounded-4">
            <Card.Body className="p-3">
                <div className="d-flex justify-content-between align-items-start mb-3">
                    <div>
                        <div className="text-secondary small mb-1">{title}</div>
                        <div className="h3 fw-bold text-dark mb-0">{value}</div>
                    </div>
                    <div
                        className="rounded-circle d-flex align-items-center justify-content-center"
                        style={{ width: 42, height: 42, backgroundColor: iconBg, color: iconColor }}
                    >
                        <i className={`bi ${icon} fs-5`}></i>
                    </div>
                </div>
                <div className={`small fw-bold ${isNegative ? 'text-danger' : 'text-success'}`} style={{ fontSize: '0.8rem' }}>
                    {trend} <span className="text-secondary fw-normal">from last month</span>
                </div>
            </Card.Body>
        </Card>
    )
}

function getBootstrapIcon(icon) {
    if (icon === 'check') return 'bi-check-lg';
    if (icon === 'user_add') return 'bi-person-plus';
    if (icon === 'clock') return 'bi-clock';
    if (icon === 'x-circle') return 'bi-x-circle';
    return 'bi-circle';
}

function getIconBg(icon) {
    if (icon === 'check') return '#dcfce7'; // green-100
    if (icon === 'user_add') return '#dbeafe'; // blue-100
    if (icon === 'clock') return '#ffedd5'; // orange-100
    if (icon === 'x-circle') return '#fee2e2'; // red-100
    return '#f1f5f9';
}

function getIconColor(icon) {
    if (icon === 'check') return '#16a34a'; // green-600
    if (icon === 'user_add') return '#2563eb'; // blue-600
    if (icon === 'clock') return '#ea580c'; // orange-600
    if (icon === 'x-circle') return '#dc2626'; // red-600
    return '#64748b';
}
