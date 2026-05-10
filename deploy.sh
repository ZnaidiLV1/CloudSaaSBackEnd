#!/bin/bash
# ==============================================================================
# Sindiboard Beta - Permanent Deploy Script
# Includes all fixes: IPv4 SMTP, complete application.properties, JWT config
# ==============================================================================
set -e

PROJECT_DIR="/opt/sindiboard/beta"
BACKEND_DIR="$PROJECT_DIR/sindiboard_backend"
FRONTEND_DIR="$PROJECT_DIR/sindiboard_frontend"
LOG_FILE="/tmp/sindiboard_backend.log"
BACKEND_PORT=8080

echo "========================================="
echo "Sindiboard Beta Deployment"
echo "========================================="

# ---- Step 1: Kill existing processes ----
echo "[1/8] Stopping existing services..."
pkill -9 -f "java.*preferIPv4Stack" 2>/dev/null || true
sleep 3

# ---- Step 2: Build Backend ----
echo "[2/8] Building backend (Maven)..."
cd "$BACKEND_DIR"
mvn clean package -DskipTests 2>&1 | tail -10
if [ ! -f "$BACKEND_DIR/target/cloudSaaS-0.0.1-SNAPSHOT.jar" ]; then
  echo "❌ Backend build failed!"
  exit 1
fi
echo "✅ Backend built successfully"

# ---- Step 3: Build Frontend ----
echo "[3/8] Building frontend (React)..."
cd "$FRONTEND_DIR"
npx react-scripts build 2>&1 | tail -10
if [ ! -d "$FRONTEND_DIR/build" ]; then
  echo "❌ Frontend build failed!"
  exit 1
fi
echo "✅ Frontend built successfully"

# ---- Step 4: Validate Nginx Config ----
echo "[4/8] Validating nginx configuration..."
nginx -t 2>&1
if [ $? -ne 0 ]; then
  echo "❌ Nginx config invalid!"
  exit 1
fi
echo "✅ Nginx config valid"

# ---- Step 5: Start Backend (with IPv4 fix for SMTP) ----
echo "[5/8] Starting backend with IPv4 stack preference..."
cd "$BACKEND_DIR"
systemctl start sindiboard-backend 2>&1 || {
  # Fallback to direct start if systemd not available
  nohup java -Djava.net.preferIPv4Stack=true -jar target/cloudSaaS-0.0.1-SNAPSHOT.jar > "$LOG_FILE" 2>&1 &
}

# Wait for backend to start
echo "   Waiting for backend to start..."
for i in {1..30}; do
  if curl -s --max-time 3 http://localhost:$BACKEND_PORT/graphql -d '{"query":"{ __typename }"}' | grep -q "Query"; then
    echo "✅ Backend started and responding on port $BACKEND_PORT"
    break
  fi
  if [ $i -eq 30 ]; then
    echo "❌ Backend failed to start within 60 seconds"
    echo "   Check log: tail -f $LOG_FILE"
    exit 1
  fi
  sleep 2
done

# ---- Step 6: Start Nginx ----
echo "[6/8] Starting/reloading nginx..."
nginx -s reload 2>/dev/null || nginx
echo "✅ Nginx started/reloaded"

# ---- Step 7: Verify no errors ----
echo "[7/8] Checking for errors..."
ERROR_COUNT=$(grep -ci "error\|exception\|failed" "$LOG_FILE" 2>/dev/null || echo "0")
if [ "$ERROR_COUNT" -gt 0 ]; then
  echo "⚠️  Found $ERROR_COUNT error(s) in log:"
  grep -i "error\|exception\|failed" "$LOG_FILE" | tail -5
else
  echo "✅ Zero errors in backend log"
fi

# ---- Step 8: Health Checks ----
echo "[8/8] Running health checks..."
echo ""
echo "Backend health:"
curl -s http://localhost:$BACKEND_PORT/graphql -d '{"query":"{ __typename }"}'
echo ""
echo ""
echo "Nginx status:"
ps aux | grep "nginx: master" | grep -v grep && echo "✅ Nginx running" || echo "❌ Nginx not running"
echo ""
echo "Backend process:"
ps aux | grep "java.*preferIPv4Stack" | grep -v grep && echo "✅ Backend running with IPv4 flag" || echo "❌ Backend not running"

echo ""
echo "========================================="
echo "Deploy Complete! 🚀"
echo "========================================="
echo "Frontend:   https://sindiboardbeta.sindibadgroup.net"
echo "Backend:    http://localhost:$BACKEND_PORT/graphql"
echo "API proxy:  https://services-sindiboardbeta.sindibadgroup.net/graphql"
echo "Log file:   $LOG_FILE"
echo ""
echo "OTP Email Fix: -Djava.net.preferIPv4Stack=true is applied"
echo "               (prevents IPv6 timeout on premium706.web-hosting.com:587)"