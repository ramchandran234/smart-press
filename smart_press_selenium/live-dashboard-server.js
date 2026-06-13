const http = require('http');
const fs = require('fs');
const path = require('path');
const { exec } = require('child_process');

let server = null;
let clients = [];
let runState = {
    status: 'Idle',
    total: 0,
    passed: 0,
    failed: 0,
    steps: []
};

// HTML page content with vanilla CSS
const HTML_CONTENT = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart Press - Live Web E2E Test Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&family=Plus+Jakarta+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg-color: #0b0f19;
            --card-bg: rgba(23, 28, 41, 0.65);
            --card-border: rgba(255, 255, 255, 0.08);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-teal: #0d9488;
            --accent-teal-glow: rgba(13, 148, 136, 0.4);
            --pass-green: #10b981;
            --pass-bg: rgba(16, 185, 129, 0.12);
            --fail-red: #ef4444;
            --fail-bg: rgba(239, 68, 68, 0.12);
            --running-blue: #3b82f6;
            --running-bg: rgba(59, 130, 246, 0.12);
            --font-family: 'Plus Jakarta Sans', sans-serif;
            --font-display: 'Outfit', sans-serif;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: var(--bg-color);
            background-image: 
                radial-gradient(at 0% 0%, rgba(13, 148, 136, 0.1) 0px, transparent 50%),
                radial-gradient(at 100% 0%, rgba(59, 130, 246, 0.08) 0px, transparent 50%),
                radial-gradient(at 50% 100%, rgba(15, 23, 42, 0.95) 0px, transparent 70%);
            background-attachment: fixed;
            color: var(--text-primary);
            font-family: var(--font-family);
            min-height: 100vh;
            padding: 2rem;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        /* Custom Scrollbar */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }
        ::-webkit-scrollbar-track {
            background: rgba(15, 23, 42, 0.5);
        }
        ::-webkit-scrollbar-thumb {
            background: rgba(148, 163, 184, 0.2);
            border-radius: 4px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: rgba(148, 163, 184, 0.4);
        }

        header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            padding: 1.5rem 2rem;
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.3);
        }

        .logo-section {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .logo-indicator {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--accent-teal);
            box-shadow: 0 0 12px var(--accent-teal);
        }

        h1 {
            font-family: var(--font-display);
            font-size: 1.5rem;
            font-weight: 700;
            letter-spacing: -0.5px;
            background: linear-gradient(135deg, #f8fafc 0%, #cbd5e1 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .status-badge {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            border-radius: 9999px;
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .status-badge.idle {
            background: rgba(148, 163, 184, 0.1);
            color: var(--text-secondary);
        }

        .status-badge.running {
            background: var(--running-bg);
            color: var(--running-blue);
            border-color: rgba(59, 130, 246, 0.2);
            animation: pulse-border 2s infinite ease-in-out;
        }

        .status-badge.completed {
            background: var(--pass-bg);
            color: var(--pass-green);
            border-color: rgba(16, 185, 129, 0.2);
        }

        .status-badge.disconnected {
            background: var(--fail-bg);
            color: var(--fail-red);
            border-color: rgba(239, 68, 68, 0.2);
        }

        .pulse-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: currentColor;
        }
        
        .status-badge.running .pulse-dot {
            animation: pulse-glow 1.5s infinite ease-in-out;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
        }

        .stat-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            position: relative;
            overflow: hidden;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            border-color: rgba(255, 255, 255, 0.12);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--text-secondary);
        }

        .stat-card.total::before { background: var(--running-blue); }
        .stat-card.passed::before { background: var(--pass-green); }
        .stat-card.failed::before { background: var(--fail-red); }
        .stat-card.rate::before { background: var(--accent-teal); }

        .stat-label {
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .stat-value {
            font-family: var(--font-display);
            font-size: 2.25rem;
            font-weight: 700;
            color: var(--text-primary);
        }

        /* Progress Bar */
        .progress-container {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            padding: 1.5rem;
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
        }

        .progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 0.9rem;
            font-weight: 600;
        }

        .progress-label {
            color: var(--text-secondary);
        }

        .progress-percentage {
            color: var(--text-primary);
            font-family: var(--font-display);
        }

        .progress-track {
            height: 10px;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 9999px;
            overflow: hidden;
            position: relative;
        }

        .progress-bar {
            height: 100%;
            width: 0%;
            background: linear-gradient(90deg, var(--running-blue) 0%, var(--accent-teal) 100%);
            border-radius: 9999px;
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }

        .progress-bar.completed {
            background: linear-gradient(90deg, var(--pass-green) 0%, var(--accent-teal) 100%);
        }

        /* Filters & Logs Layout */
        .main-content {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid var(--card-border);
            border-radius: 16px;
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.2);
            display: flex;
            flex-direction: column;
            overflow: hidden;
            flex-grow: 1;
        }

        .controls-bar {
            padding: 1.5rem;
            border-bottom: 1px solid var(--card-border);
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: center;
            gap: 1rem;
        }

        .search-wrapper {
            position: relative;
            min-width: 280px;
            flex-grow: 1;
            max-width: 400px;
        }

        .search-input {
            width: 100%;
            background: rgba(15, 23, 42, 0.5);
            border: 1px solid var(--card-border);
            color: var(--text-primary);
            padding: 0.65rem 1rem 0.65rem 2.5rem;
            border-radius: 8px;
            font-family: var(--font-family);
            font-size: 0.9rem;
            outline: none;
            transition: border-color 0.2s, box-shadow 0.2s;
        }

        .search-input:focus {
            border-color: var(--accent-teal);
            box-shadow: 0 0 0 2px var(--accent-teal-glow);
        }

        .search-icon {
            position: absolute;
            left: 0.85rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
            pointer-events: none;
        }

        .filter-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .filter-btn {
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid var(--card-border);
            color: var(--text-secondary);
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            font-family: var(--font-family);
            font-size: 0.85rem;
            font-weight: 600;
            transition: all 0.2s ease;
        }

        .filter-btn:hover {
            background: rgba(255, 255, 255, 0.07);
            color: var(--text-primary);
        }

        .filter-btn.active {
            background: var(--accent-teal);
            border-color: var(--accent-teal);
            color: var(--text-primary);
            box-shadow: 0 0 12px var(--accent-teal-glow);
        }

        /* Table Logs */
        .table-container {
            overflow-x: auto;
            max-height: 480px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            background: rgba(15, 23, 42, 0.4);
            color: var(--text-secondary);
            font-size: 0.8rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--card-border);
            position: sticky;
            top: 0;
            z-index: 10;
            backdrop-filter: blur(10px);
        }

        td {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            font-size: 0.9rem;
            vertical-align: top;
        }

        tr:hover td {
            background: rgba(255, 255, 255, 0.01);
        }

        .td-time {
            font-family: var(--font-display);
            color: var(--text-secondary);
            width: 110px;
        }

        .td-suite {
            font-weight: 600;
            color: var(--text-primary);
            width: 220px;
        }

        .td-step {
            color: var(--text-primary);
        }

        .td-status {
            width: 120px;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.65rem;
            border-radius: 6px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.5px;
        }

        .badge.pass {
            background: var(--pass-bg);
            color: var(--pass-green);
        }

        .badge.fail {
            background: var(--fail-bg);
            color: var(--fail-red);
        }

        .badge.running {
            background: var(--running-bg);
            color: var(--running-blue);
            animation: pulse-fade 1.5s infinite ease-in-out;
        }

        .td-duration {
            font-family: var(--font-display);
            color: var(--text-secondary);
            width: 100px;
            text-align: right;
        }

        .error-details {
            font-family: 'Courier New', Courier, monospace;
            font-size: 0.8rem;
            background: rgba(239, 68, 68, 0.05);
            border: 1px solid rgba(239, 68, 68, 0.15);
            color: #fca5a5;
            padding: 0.75rem;
            border-radius: 6px;
            margin-top: 0.5rem;
            white-space: pre-wrap;
            max-width: 500px;
        }

        .empty-state {
            padding: 3rem;
            text-align: center;
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        /* Action Footer */
        footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .footer-branding {
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .download-btn {
            background: var(--accent-teal);
            color: var(--text-primary);
            border: none;
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-family: var(--font-family);
            font-size: 0.9rem;
            font-weight: 600;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 14px 0 var(--accent-teal-glow);
            transition: all 0.2s ease;
            text-decoration: none;
        }

        .download-btn:hover {
            background: #0f766e;
            transform: translateY(-1px);
            box-shadow: 0 6px 20px 0 var(--accent-teal-glow);
        }

        .download-btn.disabled {
            background: rgba(255, 255, 255, 0.05);
            color: var(--text-secondary);
            cursor: not-allowed;
            box-shadow: none;
            pointer-events: none;
            border: 1px solid var(--card-border);
        }

        .download-btn.ready-glow {
            animation: pulse-button 2s infinite ease-in-out;
        }

        /* Keyframes Animations */
        @keyframes pulse-glow {
            0%, 100% { opacity: 0.5; transform: scale(1); }
            50% { opacity: 1; transform: scale(1.25); }
        }

        @keyframes pulse-fade {
            0%, 100% { opacity: 0.6; }
            50% { opacity: 1; }
        }

        @keyframes pulse-border {
            0%, 100% { border-color: rgba(59, 130, 246, 0.2); }
            50% { border-color: rgba(59, 130, 246, 0.6); }
        }

        @keyframes pulse-button {
            0%, 100% { box-shadow: 0 4px 14px 0 var(--accent-teal-glow); }
            50% { box-shadow: 0 4px 24px 8px var(--accent-teal-glow); }
        }

        @media (max-width: 768px) {
            body {
                padding: 1rem;
            }
            header, .stats-grid, .progress-container, .main-content, footer {
                padding: 1rem;
            }
            .controls-bar {
                flex-direction: column;
                align-items: stretch;
            }
            .search-wrapper {
                max-width: none;
            }
        }
    </style>
</head>
<body>

    <!-- Header Section -->
    <header>
        <div class="logo-section">
            <div class="logo-indicator"></div>
            <h1>Smart Press Web E2E Live Testing</h1>
        </div>
        <div id="connectionStatus" class="status-badge idle">
            <div class="pulse-dot"></div>
            <span id="statusText">Idle</span>
        </div>
    </header>

    <!-- Stats Grid -->
    <div class="stats-grid">
        <div class="stat-card total">
            <span class="stat-label">Total Steps</span>
            <div id="statTotal" class="stat-value">0</div>
        </div>
        <div class="stat-card passed">
            <span class="stat-label">Passed</span>
            <div id="statPassed" class="stat-value">0</div>
        </div>
        <div class="stat-card failed">
            <span class="stat-label">Failed</span>
            <div id="statFailed" class="stat-value">0</div>
        </div>
        <div class="stat-card rate">
            <span class="stat-label">Pass Rate</span>
            <div id="statRate" class="stat-value">0%</div>
        </div>
    </div>

    <!-- Progress Tracker -->
    <div class="progress-container">
        <div class="progress-header">
            <span class="progress-label">Execution Progress</span>
            <span id="progressPercentage" class="progress-percentage">0%</span>
        </div>
        <div class="progress-track">
            <div id="progressBar" class="progress-bar"></div>
        </div>
    </div>

    <!-- Logs & Filters -->
    <div class="main-content">
        <div class="controls-bar">
            <div class="search-wrapper">
                <svg class="search-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                    <path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
                </svg>
                <input type="text" id="searchInput" class="search-input" placeholder="Search tests, suites or errors...">
            </div>
            <div class="filter-buttons">
                <button class="filter-btn active" data-filter="all">All</button>
                <button class="filter-btn" data-filter="running">Running</button>
                <button class="filter-btn" data-filter="pass">Pass</button>
                <button class="filter-btn" data-filter="fail">Fail</button>
            </div>
        </div>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Time</th>
                        <th>Test Suite</th>
                        <th>Test Step Description</th>
                        <th>Status</th>
                        <th style="text-align: right;">Duration</th>
                    </tr>
                </thead>
                <tbody id="logsTableBody">
                    <!-- Steps will append here -->
                </tbody>
            </table>
            <div id="emptyState" class="empty-state">No tests recorded yet. Run a test to begin.</div>
        </div>
    </div>

    <!-- Action Footer -->
    <footer>
        <div class="footer-branding">
            Smart Press Testing System &copy; 2026
        </div>
        <a href="/download-report" id="downloadBtn" class="download-btn disabled">
            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
                <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5z"/>
                <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708l3 3z"/>
            </svg>
            <span>Download Excel Report</span>
        </a>
    </footer>

    <script>
        let tests = [];
        let activeFilter = 'all';
        let searchQuery = '';

        const logsTableBody = document.getElementById('logsTableBody');
        const emptyState = document.getElementById('emptyState');
        const connectionStatus = document.getElementById('connectionStatus');
        const statusText = document.getElementById('statusText');
        const searchInput = document.getElementById('searchInput');
        const filterBtns = document.querySelectorAll('.filter-btn');
        const downloadBtn = document.getElementById('downloadBtn');

        // Connect to SSE
        const eventSource = new EventSource('/events');

        eventSource.onopen = () => {
            updateConnectionStatus('connected');
        };

        eventSource.onerror = () => {
            updateConnectionStatus('disconnected');
        };

        eventSource.onmessage = (event) => {
            const data = JSON.parse(event.data);
            if (data.state) {
                tests = data.state.steps;
                updateStats(data.state);
                updateProgressBar(data.state);
                updateStatusBadge(data.state.status);
            }
            renderTable();
        };

        function updateConnectionStatus(status) {
            if (status === 'connected') {
                connectionStatus.className = 'status-badge';
                // Will overlay with active run state status, default to idle
                if (statusText.innerText === 'Disconnected') {
                    statusText.innerText = 'Idle';
                    connectionStatus.classList.add('idle');
                }
            } else {
                connectionStatus.className = 'status-badge disconnected';
                statusText.innerText = 'Disconnected';
            }
        }

        function updateStatusBadge(status) {
            connectionStatus.className = 'status-badge';
            if (status === 'Running') {
                connectionStatus.classList.add('running');
                statusText.innerText = 'Running Tests';
                downloadBtn.className = 'download-btn disabled';
            } else if (status === 'Completed') {
                connectionStatus.classList.add('completed');
                statusText.innerText = 'Completed';
                downloadBtn.className = 'download-btn ready-glow';
            } else {
                connectionStatus.classList.add('idle');
                statusText.innerText = 'Idle';
            }
        }

        function updateStats(state) {
            document.getElementById('statTotal').innerText = state.steps.length;
            document.getElementById('statPassed').innerText = state.passed;
            document.getElementById('statFailed').innerText = state.failed;
            
            const total = state.steps.length;
            const completed = state.passed + state.failed;
            const rate = completed > 0 ? Math.round((state.passed / completed) * 100) : 0;
            document.getElementById('statRate').innerText = rate + '%';
        }

        function updateProgressBar(state) {
            const progressBar = document.getElementById('progressBar');
            const progressPercentage = document.getElementById('progressPercentage');
            
            const total = state.steps.length;
            if (total === 0) {
                progressBar.style.width = '0%';
                progressPercentage.innerText = '0%';
                progressBar.classList.remove('completed');
                return;
            }

            const completedCount = state.steps.filter(s => s.status === 'PASS' || s.status === 'FAIL').length;
            const pct = Math.round((completedCount / total) * 100);
            
            progressBar.style.width = pct + '%';
            progressPercentage.innerText = pct + '%';

            if (pct === 100) {
                progressBar.classList.add('completed');
            } else {
                progressBar.classList.remove('completed');
            }
        }

        function renderTable() {
            // Filter and Search tests
            const filtered = tests.filter(test => {
                const matchesFilter = 
                    activeFilter === 'all' || 
                    (activeFilter === 'running' && test.status === 'RUNNING') ||
                    (activeFilter === 'pass' && test.status === 'PASS') ||
                    (activeFilter === 'fail' && test.status === 'FAIL');

                const matchesSearch = 
                    test.suiteName.toLowerCase().includes(searchQuery) ||
                    test.stepName.toLowerCase().includes(searchQuery) ||
                    (test.error && test.error.toLowerCase().includes(searchQuery));

                return matchesFilter && matchesSearch;
            });

            // Toggle empty state
            if (filtered.length === 0) {
                emptyState.style.display = 'block';
                logsTableBody.innerHTML = '';
                return;
            }
            emptyState.style.display = 'none';

            // Build rows
            const rowsHtml = filtered.map(test => {
                const statusClass = test.status.toLowerCase();
                const badgeText = test.status;
                const showDuration = test.duration;
                
                let errorHtml = '';
                if (test.status === 'FAIL' && test.error && test.error !== 'N/A') {
                    errorHtml = '<div class="error-details">' + escapeHtml(test.error) + '</div>';
                }

                return '<tr>' +
                    '<td class="td-time">' + (test.timestamp || 'N/A') + '</td>' +
                    '<td class="td-suite">' + escapeHtml(test.suiteName) + '</td>' +
                    '<td class="td-step">' +
                        '<div>' + escapeHtml(test.stepName) + '</div>' +
                        errorHtml +
                    '</td>' +
                    '<td class="td-status">' +
                        '<span class="badge ' + statusClass + '">' +
                            badgeText +
                        '</span>' +
                    '</td>' +
                    '<td class="td-duration">' + showDuration + '</td>' +
                '</tr>';
            }).join('');

            logsTableBody.innerHTML = rowsHtml;
        }

        function escapeHtml(string) {
            return String(string).replace(/[&<>"']/g, function (s) {
                return {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    '"': '&quot;',
                    "'": '&#39;'
                }[s];
            });
        }

        // Search Input Event
        searchInput.addEventListener('input', (e) => {
            searchQuery = e.target.value.toLowerCase();
            renderTable();
        });

        // Filter Button Events
        filterBtns.forEach(btn => {
            btn.addEventListener('click', (e) => {
                filterBtns.forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                activeFilter = btn.getAttribute('data-filter');
                renderTable();
            });
        });
    </script>
</body>
</html>
`;

function startServer(port = 4000) {
    if (server) return server;

    server = http.createServer((req, res) => {
        const parsedUrl = new URL(req.url, `http://${req.headers.host}`);
        
        if (req.method === 'GET' && parsedUrl.pathname === '/') {
            res.writeHead(200, { 'Content-Type': 'text/html' });
            res.end(HTML_CONTENT);
        } 
        else if (req.method === 'GET' && parsedUrl.pathname === '/events') {
            // Server-Sent Events setup
            res.writeHead(200, {
                'Content-Type': 'text/event-stream',
                'Cache-Control': 'no-cache',
                'Connection': 'keep-alive',
                'Access-Control-Allow-Origin': '*'
            });
            res.write('\n');
            clients.push(res);
            
            // Send initial state immediately
            const payload = JSON.stringify({ event: 'init', data: null, state: runState });
            res.write(`data: ${payload}\n\n`);

            req.on('close', () => {
                clients = clients.filter(client => client !== res);
            });
        } 
        else if (req.method === 'POST' && parsedUrl.pathname === '/api/event') {
            let body = '';
            req.on('data', chunk => {
                body += chunk.toString();
            });
            req.on('end', () => {
                handlePostEvent(body);
                res.writeHead(200, { 'Content-Type': 'application/json' });
                res.end(JSON.stringify({ success: true }));
            });
        } 
        else if (req.method === 'GET' && parsedUrl.pathname === '/download-report') {
            const reportPath = path.join(__dirname, 'reports/E2E_Web_Test_Report.xlsx');
            if (fs.existsSync(reportPath)) {
                res.writeHead(200, {
                    'Content-Type': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
                    'Content-Disposition': 'attachment; filename=E2E_Web_Test_Report.xlsx'
                });
                const stream = fs.createReadStream(reportPath);
                stream.pipe(res);
            } else {
                res.writeHead(404, { 'Content-Type': 'text/plain' });
                res.end('Excel analysis report has not been generated yet.');
            }
        } 
        else {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end('Not Found');
        }
    });

    server.listen(port, () => {
        console.log(`\n📡 Live Test Dashboard Server launched on http://localhost:${port}`);
    });

    return server;
}

