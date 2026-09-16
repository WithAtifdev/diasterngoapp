const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

const topic = 'all_disaster_alerts';

exports.sendDisasterTopicNotification = functions.https.onRequest(async (req, res) => {
  try {
    if (req.method !== 'POST') {
      return res.status(405).json({ error: 'Method not allowed. Use POST.' });
    }

    const authHeader = req.headers.authorization || '';
    const token = authHeader.startsWith('Bearer ') ? authHeader.slice(7) : '';
    if (!token) {
      return res.status(401).json({ error: 'Missing bearer token.' });
    }

    const decoded = await admin.auth().verifyIdToken(token);
    if (!decoded.email || !decoded.uid) {
      return res.status(401).json({ error: 'Invalid authenticated user.' });
    }

    const { title, body, severity, alertId, description, source, type, data } = req.body || {};
    if (!title || !body || !severity || !alertId) {
      return res.status(400).json({ error: 'title, body, severity, and alertId are required.' });
    }

    const allowedSeverities = new Set(['extreme', 'high', 'medium', 'info']);
    if (!allowedSeverities.has(String(severity))) {
      return res.status(400).json({ error: 'Unsupported severity.' });
    }

    const payload = {
      notification: {
        title,
        body,
      },
      data: {
        alertId: String(alertId),
        title,
        body,
        description: description || body,
        severity,
        source: source || 'firebase',
        type: type || 'disaster_alert',
        topic,
        ...(typeof data === 'object' && data ? data : {}),
      },
      android: {
        priority: 'high',
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
            badge: 1,
          },
        },
      },
    };

    await admin.messaging().sendToTopic(topic, payload);

    return res.status(200).json({
      ok: true,
      topic,
      messageId: 'topic-send',
      alertId: String(alertId),
      title,
      severity,
    });
  } catch (error) {
    console.error('sendDisasterTopicNotification error', error);
    return res.status(500).json({ error: 'Unable to send notification.' });
  }
});
