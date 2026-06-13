const ExcelJS = require('exceljs');
const path = require('path');
const fs = require('fs');

class ExcelReporter {
    constructor() {
        this.steps = [];
    }

    addStep(suiteName, stepName, status, duration, error = 'N/A') {
        this.steps.push({
            timestamp: new Date().toLocaleTimeString(),
            suiteName,
            stepName,
            status, // 'PASS' or 'FAIL'
            duration: `${duration}ms`,
            error: error || 'N/A'
        });
    }

    async generate(outputPath) {
        // Ensure parent directory exists
        const dir = path.dirname(outputPath);
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }

        const workbook = new ExcelJS.Workbook();
        
        // ── Summary Sheet ──────────────────────────
        const summarySheet = workbook.addWorksheet('Summary');
        summarySheet.views = [{ showGridLines: true }];
        
        // Title block
        summarySheet.mergeCells('A1:C2');
        const titleCell = summarySheet.getCell('A1');
        titleCell.value = 'Smart Press E2E Automation Test Summary';
        titleCell.font = { name: 'Segoe UI', size: 16, bold: true, color: { argb: 'FFFFFF' } };
        titleCell.alignment = { vertical: 'middle', horizontal: 'center' };
        titleCell.fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: '1E3A8A' } // Sleek Dark Blue
        };

        const totalSteps = this.steps.length;
        const passedSteps = this.steps.filter(s => s.status === 'PASS').length;
        const failedSteps = totalSteps - passedSteps;
        const passRate = totalSteps > 0 ? `${((passedSteps / totalSteps) * 100).toFixed(1)}%` : '0%';
        
        summarySheet.addRow([]); // Blank row 3
        
        const dataRows = [
            { metric: 'Date of Execution', value: new Date().toLocaleDateString() + ' ' + new Date().toLocaleTimeString() },
            { metric: 'Total Steps Executed', value: totalSteps },
            { metric: 'Steps Passed', value: passedSteps },
            { metric: 'Steps Failed', value: failedSteps },
            { metric: 'Overall Pass Rate', value: passRate }
        ];

        summarySheet.addRow(['Metric / Property', 'Value']);
        const headerRow = summarySheet.getRow(5);
        headerRow.font = { name: 'Segoe UI', size: 11, bold: true, color: { argb: 'FFFFFF' } };
        headerRow.getCell(1).fill = headerRow.getCell(2).fill = {
            type: 'pattern',
            pattern: 'solid',
            fgColor: { argb: '2C3E50' }
        };

        dataRows.forEach(item => {
            const row = summarySheet.addRow([item.metric, item.value]);
            row.getCell(1).font = { name: 'Segoe UI', bold: true };
            row.getCell(2).font = { name: 'Segoe UI' };
            // Style the pass rate specifically
            if (item.metric === 'Overall Pass Rate') {
                const color = failedSteps > 0 ? 'C0392B' : '27AE60';
                row.getCell(2).font = { name: 'Segoe UI', bold: true, color: { argb: color } };
            }
        });

        // Set column widths
        summarySheet.getColumn(1).width = 25;
        summarySheet.getColumn(2).width = 30;

        // ── Details Sheet ──────────────────────────
        const detailsSheet = workbook.addWorksheet('Execution Details');
        detailsSheet.views = [{ showGridLines: true }];

        detailsSheet.columns = [
            { header: 'Time', key: 'timestamp', width: 15 },
            { header: 'Test Suite', key: 'suiteName', width: 25 },
            { header: 'Test Step Description', key: 'stepName', width: 45 },
            { header: 'Status', key: 'status', width: 12 },
            { header: 'Duration', key: 'duration', width: 15 },
            { header: 'Error / Failure Details', key: 'error', width: 50 }
        ];

        // Format details header
        const detailHeader = detailsSheet.getRow(1);
        detailHeader.height = 24;
        detailHeader.eachCell((cell) => {
            cell.font = { name: 'Segoe UI', size: 11, bold: true, color: { argb: 'FFFFFF' } };
            cell.alignment = { vertical: 'middle', horizontal: 'center' };
            cell.fill = {
                type: 'pattern',
                pattern: 'solid',
                fgColor: { argb: '34495E' } // Navy-Gray
            };
        });

        // Populate details
        this.steps.forEach((step) => {
            const row = detailsSheet.addRow(step);
            row.font = { name: 'Segoe UI', size: 10 };
            const statusCell = row.getCell('status');
            statusCell.alignment = { horizontal: 'center' };
            
            if (step.status === 'PASS') {
                statusCell.fill = {
                    type: 'pattern',
                    pattern: 'solid',
                    fgColor: { argb: 'D4EDDA' } // Pastel Green
                };
                statusCell.font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: '155724' } };
            } else {
                statusCell.fill = {
                    type: 'pattern',
                    pattern: 'solid',
                    fgColor: { argb: 'F8D7DA' } // Pastel Red
                };
                statusCell.font = { name: 'Segoe UI', size: 10, bold: true, color: { argb: '721C24' } };
            }
        });

        // Save workbook
        const absolutePath = path.resolve(outputPath);
        await workbook.xlsx.writeFile(absolutePath);
        console.log(`Excel analysis report saved to: ${absolutePath}`);
    }
}

module.exports = new ExcelReporter();
