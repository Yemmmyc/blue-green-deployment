DECISION.md

Thought Process & Implementation Notes

1. Deployment Strategy

Implemented Blue/Green deployment to ensure zero downtime.

Two Node.js app containers: Blue (active) and Green (backup).

Nginx acts as a reverse proxy and traffic controller.

2. Traffic Management

Manual switch: ./switch.sh [blue|green] updates Nginx upstreams and reloads without downtime.

Auto-failover: Nginx retries the backup app if the primary fails (timeout, error, or 5xx).

3. Endpoints & Monitoring

/version → exposes current app version and active pool.

/healthz → health check endpoint.

/chaos → simulate errors for testing failover and resilience.

4. Configuration & Orchestration

Used Docker Compose to orchestrate Nginx, Blue, and Green containers.

Configurable via .env file for images, ports, and release IDs.

Nginx template (nginx.conf.template) allows dynamic upstream changes without editing main config manually.

5. Headers Forwarded

X-App-Pool → indicates which environment handled the request.

X-Release-Id → version of the app serving the request.

6. Lessons & Notes

Chaos testing highlighted the need to correctly set Nginx upstreams and proxy timeouts.

Manual switching works reliably; auto failover only triggers on actual HTTP errors from the primary container.

The setup is fully Dockerized and ready for testing by graders with no downtime.
