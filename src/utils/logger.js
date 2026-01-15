const fs = require('fs');
const path = require('path');

// Ensure logs directory exists
const logsDir = path.join(__dirname, '../../logs');
if (!fs.existsSync(logsDir)) {
    fs.mkdirSync(logsDir, { recursive: true });
}

/**
 * Write log to file
 */
const writeLog = (filename, message) => {
    const timestamp = new Date().toISOString();
    const logMessage = `[${timestamp}] ${message}\n`;
    const logPath = path.join(logsDir, filename);

    fs.appendFile(logPath, logMessage, (err) => {
        if (err) console.error('Error writing log:', err);
    });
};

/**
 * Log error
 */
const logError = (error, context = {}) => {
    const errorMessage = {
        message: error.message,
        stack: error.stack,
        context,
        timestamp: new Date().toISOString()
    };

    writeLog('error.log', JSON.stringify(errorMessage));
    console.error('Error logged:', error.message);
};

/**
 * Log info
 */
const logInfo = (message, data = {}) => {
    const infoMessage = {
        message,
        data,
        timestamp: new Date().toISOString()
    };

    writeLog('info.log', JSON.stringify(infoMessage));
};

/**
 * Log warning
 */
const logWarning = (message, data = {}) => {
    const warningMessage = {
        message,
        data,
        timestamp: new Date().toISOString()
    };

    writeLog('warning.log', JSON.stringify(warningMessage));
};

/**
 * Log database query
 */
const logQuery = (query, params = [], duration = 0) => {
    const queryMessage = {
        query,
        params,
        duration: `${duration}ms`,
        timestamp: new Date().toISOString()
    };

    writeLog('query.log', JSON.stringify(queryMessage));
};

/**
 * Log API request
 */
const logRequest = (req) => {
    const requestMessage = {
        method: req.method,
        url: req.originalUrl,
        ip: req.ip,
        userAgent: req.get('user-agent'),
        timestamp: new Date().toISOString()
    };

    writeLog('request.log', JSON.stringify(requestMessage));
};

module.exports = {
    logError,
    logInfo,
    logWarning,
    logQuery,
    logRequest
};