function stopServer() {
    if (server) {
        clients.forEach(client => client.end());
        clients = [];
        server.close();
        server = null;
        console.log('📡 Live Test Dashboard Server stopped.');
    }
}

function broadcastEvent(event, data) {
    const payload = JSON.stringify({ event, data, state: runState });
    clients.forEach(client => {
        client.write(`data: ${payload}\n\n`);
    });
}

function handlePostEvent(body) {
    try {
        const payload = JSON.parse(body);
        const { event, data } = payload;
        
        if (event === 'run:start') {
            runState = {
                status: 'Running',
                total: 0,
                passed: 0,
                failed: 0,
                steps: []
            };
        } else if (event === 'test:start') {
            runState.status = 'Running';
            // Check if step already exists
            const existingIdx = runState.steps.findIndex(s => s.suiteName === data.suiteName && s.stepName === data.stepName);
            if (existingIdx !== -1) {
                runState.steps[existingIdx].status = 'RUNNING';
                runState.steps[existingIdx].duration = '...';
            } else {
                runState.steps.push({
                    suiteName: data.suiteName,
                    stepName: data.stepName,
                    status: 'RUNNING',
                    duration: '...',
                    error: 'N/A',
                    timestamp: new Date().toLocaleTimeString()
                });
            }
        } else if (event === 'test:result') {
            const idx = runState.steps.findIndex(s => s.suiteName === data.suiteName && s.stepName === data.stepName);
            const stepResult = {
                suiteName: data.suiteName,
                stepName: data.stepName,
                status: data.status, // PASS or FAIL
                duration: `${data.duration}ms`,
                error: data.error || 'N/A',
                timestamp: new Date().toLocaleTimeString()
            };
            if (idx !== -1) {
                runState.steps[idx] = stepResult;
            } else {
                runState.steps.push(stepResult);
            }
            
            runState.total++;
            if (data.status === 'PASS') {
                runState.passed++;
            } else {
                runState.failed++;
            }
        } else if (event === 'run:complete') {
            runState.status = 'Completed';
        }
        
        broadcastEvent(event, data);
    } catch (err) {
        console.error('Error handling event POST:', err);
    }
}

// Utility to notify dashboard from inside parent process
function notifyEvent(event, data) {
    // Modify runState directly in-process
    if (event === 'run:start') {
        runState = {
            status: 'Running',
            total: 0,
            passed: 0,
            failed: 0,
            steps: []
        };
    } else if (event === 'test:start') {
        runState.status = 'Running';
        const existingIdx = runState.steps.findIndex(s => s.suiteName === data.suiteName && s.stepName === data.stepName);
        if (existingIdx !== -1) {
            runState.steps[existingIdx].status = 'RUNNING';
            runState.steps[existingIdx].duration = '...';
        } else {
            runState.steps.push({
                suiteName: data.suiteName,
                stepName: data.stepName,
                status: 'RUNNING',
                duration: '...',
                error: 'N/A',
                timestamp: new Date().toLocaleTimeString()
            });
        }
    } else if (event === 'test:result') {
        const idx = runState.steps.findIndex(s => s.suiteName === data.suiteName && s.stepName === data.stepName);
        const stepResult = {
            suiteName: data.suiteName,
            stepName: data.stepName,
            status: data.status,
            duration: `${data.duration}ms`,
            error: data.error || 'N/A',
            timestamp: new Date().toLocaleTimeString()
        };
        if (idx !== -1) {
            runState.steps[idx] = stepResult;
        } else {
            runState.steps.push(stepResult);
        }
        
        runState.total++;
        if (data.status === 'PASS') {
            runState.passed++;
        } else {
            runState.failed++;
        }
    } else if (event === 'run:complete') {
        runState.status = 'Completed';
    }

    broadcastEvent(event, data);
}

function openBrowser(port = 4000) {
    const url = `http://localhost:${port}`;
    if (process.platform === 'win32') {
        exec(`start ${url}`);
    } else if (process.platform === 'darwin') {
        exec(`open ${url}`);
    } else {
        exec(`xdg-open ${url}`);
    }
}

module.exports = {
    startServer,
    stopServer,
    notifyEvent,
    openBrowser
};
